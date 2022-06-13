const std = @import("std");

pub const platform = @import("modules/platform/build.zig");
pub const graphics = @import("modules/graphics/build.zig");
pub const audio = @import("modules/audio/build.zig");
pub const algo = @import("modules/algo/build.zig");

const all_modules = .{
    platform,
    graphics,
    audio,
    algo,  
};

pub fn build(b: *std.build.Builder) !void {
    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const target_opts = b.standardTargetOptions(.{});

    const test_step = b.step("test", "Run all tests");
    inline for (all_modules) |module| {
        test_step.dependOn(&module.buildTests(b, mode, target_opts).step);
    }
    
    { // examples
        const build_root_dir = try std.fs.openDirAbsolute(b.build_root, .{});
        const dir = try build_root_dir.openDir("examples", .{ .iterate = true });

        var dir_it = dir.iterate();
        while (try dir_it.next()) |entry| {
            switch (entry.kind) {
                .Directory => {
                    const example_id = entry.name[0..3];
                
                    const example = b.addExecutable(
                        entry.name,
                        try std.fmt.allocPrint(b.allocator, "examples/{s}/main.zig", .{entry.name}),
                    );
                    
                    example.setTarget(target_opts);
                    example.setBuildMode(mode);

                    inline for (all_modules) |module| {
                        example.addPackage(module.pkg);
                        module.buildAndLink(example);
                    }

                    example.install();

                    const example_runstep = example.run();
                    example_runstep.step.dependOn(b.getInstallStep());
                    if (b.args) |args| example_runstep.addArgs(args);

                    var run = b.step(
                        try std.fmt.allocPrint(b.allocator, "run-example-{s}", .{example_id}),
                        try std.fmt.allocPrint(b.allocator, "Build and run example {s}", .{entry.name}),
                    );
                    run.dependOn(&example_runstep.step);
                },
                else => {},
            }
        }
    }
}
