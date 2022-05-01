const xcb = @import("xcb/xcb.zig");
usingnamespace xcb;
pub usingnamespace xcb;

const xlib = @import("Xlib.zig");
usingnamespace xlib;
pub usingnamespace xlib;

pub extern fn XGetXCBConnection(?*Display) callconv(.C) ?*xcb_connection_t;

pub const XEventQueueOwner = extern enum {
    XlibOwnsEventQueue,
    XCBOwnsEventQueue,
};

pub extern fn XSetEventQueueOwner(?*Display, XEventQueueOwner) callconv(.C) void;
