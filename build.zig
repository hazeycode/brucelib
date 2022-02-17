const std = @import("std");

const platform = std.build.Pkg{
    .name = "platform",
    .path = .{ .path = "modules/platform/main.zig" },
    .dependencies = &.{
        vendored.zig_objcrt,
        vendored.zig_gamedev_win32,
    },
};

const graphics = std.build.Pkg{
    .name = "graphics",
    .path = .{ .path = "modules/graphics/main.zig" },
    .dependencies = &.{
        vendored.zig_gamedev_win32,
        vendored.zig_gamedev_zmath,
    },
};

const vendored = struct {
    const zig_objcrt = std.build.Pkg{
        .name = "zig-objcrt",
        .path = .{ .path = "vendored/zig-objcrt/src/main.zig" },
    };
    const zig_gamedev_win32 = std.build.Pkg{
        .name = "zig-gamedev-win32",
        .path = .{ .path = "vendored/zig-gamedev-win32/win32.zig" },
    };
    const zig_gamedev_zmath = std.build.Pkg{
        .name = "zig-gamedev-zmath",
        .path = .{ .path = "vendored/zig-gamedev-zmath/zmath.zig" },
    };
};

pub fn build(b: *std.build.Builder) !void {
    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    { // tests
        const platform_tests = b.addTest(platform.path.path);
        for (platform.dependencies.?) |dep| platform_tests.addPackage(dep);
        try addPlatformSystemDependencies(platform_tests);
        platform_tests.setBuildMode(mode);

        const graphics_tests = b.addTest(graphics.path.path);
        for (graphics.dependencies.?) |dep| graphics_tests.addPackage(dep);
        graphics_tests.setBuildMode(mode);

        const test_step = b.step("test", "Run all tests");
        test_step.dependOn(&platform_tests.step);
        test_step.dependOn(&graphics_tests.step);
    }

    { // examples
        // TODO(hazeycode): Use build root dir instead of cwd
        const dir = try std.fs.cwd().openDir("examples", .{ .iterate = true });

        var example_id: usize = 0;
        var dir_it = dir.iterate();
        while (try dir_it.next()) |entry| {
            switch (entry.kind) {
                .Directory => {
                    example_id += 1;

                    const example = b.addExecutable(
                        entry.name,
                        try std.fmt.allocPrint(b.allocator, "examples/{s}/main.zig", .{entry.name}),
                    );
                    example.setTarget(b.standardTargetOptions(.{}));
                    example.setBuildMode(mode);
                    example.addPackage(platform);
                    example.addPackage(graphics);
                    try addPlatformSystemDependencies(example);
                    example.install();

                    const example_runstep = example.run();
                    example_runstep.step.dependOn(b.getInstallStep());
                    if (b.args) |args| example_runstep.addArgs(args);

                    var run = b.step(
                        try std.fmt.allocPrint(b.allocator, "run-example-{:0>3}", .{example_id}),
                        try std.fmt.allocPrint(b.allocator, "Build and run example {s}", .{entry.name}),
                    );
                    run.dependOn(&example_runstep.step);
                },
                else => {},
            }
        }
    }
}

// TODO(hazeycode): load sytem libs at runtime, remove dependencies
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
        step.linkSystemLibrary("epoxy");
        step.addCSourceFile("modules/platform/macos/macos.m", &[_][]const u8{"-ObjC"});
        step.addPackage(vendored.zig_objcrt);
    } else if (step.target.isWindows()) {
        step.linkSystemLibrary("Kernel32");
        step.linkSystemLibrary("User32");
        step.linkSystemLibrary("d3d11");
        step.linkSystemLibrary("dxgi");
        step.linkSystemLibrary("D3DCompiler_47");
        step.addPackage(vendored.zig_gamedev_win32);
    } else {
        return error.UnsupportedTarget;
    }
}
