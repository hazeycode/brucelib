const std = @import("std");

pub const pkg = std.build.Pkg{
    .name = "brucelib.platform",
    .path = .{ .path = thisDir() ++ "/src/main.zig" },
    .dependencies = &.{
        std.build.Pkg{
            .name = "zwin32",
            .path = .{ .path = thisDir() ++ "/vendored/zwin32/zwin32.zig" },
        },
        std.build.Pkg{
            .name = "zig-objcrt",
            .path = .{ .path = thisDir() ++ "/vendored/zig-objcrt/src/main.zig" },
        },
        std.build.Pkg{
            .name = "zig-alsa",
            .path = .{ .path = thisDir() ++ "/vendored/zig-alsa/src/main.zig" },
        },
    },
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
    for (pkg.dependencies.?) |dep| tests.addPackage(dep);
    buildAndLink(tests);
    return tests;
}

pub fn buildAndLink(obj: *std.build.LibExeObjStep) void {
    const lib = obj.builder.addStaticLibrary(pkg.name, pkg.path.path);

    lib.setBuildMode(obj.build_mode);
    lib.setTarget(obj.target);

    lib.linkLibC();

    if (lib.target.isLinux()) {
        lib.addIncludeDir("/usr/include");
        lib.linkSystemLibrary("X11-xcb");
        lib.linkSystemLibrary("GL");
    } else if (lib.target.isDarwin()) {
        lib.linkFramework("AppKit");
        lib.linkFramework("MetalKit");
        lib.addCSourceFile("modules/platform/macos/macos.m", &[_][]const u8{"-ObjC"});
    } else if (lib.target.isWindows()) {
        lib.linkSystemLibrary("Kernel32");
        lib.linkSystemLibrary("User32");
        lib.linkSystemLibrary("d3d11");
        lib.linkSystemLibrary("dxgi");
    } else {
        std.debug.panic("Unsupported target!", .{});
    }

    for (pkg.dependencies.?) |dep| {
        lib.addPackage(dep);
    }

    lib.install();

    obj.linkLibrary(lib);
}

fn thisDir() []const u8 {
    return std.fs.path.dirname(@src().file) orelse ".";
}
