const std = @import("std");

const common = @import("common.zig");
const FrameInput = common.FrameInput;
const AudioPlaybackStream = common.AudioPlaybackStream;
const KeyEvent = common.KeyEvent;
const MouseButtonEvent = common.MouseButtonEvent;
const Key = common.Key;

const AlsaPlaybackInterface = @import("linux/AlsaPlaybackInterface.zig");
const AudioPlaybackInterface = AlsaPlaybackInterface;

const GraphicsAPI = enum {
    opengl,
};

var graphics_api: GraphicsAPI = undefined;

pub var target_framerate: u32 = undefined;

var window_width: u16 = undefined;
var window_height: u16 = undefined;

pub var audio_playback = struct {
    user_cb: ?fn (AudioPlaybackStream) anyerror!u32 = null,
    interface: AudioPlaybackInterface = undefined,
    thread: std.Thread = undefined,
}{};

var allocator: std.mem.Allocator = undefined;

var timer: std.time.Timer = undefined;

var window_closed = false;
var quit = false;

const num_keys = std.meta.fields(Key).len;
var key_states: [num_keys]bool = .{false} ** num_keys;
var key_repeats: [num_keys]u32 = .{0} ** num_keys;

pub fn getOpenGlProcAddress(_: ?*const anyopaque, entry_point: [:0]const u8) ?*const anyopaque {
    return X11.glXGetProcAddress(?*const anyopaque, entry_point.ptr) catch null;
}

pub fn timestamp() u64 {
    return timer.read();
}

