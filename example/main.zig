const std = @import("std");

const BruceLib = @import("BruceLib");
const Input = BruceLib.Input;
const gfx = BruceLib.gfx;

pub fn main() anyerror!void {
    try BruceLib.run(.{
        .title = "example",
        .pxwidth = 854,
        .pxheight = 480,
        .update_fn = update,
    });
}

var state: struct {} = .{};

fn update(input: BruceLib.Input) bool {
    gfx.clear(1, 0.5, 0);
    return input.quit_requested;
}
