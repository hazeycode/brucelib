const std = @import("std");
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

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    // const allocator = gpa.allocator();
}
