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

var debug_state: struct {
    frame_timer: std.time.Timer,
    last_frame_time_ms: f32,
    update_time_elapsed_ms: f32,
} = undefined;

fn init(allocator: std.mem.Allocator) !void {
    try graphics.init(allocator);
    debug_state.frame_timer = try std.time.Timer.start();
}

fn deinit() void {
    graphics.deinit();
}

fn update(input: platform.Input) !bool {
    debug_state.last_frame_time_ms = @intToFloat(f32, debug_state.frame_timer.lap()) / 1e6;

    var update_timer = try std.time.Timer.start();

    if (input.quit_requested) {
        std.log.debug("quit requested", .{});
        return false;
    }

    var draw_list = try graphics.beginDrawing(input.frame_arena_allocator);

    try draw_list.setViewport(0, 0, input.canvas_size.width, input.canvas_size.height);
    try draw_list.clearViewport(graphics.Colour.black);

    try funkyTriangle(input, &draw_list);

    debug_state.update_time_elapsed_ms = @intToFloat(f32, update_timer.read()) / 1e6;

    try debugOverlay(input, &draw_list);

    try graphics.submitDrawList(draw_list);

    return true;
}

fn funkyTriangle(_: platform.Input, draw_list: anytype) !void {
    state.triangle_hue = @mod(state.triangle_hue + 1e-2, 1.0);

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

fn debugOverlay(input: platform.Input, draw_list: anytype) !void {
    var debug_gui = graphics.DebugGUI.begin(
        input.frame_arena_allocator,
        draw_list,
        @intToFloat(f32, input.canvas_size.width),
        @intToFloat(f32, input.canvas_size.height),
    );

    try debug_gui.label(
        "{d:.2} ms update",
        .{debug_state.update_time_elapsed_ms},
    );

    try debug_gui.label(
        "{d:.2} ms frame, {d:.0} FPS",
        .{ debug_state.last_frame_time_ms, 1e3 / debug_state.last_frame_time_ms },
    );

    try debug_gui.end();
}
