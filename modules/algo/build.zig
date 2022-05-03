const std = @import("std");

pub const pkg = std.build.Pkg{
    .name = "brucelib.algorithms",
    .path = .{ .path = thisDir() ++ "/src/main.zig" },
};

pub fn build(b: *std.build.Builder) void {
    const build_mode = b.standardReleaseOptions();
    const target = b.standardTargetOptions(.{});
    const tests = buildTests(b, build_mode, target);

    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&tests.step);
}

pub fn buildTests(
    b: *std.build.Builder,
    build_mode: std.builtin.Mode,
    target: std.zig.CrossTarget,
) *std.build.LibExeObjStep {
    const tests = b.addTest(pkg.path.path);
    tests.setBuildMode(build_mode);
    tests.setTarget(target);
    buildAndLink(tests);
    return tests;
}

pub fn buildAndLink(obj: *std.build.LibExeObjStep) void {
    const lib = obj.builder.addStaticLibrary(pkg.name, pkg.path.path);

    lib.setBuildMode(obj.build_mode);
    lib.setTarget(obj.target);

    lib.install();

    obj.linkLibrary(lib);
}

fn thisDir() []const u8 {
    return std.fs.path.dirname(@src().file) orelse ".";
}
