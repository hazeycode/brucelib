pub const perlin = @import("perlin.zig");

const testing = @import("std").testing;

test {
    testing.refAllDecls(@This());
}
