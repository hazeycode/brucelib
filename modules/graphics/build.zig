const std = @import("std");

const stb_image = @import("src/vendored/stb_image/build.zig");
const zmesh = @import("src/vendored/zmesh/build.zig");

pub const pkg = std.build.Pkg{
    .name = "brucelib.graphics",
    .source = .{ .path = thisDir() ++ "/src/main.zig" },
};

pub fn tests(b: *std.build.Builder, mode: std.builtin.Mode, target: std.zig.CrossTarget) *std.build.LibExeObjStep {
    const ts = b.addTest(pkg.source.path);
    ts.setBuildMode(mode);
    ts.setTarget(target);
    ts.addIncludeDir(stb_image.include_dir);
    link(ts);
    return ts;
}

pub fn add_to(obj: *std.build.LibExeObjStep) !void {
    obj.addPackage(pkg);
    obj.addIncludeDir(stb_image.include_dir);
    link(obj);
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

pub fn build(b: *std.build.Builder) void {
    const build_mode = b.standardReleaseOptions();
    const target = b.standardTargetOptions(.{});

    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&tests(b, build_mode, target).step);
}

fn thisDir() []const u8 {
    return std.fs.path.dirname(@src().file) orelse ".";
}
