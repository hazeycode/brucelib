const std = @import("std");

test {
    std.testing.refAllDecls(@This());
}
