const std = @import("std");

pub const GraphicsAPI = enum {
    opengl,
    metal,
    d3d11,
};

test {
    std.testing.refAllDecls(@This());
}
