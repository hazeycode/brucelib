const std = @import("std");

const stb_image = @import("vendored/stb_image/build.zig");
const zmesh = @import("vendored/zmesh/build.zig");

pub const pkg = std.build.Pkg{
    .name = "brucelib.graphics",
    .path = .{ .path = thisDir() ++ "/src/main.zig" },
    .dependencies = &.{
        std.build.Pkg{
            .name = "zwin32",
            .path = .{ .path = thisDir() ++ "/vendored/zwin32/src/zwin32.zig" },
        },
        std.build.Pkg{
            .name = "zmath",
            .path = .{ .path = thisDir() ++ "/vendored/zmath/zmath.zig" },
        },
        std.build.Pkg{
            .name = "zig-opengl",
            .path = .{ .path = thisDir() ++ "/vendored/zig-opengl-exports/gl_4v4.zig" },
        },
        stb_image.pkg,
        zmesh.pkg,
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
        lib.linkSystemLibrary("GL");
    } else if (lib.target.isDarwin()) {
        lib.linkFramework("OpenGL");
        lib.linkFramework("MetalKit");
    } else if (lib.target.isWindows()) {
        lib.linkSystemLibrary("d3d11");
        lib.linkSystemLibrary("dxgi");
        lib.linkSystemLibrary("D3DCompiler_47");
    } else {
        std.debug.panic("Unsupported target!", .{});
    }

    obj.addIncludeDir(stb_image.include_dir);

    zmesh.link(obj);

    for (pkg.dependencies.?) |dep| {
        lib.addPackage(dep);
    }

    lib.install();

    obj.linkLibrary(lib);
}

fn thisDir() []const u8 {
    return std.fs.path.dirname(@src().file) orelse ".";
}
