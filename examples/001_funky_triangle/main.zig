const std = @import("std");

const platform = @import("platform");
const graphics = @import("graphics").usingAPI(.default);

pub fn main() anyerror!void {
    try platform.run(.{
        .title = "001_funky_triangle",
        .window_size = .{
            .width = 854,
            .height = 480,
        },
        .init_fn = init,
        .deinit_fn = deinit,
        .frame_fn = frame,
    });
}

var state: struct {
    triangle_hue: f32 = 0,
} = .{};

fn init(allocator: std.mem.Allocator) !void {
    try graphics.init(allocator);
}

fn deinit() void {
    graphics.deinit();
}

fn frame(input: platform.FrameInput) !bool {
    if (input.quit_requested) {
        std.log.debug("quit requested", .{});
        return false;
    }

    var draw_list = try graphics.beginDrawing(input.frame_arena_allocator);

    try draw_list.setViewport(0, 0, input.window_size.width, input.window_size.height);
    try draw_list.clearViewport(graphics.Colour.black);

    try funkyTriangle(input, &draw_list);

    try debugOverlay(input, &draw_list);

    try graphics.submitDrawList(draw_list);

    return true;
}

fn funkyTriangle(input: platform.FrameInput, draw_list: anytype) !void {
    state.triangle_hue = @mod(
        state.triangle_hue + @intToFloat(f32, input.target_frame_dt) / 1e9,
        1.0,
    );

    try draw_list.setProjectionTransform(graphics.identityMatrix());

    try draw_list.drawUniformColourVerts(
        graphics.Colour.fromHSV(state.triangle_hue, 0.5, 1.0),
        &[_]graphics.VertexPosition{
            .{ -0.5, -0.5, 0.0 },
            .{ 0.5, -0.5, 0.0 },
            .{ 0.0, 0.5, 0.0 },
        },
    );
}

fn debugOverlay(input: platform.FrameInput, draw_list: anytype) !void {
    var debug_gui = graphics.DebugGUI.begin(
        input.frame_arena_allocator,
        draw_list,
        @intToFloat(f32, input.window_size.width),
        @intToFloat(f32, input.window_size.height),
    );

    try debug_gui.label(
        "{d:.2} ms update",
        .{@intToFloat(f64, input.debug_stats.prev_cpu_frame_elapsed) / 1e6},
    );

    const prev_frame_time_ms = @intToFloat(f64, input.prev_frame_elapsed) / 1e6;
    try debug_gui.label(
        "{d:.2} ms frame, {d:.0} FPS",
        .{ prev_frame_time_ms, 1e3 / prev_frame_time_ms },
    );

    try debug_gui.end();
}
