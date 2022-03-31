const std = @import("std");

pub const platform = PackageDesc{
    .name = "platform",
    .path = "modules/platform/main.zig",
    .dependencies = &.{
        vendored.zig_objcrt,
        vendored.zwin32,
        vendored.zig_alsa,
    },
};

pub const graphics = PackageDesc{
    .name = "graphics",
    .path = "modules/graphics/main.zig",
    .dependencies = &.{
        vendored.zwin32,
        vendored.zmath,
        vendored.zig_opengl,
    },
};

const vendored = struct {
    const zig_objcrt = PackageDesc{
        .name = "zig-objcrt",
        .path = "vendored/zig-objcrt/src/main.zig",
    };
    const zwin32 = PackageDesc{
        .name = "zwin32",
        .path = "vendored/zwin32/zwin32.zig",
    };
    const zmath = PackageDesc{
        .name = "zmath",
        .path = "vendored/zmath/zmath.zig",
    };
    const zig_alsa = PackageDesc{
        .name = "zig-alsa",
        .path = "vendored/zig-alsa/src/main.zig",
    };
    const zig_opengl = PackageDesc{
        .name = "zig-opengl",
        .path = "vendored/zig-opengl-exports/gl_4v4.zig",
    };
};

pub const PackageDesc = struct {
    name: []const u8,
    path: []const u8,
    dependencies: []const PackageDesc = &.{},

    pub fn getPackage(
        comptime self: PackageDesc,
        allocator: std.mem.Allocator,
        comptime relative_to_path: []const u8,
    ) std.mem.Allocator.Error!std.build.Pkg {
        var dependencies = try allocator.alloc(std.build.Pkg, self.dependencies.len);
        inline for (self.dependencies) |dep, i| {
            dependencies[i] = try dep.getPackage(allocator, relative_to_path);
        }
        return std.build.Pkg{
            .name = self.name,
            .path = .{ .path = relative_to_path ++ self.path },
            .dependencies = dependencies,
        };
    }
};

pub fn build(b: *std.build.Builder) !void {
    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const standard_target_opts = b.standardTargetOptions(.{});

    const build_root_dir = try std.fs.openDirAbsolute(b.build_root, .{});

    const platform_pkg = try platform.getPackage(b.allocator, "./");
    const graphics_pkg = try graphics.getPackage(b.allocator, "./");

    { // tests
        const platform_tests = b.addTest(platform_pkg.path.path);
        for (platform_pkg.dependencies.?) |dep| platform_tests.addPackage(dep);
        try addPlatformSystemDependencies(platform_tests);
        platform_tests.setBuildMode(mode);

        const graphics_tests = b.addTest(graphics_pkg.path.path);
        for (graphics_pkg.dependencies.?) |dep| graphics_tests.addPackage(dep);
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
                    const example = b.addExecutable(
                        entry.name,
                        try std.fmt.allocPrint(b.allocator, "examples/{s}/main.zig", .{entry.name}),
                    );
                    example.setTarget(standard_target_opts);
                    example.setBuildMode(mode);

                    example.addPackage(platform_pkg);
                    example.addPackage(graphics_pkg);

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

                    example_id += 1;
                },
                else => {},
            }
        }
    }
}

pub fn addPlatformSystemDependencies(step: *std.build.LibExeObjStep) !void {
    if (step.target.isLinux()) {
        step.linkLibC();
        step.addIncludeDir("/usr/include");
        step.linkSystemLibrary("X11-xcb");
        step.linkSystemLibrary("GL");
    } else if (step.target.isDarwin()) {
        step.linkFramework("AppKit");
        step.linkFramework("MetalKit");
        step.linkFramework("OpenGL");
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
