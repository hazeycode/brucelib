const std = @import("std");

const linux = @import("linux.zig");

pub const run = linux.run;
pub const Input = @import("Input.zig");

test {
    std.testing.refAllDecls(@This());
}
