const builtin = @import("builtin");
const std = @import("std");

const log = std.log.scoped(.@"brucelib.graphics");

pub const ModuleConfig = struct {
    Profiler: type = @import("NullProfiler.zig"),
    profile_marker_colour: u32 = 0x00_00_AA_AA,
    backend_api: enum {
        default,
        opengl,
        d3d11,
    } = .default,
};

pub fn using(comptime config: ModuleConfig) type {
    const Profiler = config.Profiler;
    
    return struct {
        const common = @import("common.zig");
        pub const Matrix = common.Matrix;
        pub const identity_matrix = common.identity_matrix;
        pub const orthographic = common.orthographic;
        pub const translation = common.translation;
        pub const scaling = common.scaling;
        pub const mul = common.mul;    
        pub const Colour = common.Colour;
        pub const Rect = common.Rect;
        pub const Vertex = common.Vertex;
        pub const TexturedVertex = common.TexturedVertex;
    
        pub const Backend = switch (config.backend_api) {
            .default => switch (builtin.os.tag) {
                .linux => @import("opengl.zig"),
                .windows => @import("d3d11.zig"),
                else => @compileError("Unsupported target"),
            },
            .opengl => @import("opengl.zig"),
            .d3d11 => @import("d3d11.zig"),
        };
        
        const buffers = @import("buffers.zig").using_backend(Backend);
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

        pub const ShaderConstants = extern struct {
            mvp: Matrix,
            colour: Colour,
        };
        
        pub fn init(allocator: std.mem.Allocator, platform: anytype) !void {
            const trace_zone = Profiler.zone_name_colour(
                @src(),
                "graphics.init",
                config.profile_marker_colour,
            );
            defer trace_zone.End();
            
            try Backend.init(platform, allocator);
            errdefer Backend.deinit();
            
            debug_gui = try DebugGui.init(allocator);

            Backend.sync();
        }

        pub fn deinit() void {
            Backend.deinit();
        }
        
        pub fn sync() void {
            Backend.sync();
        }
    
        pub fn begin_frame(clear_colour: Colour) void {
            const bind_trace_zone = Profiler.zone_name_colour(
                @src(), 
                "begin_frame",
                config.profile_marker_colour,
            );
            
            defer bind_trace_zone.End();
            Backend.clear_with_colour(
                clear_colour.r,
                clear_colour.g,
                clear_colour.b,
                clear_colour.a,
            );
        }
        
    };
}

test {
    std.testing.refAllDecls(@This());
}
