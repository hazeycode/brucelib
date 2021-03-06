const std = @import("std");

pub const pkg = std.build.Pkg{
    .name = "brucelib.platform",
    .source = .{ .path = thisDir() ++ "/src/main.zig" },
    .dependencies = &.{},
};

pub fn tests(b: *std.build.Builder, mode: std.builtin.Mode, target: std.zig.CrossTarget) *std.build.LibExeObjStep {
    const ts = b.addTest(pkg.source.path);
    ts.setBuildMode(mode);
    ts.setTarget(target);
    link(ts);
    return ts;
}

pub fn add_to(obj: *std.build.LibExeObjStep) !void {
    obj.addPackage(pkg);
    link(obj);
}

pub fn link(obj: *std.build.LibExeObjStep) void {
    obj.linkLibC();
    if (obj.target.isLinux()) {
        obj.linkSystemLibrary("X11");
        obj.linkSystemLibrary("xcb");
        obj.linkSystemLibrary("X11-xcb");
        obj.linkSystemLibrary("Xrandr");
        obj.linkSystemLibrary("GL");
    } else if (obj.target.isWindows()) {
        obj.linkSystemLibrary("Kernel32");
        obj.linkSystemLibrary("User32");
        obj.linkSystemLibrary("d3d11");
        obj.linkSystemLibrary("dxgi");
        obj.linkSystemLibrary("xinput1_4");
    } else {
        std.debug.panic("Unsupported target!", .{});
    }
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
