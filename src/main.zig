const std = @import("std");
const builtin = @import("builtin");

const target_backend = switch (builtin.os.tag) {
    .linux => @import("linux.zig"),
    .macos => @import("macos.zig"),
    else => @compileError("Unsupported target"),
};

pub const run = target_backend.run;
pub const gfx = @import("gfx.zig").Interface(target_backend.gfx_api);
pub const Input = @import("Input.zig");

test {
    std.testing.refAllDecls(@This());
}
