const std = @import("std");
const builtin = @import("builtin");

const log = std.log.scoped(.@"brucelib.platform.win32");

const zwin32 = @import("vendored/zwin32/src/zwin32.zig");
const BYTE = zwin32.base.BYTE;
const UINT = zwin32.base.UINT;
const WORD = zwin32.base.WORD;
const DWORD = zwin32.base.DWORD;
const BOOL = zwin32.base.BOOL;
const TRUE = zwin32.base.TRUE;
const FALSE = zwin32.base.FALSE;
const LPCWSTR = zwin32.base.LPCWSTR;
const WPARAM = zwin32.base.WPARAM;
const LPARAM = zwin32.base.LPARAM;
const LRESULT = zwin32.base.LRESULT;
const HRESULT = zwin32.base.HRESULT;
const HANDLE = zwin32.base.HANDLE;
const HINSTANCE = zwin32.base.HINSTANCE;
const HWND = zwin32.base.HWND;
const RECT = zwin32.base.RECT;
const POINT = zwin32.base.POINT;
const kernel32 = zwin32.base.kernel32;
const user32 = zwin32.base.user32;
const dxgi = zwin32.dxgi;
const d3d = zwin32.d3d;
const d3d11 = zwin32.d3d11;
const d3dcompiler = zwin32.d3dcompiler;
const xinput = zwin32.xinput;
const hrErrorOnFail = zwin32.hrErrorOnFail;

const L = std.unicode.utf8ToUtf16LeStringLiteral;

const common = @import("common.zig");
const ring_buffers = @import("ring_buffers.zig");

