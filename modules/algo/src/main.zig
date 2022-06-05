pub const perlin = @import("perlin.zig");
pub const delaunay = @import("delaunay.zig");

const testing = @import("std").testing;

test {
    testing.refAllDecls(@This());
}
