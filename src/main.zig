const std = @import("std");

// TODO(chris): switch platform on target
const platform_layer = @import("linux.zig");

pub const run = platform_layer.run;
pub const gfx = platform_layer.gfx;
pub const Input = @import("Input.zig");

test {
    std.testing.refAllDecls(@This());
}
