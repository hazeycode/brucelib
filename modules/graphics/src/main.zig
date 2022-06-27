const builtin = @import("builtin");
const std = @import("std");

const log = std.log.scoped(.@"brucelib.graphics");

pub const ModuleConfig = struct {
    Platform: type,
    Profiler: type = @import("NullProfiler.zig"),
    profile_marker_colour: u32 = 0x00_00_AA_AA,
    backend_api: enum {
        default,
        opengl,
        d3d11,
    } = .default,
};

pub fn using(comptime config: ModuleConfig) type {
    const Platform = config.Platform;
    const Profiler = config.Profiler;

    return struct {
        pub const zmath = @import("zmath");

        const common = @import("common.zig");
        pub const FenceHandle = common.FenceHandle;
        pub const FenceState = common.FenceState;
        pub const Colour = common.Colour;
        pub const Rect = common.Rect;
        pub const Vertex = common.Vertex;
        pub const TexturedVertex = common.TexturedVertex;

        pub const Backend = (switch (config.backend_api) {
            .default => switch (builtin.os.tag) {
                .linux => @import("opengl.zig"),
                .windows => @import("d3d11.zig"),
                else => @compileError("Unsupported target"),
            },
            .opengl => @import("opengl.zig"),
            .d3d11 => @import("d3d11.zig"),
        }).using_platform(Platform);

        const buffers = @import("buffers.zig").using(.{
            .Backend = Backend,
            .Profiler = Profiler,
            .profile_marker_colour = config.profile_marker_colour,
        });
        pub const VertexBufferStatic = buffers.VertexBufferStatic;
        pub const VertexBufferDynamic = buffers.VertexBufferDynamic;

        const textures = @import("textures.zig").using_backend(Backend);
        pub const Texture2d = textures.Texture2d;

        pub const RenderList = @import("render_list.zig").using(.{
            .Backend = Backend,
            .Profiler = Profiler,
            .profile_marker_colour = config.profile_marker_colour,
        });

        pub usingnamespace @import("renderers.zig").using(.{
            .Backend = Backend,
            .Profiler = Profiler,
            .profile_marker_colour = config.profile_marker_colour,
        });

        pub const DebugGui = @import("debug_gui.zig").using(.{
            .Backend = Backend,
            .Profiler = Profiler,
            .profile_marker_colour = config.profile_marker_colour,
        });

        pub var debug_gui: DebugGui = undefined;

        // Module initilisation

        pub fn init(allocator: std.mem.Allocator) !void {
            const trace_zone = Profiler.zone_name_colour(
                @src(),
                "graphics.init",
                config.profile_marker_colour,
            );
            defer trace_zone.End();

            try Backend.init(allocator);
            errdefer Backend.deinit();

            debug_gui = try DebugGui.init(allocator);

            Backend.flush();
        }

        pub fn deinit() void {
            debug_gui.deinit();
            Backend.deinit();
        }

        pub fn begin_frame() void {
            const trace_zone = Profiler.zone_name_colour(
                @src(),
                "graphics.begin_frame",
                config.profile_marker_colour,
            );
            defer trace_zone.End();
            Backend.sync();
        }

        pub fn end_frame() void {
            Backend.flush();
        }
    };
}

test {
    std.testing.refAllDecls(@This());
}
