const std = @import("std");

// TODO(chris): switch platform on target
const platform_layer = @import("linux.zig");

pub const run = platform_layer.run;
pub const gfx = @import("gfx.zig");
pub const Input = @import("Input.zig");

test {
    std.testing.refAllDecls(@This());
}
