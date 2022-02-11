const std = @import("std");
const builtin = @import("builtin");
const core = @import("core");
const objc = @import("zig-objcrt");
const Input = @import("Input.zig");

pub const default_graphics_api = core.GraphicsAPI.opengl;

const CGFloat = switch (builtin.target.cpu.arch.ptrBitWidth()) {
    32 => f32,
    64 => f64,
    else => @compileError("Mad CPU!"),
};

const CGSize = struct {
    width: CGFloat,
    height: CGFloat,
};

var update_fn: fn (Input) anyerror!bool = undefined;
var allocator: std.mem.Allocator = undefined;

pub fn run(args: struct {
    graphics_api: core.GraphicsAPI = default_graphics_api,
    title: [:0]const u8 = "",
    pxwidth: u16 = 854,
    pxheight: u16 = 480,
    init_fn: fn (std.mem.Allocator) anyerror!void,
    deinit_fn: fn () void,
    update_fn: fn (Input) anyerror!bool,
}) !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    allocator = gpa.allocator();

    try args.init_fn(allocator);
    defer args.deinit_fn();

    update_fn = args.update_fn;

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
    var frame_mem_arena = std.heap.ArenaAllocator.init(allocator);
    defer frame_mem_arena.deinit();

    const arena_allocator = frame_mem_arena.allocator();

    var key_events = std.ArrayList(Input.KeyEvent).init(arena_allocator);
    var mouse_button_events = std.ArrayList(Input.MouseButtonEvent).init(arena_allocator);
    var window_closed = false;

    _ = !(update_fn(.{
        .frame_arena_allocator = arena_allocator,
        .key_events = key_events.items,
        .mouse_button_events = mouse_button_events.items,
        .canvas_size = .{
            .width = @intCast(u16, view_width),
            .height = @intCast(u16, view_height),
        },
        .quit_requested = window_closed,
    }) catch unreachable);
}
