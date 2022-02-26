const std = @import("std");
const builtin = @import("builtin");

const FrameInput = @import("FrameInput.zig");
const AudioOutputBuffer = @import("AudioOutputBuffer.zig");

const WasapiInterface = @import("win32/WasapiInterface.zig");
const AudioInterface = WasapiInterface;

const zwin32 = @import("zwin32");
const BYTE = zwin32.base.BYTE;
const UINT = zwin32.base.UINT;
const DWORD = zwin32.base.DWORD;
const BOOL = zwin32.base.BOOL;
const TRUE = zwin32.base.TRUE;
const FALSE = zwin32.base.FALSE;
const LPCWSTR = zwin32.base.LPCWSTR;
const WPARAM = zwin32.base.WPARAM;
const LPARAM = zwin32.base.LPARAM;
const LRESULT = zwin32.base.LRESULT;
const HRESULT = zwin32.base.HRESULT;
const HINSTANCE = zwin32.base.HINSTANCE;
const HWND = zwin32.base.HWND;
const RECT = zwin32.base.RECT;
const kernel32 = zwin32.base.kernel32;
const user32 = zwin32.base.user32;
const dxgi = zwin32.dxgi;
const d3d = zwin32.d3d;
const d3d11 = zwin32.d3d11;
const d3dcompiler = zwin32.d3dcompiler;
const hrErrorOnFail = zwin32.hrErrorOnFail;

const L = std.unicode.utf8ToUtf16LeStringLiteral;

pub const Error = error{
    FailedToGetModuleHandle,
};

const GraphicsAPI = enum {
    d3d11,
};

var target_framerate: u16 = undefined;
var target_frame_dt: u64 = undefined;
var window_width: u16 = undefined;
var window_height: u16 = undefined;
var audio_enabled: bool = undefined;
var audio_interface: AudioInterface = undefined;
var audio_ring_buf: []f32 = undefined;
var audio_ring_read_cur: usize = 0;
var audio_ring_write_cur: usize = 0;
var audio_samples_queued: usize = 0;
var audio_thread: std.Thread = undefined;
var audio_playing = false;
var audio_write_cursor: usize = 0;
var audio_read_cursor: usize = 0;
const num_audio_latency_samples = 16;
var audio_latency = [_]u64{0} ** num_audio_latency_samples;
var audio_latency_cur: usize = 0;
var audio_latency_avg: u64 = 0;
var timer: std.time.Timer = undefined;

var window_closed = false;
var quit = false;

pub fn timestamp() u64 {
    return timer.read();
}

/// the caller is responsible for free'ing the allocated sample buffer
pub fn frameBeginAudio(allocator: std.mem.Allocator) !AudioOutputBuffer {
    const format = audio_interface.format;

    const samples_per_frame = format.nSamplesPerSec / target_framerate;
    const frames_per_frame = samples_per_frame / format.nChannels;

    const min_frames = frames_per_frame * 2;

    var samples_queued = @atomicLoad(usize, &audio_samples_queued, .Monotonic);

    const max_samples = audio_ring_buf.len / 2;

    var max_frames = max_samples / format.nChannels;
    if (max_frames < min_frames) max_frames = min_frames;

    const rewrite = @intCast(
        u32,
        std.math.max(0, @intCast(i64, samples_queued) - min_frames * format.nChannels),
    );

    // if (rewrite > 0) std.log.debug("rewrite {} samples", .{rewrite});

    samples_queued = @atomicLoad(usize, &audio_samples_queued, .Acquire);
    while (@cmpxchgWeak(
        usize,
        &audio_samples_queued,
        samples_queued,
        samples_queued - @intCast(usize, rewrite),
        .Release,
        .Monotonic,
    )) |val| {
        samples_queued = val;
    }

    audio_write_cursor -= rewrite / format.nChannels;

    return AudioOutputBuffer{
        .cursor = audio_write_cursor,
        .rewrite = rewrite / format.nChannels,
        .channels = format.nChannels,
        .sample_rate = format.nSamplesPerSec,
        .min_frames = min_frames,
        .max_frames = max_frames,
        .sample_buf = try allocator.alloc(f32, max_samples),
    };
}

