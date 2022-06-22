const std = @import("std");
const builtin = @import("builtin");

const common = @import("common.zig");
const Viewport = common.Viewport;
const PipelineResources = common.PipelineResources;
const Matrix = common.Matrix;
const identity_matrix = common.identity_matrix;
const mul = common.mul;
const Colour = common.Colour;
const BufferHandle = common.BufferHandle;
const Topology = common.Topology;

pub const Config = struct {
    Backend: type,
    Profiler: type = @import("NullProfiler.zig"),
    profile_marker_colour: u32 = 0x00_00_AA_AA,
};

pub fn using(comptime config: Config) type {
    const Backend = config.Backend;
    const Profiler = config.Profiler;

    const textures = @import("textures.zig").using_backend(Backend);
    const Texture2d = textures.Texture2d;

    return struct {
        pub const Entry = union(enum) {
            set_viewport: Viewport,
            bind_pipeline_resources: PipelineResources,
            set_projection_transform: Matrix,
            set_view_transform: Matrix,
            set_model_transform: Matrix,
            set_colour: Colour,
            bind_texture: struct {
                slot: u32,
                texture: Texture2d,
            },
            draw: struct {
                topology: Topology,
                vertex_offset: u32,
                vertex_count: u32,
            },
        };

        entries: std.ArrayList(Entry),

        pub fn init(allocator: std.mem.Allocator) !@This() {
            return @This(){
                .entries = std.ArrayList(@This().Entry).init(allocator),
            };
        }

        pub fn set_viewport(self: *@This(), viewport: Viewport) !void {
            try self.entries.append(.{
                .set_viewport = viewport,
            });
        }

        pub fn bind_pipeline_resources(self: *@This(), resources: PipelineResources) !void {
            try self.entries.append(.{
                .bind_pipeline_resources = resources,
            });
        }

        pub fn set_projection_transform(self: *@This(), transform: Matrix) !void {
            try self.entries.append(.{
                .set_projection_transform = transform,
            });
        }

        pub fn set_view_transform(self: *@This(), transform: Matrix) !void {
            try self.entries.append(.{
                .set_view_transform = transform,
            });
        }

        pub fn set_model_transform(self: *@This(), transform: Matrix) !void {
            try self.entries.append(.{
                .set_model_transform = transform,
            });
        }

        pub fn set_colour(self: *@This(), colour: Colour) !void {
            try self.entries.append(.{
                .set_colour = colour,
            });
        }

        pub fn bind_texture(self: *@This(), slot: u32, texture: Texture2d) !void {
            try self.entries.append(.{
                .bind_texture = .{
                    .slot = slot,
                    .texture = texture,
                },
            });
        }

        pub fn draw(self: *@This(), topology: Topology, vertex_offset: u32, vertex_count: u32) !void {
            try self.entries.append(.{
                .draw = .{
                    .topology = topology,
                    .vertex_offset = vertex_offset,
                    .vertex_count = vertex_count,
                },
            });
        }

        pub fn submit(self: *@This()) !void {
            const trace_zone = Profiler.zone_name_colour(
                @src(),
                "graphics.render_list.submit",
                config.profile_marker_colour,
            );
            defer trace_zone.End();

            var model = identity_matrix();
            var view = identity_matrix();
            var projection = identity_matrix();
            var current_colour = Colour.white;
            var constant_buffer_handle: BufferHandle = 0;

            for (self.entries.items) |entry| {
                switch (entry) {
                    .set_viewport => |viewport| {
                        Backend.set_viewport(viewport.x, viewport.y, viewport.width, viewport.height);
                    },
                    .set_projection_transform => |transform| {
                        projection = transform;
                    },
                    .set_view_transform => |transform| {
                        view = transform;
                    },
                    .set_model_transform => |transform| {
                        model = transform;
                    },
                    .set_colour => |colour| {
                        current_colour = colour;
                    },
                    .bind_pipeline_resources => |resources| {
                        Backend.set_shader_program(resources.program);
                        Backend.bind_vertex_layout(resources.vertex_layout.handle);
                        Backend.set_raster_state(resources.rasteriser_state);
                        Backend.set_blend_state(resources.blend_state);
                        Backend.set_constant_buffer(resources.constant_buffer);
                        constant_buffer_handle = resources.constant_buffer;
                    },
                    .bind_texture => |desc| {
                        Backend.bind_texture(desc.slot, desc.texture.handle);
                    },
                    .draw => |desc| {
                        try Backend.update_shader_constant_buffer(
                            constant_buffer_handle,
                            std.mem.asBytes(&.{
                                .mvp = mul(mul(model, view), projection),
                                .colour = current_colour,
                            }),
                        );

                        Backend.draw(desc.topology, desc.vertex_offset, desc.vertex_count);
                    },
                }
            }

            if (builtin.mode == .Debug) {
                try Backend.log_debug_messages();
            }
        }
    };
}
