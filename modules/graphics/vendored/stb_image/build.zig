const std = @import("std");

pub const pkg = std.build.Pkg{
    .name = "stb_image",
    .source = .{ .path = thisDir() ++ "/main.zig" },
};

pub const include_dir = thisDir() ++ "/";

fn thisDir() []const u8 {
    return std.fs.path.dirname(@src().file) orelse ".";
}
