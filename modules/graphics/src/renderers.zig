const common = @import("common.zig");
const PipelineResources = common.PipelineResources;
const Vertex = common.Vertex;
const ColouredVertex = common.ColouredVertex;
const TexturedVertex = common.TexturedVertex;
const VertexLayout = common.VertexLayout;
const VertexLayoutDesc = common.VertexLayoutDesc;
const Colour = common.Colour;
const Rect = common.Rect;

pub const Config = struct {
    Backend: type,
    Profiler: type = @import("NullProfiler.zig"),
    profile_marker_colour: u32 = 0x00_00_AA_AA,
};

pub fn using(comptime config: Config) type {
    const Backend = config.Backend;
    const Profiler = config.Profiler;

    const buffers = @import("buffers.zig").using_backend(Backend);
    const VertexBufferDynamic = buffers.VertexBufferDynamic;

    const textures = @import("textures.zig").using_backend(Backend);
    const Texture2d = textures.Texture2d;

    const RenderList = @import("render_list.zig").using(.{
        .Backend = Backend,
        .Profiler = Profiler,
        .profile_marker_colour = config.profile_marker_colour,
    });

    return struct {
        ///
        pub const UniformColourVertsRenderer = struct {
            pipeline_resources: PipelineResources,
            vertex_buffer: VertexBufferDynamic(Vertex),

            pub fn init(max_vertices: u32) !@This() {
                const vertex_buffer = try VertexBufferDynamic(Vertex).init(max_vertices);
                const vertex_layout_desc = VertexLayoutDesc{
                    .entries = &[_]VertexLayoutDesc.Entry{
                        .{
                            .buffer_handle = vertex_buffer.handle,
                            .attributes = Vertex.get_layout_attributes(),
                            .offset = 0,
                        },
                    },
                };
                return @This(){
                    .pipeline_resources = .{
                        .program = try Backend.createUniformColourShader(), // TODO(hazeycode): shader cacheing
                        .vertex_layout = .{
                            .handle = try Backend.create_vertex_layout(vertex_layout_desc),
                            .desc = vertex_layout_desc,
                        },
                        .rasteriser_state = try Backend.create_raster_state(),
                        .blend_state = try Backend.create_blend_state(),
                        // TODO(hazeycode): create constant buffer of exactly the required size
                        .constant_buffer = try Backend.create_constant_buffer(0x1000),
                    },
                    .vertex_buffer = vertex_buffer,
                };
            }

            pub fn render(
                self: *@This(),
                render_list: *RenderList,
                colour: Colour,
                vertices: []const Vertex,
            ) !void {
                const vert_offset = self.vertex_buffer.push(vertices);

                try render_list.bind_pipeline_resources(self.pipeline_resources);
                try render_list.set_colour(colour);
                try render_list.draw(vert_offset, @intCast(u32, vertices.len));
            }
        };

        ///
        pub const TexturedVertsRenderer = struct {
            pipeline_resources_mono: PipelineResources,
            pipeline_resources_rgba: PipelineResources,
            vertex_buffer: VertexBufferDynamic(TexturedVertex),

            pub fn init(max_vertices: u32) !@This() {
                const vertex_buffer = try VertexBufferDynamic(TexturedVertex).init(max_vertices);
                const vertex_layout_desc = VertexLayoutDesc{
                    .entries = &[_]VertexLayoutDesc.Entry{
                        .{
                            .buffer_handle = vertex_buffer.handle,
                            .attributes = TexturedVertex.get_layout_attributes(),
                            .offset = 0,
                        },
                    },
                };
                const vertex_layout = VertexLayout{
                    .handle = try Backend.create_vertex_layout(vertex_layout_desc),
                    .desc = vertex_layout_desc,
                };
                const raster_state = try Backend.create_raster_state();
                const blend_state = try Backend.create_blend_state();
                const constant_buffer = try Backend.create_constant_buffer(0x1000); // TODO(hazeycode): create constant buffer of exactly the required size
                return @This(){
                    .pipeline_resources_mono = .{
                        .program = try Backend.createTexturedVertsMonoShader(), // TODO(hazeycode): shader cacheing
                        .vertex_layout = vertex_layout,
                        .rasteriser_state = raster_state,
                        .blend_state = blend_state,
                        .constant_buffer = constant_buffer,
                    },
                    .pipeline_resources_rgba = .{
                        .program = try Backend.createTexturedVertsShader(), // TODO(hazeycode): shader cacheing
                        .vertex_layout = vertex_layout,
                        .rasteriser_state = raster_state,
                        .blend_state = blend_state,
                        .constant_buffer = constant_buffer,
                    },
                    .vertex_buffer = vertex_buffer,
                };
            }

            pub fn render(
                self: *@This(),
                render_list: *RenderList,
                texture: Texture2d,
                vertices: []const TexturedVertex,
            ) !void {
                const vert_offset = self.vertex_buffer.push(vertices);

                const resources = switch (texture.format) {
                    .uint8 => self.pipeline_resources_mono,
                    .rgba_u8 => self.pipeline_resources_rgba,
                };

                try render_list.bind_pipeline_resources(resources);
                try render_list.bind_texture(0, texture);
                try render_list.draw(vert_offset, @intCast(u32, vertices.len));
            }

            pub fn render_sprite(
                self: *@This(),
                render_list: *RenderList,
                resources: PipelineResources,
                args: struct {
                    texture: Texture2d,
                    uv_rect: Rect = .{
                        .min_x = 0,
                        .min_y = 0,
                        .max_x = 1,
                        .max_y = 1,
                    },
                },
            ) !void {
                const width = @intToFloat(f32, args.texture.height);
                const height = @intToFloat(f32, args.texture.width);
                const aspect_ratio = width / height;
                const rect = Rect{
                    .min_x = -1,
                    .min_y = 1 * aspect_ratio,
                    .max_x = 1,
                    .max_y = -1 * aspect_ratio,
                };
                try self.render(
                    render_list,
                    resources,
                    args.texture,
                    &rect.textured_vertices(args.uv_rect),
                );
            }
        };
    };
}
