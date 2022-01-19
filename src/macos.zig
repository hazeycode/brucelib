const std = @import("std");
const objc = @import("objc.zig");
const gfx = @import("gfx.zig");
const Input = @import("Input.zig");

pub const gfx_api = gfx.API.metal;

pub fn run(args: struct {
    title: []const u8 = "",
    pxwidth: u16 = 854,
    pxheight: u16 = 480,
    update_fn: fn (Input) anyerror!bool,
}) !void {
    _ = args;

    const NSApplication = try objc.lookupClass("NSApplication");

    const application = objc.msgSend(NSApplication, "sharedApplication", .{}, objc.id);

    objc.msgSend(application, "run", .{}, void);
}
