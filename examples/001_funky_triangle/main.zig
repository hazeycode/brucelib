const std = @import("std");

const platform = @import("platform");
const graphics = @import("graphics").usingAPI(platform.default_graphics_api);

pub fn main() anyerror!void {
    try platform.run(.{
        .title = "001_funky_triangle",
        .pxwidth = 854,
        .pxheight = 480,
        .init_fn = init,
        .deinit_fn = deinit,
        .update_fn = update,
    });
}

var state: struct {
    triangle_hue: f32 = 0,
} = .{};

fn init(allocator: std.mem.Allocator) !void {
    try graphics.init(allocator);
    debug_stats.timer = try std.time.Timer.start();
}

fn deinit() void {
    graphics.deinit();
}

fn update(input: platform.Input) !bool {
    debug_stats.last_frame_time_ms = @intToFloat(f32, debug_stats.timer.lap()) / 1e6;

    const frame_allocator = input.frame_arena_allocator;

    if (input.quit_requested) {
        std.log.debug("quit requested", .{});
        return false;
    }

    state.triangle_hue = @mod(state.triangle_hue + 1e-2, 1.0);

    var draw_list = try graphics.beginDrawing(frame_allocator);
    try draw_list.setViewport(0, 0, input.canvas_size.width, input.canvas_size.height);
    try draw_list.clearViewport(graphics.Colour.black);
    try draw_list.drawTriangles(
        graphics.Colour.fromHSV(state.triangle_hue, 0.5, 1.0),
        &[_][3]graphics.VertexPosition{
            .{
                .{ -0.5, -0.5, 0.0 },
                .{ 0.5, -0.5, 0.0 },
                .{ 0.0, 0.5, 0.0 },
            },
        },
    );

    if (true) {
        var debug_gui = graphics.DebugGUI.begin(
            input.frame_arena_allocator,
            @intToFloat(f32, input.canvas_size.width),
            @intToFloat(f32, input.canvas_size.height),
            &draw_list,
        );
        try debug_gui.beginMenu(.top);
        debug_gui.label("CPU frame time: {0:<3} ms", .{debug_stats.last_frame_time_ms});
        debug_gui.endMenu();
        debug_gui.end();
    }

    try graphics.submitDrawList(draw_list);

    return true;
}

var debug_stats: struct {
    timer: std.time.Timer,
    last_frame_time_ms: f32,
} = undefined;