/// queues the given audio buffer for the audio thread to write to the playback stream
/// and starts the stream, if not already started
pub fn frameQueueAudio(buffer: AudioOutputBuffer, num_frames: usize) void {
    std.debug.assert(num_frames <= buffer.max_frames);
    std.debug.assert(num_frames >= buffer.min_frames);

    const num_samples = num_frames * buffer.channels;

    { // move write_cur back to rewrite
        var i: usize = 0;
        while (i < buffer.rewrite * buffer.channels) : (i += 1) {
            audio_ring_write_cur = if (audio_ring_write_cur == 0) audio_ring_buf.len - 1 else audio_ring_write_cur - 1;
        }
    }

    { // copy samples from user buffer into ring buffer
        var i: usize = 0;
        while (i < num_samples) : (i += 1) {
            audio_ring_buf[audio_ring_write_cur] = buffer.sample_buf[i];
            audio_ring_write_cur = (audio_ring_write_cur + 1) % audio_ring_buf.len;
        }
    }

    std.debug.assert(audio_read_cursor <= audio_write_cursor);

    audio_latency[audio_latency_cur] = audio_write_cursor - audio_read_cursor;

    if (audio_latency_cur + 1 == num_audio_latency_samples) {
        audio_latency_avg = 0;
        var i: usize = 0;
        while (i < num_audio_latency_samples) : (i += 1) {
            audio_latency_avg += audio_latency[i];
        }
        audio_latency_avg /= num_audio_latency_samples;
        audio_latency_cur = 0;
    } else audio_latency_cur += 1;

    audio_write_cursor += num_frames;

    var samples_queued = @atomicLoad(usize, &audio_samples_queued, .Acquire);
    while (@cmpxchgWeak(
        usize,
        &audio_samples_queued,
        samples_queued,
        samples_queued + num_samples,
        .Release,
        .Monotonic,
    )) |val| {
        samples_queued = val;
    }

    // std.log.debug("write cur = {}", .{audio_ring_write_cur});

    if (audio_playing == false) {
        audio_playing = true;
    }
}

pub fn run(args: struct {
    graphics_api: GraphicsAPI = .d3d11,
    requested_framerate: u16 = 0,
    title: []const u8 = "",
    window_size: struct {
        width: u16,
        height: u16,
    } = .{
        .width = 854,
        .height = 480,
    },
    enable_audio: bool = false,
    init_fn: fn (std.mem.Allocator) anyerror!void,
    deinit_fn: fn () void,
    frame_fn: fn (FrameInput) anyerror!bool,
}) !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    var allocator = gpa.allocator();

    // TODO(hazeycode): get monitor refresh and shoot for that, downgrade if we miss alot
    target_framerate = if (args.requested_framerate == 0) 60 else args.requested_framerate;

    window_width = args.window_size.width;
    window_height = args.window_size.height;

    audio_enabled = args.enable_audio;

    timer = try std.time.Timer.start();

    const hinstance = @ptrCast(HINSTANCE, kernel32.GetModuleHandleW(null) orelse {
        std.log.err("GetModuleHandleW failed with error: {}", .{kernel32.GetLastError()});
        return Error.FailedToGetModuleHandle;
    });

    var utf16_title = [_]u16{0} ** 64;
    _ = try std.unicode.utf8ToUtf16Le(utf16_title[0..], args.title);
    const utf16_title_ptr = @ptrCast([*:0]const u16, &utf16_title);

    try registerClass(hinstance, utf16_title_ptr);

    const hwnd = try createWindow(
        hinstance,
        utf16_title_ptr,
        utf16_title_ptr,
    );

    try createDeviceAndSwapchain(hwnd);
    try createRenderTargetView();

    if (audio_enabled) {
        audio_interface = try AudioInterface.init((1 * std.time.ns_per_s) / @intCast(u64, target_framerate));
        std.log.info(
            \\Initilised WASAPI interface:
            \\  {} channels
            \\  {} Hz
            \\  {} bits per sample
        ,
            .{
                audio_interface.format.nChannels,
                audio_interface.format.nSamplesPerSec,
                audio_interface.format.wBitsPerSample,
            },
        );

        const audio_ring_len = audio_interface.format.nSamplesPerSec * 2;
        audio_ring_buf = try allocator.alloc(f32, audio_ring_len);

        audio_thread = try std.Thread.spawn(.{}, audioThread, .{});
        audio_thread.detach();
    }
    defer {
        if (audio_enabled) {
            audio_interface.deinit();
            allocator.free(audio_ring_buf);
        }
    }

    try args.init_fn(allocator);
    defer args.deinit_fn();

    var frame_timer = try std.time.Timer.start();
    var prev_cpu_frame_elapsed: u64 = 0;

    while (quit == false) main_loop: {
        const prev_frame_elapsed = frame_timer.lap();

        const start_cpu_time = timestamp();

        var frame_mem_arena = std.heap.ArenaAllocator.init(allocator);
        defer frame_mem_arena.deinit();

        var frame_arena_allocator = frame_mem_arena.allocator();

        var key_events = std.ArrayList(FrameInput.KeyEvent).init(frame_arena_allocator);
        var mouse_button_events = std.ArrayList(FrameInput.MouseButtonEvent).init(frame_arena_allocator);

        var msg: user32.MSG = undefined;
        while (try user32.peekMessageW(&msg, null, 0, 0, user32.PM_REMOVE)) {
            _ = user32.translateMessage(&msg);
            _ = user32.dispatchMessageW(&msg);
            if (msg.message == user32.WM_QUIT) {
                quit = true;
                break :main_loop;
            }
        }

        target_frame_dt = @floatToInt(u64, (1 / @intToFloat(f64, target_framerate) * 1e9));

        quit = !(try args.frame_fn(.{
            .frame_arena_allocator = frame_arena_allocator,
            .quit_requested = window_closed,
            .target_frame_dt = target_frame_dt,
            .prev_frame_elapsed = prev_frame_elapsed,
            .input_events = .{
                .key_events = key_events.items,
                .mouse_button_events = mouse_button_events.items,
            },
            .window_size = .{
                .width = window_width,
                .height = window_height,
            },
            .debug_stats = .{
                .prev_cpu_frame_elapsed = prev_cpu_frame_elapsed,
                .audio_latency_avg_ms = @intToFloat(f32, audio_latency_avg) / @intToFloat(f32, audio_interface.format.nSamplesPerSec) * 1e3,
            },
        }));

        prev_cpu_frame_elapsed = timestamp() - start_cpu_time;

        try hrErrorOnFail(dxgi_swap_chain.?.Present(1, 0));
    }
}

