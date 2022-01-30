const std = @import("std");
const builtin = @import("builtin");

const platform_layer = switch (builtin.os.tag) {
    .linux => @import("linux.zig"),
    .macos => @import("macos.zig"),
    .windows => @import("windows.zig"),
    else => @compileError("Unsupported target"),
};

pub const run = platform_layer.run;
pub const gfx = @import("gfx.zig").Interface(platform_layer.gfx_api);
pub const Input = @import("Input.zig");

test {
    std.testing.refAllDecls(@This());
}
