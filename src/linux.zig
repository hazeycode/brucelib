const std = @import("std");
const Input = @import("Input.zig");

var window_width: u16 = undefined;
var window_height: u16 = undefined;
var window_resized: bool = false;

const num_keys = std.meta.fields(Input.Key).len;
var key_repeats: [num_keys]u32 = .{0} ** num_keys;

pub fn run(args: struct {
    title: []const u8 = "",
    pxwidth: u16 = 854,
    pxheight: u16 = 480,
    update_fn: fn (Input) bool,
}) !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    const windowing = X11;

    window_width = args.pxwidth;
    window_height = args.pxheight;

    try windowing.init(args.title);
    defer windowing.deinit();

    while (true) {
        var frame_mem_arena = std.heap.ArenaAllocator.init(allocator);
        defer frame_mem_arena.deinit();

        const arena_allocator = frame_mem_arena.allocator();

        var key_presses = std.ArrayList(Input.KeyPressEvent).init(arena_allocator);
        var key_releases = std.ArrayList(Input.KeyReleaseEvent).init(arena_allocator);
        var mouse_button_presses = std.ArrayList(Input.MouseButtonEvent).init(arena_allocator);
        var mouse_button_releases = std.ArrayList(Input.MouseButtonEvent).init(arena_allocator);
        var window_closed = false;
        try windowing.processEvents(
            &key_presses,
            &key_releases,
            &mouse_button_presses,
            &mouse_button_releases,
            &window_closed,
        );

        if (window_resized) {
            // TODO(chris): set framebuffer size / recreate swapchain
            window_resized = false;
        }

        const input = Input{
            .key_presses = key_presses.items,
            .key_releases = key_releases.items,
            .mouse_button_presses = mouse_button_presses.items,
            .mouse_button_releases = mouse_button_releases.items,
            .quit_requested = window_closed,
        };

        const quit = args.update_fn(input);

        if (quit) break;
    }
}

const X11 = struct {
    const c = @cImport({
        @cInclude("X11/Xlib-xcb.h");
        @cInclude("X11/XKBlib.h");
    });

    var display: *c.Display = undefined;
    var connection: *c.xcb_connection_t = undefined;
    var atom_protocols: *c.xcb_intern_atom_reply_t = undefined;
    var atom_delete_window: *c.xcb_intern_atom_reply_t = undefined;
    var window: u32 = undefined;

    fn init(window_title: []const u8) !void {
        c.XrmInitialize();

        display = c.XOpenDisplay(@intToPtr(?*const u8, 0)) orelse return error.XOpenDisplayFailed;

        _ = c.XkbSetDetectableAutoRepeat(display, c.True, null);

        connection = c.XGetXCBConnection(display) orelse return error.XGetXCBConnectionFailed;
        errdefer c.xcb_disconnect(connection);

        const screen = (c.xcb_setup_roots_iterator(c.xcb_get_setup(connection))).data;

        c.XSetEventQueueOwner(display, c.XCBOwnsEventQueue);

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

        // create xcb window
        window = c.xcb_generate_id(connection);
        _ = c.xcb_create_window(
            connection,
            c.XCB_COPY_FROM_PARENT,
            window,
            screen.*.root,
            0,
            0,
            window_width,
            window_height,
            0,
            c.XCB_WINDOW_CLASS_INPUT_OUTPUT,
            screen.*.root_visual,
            c.XCB_CW_BACK_PIXEL | c.XCB_CW_EVENT_MASK,
            &[_]u32{
                screen.*.black_pixel,
                c.XCB_EVENT_MASK_EXPOSURE |
                    c.XCB_EVENT_MASK_STRUCTURE_NOTIFY |
                    c.XCB_EVENT_MASK_RESIZE_REDIRECT |
                    c.XCB_EVENT_MASK_KEY_PRESS |
                    c.XCB_EVENT_MASK_KEY_RELEASE |
                    c.XCB_EVENT_MASK_BUTTON_PRESS |
                    c.XCB_EVENT_MASK_BUTTON_RELEASE,
            },
        );

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
    }

    fn deinit() void {
        _ = c.XFree(atom_delete_window);
        _ = c.XFree(atom_protocols);
        c.xcb_disconnect(connection);
    }

    fn onWindowResize(event: anytype) void {
        if (event.width != window_width or event.height != window_height) {
            window_width = event.width;
            window_height = event.height;
            window_resized = true;
        }
    }

    fn processEvents(
        key_presses: anytype,
        key_releases: anytype,
        mouse_button_presses: anytype,
        mouse_button_releases: anytype,
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
                    onWindowResize(xcb_config_event);
                },
                c.XCB_RESIZE_REQUEST => {
                    const xcb_resize_event = @ptrCast(*c.xcb_resize_request_event_t, xcb_event);
                    onWindowResize(xcb_resize_event);
                },
                c.XCB_KEY_PRESS => {
                    const xcb_key_press_event = @ptrCast(*c.xcb_key_press_event_t, xcb_event);
                    if (translateKey(xcb_key_press_event.detail)) |key| {
                        const repeats = &key_repeats[@enumToInt(key)];
                        try key_presses.append(.{ .key = key, .repeat_count = repeats.* });
                        repeats.* += 1;
                    } else {
                        std.log.debug("press {}", .{xcb_key_press_event.detail});
                    }
                },
                c.XCB_KEY_RELEASE => {
                    const xcb_key_release_event = @ptrCast(*c.xcb_key_release_event_t, xcb_event);
                    if (translateKey(xcb_key_release_event.detail)) |key| {
                        key_repeats[@enumToInt(key)] = 0;
                        try key_releases.append(key);
                    }
                },
                c.XCB_BUTTON_PRESS => {
                    const xcb_button_press_event = @ptrCast(*c.xcb_button_press_event_t, xcb_event);
                    try mouse_button_presses.append(.{
                        .button = xcb_button_press_event.detail,
                        .x = xcb_button_press_event.event_x,
                        .y = xcb_button_press_event.event_y,
                    });
                },
                c.XCB_BUTTON_RELEASE => {
                    const xcb_button_release_event = @ptrCast(*c.xcb_button_release_event_t, xcb_event);
                    try mouse_button_releases.append(.{
                        .button = xcb_button_release_event.detail,
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