fn audioThread() void {
    { // write some silence before starting the stream
        var buffer_frames: UINT = 0;
        hrErrorOnFail(audio_interface.client.GetBufferSize(&buffer_frames)) catch {
            std.debug.panic("audioThread: failed to prefill silence", .{});
        };
        std.log.debug("audio stream buffer size = {} frames", .{buffer_frames});

        var ptr: [*]f32 = undefined;
        hrErrorOnFail(audio_interface.render_client.GetBuffer(
            buffer_frames,
            @ptrCast(*?[*]BYTE, &ptr),
        )) catch {
            std.debug.panic("audioThread: failed to prefill silence", .{});
        };

        hrErrorOnFail(audio_interface.render_client.ReleaseBuffer(
            @intCast(UINT, buffer_frames),
            zwin32.wasapi.AUDCLNT_BUFFERFLAGS_SILENT,
        )) catch {
            std.debug.panic("audioThread: failed to prefill silence", .{});
        };
    }

    while (audio_playing == false) {
        std.time.sleep(1000);
    }

    hrErrorOnFail(audio_interface.client.Start()) catch {};
    defer _ = audio_interface.client.Stop();

    while (quit == false) {
        zwin32.base.WaitForSingleObject(audio_interface.buffer_ready_event, zwin32.base.INFINITE) catch {};

        var buffer_frames: UINT = 0;
        _ = audio_interface.client.GetBufferSize(&buffer_frames);

        var padding: UINT = 0;
        _ = audio_interface.client.GetCurrentPadding(&padding);

        const num_frames = buffer_frames - padding;
        const num_channels = audio_interface.format.nChannels;
        const num_samples = num_frames * num_channels;

        while (@atomicLoad(usize, &audio_samples_queued, .Monotonic) < num_samples) {
            continue;
        }

        var byte_buf: [*]BYTE = undefined;
        hrErrorOnFail(audio_interface.render_client.GetBuffer(num_frames, @ptrCast(*?[*]u8, &byte_buf))) catch |err| {
            std.log.warn("Audio GetBuffer failed with error: {}", .{err});
            continue;
        };

        {
            const bytes_per_sample = audio_interface.format.nBlockAlign / num_channels;
            var n: usize = 0;
            while (n < num_samples) : (n += 1) {
                const off = (n * bytes_per_sample);
                std.mem.copy(
                    BYTE,
                    byte_buf[off..(off + bytes_per_sample)],
                    std.mem.sliceAsBytes(audio_ring_buf[audio_ring_read_cur..(audio_ring_read_cur + 1)]),
                );
                audio_ring_read_cur = (audio_ring_read_cur + 1) % audio_ring_buf.len;
            }
            audio_read_cursor += num_samples / num_channels;
        }

        _ = audio_interface.render_client.ReleaseBuffer(
            @intCast(UINT, num_frames),
            0,
        );

        var samples_queued = @atomicLoad(usize, &audio_samples_queued, .Acquire);
        while (@cmpxchgWeak(
            usize,
            &audio_samples_queued,
            samples_queued,
            samples_queued - num_samples,
            .Release,
            .Monotonic,
        )) |val| {
            samples_queued = val;
        }

        std.time.sleep(1000);
    }
}

fn wndProc(hwnd: HWND, msg: UINT, wparam: WPARAM, lparam: LPARAM) callconv(.C) LRESULT {
    switch (msg) {
        user32.WM_CLOSE => {
            window_closed = true;
            return 0;
        },
        user32.WM_DESTROY => user32.postQuitMessage(0),
        else => {},
    }
    return user32.defWindowProcW(hwnd, msg, wparam, lparam);
}