pub fn run(args: struct {
    graphics_api: GraphicsAPI = .opengl,
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
    audio_playback_fn: ?fn (AudioPlaybackStream) anyerror!u32 = null,
}) !void {
    timer = try std.time.Timer.start();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    allocator = gpa.allocator();

    const windowing = X11;

    graphics_api = args.graphics_api;

    // TODO(hazeycode): get monitor refresh and shoot for that, downgrade if we miss alot
    target_framerate = if (args.requested_framerate == 0) 60 else args.requested_framerate;

    window_width = args.window_size.width;
    window_height = args.window_size.height;

    try windowing.init(args.title);
    defer windowing.deinit();

    const audio_enabled = (args.audio_playback_fn != null);

    if (audio_enabled) {
        audio_playback.user_cb = args.audio_playback_fn;

        const sample_rate = 48000;
        const buffer_size_frames = std.math.ceilPowerOfTwoAssert(
            u32, 
            3 * sample_rate / target_framerate,
        );

        audio_playback.interface = try AudioPlaybackInterface.init(
            sample_rate,
            buffer_size_frames,
        );

        std.log.info(
            \\Initilised audio playback (ALSA):
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

        audio_playback.thread = try std.Thread.spawn(.{}, audioThread, .{});
        audio_playback.thread.detach();
    }
    defer {
        if (audio_enabled) {
            audio_playback.interface.deinit();
        }
    }

    try args.init_fn(allocator);
    defer args.deinit_fn();

    var frame_timer = try std.time.Timer.start();

    var prev_cpu_frame_elapsed: u64 = 0;

    while (true) {
        const prev_frame_elapsed = frame_timer.lap();

        const start_cpu_time = timestamp();

        var frame_mem_arena = std.heap.ArenaAllocator.init(allocator);
        defer frame_mem_arena.deinit();

        const arena_allocator = frame_mem_arena.allocator();

        var key_events = std.ArrayList(KeyEvent).init(arena_allocator);
        var mouse_button_events = std.ArrayList(MouseButtonEvent).init(arena_allocator);

        try windowing.processEvents(
            &key_events,
            &mouse_button_events,
        );

        const mouse_pos = windowing.getMousePos();

        const target_frame_dt = @floatToInt(u64, (1 / @intToFloat(f64, target_framerate) * 1e9));

        quit = !(try args.frame_fn(.{
            .frame_arena_allocator = arena_allocator,
            .quit_requested = window_closed,
            .target_frame_dt = target_frame_dt,
            .prev_frame_elapsed = prev_frame_elapsed,
            .input_events = .{
                .key_events = key_events.items,
                .mouse_button_events = mouse_button_events.items,
            },
            .mouse_position = .{
                .x = mouse_pos.x,
                .y = mouse_pos.y,
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

        const remaining_frame_time = @intCast(i128, target_frame_dt - 100000) - frame_timer.read();
        if (remaining_frame_time > 0) {
            std.time.sleep(@intCast(u64, remaining_frame_time));
        }

        windowing.swapBuffers();

        if (quit) break;
    }
}

fn audioThread() !void {
    var buffer = try allocator.alloc(
        f32,
        audio_playback.interface.buffer_frames * audio_playback.interface.num_channels,
    );
    defer allocator.free(buffer);

    var read_cur: usize = 0;
    var write_cur: usize = 0;
    var samples_queued: usize = 0;

    std.mem.set(f32, buffer, 0);

    { // write a couple of frames of silence
        const samples_silence = 2 * audio_playback.interface.sample_rate / target_framerate;
        std.debug.assert(samples_silence < buffer.len);

        _ = audio_playback.interface.writeSamples(buffer[0..(0 + samples_silence)]);
    }

    try audio_playback.interface.prepare();

    while (quit == false) {
        if (samples_queued > 0) {

            var end = read_cur + samples_queued;
            if (end > buffer.len) {
                end = buffer.len;
            }

            if (end > read_cur) {

                const samples = buffer[read_cur..end];
                
                read_cur = (read_cur + samples.len) % buffer.len;

                samples_queued -= samples.len;

                if (audio_playback.interface.writeSamples(samples) == false) {
                    try audio_playback.interface.prepare();
                    continue;
                }
            }
        }

        if (samples_queued < buffer.len) {
            const max_samples = 3 * audio_playback.interface.sample_rate / target_framerate;
            std.debug.assert(max_samples < buffer.len);

            const end = if ((buffer.len - write_cur) > max_samples)
                write_cur + max_samples
            else
                buffer.len;

            const num_frames = try audio_playback.user_cb.?(.{
                .sample_rate = audio_playback.interface.sample_rate,
                .channels = audio_playback.interface.num_channels,
                .sample_buf = buffer[write_cur..end],
                .max_frames = @intCast(u32, end - write_cur) / audio_playback.interface.num_channels,
            });

            const num_samples = num_frames * audio_playback.interface.num_channels;

            samples_queued += num_samples;

            write_cur = (write_cur + num_samples) % buffer.len;
        }

        std.time.sleep(0);
    }
}

const X11 = struct {
    // TODO(chris): remove system header imports, create bindings
    const c = @cImport({
        @cInclude("X11/Xlib-xcb.h");
        @cInclude("X11/XKBlib.h");
        @cInclude("GL/glx.h");
        @cInclude("GL/glext.h");
    });

    var display: *c.Display = undefined;
    var connection: *c.xcb_connection_t = undefined;
    var atom_protocols: *c.xcb_intern_atom_reply_t = undefined;
    var atom_delete_window: *c.xcb_intern_atom_reply_t = undefined;
    var window: u32 = undefined;
    var fb_config: c.GLXFBConfig = undefined;

    fn init(window_title: []const u8) !void {
        c.XrmInitialize();

        display = c.XOpenDisplay(@intToPtr(?*const u8, 0)) orelse return error.XOpenDisplayFailed;

        _ = c.XkbSetDetectableAutoRepeat(display, c.True, null);

        connection = c.XGetXCBConnection(display) orelse return error.XGetXCBConnectionFailed;
        errdefer c.xcb_disconnect(connection);

        c.XSetEventQueueOwner(display, c.XCBOwnsEventQueue);

        const default_screen_num = c.XDefaultScreen(display);

        var screen: ?*c.xcb_screen_t = null;
        {
            var iter = c.xcb_setup_roots_iterator(c.xcb_get_setup(connection));
            var screen_num: u32 = 0;
            while (iter.rem > 0) : ({
                c.xcb_screen_next(&iter);
                screen_num += 1;
            }) {
                if (screen_num == default_screen_num) screen = iter.data;
            }
        }
        if (screen == null) return error.FailedToFindXCBScreen;

        const screen_root = screen.?.*.root;

        atom_protocols = c.xcb_intern_atom_reply(
            connection,
            c.xcb_intern_atom(connection, 1, 12, "WM_PROTOCOLS"),
            0,
        );
        errdefer _ = c.XFree(atom_protocols);

        atom_delete_window = c.xcb_intern_atom_reply(
            connection,
            c.xcb_intern_atom(connection, 0, 16, "WM_DELETE_WINDOW"),
            0,
        );
        errdefer _ = c.XFree(atom_delete_window);

        var visual_info: *c.XVisualInfo = undefined;

        switch (graphics_api) {
            .opengl => {
                // query opengl version
                var glx_ver_min: c_int = undefined;
                var glx_ver_maj: c_int = undefined;
                if (c.glXQueryVersion(display, &glx_ver_maj, &glx_ver_min) == 0) return error.FailedToQueryGLXVersion;
                std.log.info("GLX version {}.{}", .{ glx_ver_maj, glx_ver_min });

                // query framebuffer configurations that match visual_attribs
                const attrib_list = [_]c_int{
                    c.GLX_X_RENDERABLE,   c.True,
                    c.GLX_DRAWABLE_TYPE,  c.GLX_WINDOW_BIT,
                    c.GLX_RENDER_TYPE,    c.GLX_RGBA_BIT,
                    c.GLX_X_VISUAL_TYPE,  c.GLX_TRUE_COLOR,
                    c.GLX_RED_SIZE,       8,
                    c.GLX_GREEN_SIZE,     8,
                    c.GLX_BLUE_SIZE,      8,
                    c.GLX_ALPHA_SIZE,     8,
                    c.GLX_DEPTH_SIZE,     24,
                    c.GLX_STENCIL_SIZE,   8,
                    c.GLX_DOUBLEBUFFER,   c.True,
                    c.GLX_SAMPLE_BUFFERS, 1,
                    c.GLX_SAMPLES,        4,
                    c.None,
                };
                var num_fb_configs: c_int = 0;
                const fb_configs = c.glXChooseFBConfig(
                    display,
                    default_screen_num,
                    &attrib_list,
                    &num_fb_configs,
                );
                if (fb_configs == null) return error.FailedToQueryFramebufferConfigs;
                if (num_fb_configs == 0) return error.NoCompatibleFramebufferConfigsFound;
                defer _ = c.XFree(fb_configs);

                // use the first config and get visual info
                fb_config = fb_configs[0];
                visual_info = c.glXGetVisualFromFBConfig(display, fb_config) orelse return error.FailedToGetVisualFromFBConfig;
            },
        }

        const visual_id = @intCast(u32, c.XVisualIDFromVisual(visual_info.visual));

        // create colormap
        const colour_map = c.xcb_generate_id(connection);
        _ = c.xcb_create_colormap(connection, c.XCB_COLORMAP_ALLOC_NONE, colour_map, screen_root, visual_id);

        // create xcb window
        window = c.xcb_generate_id(connection);
        if (c.xcb_request_check(
            connection,
            c.xcb_create_window_checked(
                connection,
                c.XCB_COPY_FROM_PARENT,
                window,
                screen_root,
                0,
                0,
                window_width,
                window_height,
                0,
                c.XCB_WINDOW_CLASS_INPUT_OUTPUT,
                visual_id,
                c.XCB_CW_EVENT_MASK | c.XCB_CW_COLORMAP,
                &[_]u32{
                    c.XCB_EVENT_MASK_EXPOSURE |
                        c.XCB_EVENT_MASK_STRUCTURE_NOTIFY |
                        c.XCB_EVENT_MASK_KEY_PRESS |
                        c.XCB_EVENT_MASK_KEY_RELEASE |
                        c.XCB_EVENT_MASK_BUTTON_PRESS |
                        c.XCB_EVENT_MASK_BUTTON_RELEASE,
                    colour_map,
                    0,
                },
            ),
        ) != null) return error.FailedToCreateWindow;

        // hook up close button event
        _ = c.xcb_change_property(
            connection,
            c.XCB_PROP_MODE_REPLACE,
            window,
            atom_protocols.*.atom,
            4,
            32,
            1,
            &(atom_delete_window.*.atom),
        );

        if (window_title.len > 0) {
            _ = c.xcb_change_property(
                connection,
                c.XCB_PROP_MODE_REPLACE,
                window,
                c.XCB_ATOM_WM_NAME,
                c.XCB_ATOM_STRING,
                8,
                @intCast(u32, window_title.len),
                &window_title[0],
            );
        }

        _ = c.xcb_map_window(connection, window);
        _ = c.xcb_flush(connection);

        switch (graphics_api) {
            .opengl => {
                // load glXCreateContextAttribsARB fn ptr
                const glXGetProcAddressARBFn = fn (
                    ?*c.Display,
                    c.GLXFBConfig,
                    c.GLXContext,
                    c.Bool,
                    [*]const c_int,
                ) callconv(.C) c.GLXContext;
                const glXCreateContextAttribsARB = try glXGetProcAddressARB(
                    glXGetProcAddressARBFn,
                    "glXCreateContextAttribsARB",
                );

                // create context and set it as current
                const attribs = [_]c_int{
                    c.GLX_CONTEXT_MAJOR_VERSION_ARB, 4,
                    c.GLX_CONTEXT_MINOR_VERSION_ARB, 4,
                    c.GLX_CONTEXT_PROFILE_MASK_ARB,  c.GLX_CONTEXT_CORE_PROFILE_BIT_ARB,
                };
                const context = glXCreateContextAttribsARB(display, fb_config, null, c.True, &attribs);
                if (context == null) return error.FailedToCreateGLXContext;
                if (c.glXMakeCurrent(display, window, context) != c.True) return error.FailedToMakeGLXContextCurrent;

                std.log.info("OpenGL version {s}", .{c.glGetString(c.GL_VERSION)});
            },
        }
    }

    fn glXGetProcAddress(comptime T: type, sym_name: [*c]const u8) !T {
        const fn_ptr = c.glXGetProcAddress(sym_name) orelse return error.glXGetProcAddress;
        return @ptrCast(T, fn_ptr);
    }

    fn glXGetProcAddressARB(comptime T: type, sym_name: [*c]const u8) !T {
        const fn_ptr = c.glXGetProcAddressARB(sym_name) orelse return error.glXGetProcAddressARB;
        return @ptrCast(T, fn_ptr);
    }

    fn deinit() void {
        switch (graphics_api) {
            .opengl => {
                const context = c.glXGetCurrentContext();
                _ = c.glXMakeCurrent(display, 0, null);
                c.glXDestroyContext(display, context);
            },
        }
        _ = c.XFree(atom_delete_window);
        _ = c.XFree(atom_protocols);
        c.xcb_disconnect(connection);
    }

    fn swapBuffers() void {
        c.glXSwapBuffers(display, window);
    }

    fn getMousePos() struct { x: i32, y: i32 } {
        var root: c.Window = undefined;
        var child: c.Window = undefined;
        var root_x: i32 = 0;
        var root_y: i32 = 0;
        var win_x: i32 = 0;
        var win_y: i32 = 0;
        var mask: u32 = 0;
        _ = c.XQueryPointer(
            display,
            window,
            &root,
            &child,
            &root_x,
            &root_y,
            &win_x,
            &win_y,
            &mask,
        );
        return .{
            .x = win_x,
            .y = win_y,
        };
    }

    fn processEvents(
        key_events: anytype,
        mouse_button_events: anytype,
    ) !void {
        var xcb_event = c.xcb_poll_for_event(connection);
        while (@ptrToInt(xcb_event) > 0) : (xcb_event = c.xcb_poll_for_event(connection)) {
            defer _ = c.XFree(xcb_event);
            switch (xcb_event.*.response_type & ~@as(u32, 0x80)) {
                c.XCB_EXPOSE => {
                    _ = c.xcb_flush(connection);
                },
                c.XCB_CLIENT_MESSAGE => {
                    const xcb_client_message_event = @ptrCast(*c.xcb_client_message_event_t, xcb_event);
                    if (xcb_client_message_event.data.data32[0] == atom_delete_window.*.atom) {
                        window_closed = true;
                    }
                },
                c.XCB_CONFIGURE_NOTIFY => {
                    const xcb_config_event = @ptrCast(*c.xcb_configure_notify_event_t, xcb_event);
                    if (xcb_config_event.width != window_width or xcb_config_event.height != window_height) {
                        window_width = xcb_config_event.width;
                        window_height = xcb_config_event.height;
                    }
                },
                c.XCB_KEY_PRESS => {
                    const xcb_key_press_event = @ptrCast(*c.xcb_key_press_event_t, xcb_event);
                    if (translateKey(xcb_key_press_event.detail)) |key| {
                        const repeat = key_states[@enumToInt(key)];
                        if (repeat == false) {
                            key_repeats[@enumToInt(key)] += 1;
                            try key_events.append(.{
                                .action = .press,
                                .key = key,
                            });
                        } else {
                            key_repeats[@enumToInt(key)] = 1;
                            try key_events.append(.{
                                .action = .{ .repeat = key_repeats[@enumToInt(key)] },
                                .key = key,
                            });
                        }
                        key_states[@enumToInt(key)] = true;
                    }
                },
                c.XCB_KEY_RELEASE => {
                    const xcb_key_release_event = @ptrCast(*c.xcb_key_release_event_t, xcb_event);
                    if (translateKey(xcb_key_release_event.detail)) |key| {
                        try key_events.append(.{
                            .action = .release,
                            .key = key,
                        });
                        key_repeats[@enumToInt(key)] = 0;
                        key_states[@enumToInt(key)] = false;
                    }
                },
                c.XCB_BUTTON_PRESS => {
                    const xcb_button_press_event = @ptrCast(*c.xcb_button_press_event_t, xcb_event);
                    try mouse_button_events.append(.{
                        .button = .{
                            .action = .press,
                            .index = xcb_button_press_event.detail,
                        },
                        .x = xcb_button_press_event.event_x,
                        .y = xcb_button_press_event.event_y,
                    });
                },
                c.XCB_BUTTON_RELEASE => {
                    const xcb_button_release_event = @ptrCast(*c.xcb_button_release_event_t, xcb_event);
                    try mouse_button_events.append(.{
                        .button = .{
                            .action = .release,
                            .index = xcb_button_release_event.detail,
                        },
                        .x = xcb_button_release_event.event_x,
                        .y = xcb_button_release_event.event_y,
                    });
                },
                else => {},
            }
        }
    }

    fn translateKey(keycode: u8) ?Key {
        // TODO(hazeycode): measure and consider cacheing this in a LUT for performance
        var keysyms_per_keycode: c_int = 0;
        const keysyms = c.XGetKeyboardMapping(display, keycode, 1, &keysyms_per_keycode);
        const keysym = keysyms[0];
        _ = c.XFree(keysyms);
        return switch (keysym) {
            c.XK_Escape => .escape,
            c.XK_Tab => .tab,
            c.XK_Shift_L => .shift_left,
            c.XK_Shift_R => .shift_right,
            c.XK_Control_L => .ctrl_left,
            c.XK_Control_R => .ctrl_right,
            c.XK_Meta_L, c.XK_Alt_L => .alt_left,
            c.XK_Mode_switch, c.XK_ISO_Level3_Shift, c.XK_Meta_R, c.XK_Alt_R => .alt_right,
            c.XK_Super_L => .super_left,
            c.XK_Super_R => .super_right,
            c.XK_Menu => .menu,
            c.XK_Num_Lock => .numlock,
            c.XK_Caps_Lock => .capslock,
            c.XK_Print => .printscreen,
            c.XK_Scroll_Lock => .scrolllock,
            c.XK_Pause => .pause,
            c.XK_Delete => .delete,
            c.XK_BackSpace => .backspace,
            c.XK_Return => .enter,
            c.XK_Home => .home,
            c.XK_End => .end,
            c.XK_Page_Up => .pageup,
            c.XK_Page_Down => .pagedown,
            c.XK_Insert => .insert,
            c.XK_Left => .left,
            c.XK_Right => .right,
            c.XK_Down => .down,
            c.XK_Up => .up,
            c.XK_F1 => .f1,
            c.XK_F2 => .f2,
            c.XK_F3 => .f3,
            c.XK_F4 => .f4,
            c.XK_F5 => .f5,
            c.XK_F6 => .f6,
            c.XK_F7 => .f7,
            c.XK_F8 => .f8,
            c.XK_F9 => .f9,
            c.XK_F10 => .f10,
            c.XK_F11 => .f11,
            c.XK_F12 => .f12,
            c.XK_F13 => .f13,
            c.XK_F14 => .f14,
            c.XK_F15 => .f15,
            c.XK_F16 => .f16,
            c.XK_F17 => .f17,
            c.XK_F18 => .f18,
            c.XK_F19 => .f19,
            c.XK_F20 => .f20,
            c.XK_F21 => .f21,
            c.XK_F22 => .f22,
            c.XK_F23 => .f23,
            c.XK_F24 => .f24,
            c.XK_F25 => .f25,
            c.XK_KP_Divide => .keypad_divide,
            c.XK_KP_Multiply => .keypad_multiply,
            c.XK_KP_Subtract => .keypad_subtract,
            c.XK_KP_Add => .keypad_add,
            c.XK_KP_Insert => .keypad_0,
            c.XK_KP_End => .keypad_1,
            c.XK_KP_Down => .keypad_2,
            c.XK_KP_Page_Down => .keypad_3,
            c.XK_KP_Left => .keypad_4,
            c.XK_KP_Begin => .keypad_5,
            c.XK_KP_Right => .keypad_6,
            c.XK_KP_Home => .keypad_7,
            c.XK_KP_Up => .keypad_8,
            c.XK_KP_Page_Up => .keypad_9,
            c.XK_KP_Delete => .keypad_decimal,
            c.XK_KP_Equal => .keypad_equal,
            c.XK_KP_Enter => .keypad_enter,
            c.XK_a => .a,
            c.XK_b => .b,
            c.XK_c => .c,
            c.XK_d => .d,
            c.XK_e => .e,
            c.XK_f => .f,
            c.XK_g => .g,
            c.XK_h => .h,
            c.XK_i => .i,
            c.XK_j => .j,
            c.XK_k => .k,
            c.XK_l => .l,
            c.XK_m => .m,
            c.XK_n => .n,
            c.XK_o => .o,
            c.XK_p => .p,
            c.XK_q => .q,
            c.XK_r => .r,
            c.XK_s => .s,
            c.XK_t => .t,
            c.XK_u => .u,
            c.XK_v => .v,
            c.XK_w => .w,
            c.XK_x => .x,
            c.XK_y => .y,
            c.XK_z => .z,
            c.XK_1 => .one,
            c.XK_2 => .two,
            c.XK_3 => .three,
            c.XK_4 => .four,
            c.XK_5 => .five,
            c.XK_6 => .six,
            c.XK_7 => .seven,
            c.XK_8 => .eight,
            c.XK_9 => .nine,
            c.XK_0 => .zero,
            c.XK_space => .space,
            c.XK_minus => .minus,
            c.XK_equal => .equal,
            c.XK_bracketleft => .bracket_left,
            c.XK_bracketright => .bracket_right,
            c.XK_backslash => .backslash,
            c.XK_semicolon => .semicolon,
            c.XK_apostrophe => .apostrophe,
            c.XK_grave => .grave_accent,
            c.XK_comma => .comma,
            c.XK_period => .period,
            c.XK_slash => .slash,
            c.XK_less => .world1,
            else => .unknown,
        };
    }
};
