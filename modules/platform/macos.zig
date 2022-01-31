const std = @import("std");
const builtin = @import("builtin");
const core = @import("core");
const objc = @import("zig-objcrt");
const Input = @import("Input.zig");

pub const default_graphics_api = core.GraphicsAPI.metal;

const CGFloat = switch (builtin.target.cpu.arch.ptrBitWidth()) {
    32 => f32,
    64 => f64,
    else => @compileError("Mad CPU!"),
};

const CGSize = struct {
    width: CGFloat,
    height: CGFloat,
};

pub fn run(args: struct {
    graphics_api: core.GraphicsAPI = default_graphics_api,
    title: [:0]const u8 = "",
    pxwidth: u16 = 854,
    pxheight: u16 = 480,
    update_fn: fn (Input) anyerror!bool,
}) !void {
    const NSApplication = try objc.getClass("NSApplication");
    const NSString = try objc.getClass("NSString");
    const AppDelegate = try objc.getClass("AppDelegate");

    const application = try objc.msgSendByName(objc.id, NSApplication, "sharedApplication", .{});

    const title_string = try objc.msgSendByName(objc.id, NSString, "stringWithUTF8String:", .{args.title.ptr});

    const app_delegate = try objc.msgSendByName(
        objc.id,
        AppDelegate,
        "appDelegateWithWindowWidth:height:andTitle:",
        .{ @intToFloat(CGFloat, args.pxwidth), @intToFloat(CGFloat, args.pxheight), title_string },
    );

    try objc.msgSendByName(void, application, "setDelegate:", .{app_delegate});
    try objc.msgSendByName(void, application, "run", .{});
}

export fn frame(view_width: c_int, view_height: c_int) callconv(.C) void {
    std.debug.print("frame: {}, {}\n", .{ view_width, view_height });
}
