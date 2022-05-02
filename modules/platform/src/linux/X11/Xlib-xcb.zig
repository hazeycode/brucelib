const xcb = @import("xcb/xcb.zig");
pub usingnamespace xcb;

const xlib = @import("Xlib.zig");
pub usingnamespace xlib;

pub extern fn XGetXCBConnection(?*xlib.Display) callconv(.C) ?*xcb.xcb_connection_t;

pub const XEventQueueOwner = enum(c_int) {
    XlibOwnsEventQueue,
    XCBOwnsEventQueue,
};

pub extern fn XSetEventQueueOwner(?*xlib.Display, XEventQueueOwner) callconv(.C) void;
