const std = @import("std");

const platform = std.build.Pkg{
    .name = "platform",
    .path = .{ .path = "modules/platform/main.zig" },
    .dependencies = &.{
        vendored.zig_objcrt,
        vendored.zwin32,
        vendored.zig_alsa,
    },
};

const graphics = std.build.Pkg{
    .name = "graphics",
    .path = .{ .path = "modules/graphics/main.zig" },
    .dependencies = &.{
        vendored.zwin32,
        vendored.zmath,
    },
};

const vendored = struct {
    const zig_objcrt = std.build.Pkg{
        .name = "zig-objcrt",
        .path = .{ .path = "vendored/zig-objcrt/src/main.zig" },
    };
    const zwin32 = std.build.Pkg{
        .name = "zwin32",
        .path = .{ .path = "vendored/zwin32/win32.zig" },
    };
    const zmath = std.build.Pkg{
        .name = "zmath",
        .path = .{ .path = "vendored/zmath/zmath.zig" },
    };
    const zig_alsa = std.build.Pkg{
        .name = "zig-alsa",
        .path = .{ .path = "vendored/zig-alsa/src/main.zig" },
    };
};

pub fn build(b: *std.build.Builder) !void {
    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const standard_target_opts = b.standardTargetOptions(.{});

    const build_root_dir = try std.fs.openDirAbsolute(b.build_root, .{});

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
        const dir = try build_root_dir.openDir("examples", .{ .iterate = true });

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
                    example.setTarget(standard_target_opts);
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
    } else if (step.target.isWindows()) {
        step.linkSystemLibrary("Kernel32");
        step.linkSystemLibrary("User32");
        step.linkSystemLibrary("d3d11");
        step.linkSystemLibrary("dxgi");
        step.linkSystemLibrary("D3DCompiler_47");
    } else {
        return error.UnsupportedTarget;
    }
}
