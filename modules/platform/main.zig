const std = @import("std");
const builtin = @import("builtin");

pub usingnamespace switch (builtin.os.tag) {
    .linux => @import("linux.zig"),
    .macos => @import("macos.zig"),
    .windows => @import("windows.zig"),
    else => @compileError("Unsupported target"),
};

pub const Input = @import("Input.zig");

test {
    std.testing.refAllDecls(@This());
}
