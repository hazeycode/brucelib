const std = @import("std");

pub const pkg = std.build.Pkg{
    .name = "brucelib.audio",
    .source = .{ .path = thisDir() ++ "/src/main.zig" },
    .dependencies = &.{},
};

pub fn tests(b: *std.build.Builder, mode: std.builtin.Mode, target: std.zig.CrossTarget) *std.build.LibExeObjStep {
    const ts = b.addTest(pkg.source.path);
    ts.setBuildMode(mode);
    ts.setTarget(target);
    for (pkg.dependencies.?) |dep| ts.addPackage(dep);
    return ts;
}

pub fn add_to(obj: *std.build.LibExeObjStep, dependencies: *std.StringHashMap(std.build.Pkg)) !void {
    obj.addPackage(pkg);
    for (pkg.dependencies.?) |dep| try dependencies.put(dep.name, dep);
}

pub fn build(b: *std.build.Builder) void {
    const build_mode = b.standardReleaseOptions();
    const target = b.standardTargetOptions(.{});

    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&tests(b, build_mode, target).step);
}

fn thisDir() []const u8 {
    return std.fs.path.dirname(@src().file) orelse ".";
}
