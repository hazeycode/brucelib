const std = @import("std");
const builtin = @import("builtin");

pub usingnamespace switch (builtin.os.tag) {
    .linux => @import("linux.zig"),
    .macos => @import("macos.zig"),
    .windows => @import("win32.zig"),
    else => @compileError("Unsupported target"),
};

pub const FrameInput = @import("FrameInput.zig");

test {
    std.testing.refAllDecls(@This());
}
