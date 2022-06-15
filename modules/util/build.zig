const std = @import("std");

pub const ztracy = @import("src/vendored/ztracy/build.zig");

pub fn getPkg(ztracy_options: ztracy.BuildOptionsStep) std.build.Pkg {
    return .{
        .name = "brucelib.util",
        .source = .{ .path = thisDir() ++ "/src/main.zig" },
        .dependencies = &.{ztracy_options.getPkg()},
    };
}

pub fn link(obj: *std.build.LibExeObjStep, ztracy_options: ztracy.BuildOptionsStep) void {
    ztracy.link(obj, ztracy_options);
}

pub fn build(b: *std.build.Builder) void {
    _ = b;
    // const build_mode = b.standardReleaseOptions();
    // const target = b.standardTargetOptions(.{});

    // const test_step = b.step("test", "Run tests");
    // test_step.dependOn(&tests(b, build_mode, target).step);
}

fn thisDir() []const u8 {
    return std.fs.path.dirname(@src().file) orelse ".";
}
