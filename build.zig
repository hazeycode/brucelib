const std = @import("std");

pub fn build(b: *std.build.Builder) !void {
    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const package = std.build.Pkg{
        .name = "BruceLib",
        .path = .{ .path = "src/main.zig" },
        .dependencies = &.{},
    };

    const tests = b.addTest("src/main.zig");
    try addPlatformDependencies(b.allocator, tests);
    tests.setBuildMode(mode);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&tests.step);

    const example = b.addExecutable("example", "example/main.zig");
    example.setTarget(b.standardTargetOptions(.{}));
    example.setBuildMode(mode);
    example.addPackage(package);
    try addPlatformDependencies(b.allocator, example);

    const example_runstep = example.run();
    example_runstep.step.dependOn(b.getInstallStep());
    if (b.args) |args| example_runstep.addArgs(args);
    b.step("run-example", "Build and run example").dependOn(&example_runstep.step);
}

fn addPlatformDependencies(allocator: std.mem.Allocator, step: *std.build.LibExeObjStep) !void {
    if (step.target.isLinux()) {
        step.linkLibC();
        step.addIncludeDir("/usr/include");
        step.linkSystemLibrary("X11-xcb");
        step.linkSystemLibrary("GL");
        step.linkSystemLibrary("epoxy");
    } else if (step.target.isDarwin()) {
        const host = try std.zig.system.NativeTargetInfo.detect(allocator, .{});
        const sdk = std.zig.system.darwin.getDarwinSDK(allocator, host.target) orelse return error.FailedToGetDarwinSDK;
        defer sdk.deinit(allocator);
        const framework_dir = try std.mem.concat(allocator, u8, &[_][]const u8{ sdk.path, "/System/Library/Frameworks" });
        const usrinclude_dir = try std.mem.concat(allocator, u8, &[_][]const u8{ sdk.path, "/usr/include" });
        step.addFrameworkDir(framework_dir);
        step.addIncludeDir(usrinclude_dir);
        step.linkFramework("AppKit");
    } else {
        return error.UnsupportedTarget;
    }
}
