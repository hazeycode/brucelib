const std = @import("std");

const brucelib = @import("brucelib");
const Input = brucelib.Input;
const gfx = brucelib.gfx;

pub fn main() anyerror!void {
    try brucelib.run(.{
        .title = "example",
        .pxwidth = 854,
        .pxheight = 480,
        .update_fn = update,
    });
}

var state: struct {
    triangle_hue: f32 = 0,
} = .{};

fn update(input: Input) !bool {
    if (input.quit_requested) return false;

    state.triangle_hue = @mod(state.triangle_hue + 1.0, 360.0);

    var draw_list = try gfx.beginDrawing(input.frame_arena_allocator);
    try draw_list.setViewport(0, 0, input.canvas_width, input.canvas_height);
    try draw_list.clearViewport(gfx.Colour.black);
    try draw_list.drawTriangles(
        gfx.Colour.fromHSV(state.triangle_hue, 0.5, 1.0),
        &[_][3][3]f32{
            .{
                .{ -0.5, -0.5, 0.0 },
                .{ 0.5, -0.5, 0.0 },
                .{ 0.0, 0.5, 0.0 },
            },
        },
    );
    gfx.submitDrawList(draw_list);

    return true;
}
