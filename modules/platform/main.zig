const std = @import("std");
const builtin = @import("builtin");

const backend = switch (builtin.os.tag) {
    .linux => @import("linux.zig"),
    .macos => @import("macos.zig"),
    .windows => @import("win32.zig"),
    else => @compileError("Unsupported target"),
};

pub usingnamespace backend;

pub const FrameInput = @import("FrameInput.zig");

pub const AudioPlaybackStream = @import("AudioPlaybackStream.zig");

test {
    std.testing.refAllDecls(@This());
}
