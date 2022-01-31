const std = @import("std");

const core = std.build.Pkg{
    .name = "core",
    .path = .{ .path = "modules/core/main.zig" },
};

const platform = std.build.Pkg{
    .name = "platform",
    .path = .{ .path = "modules/platform/main.zig" },
    .dependencies = &.{ core, external.zig_objcrt },
};

const graphics = std.build.Pkg{
    .name = "graphics",
    .path = .{ .path = "modules/graphics/main.zig" },
    .dependencies = &.{core},
};

const external = struct {
    const zig_objcrt = std.build.Pkg{
        .name = "zig-objcrt",
        .path = .{ .path = "external/zig-objcrt/src/main.zig" },
    };
};

pub fn build(b: *std.build.Builder) !void {
    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    { // tests
        const core_tests = b.addTest(core.path.path);
        core_tests.setBuildMode(mode);

        const platform_tests = b.addTest(platform.path.path);
        for (platform.dependencies.?) |dep| platform_tests.addPackage(dep);
        try addPlatformSystemDependencies(platform_tests);
        platform_tests.setBuildMode(mode);

        const graphics_tests = b.addTest(graphics.path.path);
        for (platform.dependencies.?) |dep| graphics_tests.addPackage(dep);
        graphics_tests.setBuildMode(mode);

        const test_step = b.step("test", "Run all tests");
        test_step.dependOn(&core_tests.step);
        test_step.dependOn(&platform_tests.step);
        test_step.dependOn(&graphics_tests.step);
    }

    const example = b.addExecutable("example", "example/main.zig");
    example.setTarget(b.standardTargetOptions(.{}));
    example.setBuildMode(mode);
    example.addPackage(core);
    example.addPackage(platform);
    example.addPackage(graphics);
    try addPlatformSystemDependencies(example);

    const example_runstep = example.run();
    example_runstep.step.dependOn(b.getInstallStep());
    if (b.args) |args| example_runstep.addArgs(args);
    b.step("run-example", "Build and run example").dependOn(&example_runstep.step);
}

// TODO(hazeycode): Remove system dependencies
fn addPlatformSystemDependencies(step: *std.build.LibExeObjStep) !void {
    if (step.target.isLinux()) {
        step.linkLibC();
        step.addIncludeDir("/usr/include");
        step.linkSystemLibrary("X11-xcb");
        step.linkSystemLibrary("GL");
        step.linkSystemLibrary("epoxy");
    } else if (step.target.isDarwin()) {
        step.linkFramework("AppKit");
        step.linkFramework("MetalKit");
        step.linkFramework("OpenGL");
        step.addCSourceFile("modules/platform/macos/macos.m", &[_][]const u8{"-ObjC"});
        step.addPackage(external.zig_objcrt);
    } else if (step.target.isWindows()) {
        step.linkLibC();
        step.linkSystemLibrary("Kernel32");
        step.linkSystemLibrary("User32");
    } else {
        return error.UnsupportedTarget;
    }
}
