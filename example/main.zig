const std = @import("std");

const platform = @import("platform");
// TODO(chris): support runtime selection of graphics API
const graphics = @import("graphics").usingAPI(platform.default_graphics_api);

pub fn main() anyerror!void {
    try platform.run(.{
        .title = "example",
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
}

fn deinit() void {
    graphics.deinit();
}

fn update(input: platform.Input) !bool {
    if (input.quit_requested) {
        std.log.debug("quit requested", .{});
        return false;
    }

    state.triangle_hue = @mod(state.triangle_hue + 1.0, 360.0);

    var draw_list = try graphics.beginDrawing(input.frame_arena_allocator);
    try draw_list.setViewport(0, 0, input.canvas_width, input.canvas_height);
    try draw_list.clearViewport(graphics.Colour.black);
    try draw_list.drawTriangles(
        graphics.Colour.fromHSV(state.triangle_hue, 0.5, 1.0),
        &[_][3][3]f32{
            .{
                .{ -0.5, -0.5, 0.0 },
                .{ 0.5, -0.5, 0.0 },
                .{ 0.0, 0.5, 0.0 },
            },
        },
    );
    graphics.submitDrawList(draw_list);

    return true;
}
