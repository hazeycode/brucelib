const std = @import("std");
const builtin = @import("builtin");

const log = std.log.scoped(.@"brucelib.platform.win32");

const common = @import("common.zig");

pub fn using(comptime config: common.ModuleConfig) type {
    const Profiler = config.Profiler;

    return struct {
        pub const InitFn = common.InitFn;
        pub const DeinitFn = common.DeinitFn;
        pub const FrameFn = common.FrameFn;
        pub const AudioPlaybackFn = common.AudioPlaybackFn;
        pub const FrameInput = common.FrameInput;
        pub const AudioPlaybackStream = common.AudioPlaybackStream;
        pub const KeyEvent = common.KeyEvent;
        pub const MouseButton = common.MouseButton;
        pub const MouseButtonEvent = common.MouseButtonEvent;
        pub const Key = common.Key;

        const WasapiInterface = @import("win32/WasapiInterface.zig");
        const AudioPlaybackInterface = WasapiInterface;

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

        pub var target_framerate: u16 = undefined;
        var target_frame_dt: u64 = undefined;
        var window_width: u16 = undefined;
        var window_height: u16 = undefined;
        var mouse_x: i32 = undefined;
        var mouse_y: i32 = undefined;
        var key_events: std.ArrayList(KeyEvent) = undefined;
        var mouse_button_events: std.ArrayList(MouseButtonEvent) = undefined;

        pub var audio_playback = struct {
            user_cb: ?fn (AudioPlaybackStream) anyerror!u32 = null,
            interface: AudioPlaybackInterface = undefined,
            thread: std.Thread = undefined,
        }{};

        var window_closed = false;
        var quit = false;

        pub fn getD3D11Device() *d3d11.IDevice {
            return d3d11_device.?;
        }

        pub fn getD3D11DeviceContext() *d3d11.IDeviceContext {
            return d3d11_device_context.?;
        }

        pub fn getD3D11RenderTargetView() *d3d11.IRenderTargetView {
            return d3d11_render_target_view.?;
        }

        pub fn getSampleRate() u32 {
            return audio_playback.interface.sample_rate;
        }

        pub fn run(
            args: struct {
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
                init_fn: InitFn,
                deinit_fn: DeinitFn,
                frame_fn: FrameFn,
                audio_playback: ?struct {
                    request_sample_rate: u32 = 48000,
                    callback: AudioPlaybackFn = null,
                },
            },
        ) !void {
            var gpa = std.heap.GeneralPurposeAllocator(.{}){};
            defer _ = gpa.deinit();

            var allocator = gpa.allocator();

            // TODO(hazeycode): get monitor refresh and shoot for that, downgrade if we miss alot
            target_framerate = if (args.requested_framerate == 0) 60 else args.requested_framerate;

            window_width = args.window_size.width;
            window_height = args.window_size.height;

            const hinstance = @ptrCast(HINSTANCE, kernel32.GetModuleHandleW(null) orelse {
                log.err("GetModuleHandleW failed with error: {}", .{kernel32.GetLastError()});
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

            const audio_enabled = (args.audio_playback != null);

            if (audio_enabled) {
                audio_playback.user_cb = args.audio_playback.?.callback;
                audio_playback.interface = try AudioPlaybackInterface.init(
                    args.audio_playback.?.request_sample_rate,
                );
                log.info(
                    \\Initilised audio playback (WASAPI):
                    \\  {} channels
                    \\  {} Hz
                    \\  {} bits per sample
                ,
                    .{
                        audio_playback.interface.num_channels,
                        audio_playback.interface.sample_rate,
                        audio_playback.interface.bits_per_sample,
                    },
                );
            }
            defer {
                if (audio_enabled) {
                    audio_playback.interface.deinit();
                }
            }

            try args.init_fn(allocator);
            defer args.deinit_fn(allocator);

            if (audio_enabled) {
                audio_playback.thread = try std.Thread.spawn(.{}, audioThread, .{});
                audio_playback.thread.detach();
            }
            
            var prev_frame_elapsed: u64 = 0;
            var prev_cpu_elapsed: u64 = 0;

            var timer = try std.time.Timer.start();
            while (quit == false) main_loop: {
                prev_frame_elapsed = timer.lap();
                
                defer Profiler.frame_mark();

                var frame_mem_arena = std.heap.ArenaAllocator.init(allocator);
                defer frame_mem_arena.deinit();

                var frame_arena_allocator = frame_mem_arena.allocator();

                key_events = std.ArrayList(KeyEvent).init(frame_arena_allocator);
                mouse_button_events = std.ArrayList(MouseButtonEvent).init(frame_arena_allocator);

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

                {
                    const trace_zone = Profiler.zone_name_colour(@src(), "request frame", 0x00_ff_00_00);
                    defer trace_zone.End();
                    quit = !(try args.frame_fn(.{
                        .frame_arena_allocator = frame_arena_allocator,
                        .quit_requested = window_closed,
                        .target_frame_dt = target_frame_dt,
                        .prev_frame_elapsed = prev_frame_elapsed,
                        .user_input = .{
                            .key_events = key_events.items,
                            .mouse_button_events = mouse_button_events.items,
                            .mouse_position = .{
                                .x = mouse_x,
                                .y = mouse_y,
                            },
                        },
                        .window_size = .{
                            .width = window_width,
                            .height = window_height,
                        },
                        .debug_stats = .{
                            .prev_cpu_elapsed = prev_cpu_elapsed,
                        },
                    }));
                }

                prev_cpu_elapsed = timer.read();

                try hrErrorOnFail(dxgi_swap_chain.?.Present(1, 0));
            }
        }

        fn audioThread() !void {
            { // write some silence before starting the stream
                var buffer_frames: UINT = 0;
                hrErrorOnFail(audio_playback.interface.client.GetBufferSize(&buffer_frames)) catch {
                    std.debug.panic("audioThread: failed to prefill silence", .{});
                };
                log.debug("audio stream buffer size = {} frames", .{buffer_frames});

                var ptr: [*]f32 = undefined;
                hrErrorOnFail(audio_playback.interface.render_client.GetBuffer(
                    buffer_frames,
                    @ptrCast(*?[*]BYTE, &ptr),
                )) catch {
                    std.debug.panic("audioThread: failed to prefill silence", .{});
                };

                hrErrorOnFail(audio_playback.interface.render_client.ReleaseBuffer(
                    @intCast(UINT, buffer_frames),
                    zwin32.wasapi.AUDCLNT_BUFFERFLAGS_SILENT,
                )) catch {
                    std.debug.panic("audioThread: failed to prefill silence", .{});
                };
            }

            hrErrorOnFail(audio_playback.interface.client.Start()) catch {};
            defer _ = audio_playback.interface.client.Stop();

            while (quit == false) {
                zwin32.base.WaitForSingleObject(audio_playback.interface.buffer_ready_event, zwin32.base.INFINITE) catch {
                    continue;
                };

                var buffer_frames: UINT = 0;
                _ = audio_playback.interface.client.GetBufferSize(&buffer_frames);

                var padding: UINT = 0;
                _ = audio_playback.interface.client.GetCurrentPadding(&padding);

                const num_frames = buffer_frames - padding;
                const num_channels = audio_playback.interface.num_channels;
                const num_samples = num_frames * num_channels;

                var byte_buf: [*]BYTE = undefined;
                hrErrorOnFail(audio_playback.interface.render_client.GetBuffer(num_frames, @ptrCast(*?[*]BYTE, &byte_buf))) catch |err| {
                    log.warn("Audio GetBuffer failed with error: {}", .{err});
                    continue;
                };

                const sample_buf = @ptrCast([*]f32, @alignCast(@alignOf(f32), byte_buf))[0..num_samples];

                const frames_written = try audio_playback.user_cb.?(.{
                    .sample_rate = audio_playback.interface.sample_rate,
                    .channels = num_channels,
                    .sample_buf = sample_buf,
                    .max_frames = num_frames,
                });
                if (frames_written < num_frames) {
                    log.warn("Audio playback underflow", .{});
                }

                _ = audio_playback.interface.render_client.ReleaseBuffer(
                    @intCast(UINT, num_frames),
                    0,
                );
            }
        }

        fn wndProc(hwnd: HWND, msg: UINT, wparam: WPARAM, lparam: LPARAM) callconv(.C) LRESULT {
            switch (msg) {
                user32.WM_CLOSE => {
                    window_closed = true;
                    return 0;
                },
                user32.WM_DESTROY => user32.postQuitMessage(0),
                user32.WM_MOUSEMOVE => {
                    // TODO(hazeycode): Scale mouse using dpi
                    const scale: f32 = 1;
                    mouse_x = @floatToInt(i32, @intToFloat(f32, zwin32.base.GET_X_LPARAM(lparam)) * scale);
                    mouse_y = @floatToInt(i32, @intToFloat(f32, zwin32.base.GET_Y_LPARAM(lparam)) * scale);
                    // TODO(hazeycode): Also track mouse position even when it's outside the window
                },
                user32.WM_KEYDOWN, user32.WM_SYSKEYDOWN, user32.WM_KEYUP, user32.WM_SYSKEYUP => {
                    const key = translateKey(wparam);
                    key_events.append(.{
                        .action = switch (msg) {
                            user32.WM_KEYDOWN, user32.WM_SYSKEYDOWN => .press,
                            user32.WM_KEYUP, user32.WM_SYSKEYUP => .release,
                            else => unreachable,
                            // TODO(hazeycode): key repeat events
                        },
                        .key = key,
                    }) catch |err| {
                        log.warn("Failed to translate key {} with error: {}", .{ wparam, err });
                    };
                },
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

        fn translateKey(wparam: WPARAM) Key {
            return switch (wparam) {
                zwin32.base.VK_ESCAPE => .escape,
                zwin32.base.VK_TAB => .tab,
                zwin32.base.VK_LSHIFT => .shift_left,
                zwin32.base.VK_RSHIFT => .shift_right,
                zwin32.base.VK_LCONTROL => .ctrl_left,
                zwin32.base.VK_RCONTROL => .ctrl_right,
                zwin32.base.VK_LMENU => .alt_left,
                zwin32.base.VK_RMENU => .alt_right,
                zwin32.base.VK_LWIN => .super_left,
                zwin32.base.VK_RWIN => .super_right,
                zwin32.base.VK_APPS => .menu,
                zwin32.base.VK_NUMLOCK => .numlock,
                zwin32.base.VK_CAPITAL => .capslock,
                zwin32.base.VK_SNAPSHOT => .printscreen,
                zwin32.base.VK_SCROLL => .scrolllock,
                zwin32.base.VK_PAUSE => .pause,
                zwin32.base.VK_DELETE => .delete,
                zwin32.base.VK_BACK => .backspace,
                zwin32.base.VK_RETURN => .enter,
                zwin32.base.VK_HOME => .home,
                zwin32.base.VK_END => .end,
                zwin32.base.VK_PRIOR => .pageup,
                zwin32.base.VK_NEXT => .pagedown,
                zwin32.base.VK_INSERT => .insert,
                zwin32.base.VK_LEFT => .left,
                zwin32.base.VK_RIGHT => .right,
                zwin32.base.VK_DOWN => .down,
                zwin32.base.VK_UP => .up,
                zwin32.base.VK_F1 => .f1,
                zwin32.base.VK_F2 => .f2,
                zwin32.base.VK_F3 => .f3,
                zwin32.base.VK_F4 => .f4,
                zwin32.base.VK_F5 => .f5,
                zwin32.base.VK_F6 => .f6,
                zwin32.base.VK_F7 => .f7,
                zwin32.base.VK_F8 => .f8,
                zwin32.base.VK_F9 => .f9,
                zwin32.base.VK_F10 => .f10,
                zwin32.base.VK_F11 => .f11,
                zwin32.base.VK_F12 => .f12,
                zwin32.base.VK_DIVIDE => .keypad_divide,
                zwin32.base.VK_MULTIPLY => .keypad_multiply,
                zwin32.base.VK_SUBTRACT => .keypad_subtract,
                zwin32.base.VK_ADD => .keypad_add,
                zwin32.base.VK_NUMPAD0 => .keypad_0,
                zwin32.base.VK_NUMPAD1 => .keypad_1,
                zwin32.base.VK_NUMPAD2 => .keypad_2,
                zwin32.base.VK_NUMPAD3 => .keypad_3,
                zwin32.base.VK_NUMPAD4 => .keypad_4,
                zwin32.base.VK_NUMPAD5 => .keypad_5,
                zwin32.base.VK_NUMPAD6 => .keypad_6,
                zwin32.base.VK_NUMPAD7 => .keypad_7,
                zwin32.base.VK_NUMPAD8 => .keypad_8,
                zwin32.base.VK_NUMPAD9 => .keypad_9,
                zwin32.base.VK_DECIMAL => .keypad_decimal,
                'A' => .a,
                'B' => .b,
                'C' => .c,
                'D' => .d,
                'E' => .e,
                'F' => .f,
                'G' => .g,
                'H' => .h,
                'I' => .i,
                'J' => .j,
                'K' => .k,
                'L' => .l,
                'M' => .m,
                'N' => .n,
                'O' => .o,
                'P' => .p,
                'Q' => .q,
                'R' => .r,
                'S' => .s,
                'T' => .t,
                'U' => .u,
                'V' => .v,
                'W' => .w,
                'X' => .x,
                'Y' => .y,
                'Z' => .z,
                '1' => .one,
                '2' => .two,
                '3' => .three,
                '4' => .four,
                '5' => .five,
                '6' => .six,
                '7' => .seven,
                '8' => .eight,
                '9' => .nine,
                '0' => .zero,
                zwin32.base.VK_SPACE => .space,
                zwin32.base.VK_OEM_MINUS => .minus,
                zwin32.base.VK_OEM_PLUS => .equal,
                zwin32.base.VK_OEM_4 => .bracket_left,
                zwin32.base.VK_OEM_6 => .bracket_right,
                zwin32.base.VK_OEM_5 => .backslash,
                zwin32.base.VK_OEM_1 => .semicolon,
                zwin32.base.VK_OEM_7 => .apostrophe,
                zwin32.base.VK_OEM_3 => .grave_accent,
                zwin32.base.VK_OEM_COMMA => .comma,
                zwin32.base.VK_OEM_PERIOD => .period,
                zwin32.base.VK_OEM_2 => .slash,
                else => .unknown,
            };
        }
    };
}
