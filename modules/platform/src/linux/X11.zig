const std = @import("std");

const log = std.log.scoped(.@"brucelib.platform.linux.X11");

const common = @import("../common.zig");
const WindowEvent = common.WindowEvent;
const KeyWindowEvent = common.KeyWindowEvent;
const MouseButton = common.MouseButton;
const Key = common.Key;

const num_keys = std.meta.fields(Key).len;

const c = struct {
    pub usingnamespace @import("X11/Xlib-xcb.zig");
    pub usingnamespace @import("X11/XKBlib.zig");
    pub usingnamespace @import("X11/glx.zig");
};

display: *c.Display,
connection: *c.xcb_connection_t,
atom_protocols: *c.xcb_intern_atom_reply_t,
atom_delete_window: *c.xcb_intern_atom_reply_t,

// TODO(hazeycode): support for multiple windows
window: u32,
window_width: u16,
window_height: u16,

key_states: [num_keys]bool = .{false} ** num_keys,
key_repeats: [num_keys]u32 = .{0} ** num_keys,

// TODO(hazeycode): refactor this to separate init and window creation
pub fn init_and_create_window(window_properties: struct {
    title: []const u8,
    width: u16,
    height: u16,
}) !@This() {
    c.XrmInitialize();

    const display = c.XOpenDisplay(@intToPtr(?*const u8, 0)) orelse return error.XOpenDisplayFailed;

    _ = c.XkbSetDetectableAutoRepeat(display, c.True, null);

    const connection = c.XGetXCBConnection(display) orelse return error.XGetXCBConnectionFailed;
    errdefer c.xcb_disconnect(connection);

    c.XSetEventQueueOwner(display, c.XEventQueueOwner.XCBOwnsEventQueue);

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

    const atom_protocols = c.xcb_intern_atom_reply(
        connection,
        c.xcb_intern_atom(connection, 1, 12, "WM_PROTOCOLS"),
        0,
    );
    errdefer _ = c.XFree(atom_protocols);

    const atom_delete_window = c.xcb_intern_atom_reply(
        connection,
        c.xcb_intern_atom(connection, 0, 16, "WM_DELETE_WINDOW"),
        0,
    );
    errdefer _ = c.XFree(atom_delete_window);

    var visual_info: *c.XVisualInfo = undefined;

    var glx_fb_config: c.GLXFBConfig = undefined;

    // query opengl version
    var glx_ver_min: c_int = undefined;
    var glx_ver_maj: c_int = undefined;
    if (c.glXQueryVersion(display, &glx_ver_maj, &glx_ver_min) == 0) return error.FailedToQueryGLXVersion;
    log.info("GLX version {}.{}", .{ glx_ver_maj, glx_ver_min });

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
    var num_glx_fb_configs: c_int = 0;
    const glx_fb_configs = c.glXChooseFBConfig(
        display,
        default_screen_num,
        &attrib_list,
        &num_glx_fb_configs,
    );

    if (glx_fb_configs == null) return error.FailedToQueryFramebufferConfigs;
    if (num_glx_fb_configs == 0) return error.NoCompatibleFramebufferConfigsFound;
    // defer _ = c.XFree(glx_fb_configs);

    // use the first config and get visual info
    glx_fb_config = glx_fb_configs[0];

    visual_info = c.glXGetVisualFromFBConfig(display, glx_fb_config) orelse
        return error.FailedToGetVisualFromFBConfig;

    const visual_id = @intCast(u32, c.XVisualIDFromVisual(visual_info.visual));

    // create colormap
    const colour_map = c.xcb_generate_id(connection);
    _ = c.xcb_create_colormap(connection, c.XCB_COLORMAP_ALLOC_NONE, colour_map, screen_root, visual_id);

    // create xcb window
    const window = c.xcb_generate_id(connection);
    if (c.xcb_request_check(
        connection,
        c.xcb_create_window_checked(
            connection,
            c.XCB_COPY_FROM_PARENT,
            window,
            screen_root,
            0,
            0,
            window_properties.width,
            window_properties.height,
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
                    c.XCB_EVENT_MASK_BUTTON_RELEASE |
                    c.XCB_EVENT_MASK_POINTER_MOTION | c.XCB_EVENT_MASK_BUTTON_MOTION,
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

    if (window_properties.title.len > 0) {
        _ = c.xcb_change_property(
            connection,
            c.XCB_PROP_MODE_REPLACE,
            window,
            c.XCB_ATOM_WM_NAME,
            c.XCB_ATOM_STRING,
            8,
            @intCast(u32, window_properties.title.len),
            &window_properties.title[0],
        );
    }

    _ = c.xcb_map_window(connection, window);
    _ = c.xcb_flush(connection);

    // load glXCreateContextAttribsARB fn ptr
    const glXGetProcAddressARBFn = fn (
        ?*c.Display,
        c.GLXFBConfig,
        c.GLXContext,
        c.Bool,
        [*]const c_int,
    ) callconv(.C) c.GLXContext;
    const glXCreateContextAttribsARB = try glx_get_proc_addr_arb(
        glXGetProcAddressARBFn,
        "glXCreateContextAttribsARB",
    );

    // create context and set it as current
    const glx_ctx_attribs = [_]c_int{
        c.GLX_CONTEXT_MAJOR_VERSION_ARB, 4,
        c.GLX_CONTEXT_MINOR_VERSION_ARB, 4,
        c.GLX_CONTEXT_PROFILE_MASK_ARB,  c.GLX_CONTEXT_CORE_PROFILE_BIT_ARB,
        0,
    };
    const context = glXCreateContextAttribsARB(display, glx_fb_config, null, c.True, &glx_ctx_attribs);
    if (context == null) return error.FailedToCreateGLXContext;
    if (c.glXMakeCurrent(display, window, context) != c.True) return error.FailedToMakeGLXContextCurrent;

    log.info("OpenGL version {s}", .{c.glGetString(c.GL_VERSION)});

    return @This(){
        .display = display,
        .connection = connection,
        .atom_protocols = atom_protocols,
        .atom_delete_window = atom_delete_window,
        .window = window,
        .window_width = window_properties.width,
        .window_height = window_properties.height,
    };
}

pub fn glx_get_proc_addr(comptime T: type, sym_name: [*c]const u8) !T {
    const fn_ptr = c.glXGetProcAddress(sym_name) orelse return error.glXGetProcAddress;
    return @ptrCast(T, fn_ptr);
}

pub fn glx_get_proc_addr_arb(comptime T: type, sym_name: [*c]const u8) !T {
    const fn_ptr = c.glXGetProcAddressARB(sym_name) orelse return error.glXGetProcAddressARB;
    return @ptrCast(T, fn_ptr);
}

pub fn deinit(self: *@This()) void {
    const context = c.glXGetCurrentContext();
    _ = c.glXMakeCurrent(self.display, 0, null);
    c.glXDestroyContext(self.display, context);

    _ = c.XFree(self.atom_delete_window);
    _ = c.XFree(self.atom_protocols);
    c.xcb_disconnect(self.connection);
}

pub fn present(self: *@This()) void {
    c.glXSwapBuffers(self.display, self.window);
}

pub fn get_mouse_pos(self: *@This()) struct { x: i32, y: i32 } {
    var root: c.Window = undefined;
    var child: c.Window = undefined;
    var root_x: i32 = 0;
    var root_y: i32 = 0;
    var win_x: i32 = 0;
    var win_y: i32 = 0;
    var mask: u32 = 0;
    _ = c.XQueryPointer(
        self.display,
        self.window,
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

pub fn poll_events(
    self: *@This(),
    window_events_buffer: anytype,
    key_events_buffer: anytype,
    mouse_events_buffer: anytype,
) !void {
    if (@typeInfo(@TypeOf(window_events_buffer)) != .Pointer) @compileError("window_events_buffer must be a pointer");
    if (@typeInfo(@TypeOf(key_events_buffer)) != .Pointer) @compileError("key_events_buffer must be a pointer");
    if (@typeInfo(@TypeOf(mouse_events_buffer)) != .Pointer) @compileError("mouse_events_buffer must be a pointer");

    var xcb_event = c.xcb_poll_for_event(self.connection);
    while (@ptrToInt(xcb_event) > 0) : (xcb_event = c.xcb_poll_for_event(self.connection)) {
        defer _ = c.XFree(xcb_event);
        switch (xcb_event.*.response_type & ~@as(u32, 0x80)) {
            c.XCB_EXPOSE => {
                _ = c.xcb_flush(self.connection);
            },
            c.XCB_CLIENT_MESSAGE => {
                const xcb_client_message_event = @ptrCast(*c.xcb_client_message_event_t, xcb_event);
                if (xcb_client_message_event.data.data32[0] == self.atom_delete_window.*.atom) {
                    try window_events_buffer.push(.{
                        .window_id = xcb_client_message_event.window,
                        .action = .closed,
                        .width = self.window_width,
                        .height = self.window_height,
                    });
                }
            },
            c.XCB_CONFIGURE_NOTIFY => {
                const xcb_config_event = @ptrCast(*c.xcb_configure_notify_event_t, xcb_event);
                if (xcb_config_event.width != self.window_width or
                    xcb_config_event.height != self.window_height)
                {
                    self.window_width = xcb_config_event.width;
                    self.window_height = xcb_config_event.height;
                    try window_events_buffer.push(.{
                        .window_id = xcb_config_event.window,
                        .action = .resized,
                        .width = self.window_width,
                        .height = self.window_height,
                    });
                }
            },
            c.XCB_KEY_PRESS => {
                const xcb_key_press_event = @ptrCast(*c.xcb_key_press_event_t, xcb_event);
                if (translateKey(self.display, xcb_key_press_event.detail)) |key| {
                    const repeat = self.key_states[@enumToInt(key)];
                    var action: KeyWindowEvent.Action = undefined;
                    if (repeat == false) {
                        self.key_repeats[@enumToInt(key)] += 1;
                        action = .press;
                    } else {
                        self.key_repeats[@enumToInt(key)] = 1;
                        action = .{ .repeat = self.key_repeats[@enumToInt(key)] };
                    }
                    self.key_states[@enumToInt(key)] = true;
                    try key_events_buffer.push(.{
                        .window_id = 0, // TODO(hazeycode): get the "active" window id to fill this in
                        .action = action,
                        .key = key,
                    });
                }
            },
            c.XCB_KEY_RELEASE => {
                const xcb_key_release_event = @ptrCast(*c.xcb_key_release_event_t, xcb_event);
                if (translateKey(self.display, xcb_key_release_event.detail)) |key| {
                    self.key_repeats[@enumToInt(key)] = 0;
                    self.key_states[@enumToInt(key)] = false;
                    try key_events_buffer.push(.{
                        .window_id = 0, // TODO(hazeycode): get the "active" window id to fill this in
                        .action = .release,
                        .key = key,
                    });
                }
            },
            c.XCB_BUTTON_PRESS => {
                const xcb_button_press_event = @ptrCast(*c.xcb_button_press_event_t, xcb_event);
                const maybe_mouse_button: ?MouseButton = switch (xcb_button_press_event.detail) {
                    1 => .left,
                    2 => .middle,
                    3 => .right,
                    else => null,
                };
                if (maybe_mouse_button) |mouse_button| {
                    try mouse_events_buffer.push(.{
                        .window_id = 0, // TODO(hazeycode): get the "active" window id to fill this in
                        .action = .button_pressed,
                        .button = mouse_button,
                        .x = xcb_button_press_event.event_x,
                        .y = xcb_button_press_event.event_y,
                    });
                } else {
                    log.info("Pressed unmapped mouse button {}", .{xcb_button_press_event.detail});
                }
            },
            c.XCB_BUTTON_RELEASE => {
                const xcb_button_release_event = @ptrCast(*c.xcb_button_release_event_t, xcb_event);
                const maybe_mouse_button: ?MouseButton = switch (xcb_button_release_event.detail) {
                    1 => .left,
                    2 => .middle,
                    3 => .right,
                    else => null,
                };
                if (maybe_mouse_button) |mouse_button| {
                    try mouse_events_buffer.push(.{
                        .window_id = 0, // TODO(hazeycode): get the "active" window id to fill this in
                        .action = .button_released,
                        .button = mouse_button,
                        .x = xcb_button_release_event.event_x,
                        .y = xcb_button_release_event.event_y,
                    });
                } else {
                    log.info("Released unmapped mouse button {}", .{xcb_button_release_event.detail});
                }
            },
            else => {},
        }
    }
}

fn translateKey(display: *c.Display, keycode: u8) ?Key {
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
