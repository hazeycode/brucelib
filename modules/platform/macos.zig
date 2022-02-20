const std = @import("std");
const builtin = @import("builtin");
const objc = @import("zig-objcrt");
const FrameInput = @import("FrameInput.zig");

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
var frame_fn: fn (FrameInput) anyerror!bool = undefined;
var allocator: std.mem.Allocator = undefined;
var frame_timer: std.time.Timer = undefined;
var prev_cpu_frame_elapsed: u64 = 0;

const GraphicsAPI = enum {
    metal,
};

pub fn run(args: struct {
    graphics_api: GraphicsAPI = .metal,
    requested_framerate: u16 = 0,
    title: []const u8 = "",
    window_size: struct {
        width: u16,
        height: u16,
    } = .{
        .width = 854,
        .height = 480,
    },
    init_fn: fn (std.mem.Allocator) anyerror!void,
    deinit_fn: fn () void,
    frame_fn: fn (FrameInput) anyerror!bool,
}) !void {
    timer = try std.time.Timer.start();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    allocator = gpa.allocator();

    // TODO(hazeycode): get monitor refresh and shoot for that, downgrade if we miss alot
    target_framerate = if (args.requested_framerate == 0) 60 else args.requested_framerate;

    try args.init_fn(allocator);
    defer args.deinit_fn();

    frame_fn = args.frame_fn;

    const NSApplication = try objc.getClass("NSApplication");
    const NSString = try objc.getClass("NSString");
    const AppDelegate = try objc.getClass("AppDelegate");

    const application = try objc.msgSendByName(objc.id, NSApplication, "sharedApplication", .{});

    const title_string = try objc.msgSendByName(objc.id, NSString, "stringWithUTF8String:", .{args.title.ptr});

    const app_delegate = try objc.msgSendByName(
        objc.id,
        AppDelegate,
        "appDelegateWithWindowWidth:height:andTitle:",
        .{
            @intToFloat(CGFloat, args.window_size.width),
            @intToFloat(CGFloat, args.window_size.height),
            title_string,
        },
    );

    try objc.msgSendByName(void, application, "setDelegate:", .{app_delegate});

    frame_timer = try std.time.Timer.start();

    try objc.msgSendByName(void, application, "run", .{});
}

export fn frame(view_width: c_int, view_height: c_int) callconv(.C) void {
    const prev_frame_elapsed = frame_timer.lap();

    const start_cpu_time = timestamp();

    var frame_mem_arena = std.heap.ArenaAllocator.init(allocator);
    defer frame_mem_arena.deinit();

    const arena_allocator = frame_mem_arena.allocator();

    var key_events = std.ArrayList(FrameInput.KeyEvent).init(arena_allocator);
    var mouse_button_events = std.ArrayList(FrameInput.MouseButtonEvent).init(arena_allocator);
    var window_closed = false;

    const target_frame_dt = @floatToInt(u64, (1 / @intToFloat(f64, target_framerate) * 1e9));

    _ = !(frame_fn(.{
        .frame_arena_allocator = arena_allocator,
        .quit_requested = window_closed,
        .frame_dt = @intCast(u64, @intCast(i128, prev_frame_elapsed) - target_frame_dt + target_frame_dt),
        .target_frame_dt = target_frame_dt,
        .prev_frame_elapsed = prev_frame_elapsed,
        .input_events = .{
            .key_events = key_events.items,
            .mouse_button_events = mouse_button_events.items,
        },
        .window_size = .{
            .width = @intCast(u16, view_width),
            .height = @intCast(u16, view_height),
        },
        .debug_stats = .{
            .prev_cpu_frame_elapsed = prev_cpu_frame_elapsed,
        },
    }) catch unreachable);

    prev_cpu_frame_elapsed = timestamp() - start_cpu_time;

    const remaining_frame_time = @intCast(i128, target_frame_dt - 100000) - frame_timer.read();
    if (remaining_frame_time > 0) {
        std.time.sleep(@intCast(u64, remaining_frame_time));
    }
}
