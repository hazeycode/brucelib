const std = @import("std");

const stb_image = @import("vendored/stb_image/build.zig");
const zmesh = @import("vendored/zmesh/build.zig");

pub const pkg = std.build.Pkg{
    .name = "brucelib.graphics",
    .source = .{ .path = thisDir() ++ "/src/main.zig" },
    .dependencies = &.{
        std.build.Pkg{
            .name = "zwin32",
            .source = .{ .path = thisDir() ++ "/vendored/zwin32/src/zwin32.zig" },
        },
        std.build.Pkg{
            .name = "zmath",
            .source = .{ .path = thisDir() ++ "/vendored/zmath/src/zmath.zig" },
        },
        std.build.Pkg{
            .name = "zig-opengl",
            .source = .{ .path = thisDir() ++ "/vendored/zig-opengl-exports/gl_4v4.zig" },
        },
        stb_image.pkg,
        zmesh.pkg,
    },
};

pub fn tests(b: *std.build.Builder, mode: std.builtin.Mode, target: std.zig.CrossTarget) *std.build.LibExeObjStep  {
    const ts = b.addTest(pkg.source.path);
    ts.setBuildMode(mode);
    ts.setTarget(target);
    for (pkg.dependencies.?) |dep| ts.addPackage(dep);
    return ts;
}

pub fn link(obj: *std.build.LibExeObjStep) void {
    obj.linkLibC();
    if (obj.target.isLinux()) {
        obj.linkSystemLibrary("GL");
    } else if (obj.target.isDarwin()) {
        obj.linkFramework("OpenGL");
        obj.linkFramework("MetalKit");
    } else if (obj.target.isWindows()) {
        obj.linkSystemLibrary("d3d11");
        obj.linkSystemLibrary("dxgi");
        obj.linkSystemLibrary("D3DCompiler_47");
    } else {
        std.debug.panic("Unsupported target!", .{});
    }
    zmesh.link(obj);
}

pub fn add_to(obj: *std.build.LibExeObjStep) void {
    obj.addIncludeDir(stb_image.include_dir);
    obj.addPackage(pkg);
    link(obj);
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
