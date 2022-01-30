const std = @import("std");
const core = @import("core");
const objc = @import("objc.zig");
const Input = @import("Input.zig");

pub const default_graphics_api = core.GraphicsAPI.metal;

pub fn run(args: struct {
    graphics_api: core.GraphicsAPI = default_graphics_api,
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
