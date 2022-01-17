const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const package = std.build.Pkg{
        .name = "BruceLib",
        .path = .{ .path = "src/main.zig" },
        .dependencies = &.{},
    };

    const tests = b.addTest("src/main.zig");
    addPlatformDependencies(tests);
    tests.setBuildMode(mode);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&tests.step);

    const example = b.addExecutable("example", "example/main.zig");
    example.setTarget(b.standardTargetOptions(.{}));
    example.setBuildMode(mode);
    example.addPackage(package);
    addPlatformDependencies(example);

    const example_runstep = example.run();
    example_runstep.step.dependOn(b.getInstallStep());
    if (b.args) |args| example_runstep.addArgs(args);
    b.step("run-example", "Build and run example").dependOn(&example_runstep.step);
}

fn addPlatformDependencies(step: *std.build.LibExeObjStep) void {
    // TODO(chris): switch target
    { // linux
        step.linkLibC();
        step.addIncludeDir("/usr/include");
        step.linkSystemLibrary("X11-xcb");
        step.linkSystemLibrary("GL");
    }
}
