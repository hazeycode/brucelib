const std = @import("std");

pub const platform = @import("modules/platform/build.zig");
pub const graphics = @import("modules/graphics/build.zig");
pub const audio = @import("modules/audio/build.zig");

pub fn build(b: *std.build.Builder) !void {
    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const target_opts = b.standardTargetOptions(.{});

    { // tests
        const platform_tests = platform.buildTests(b, mode, target_opts);
        const graphics_tests = graphics.buildTests(b, mode, target_opts);
        const audio_tests = audio.buildTests(b, mode, target_opts);

        const test_step = b.step("test", "Run all tests");
        test_step.dependOn(&platform_tests.step);
        test_step.dependOn(&graphics_tests.step);
        test_step.dependOn(&audio_tests.step);
    }

    { // examples
        const build_root_dir = try std.fs.openDirAbsolute(b.build_root, .{});
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
                    example.setTarget(target_opts);
                    example.setBuildMode(mode);

                    example.addPackage(platform.pkg);
                    platform.buildAndLink(example);

                    example.addPackage(graphics.pkg);
                    graphics.buildAndLink(example);

                    example.addPackage(audio.pkg);
                    audio.buildAndLink(example);

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
