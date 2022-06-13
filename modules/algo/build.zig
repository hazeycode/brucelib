const std = @import("std");

const bench = std.build.Pkg{
    .name = "bench",
    .path = .{ .path = thisDir() ++ "/vendored/zig-bench/bench.zig" },
};

const zmath = std.build.Pkg{
    .name = "zmath",
    .path = .{ .path = thisDir() ++ "/vendored/zmath/src/zmath.zig" },
};

pub const pkg = std.build.Pkg{
    .name = "brucelib.algo",
    .path = .{ .path = thisDir() ++ "/src/main.zig" },
    .dependencies = &.{
        bench,
        zmath,
    },
};

pub fn tests(b: *std.build.Builder, mode: std.builtin.Mode, target: std.zig.CrossTarget) *std.build.LibExeObjStep  {
    const ts = b.addTest(pkg.path.path);
    ts.setBuildMode(mode);
    ts.setTarget(target);
    for (pkg.dependencies.?) |dep| ts.addPackage(dep);
    return ts;
}

pub fn build(b: *std.build.Builder) void {
    const build_mode = b.standardReleaseOptions();
    const target = b.standardTargetOptions(.{});

    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&tests(b, build_mode, target).step);
}

pub fn add_to(obj: *std.build.LibExeObjStep) void {
    obj.addPackage(pkg);
}

fn thisDir() []const u8 {
    return std.fs.path.dirname(@src().file) orelse ".";
}
