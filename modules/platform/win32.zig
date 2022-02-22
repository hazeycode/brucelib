const std = @import("std");
const builtin = @import("builtin");
const FrameInput = @import("FrameInput.zig");

const WasapiInterface = @import("win32/WasapiInterface.zig");
const AudioInterface = WasapiInterface;

const zwin32 = @import("zwin32");
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

var timer: std.time.Timer = undefined;
pub fn timestamp() u64 {
    return timer.read();
}

var target_framerate: u16 = undefined;
var window_width: u16 = undefined;
var window_height: u16 = undefined;
var window_closed = false;

var audio_enabled: bool = undefined;
var audio_interface: AudioInterface = undefined;

const GraphicsAPI = enum {
    d3d11,
};

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
    init_fn: fn (std.mem.Allocator) anyerror!void,
    deinit_fn: fn () void,
    frame_fn: fn (FrameInput) anyerror!bool,
}) !void {
    timer = try std.time.Timer.start();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    // TODO(hazeycode): get monitor refresh and shoot for that, downgrade if we miss alot
    target_framerate = if (args.requested_framerate == 0) 60 else args.requested_framerate;

    window_width = args.window_size.width;
    window_height = args.window_size.height;

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

    // TODO(hazeycode): replace with user fed conditional
    audio_enabled = true;

    if (audio_enabled) {
        audio_interface = try AudioInterface.init();
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
    }
    defer {
        if (audio_enabled) audio_interface.deinit();
    }

    try args.init_fn(allocator);
    defer args.deinit_fn();

    var frame_timer = try std.time.Timer.start();
    var prev_cpu_frame_elapsed: u64 = 0;

    var quit = false;
    while (quit == false) main_loop: {
        const prev_frame_elapsed = frame_timer.lap();

        const start_cpu_time = timestamp();

        var frame_mem_arena = std.heap.ArenaAllocator.init(allocator);
        defer frame_mem_arena.deinit();

        const arena_allocator = frame_mem_arena.allocator();

        var key_events = std.ArrayList(FrameInput.KeyEvent).init(arena_allocator);
        var mouse_button_events = std.ArrayList(FrameInput.MouseButtonEvent).init(arena_allocator);

        var msg: user32.MSG = undefined;
        while (try user32.peekMessageW(&msg, null, 0, 0, user32.PM_REMOVE)) {
            _ = user32.translateMessage(&msg);
            _ = user32.dispatchMessageW(&msg);
            if (msg.message == user32.WM_QUIT) {
                quit = true;
                break :main_loop;
            }
        }

        const target_frame_dt = @floatToInt(u64, (1 / @intToFloat(f64, target_framerate) * 1e9));

        quit = !(try args.frame_fn(.{
            .frame_arena_allocator = arena_allocator,
            .quit_requested = window_closed,
            .frame_dt = @intCast(u64, @intCast(i128, prev_frame_elapsed) - target_frame_dt + target_frame_dt),
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
            },
        }));

        prev_cpu_frame_elapsed = timestamp() - start_cpu_time;

        try hrErrorOnFail(dxgi_swap_chain.?.Present(1, 0));
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
            .Quality = @enumToInt(d3d11.STANDARD_MULTISAMPLE_QUALITY_LEVELS.STANDARD_MULTISAMPLE_PATTERN),
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
