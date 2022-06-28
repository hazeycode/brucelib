const std = @import("std");
const builtin = @import("builtin");

const backend = switch (builtin.os.tag) {
    .linux => @import("linux.zig"),
    .windows => @import("win32.zig"),
    else => @compileError("Unsupported target"),
};

pub usingnamespace backend;

test {
    std.testing.refAllDecls(@This());
    _ = @import("ring_buffers.zig");
}