fn registerClass(hinstance: HINSTANCE, name: LPCWSTR) !void {
    var wndclass = user32.WNDCLASSEXW{
        .cbSize = @sizeOf(user32.WNDCLASSEXW),
        .style = 0,
        .lpfnWndProc = wndProc,
        .cbClsExtra = 0,
        .cbWndExtra = 0,
        .hInstance = hinstance,
        .hIcon = null,
        .hCursor = null,
        .hbrBackground = null,
        .lpszMenuName = null,
        .lpszClassName = name,
        .hIconSm = null,
    };

    _ = try user32.registerClassExW(&wndclass);
}

fn createWindow(
    hinstance: HINSTANCE,
    class_name: LPCWSTR,
    window_name: LPCWSTR,
) !HWND {
    const offset_x = 60;
    const offset_y = 60;
    var rect = RECT{
        .left = offset_x,
        .top = offset_y,
        .right = offset_x + window_width,
        .bottom = offset_y + window_height,
    };
    const style: DWORD = user32.WS_OVERLAPPEDWINDOW;
    try user32.adjustWindowRectEx(&rect, style, false, 0);
    const hwnd = try user32.createWindowExW(
        0,
        class_name,
        window_name,
        style,
        rect.left,
        rect.top,
        rect.right - rect.left,
        rect.bottom - rect.top,
        null,
        null,
        hinstance,
        null,
    );
    _ = user32.showWindow(hwnd, user32.SW_SHOWNORMAL);
    try user32.updateWindow(hwnd);
    return hwnd;
}

var dxgi_swap_chain: ?*dxgi.ISwapChain = null;
var d3d11_device: ?*d3d11.IDevice = null;
var d3d11_device_context: ?*d3d11.IDeviceContext = null;
var d3d11_render_target_view: ?*d3d11.IRenderTargetView = null;

fn createDeviceAndSwapchain(hwnd: HWND) zwin32.HResultError!void {
    const STANDARD_MULTISAMPLE_QUALITY_LEVELS = enum(UINT) {
        STANDARD_MULTISAMPLE_PATTERN = 0xffffffff,
        CENTER_MULTISAMPLE_PATTERN = 0xfffffffe,
    };

    // TODO(chris): check that hardware supports the multisampling values we want
    // and downgrade if nessesary
    var swapchain_desc: dxgi.SWAP_CHAIN_DESC = .{
        .BufferDesc = .{
            .Width = 0,
            .Height = 0,
            .RefreshRate = .{
                .Numerator = 0,
                .Denominator = 1,
            },
            .Format = dxgi.FORMAT.B8G8R8A8_UNORM,
            .ScanlineOrdering = dxgi.MODE_SCANLINE_ORDER.UNSPECIFIED,
            .Scaling = dxgi.MODE_SCALING.UNSPECIFIED,
        },
        .SampleDesc = .{
            .Count = 4,
            .Quality = @enumToInt(STANDARD_MULTISAMPLE_QUALITY_LEVELS.STANDARD_MULTISAMPLE_PATTERN),
        },
        .BufferUsage = dxgi.USAGE_RENDER_TARGET_OUTPUT,
        .BufferCount = 1,
        .OutputWindow = hwnd,
        .Windowed = TRUE,
        .SwapEffect = dxgi.SWAP_EFFECT.DISCARD,
        .Flags = 0,
    };

    var flags: UINT = d3d11.CREATE_DEVICE_SINGLETHREADED;
    if (builtin.mode == .Debug) {
        flags |= d3d11.CREATE_DEVICE_DEBUG;
    }

    var feature_level: d3d.FEATURE_LEVEL = .FL_11_1;

    try hrErrorOnFail(d3d11.D3D11CreateDeviceAndSwapChain(
        null,
        d3d.DRIVER_TYPE.HARDWARE,
        null,
        flags,
        null,
        0,
        d3d11.SDK_VERSION,
        &swapchain_desc,
        &dxgi_swap_chain,
        &d3d11_device,
        &feature_level,
        &d3d11_device_context,
    ));
}

fn createRenderTargetView() zwin32.HResultError!void {
    var framebuffer: *d3d11.IResource = undefined;
    try hrErrorOnFail(dxgi_swap_chain.?.GetBuffer(
        0,
        &d3d11.IID_IResource,
        @ptrCast(*?*anyopaque, &framebuffer),
    ));
    try hrErrorOnFail(d3d11_device.?.CreateRenderTargetView(
        framebuffer,
        null,
        &d3d11_render_target_view,
    ));
    _ = framebuffer.Release();
}

export fn getD3D11Device() *d3d11.IDevice {
    return d3d11_device.?;
}

export fn getD3D11DeviceContext() *d3d11.IDeviceContext {
    return d3d11_device_context.?;
}

export fn getD3D11RenderTargetView() *d3d11.IRenderTargetView {
    return d3d11_render_target_view.?;
}
