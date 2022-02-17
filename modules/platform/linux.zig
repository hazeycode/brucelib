const std = @import("std");
const Input = @import("Input.zig");

var window_width: u16 = undefined;
var window_height: u16 = undefined;

const num_keys = std.meta.fields(Input.Key).len;
var key_repeats: [num_keys]u32 = .{0} ** num_keys;
var maybe_last_key_event: ?*Input.KeyEvent = null;

const GraphicsAPI = enum {
    opengl,
};

var graphics_api: GraphicsAPI = undefined;

pub fn run(args: struct {
    graphics_api: GraphicsAPI = .opengl,
    title: []const u8 = "",
    pxwidth: u16 = 854,
    pxheight: u16 = 480,
    init_fn: fn (std.mem.Allocator) anyerror!void,
    deinit_fn: fn () void,
    update_fn: fn (Input) anyerror!bool,
}) !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    const windowing = X11;

    graphics_api = args.graphics_api;

    window_width = args.pxwidth;
    window_height = args.pxheight;

    try windowing.init(args.title);
    defer windowing.deinit();

    try args.init_fn(allocator);
    defer args.deinit_fn();

    while (true) {
        var frame_mem_arena = std.heap.ArenaAllocator.init(allocator);
        defer frame_mem_arena.deinit();

        const arena_allocator = frame_mem_arena.allocator();

        var key_events = std.ArrayList(Input.KeyEvent).init(arena_allocator);
        var mouse_button_events = std.ArrayList(Input.MouseButtonEvent).init(arena_allocator);
        var window_closed = false;

        try windowing.processEvents(
            &key_events,
            &mouse_button_events,
            &window_closed,
        );

        const quit = !(try args.update_fn(.{
            .frame_arena_allocator = arena_allocator,
            .key_events = key_events.items,
            .mouse_button_events = mouse_button_events.items,
            .canvas_size = .{ .width = window_width, .height = window_height },
            .quit_requested = window_closed,
        }));

        windowing.swapBuffers();

        if (quit) break;
    }
}

const X11 = struct {
    // TODO(chris): remove system header imports
    const c = @cImport({
        @cInclude("X11/Xlib-xcb.h");
        @cInclude("X11/XKBlib.h");
        @cInclude("epoxy/glx.h");
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
                // create context and set it as current
                const attribs = [_]c_int{
                    c.GLX_CONTEXT_MAJOR_VERSION_ARB, 4,
                    c.GLX_CONTEXT_MINOR_VERSION_ARB, 6,
                    c.GLX_CONTEXT_PROFILE_MASK_ARB,  c.GLX_CONTEXT_CORE_PROFILE_BIT_ARB,
                };
                const context = c.glXCreateContextAttribsARB(display, fb_config, null, c.True, &attribs);
                if (context == null) return error.FailedToCreateGLXContext;
                if (c.glXMakeCurrent(display, window, context) != c.True) return error.FailedToMakeGLXContextCurrent;
                std.log.info("OpenGL version {s}", .{c.glGetString(c.GL_VERSION)});
            },
        }
    }

    fn glXGetProcAddress(comptime T: type, sym_name: [*c]const u8) !T {
        const fn_ptr = c.glXGetProcAddress(sym_name) orelse return error.FailedToGetProcAddress;
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

    fn processEvents(
        key_events: anytype,
        mouse_button_events: anytype,
        window_closed: *bool,
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
                        window_closed.* = true;
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
                        if (key_repeats[@enumToInt(key)] > 0) {
                            key_repeats[@enumToInt(key)] += 1;
                            if (maybe_last_key_event) |last_key_event| {
                                if (last_key_event.action == .repeat and last_key_event.key == key) {
                                    last_key_event.action.repeat += 1;
                                }
                            }
                            try key_events.append(.{
                                .action = .{ .repeat = key_repeats[@enumToInt(key)] },
                                .key = key,
                            });
                        } else {
                            key_repeats[@enumToInt(key)] = 1;
                            try key_events.append(.{
                                .action = .press,
                                .key = key,
                            });
                        }
                        maybe_last_key_event = &key_events.items[key_events.items.len - 1];
                    } else {
                        std.log.debug("press {}", .{xcb_key_press_event.detail});
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
                        maybe_last_key_event = &key_events.items[key_events.items.len - 1];
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
};

fn translateKey(keycode: u32) ?Input.Key {
    return switch (keycode) {
        23 => .tab,
        25 => .w,
        38 => .a,
        39 => .s,
        40 => .d,
        94 => .grave_accent,
        else => null,
    };
}
