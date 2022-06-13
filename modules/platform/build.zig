const std = @import("std");

pub const pkg = std.build.Pkg{
    .name = "brucelib.platform",
    .source = .{ .path = thisDir() ++ "/src/main.zig" },
    .dependencies = &.{
        std.build.Pkg{
            .name = "zwin32",
            .source = .{ .path = thisDir() ++ "/vendored/zwin32/src/zwin32.zig" },
        },
        std.build.Pkg{
            .name = "zig-alsa",
            .source = .{ .path = thisDir() ++ "/vendored/zig-alsa/src/main.zig" },
        },
        std.build.Pkg{
            .name = "ztracy",
            .source = .{ .path = thisDir() ++ "/vendored/ztracy/src/ztracy.zig" },
        }
    },
};

pub fn tests(b: *std.build.Builder, mode: std.builtin.Mode, target: std.zig.CrossTarget) *std.build.LibExeObjStep {
    const ts = b.addTest(pkg.source.path);
    ts.setBuildMode(mode);
    ts.setTarget(target);
    for (pkg.dependencies.?) |dep| ts.addPackage(dep);
    return ts;
}

pub fn link(obj: *std.build.LibExeObjStep, enable_ztracy: bool) void {
    obj.linkLibC();
    if (obj.target.isLinux()) {
        obj.linkSystemLibrary("X11");
        obj.linkSystemLibrary("xcb");
        obj.linkSystemLibrary("X11-xcb");
        obj.linkSystemLibrary("GL");
    } else if (obj.target.isWindows()) {
        obj.linkSystemLibrary("Kernel32");
        obj.linkSystemLibrary("User32");
        obj.linkSystemLibrary("d3d11");
        obj.linkSystemLibrary("dxgi");
    } else {
        std.debug.panic("Unsupported target!", .{});
    }
    
    const ztracy = @import("vendored/ztracy/build.zig");
    const ztracy_options = ztracy.BuildOptionsStep.init(obj.builder, .{ .enable_ztracy = enable_ztracy });
    ztracy.link(obj, ztracy_options);
}

pub fn add_to(obj: *std.build.LibExeObjStep, enable_ztracy: bool) void {
    obj.addPackage(pkg);
    link(obj, enable_ztracy);
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