pub fn using(comptime module_config: common.ModuleConfig) type {
    const Profiler = module_config.Profiler;

    return struct {
        pub const InitFn = common.InitFn;
        pub const DeinitFn = common.DeinitFn;
        pub const FramePrepareFn = common.FramePrepareFn;
        pub const FrameFn = common.FrameFn;
        pub const FrameEndFn = common.FrameEndFn;
        pub const AudioPlaybackFn = common.AudioPlaybackFn;
        pub const FrameInput = common.FrameInput;
        pub const AudioPlaybackStream = common.AudioPlaybackStream;
        pub const WindowEvent = common.WindowEvent;
        pub const KeyWindowEvent = common.KeyWindowEvent;
        pub const MouseWindowEvent = common.MouseWindowEvent;
        pub const GamepadPollEvent = common.GamepadPollEvent;
        pub const Key = common.Key;
        pub const MouseButton = common.MouseButton;
        pub const GamepadState = common.GamepadState;

        const WasapiInterface = @import("win32/WasapiInterface.zig");
        const AudioPlaybackInterface = WasapiInterface;

        pub const Error = error{
            FailedToGetModuleHandle,
        };

        const GraphicsAPI = enum {
            d3d11,
        };

        pub var target_framerate: u16 = undefined;

        var frame_prepare_fn: FramePrepareFn = undefined;
        var frame_fn: FrameFn = undefined;
        var frame_end_fn: FrameEndFn = undefined;

        var global_timer: std.time.Timer = undefined;
        var quit = false;
        var window: HWND = undefined;
        var resize_swapchain_buffers = false;
        var window_width: u16 = undefined;
        var window_height: u16 = undefined;
        var mouse_screen_x: i32 = 0;
        var mouse_screen_y: i32 = 0;
        var xinput_device_states: [xinput.XUSER_MAX_COUNT]bool = .{false} ** xinput.XUSER_MAX_COUNT;
        var xinput_states: [xinput.XUSER_MAX_COUNT]xinput.STATE = undefined;

        var window_events_buffer = ring_buffers.RingBufferStatic(WindowEvent, 64){};
        var key_window_events_buffer = ring_buffers.RingBufferStatic(KeyWindowEvent, 128){};
        var mouse_window_events_buffer = ring_buffers.RingBufferStatic(MouseWindowEvent, 128){};
        var gamepad_poll_events_buffer = ring_buffers.RingBufferStatic(GamepadPollEvent, 1024){};

        var display = struct {
            thread: std.Thread = undefined,
        }{};

        var audio_playback = struct {
            user_cb: ?fn (AudioPlaybackStream) anyerror!u32 = null,
            interface: AudioPlaybackInterface = undefined,
            thread: std.Thread = undefined,
        }{};

        pub fn get_d3d11_device() *d3d11.IDevice {
            return d3d11_device.?;
        }

        pub fn get_d3d11_device_context() *d3d11.IDeviceContext {
            return d3d11_device_context.?;
        }

        pub fn get_d3d11_render_target_view() *d3d11.IRenderTargetView {
            return d3d11_render_target_view.?;
        }

        pub fn get_sample_rate() u32 {
            return audio_playback.interface.sample_rate;
        }

        /// Returns application uptime (in nanoseconds)
        pub fn get_time() u64 {
            return global_timer.read();
        }

        pub fn run(
            allocator: std.mem.Allocator,
            run_config: struct {
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
                target_input_poll_rate: u32 = 200,
                init_fn: InitFn,
                deinit_fn: DeinitFn,
                frame_prepare_fn: FramePrepareFn,
                frame_fn: FrameFn,
                frame_end_fn: FrameEndFn,
                audio_playback: ?struct {
                    request_sample_rate: u32 = 48000,
                    callback: AudioPlaybackFn = null,
                },
            },
        ) !void {
            var main_mem_arena = std.heap.ArenaAllocator.init(allocator);
            defer main_mem_arena.deinit();

            frame_prepare_fn = run_config.frame_prepare_fn;
            frame_fn = run_config.frame_fn;
            frame_end_fn = run_config.frame_end_fn;

            // TODO(hazeycode): downgrade target framerate if we miss alot
            target_framerate = if (run_config.requested_framerate == 0)
                60 // TODO(hazeycode): get monitor refresh rate
            else
                run_config.requested_framerate;

            window_width = run_config.window_size.width;
            window_height = run_config.window_size.height;

            const hinstance = @ptrCast(HINSTANCE, kernel32.GetModuleHandleW(null) orelse {
                log.err("GetModuleHandleW failed with error: {}", .{kernel32.GetLastError()});
                return Error.FailedToGetModuleHandle;
            });

            var utf16_title = [_]u16{0} ** 64;
            _ = try std.unicode.utf8ToUtf16Le(utf16_title[0..], run_config.title);
            const utf16_title_ptr = @ptrCast([*:0]const u16, &utf16_title);

            var wndclass = user32.WNDCLASSEXW{
                .cbSize = @sizeOf(user32.WNDCLASSEXW),
                .style = 0,
                .lpfnWndProc = wnd_proc,
                .cbClsExtra = 0,
                .cbWndExtra = 0,
                .hInstance = hinstance,
                .hIcon = null,
                .hCursor = null,
                .hbrBackground = null,
                .lpszMenuName = null,
                .lpszClassName = utf16_title_ptr,
                .hIconSm = null,
            };
            _ = try user32.registerClassExW(&wndclass);

            window = try createWindow(
                hinstance,
                utf16_title_ptr,
                utf16_title_ptr,
            );

            try create_device_and_swapchain(window);
            try create_render_target_view();

            const audio_enabled = (run_config.audio_playback != null);

            if (audio_enabled) {
                audio_playback.user_cb = run_config.audio_playback.?.callback;
                audio_playback.interface = try AudioPlaybackInterface.init(
                    run_config.audio_playback.?.request_sample_rate,
                );
                log.info(
                    "Initilised audio playback (WASAPI): {} channels, {} Hz, {} bits per sample",
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

            xinput.XInputEnable(TRUE);

            try run_config.init_fn(main_mem_arena.allocator());
            defer run_config.deinit_fn(main_mem_arena.allocator());

            if (audio_enabled) {
                audio_playback.thread = try std.Thread.spawn(.{}, audio_thread, .{});
                audio_playback.thread.detach();
            }

            display.thread = try std.Thread.spawn(
                .{},
                display_thread,
                .{main_mem_arena.allocator()},
            );

            while (quit == false) {
                var input_frame_timer = try std.time.Timer.start();
                {
                    const trace_zone = Profiler.zone_name_colour(
                        @src(),
                        "platform.win32 main thread loop",
                        module_config.profile_marker_colour,
                    );
                    defer trace_zone.End();

                    var msg: user32.MSG = undefined;
                    while (try user32.peekMessageW(&msg, null, 0, 0, user32.PM_REMOVE)) {
                        _ = user32.translateMessage(&msg);
                        _ = user32.dispatchMessageW(&msg);
                        if (msg.message == user32.WM_QUIT) {
                            quit = true;
                        }
                    }

                    var cursor_pos: POINT = undefined;
                    _ = zwin32.base.GetCursorPos(&cursor_pos);
                    mouse_screen_x = cursor_pos.x;
                    mouse_screen_y = cursor_pos.y;

                    for (xinput_states) |*state, i| {
                        const prev_state = state.*;
                        switch (xinput.XInputGetState(@intCast(DWORD, i), state)) {
                            xinput.ERROR_SUCCESS => {},
                            xinput.ERROR_DEVICE_NOT_CONNECTED => {
                                if (xinput_device_states[i]) {
                                    xinput_states[i] = std.mem.zeroes(xinput.STATE);
                                    queue_gamepad_event(@intCast(u32, i), .disconnected, .{});
                                    xinput_device_states[i] = false;
                                }
                                continue;
                            },
                            else => {
                                log.err("XInputGetState failed for user index {}", .{i});
                                continue;
                            },
                        }
                        if (xinput_device_states[i] == false) {
                            queue_gamepad_event(@intCast(u32, i), .connected, .{});
                            xinput_device_states[i] = true;
                        }
                        if (state.dwPacketNumber != prev_state.dwPacketNumber) {
                            queue_gamepad_event(
                                @intCast(u32, i),
                                .none,
                                .{
                                    .buttons = .{
                                        .dpad_up = get_button(state.Gamepad.wButtons, xinput.GAMEPAD_DPAD_UP),
                                        .dpad_down = get_button(state.Gamepad.wButtons, xinput.GAMEPAD_DPAD_DOWN),
                                        .dpad_left = get_button(state.Gamepad.wButtons, xinput.GAMEPAD_DPAD_LEFT),
                                        .dpad_right = get_button(state.Gamepad.wButtons, xinput.GAMEPAD_DPAD_RIGHT),
                                        .start = get_button(state.Gamepad.wButtons, xinput.GAMEPAD_START),
                                        .back = get_button(state.Gamepad.wButtons, xinput.GAMEPAD_BACK),
                                        .left_thumb = get_button(state.Gamepad.wButtons, xinput.GAMEPAD_LEFT_THUMB),
                                        .right_thumb = get_button(state.Gamepad.wButtons, xinput.GAMEPAD_RIGHT_THUMB),
                                        .left_shoulder = get_button(state.Gamepad.wButtons, xinput.GAMEPAD_LEFT_SHOULDER),
                                        .right_shoulder = get_button(state.Gamepad.wButtons, xinput.GAMEPAD_RIGHT_SHOULDER),
                                        .a = get_button(state.Gamepad.wButtons, xinput.GAMEPAD_A),
                                        .b = get_button(state.Gamepad.wButtons, xinput.GAMEPAD_B),
                                        .x = get_button(state.Gamepad.wButtons, xinput.GAMEPAD_X),
                                        .y = get_button(state.Gamepad.wButtons, xinput.GAMEPAD_Y),
                                    },
                                    .left_thumb_x = state.Gamepad.sThumbLX,
                                    .left_thumb_y = state.Gamepad.sThumbLY,
                                    .right_thumb_x = state.Gamepad.sThumbRX,
                                    .right_thumb_y = state.Gamepad.sThumbRY,
                                    .left_trigger = state.Gamepad.bLeftTrigger,
                                    .right_trigger = state.Gamepad.bRightTrigger,
                                },
                            );
                        }
                    }
                }

                { // Wait for time remaining (in one-hundred-nanoseconds) until target input frame time
                    const elapsed = input_frame_timer.lap() / 100;
                    const target = 10_000_000 / run_config.target_input_poll_rate;
                    if (elapsed < target) {
                        const remain = target - elapsed;
                        const wait_object = @ptrCast(HANDLE, zwin32.base.CreateWaitableTimerExW(
                            null,
                            null,
                            zwin32.base.CREATE_WAITABLE_TIMER_HIGH_RESOLUTION,
                            zwin32.base.EVENT_ALL_ACCESS,
                        ));
                        const due_time = -@intCast(i64, remain);
                        if (zwin32.base.SetWaitableTimer(
                            wait_object,
                            &due_time,
                            0,
                            null,
                            null,
                            FALSE,
                        ) > 0) {
                            _ = try zwin32.base.WaitForSingleObject(wait_object, zwin32.base.INFINITE);
                        } else {
                            log.err("SetWaitableTimer failed with error: {}", .{kernel32.GetLastError()});
                        }
                    }
                }
            }

            display.thread.join();
        }

        inline fn get_button(buttons: WORD, mask: WORD) u1 {
            return if ((buttons & mask) > 0) 1 else 0;
        }

        fn display_thread(allocator: std.mem.Allocator) !void {
            Profiler.set_thread_name("Display thread");

            var prev_frame_elapsed: u64 = 0;
            var prev_cpu_elapsed: u64 = 0;

            var timer = try std.time.Timer.start();
            while (quit == false) {
                const trace_zone = Profiler.zone_name_colour(
                    @src(),
                    "platform.win32 display thread loop",
                    module_config.profile_marker_colour,
                );
                defer trace_zone.End();

                {
                    const trace_zone_present = Profiler.zone_name_colour(
                        @src(),
                        "platform.win32 present",
                        module_config.profile_marker_colour,
                    );
                    defer trace_zone_present.End();

                    try hrErrorOnFail(dxgi_swap_chain.?.Present(1, 0));
                }

                if (resize_swapchain_buffers) {
                    resize_swapchain_buffers = false;

                    _ = d3d11_render_target_view.?.Release();

                    try hrErrorOnFail(dxgi_swap_chain.?.ResizeBuffers(
                        0, // preserves the existing number of buffers in the swap chain
                        window_width,
                        window_height,
                        dxgi.FORMAT.UNKNOWN, // preserves the existing back buffer format
                        0,
                    ));

                    try create_render_target_view();
                }

                frame_prepare_fn();

                var cpu_frame_timer = try std.time.Timer.start();

                Profiler.frame_mark();

                var frame_mem_arena = std.heap.ArenaAllocator.init(allocator);
                defer frame_mem_arena.deinit();

                const window_events = try window_events_buffer.drain(frame_mem_arena.allocator());
                const key_window_events = try key_window_events_buffer.drain(frame_mem_arena.allocator());
                const mouse_window_events = try mouse_window_events_buffer.drain(frame_mem_arena.allocator());
                const gamepad_poll_events = try gamepad_poll_events_buffer.drain(frame_mem_arena.allocator());

                const target_frame_dt = @floatToInt(u64, (1 / @intToFloat(f64, target_framerate) * 1e9));

                quit = !(try frame_fn(.{
                    .frame_arena_allocator = frame_mem_arena.allocator(),
                    .target_frame_dt = target_frame_dt,
                    .prev_frame_elapsed = prev_frame_elapsed,
                    .window_events = window_events,
                    .key_window_events = key_window_events,
                    .mouse_window_events = mouse_window_events,
                    .gamepad_poll_events = gamepad_poll_events,
                    .mouse_screen_x = mouse_screen_x,
                    .mouse_screen_y = mouse_screen_y,
                    .window_size = .{ .width = window_width, .height = window_height },
                    .debug_stats = .{
                        .prev_cpu_elapsed = prev_cpu_elapsed,
                    },
                }));

                prev_cpu_elapsed = cpu_frame_timer.read();

                prev_frame_elapsed = timer.lap();

                frame_end_fn();
            }
        }

        fn audio_thread() !void {
            Profiler.set_thread_name("Audio playback thread");

            { // write some silence before starting the stream
                var buffer_frames: UINT = 0;
                hrErrorOnFail(audio_playback.interface.client.GetBufferSize(&buffer_frames)) catch {
                    std.debug.panic("audio_thread: failed to prefill silence", .{});
                };
                log.debug("audio stream buffer size = {} frames", .{buffer_frames});

                var ptr: [*]f32 = undefined;
                hrErrorOnFail(audio_playback.interface.render_client.GetBuffer(
                    buffer_frames,
                    @ptrCast(*?[*]BYTE, &ptr),
                )) catch {
                    std.debug.panic("audio_thread: failed to prefill silence", .{});
                };

                hrErrorOnFail(audio_playback.interface.render_client.ReleaseBuffer(
                    @intCast(UINT, buffer_frames),
                    zwin32.wasapi.AUDCLNT_BUFFERFLAGS_SILENT,
                )) catch {
                    std.debug.panic("audio_thread: failed to prefill silence", .{});
                };
            }

            hrErrorOnFail(audio_playback.interface.client.Start()) catch {};
            defer _ = audio_playback.interface.client.Stop();

            log.debug("audio playback started", .{});

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

        fn wnd_proc(hwnd: HWND, msg: UINT, wparam: WPARAM, lparam: LPARAM) callconv(.C) LRESULT {
            switch (msg) {
                user32.WM_SIZE => {
                    window_width = zwin32.base.LOWORD(@intCast(DWORD, lparam));
                    window_height = zwin32.base.HIWORD(@intCast(DWORD, lparam));
                    resize_swapchain_buffers = true;
                    window_events_buffer.push(.{
                        .window_id = @ptrToInt(hwnd),
                        .action = .resized,
                        .width = window_width,
                        .height = window_height,
                    }) catch |err| log.err("Failed to queue window resize event with error: {}", .{err});
                },
                user32.WM_CLOSE => window_events_buffer.push(.{
                    .window_id = @ptrToInt(hwnd),
                    .action = .closed,
                    .width = window_width,
                    .height = window_height,
                }) catch |err| log.err("Failed to queue window close event with error: {}", .{err}),
                user32.WM_DESTROY => user32.postQuitMessage(0),
                user32.WM_LBUTTONDOWN => queue_mouse_button_event(hwnd, .button_pressed, .left),
                user32.WM_LBUTTONUP => queue_mouse_button_event(hwnd, .button_released, .left),
                user32.WM_MBUTTONDOWN => queue_mouse_button_event(hwnd, .button_pressed, .middle),
                user32.WM_MBUTTONUP => queue_mouse_button_event(hwnd, .button_released, .middle),
                user32.WM_RBUTTONDOWN => queue_mouse_button_event(hwnd, .button_pressed, .right),
                user32.WM_RBUTTONUP => queue_mouse_button_event(hwnd, .button_released, .right),
                user32.WM_XBUTTONDOWN, user32.WM_XBUTTONUP => {},
                user32.WM_KEYDOWN, user32.WM_SYSKEYDOWN => queue_key_event(hwnd, .press, wparam), // TODO(hazeycode): key repeat events
                user32.WM_KEYUP, user32.WM_SYSKEYUP => queue_key_event(hwnd, .release, wparam),
                else => {},
            }
            return user32.defWindowProcW(hwnd, msg, wparam, lparam);
        }

        fn queue_key_event(hwnd: HWND, action: KeyWindowEvent.Action, keycode: WPARAM) void {
            key_window_events_buffer.push(.{
                .window_id = @ptrToInt(hwnd),
                .action = action,
                .key = translate_keycode(keycode),
            }) catch |err| log.err("Failed to queue key event with error: {}", .{err});
        }

        fn queue_mouse_button_event(hwnd: HWND, action: MouseWindowEvent.Action, button: MouseButton) void {
            var cursor_pos: POINT = undefined;
            _ = zwin32.base.GetCursorPos(&cursor_pos);
            _ = zwin32.base.ScreenToClient(window, &cursor_pos);
            mouse_window_events_buffer.push(.{
                .window_id = @ptrToInt(hwnd),
                .action = action,
                .button = button,
                .x = cursor_pos.x,
                .y = cursor_pos.y,
            }) catch |err| log.err("Failed to queue mouse button event with error: {}", .{err});
        }

        fn queue_gamepad_event(user_index: u32, action: GamepadPollEvent.Action, state: GamepadState) void {
            gamepad_poll_events_buffer.push(.{
                .user_index = user_index,
                .action = action,
                .state = state,
            }) catch |err| log.err("Failed to queue gamepad event with error: {}", .{err});
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

        fn create_device_and_swapchain(hwnd: HWND) zwin32.HResultError!void {
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

        fn create_render_target_view() zwin32.HResultError!void {
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

        fn translate_keycode(wparam: WPARAM) Key {
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
