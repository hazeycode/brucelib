const std = @import("std");
const ziggylib = @import("ziggylib");

pub fn main() anyerror!void {
    try ziggylib.run(.{
        .title = "example",
        .pxwidth = 854,
        .pxheight = 480,
        .update_fn = update,
    });
}

var state: struct {} = .{};

fn update(input: ziggylib.Input) bool {
    return input.quit_requested;
}
