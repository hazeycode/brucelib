const std = @import("std");
const builtin = @import("builtin");
const objc = @import("zig-objcrt");
const Input = @import("Input.zig");

const CGFloat = switch (builtin.target.cpu.arch.ptrBitWidth()) {
    32 => f32,
    64 => f64,
    else => @compileError("Mad CPU!"),
};

const CGSize = struct {
    width: CGFloat,
    height: CGFloat,
};

var timer: std.time.Timer = undefined;
pub fn timestamp() u64 {
    return timer.read();
}

var target_framerate: u16 = undefined;
var update_fn: fn (Input) anyerror!bool = undefined;
var allocator: std.mem.Allocator = undefined;
var frame_timer: std.time.Timer = undefined;
var prev_update_time: u64 = 0;

const GraphicsAPI = enum {
    metal,
};

pub fn run(args: struct {
    graphics_api: GraphicsAPI = .metal,
    requested_framerate: u16 = 0,
    title: [:0]const u8 = "",
    pxwidth: u16 = 854,
    pxheight: u16 = 480,
    init_fn: fn (std.mem.Allocator) anyerror!void,
    deinit_fn: fn () void,
    update_fn: fn (Input) anyerror!bool,
}) !void {
    timer = try std.time.Timer.start();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    allocator = gpa.allocator();

    // TODO(hazeycode): get monitor refresh and shoot for that, downgrade if we miss alot
    target_framerate = if (args.requested_framerate == 0) 60 else args.requested_framerate;

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

    frame_timer = try std.time.Timer.start();

    try objc.msgSendByName(void, application, "run", .{});
}

export fn frame(view_width: c_int, view_height: c_int) callconv(.C) void {
    const prev_frame_time = frame_timer.lap();

    const start_update_time = timestamp();

    var frame_mem_arena = std.heap.ArenaAllocator.init(allocator);
    defer frame_mem_arena.deinit();

    const arena_allocator = frame_mem_arena.allocator();

    var key_events = std.ArrayList(Input.KeyEvent).init(arena_allocator);
    var mouse_button_events = std.ArrayList(Input.MouseButtonEvent).init(arena_allocator);
    var window_closed = false;

    const target_frame_time = @floatToInt(u64, (1 / @intToFloat(f64, target_framerate) * 1e9));

    _ = !(update_fn(.{
        .frame_arena_allocator = arena_allocator,
        .target_frame_time = target_frame_time,
        .prev_frame_time = prev_frame_time,
        .prev_update_time = prev_update_time,
        .key_events = key_events.items,
        .mouse_button_events = mouse_button_events.items,
        .canvas_size = .{
            .width = @intCast(u16, view_width),
            .height = @intCast(u16, view_height),
        },
        .quit_requested = window_closed,
    }) catch unreachable);

    prev_update_time = timestamp() - start_update_time;

    const remaining_frame_time = @intCast(i128, target_frame_time - 100000) - frame_timer.read();
    if (remaining_frame_time > 0) {
        std.time.sleep(@intCast(u64, remaining_frame_time));
    }
}
