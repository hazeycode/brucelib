const builtin = @import("builtin");
const std = @import("std");

const log = std.log.scoped(.@"brucelib.graphics");

pub const ModuleConfig = struct {
    backend_api: enum {
        default,
        opengl,
        d3d11,
    } = .default,
    Profiler: type = @import("NullProfiler.zig"),
};

pub fn using(comptime config: ModuleConfig) type {
    const Profiler = config.Profiler;
    
    return struct {
        pub const Backend = switch (config.backend_api) {
            .default => switch (builtin.os.tag) {
                .linux => @import("opengl.zig"),
                .windows => @import("d3d11.zig"),
                else => @compileError("Unsupported target"),
            },
            .opengl => @import("opengl.zig"),
            .d3d11 => @import("d3d11.zig"),
        };
        
        const common = @import("common.zig");
        pub const ShaderProgramHandle = common.ShaderProgramHandle;
        pub const BufferHandle = common.BufferHandle;
        pub const VertexLayoutHandle = common.VertexLayoutHandle;
        pub const RasteriserStateHandle = common.RasteriserStateHandle;
        pub const BlendStateHandle = common.BlendStateHandle;
        pub const TextureHandle = common.TextureHandle;
        pub const SamplerStateHandle = common.SamplerStateHandle;
        pub const VertexLayoutDesc = common.VertexLayoutDesc;
        pub const TextureFormat = common.TextureFormat;
        pub const FenceHandle = common.FenceHandle;
        pub const FenceState = common.FenceState;
        
        const buffers = @import("buffers.zig").using_backend(Backend);
        pub const VertexBufferDynamic = buffers.VertexBufferDynamic;
        
        const textures = @import("textures.zig").using_backend(Backend);
        pub const Texture2d = textures.Texture2d;

        pub const zmath = @import("zmath");
        pub const F32x4 = zmath.F32x4;
        pub const Matrix = zmath.Mat;
        pub const identityMatrix = zmath.identity;
        pub const orthographic = zmath.orthographicLh;

        // Module initilisation

        pub var builtin_pipeline_resources: struct {
            uniform_colour_verts: PipelineResources,
            textured_verts_mono: PipelineResources,
            textured_verts: PipelineResources,
        } = undefined;

        pub var builtin_vertex_buffers: struct {
            pos: VertexBufferDynamic(Vertex),
            pos_uv: VertexBufferDynamic(TexturedVertex),
        } = undefined;

        pub const ShaderConstants = extern struct {
            mvp: Matrix,
            colour: Colour,
        };

        pub var debugfont_texture: Texture2d = undefined;
        
        pub fn init(allocator: std.mem.Allocator, platform: anytype) !void {
            const trace_zone = Profiler.zone_name_colour(@src(), "graphics.init", 0x00_af_af_00);
            defer trace_zone.End();
            
            try Backend.init(platform, allocator);
            errdefer Backend.deinit();

            debugfont_texture = try Texture2d.fromPBM(allocator, @embedFile("../data/debugfont.pbm"));

            builtin_vertex_buffers.pos = try VertexBufferDynamic(Vertex).init(1e3);
            builtin_vertex_buffers.pos_uv = try VertexBufferDynamic(TexturedVertex).init(1e3);

            { // create builtin uniform_colour_verts pipeline
                const vertex_layout_desc = VertexLayoutDesc{
                    .entries = &[_]VertexLayoutDesc.Entry{
                        .{
                            .buffer_handle = builtin_vertex_buffers.pos.handle,
                            .attributes = Vertex.getLayoutAttributes(),
                            .offset = 0,
                        },
                    },
                };

                builtin_pipeline_resources.uniform_colour_verts = .{
                    .program = try Backend.createUniformColourShader(),
                    .vertex_layout = .{
                        .handle = try Backend.createVertexLayout(vertex_layout_desc),
                        .desc = vertex_layout_desc,
                    },
                    .rasteriser_state = try Backend.createRasteriserState(),
                    .blend_state = try Backend.createBlendState(),
                    // TODO(hazeycode): create constant buffer of exactly the required size
                    .constant_buffer = try Backend.createConstantBuffer(0x1000),
                };
            }

            { // create builtin uniform_colour_verts pipeline
                const vertex_layout_desc = VertexLayoutDesc{
                    .entries = &[_]VertexLayoutDesc.Entry{
                        .{
                            .buffer_handle = builtin_vertex_buffers.pos_uv.handle,
                            .attributes = TexturedVertex.getLayoutAttributes(),
                            .offset = 0,
                        },
                    },
                };

                builtin_pipeline_resources.textured_verts_mono = .{
                    .program = try Backend.createTexturedVertsMonoShader(),
                    .vertex_layout = .{
                        .handle = try Backend.createVertexLayout(vertex_layout_desc),
                        .desc = vertex_layout_desc,
                    },
                    .rasteriser_state = try Backend.createRasteriserState(),
                    .blend_state = try Backend.createBlendState(),
                    // TODO(hazeycode): create constant buffer of exactly the required size
                    .constant_buffer = try Backend.createConstantBuffer(0x1000),
                };
            }

            { // create builtin uniform_colour_verts pipeline
                const vertex_layout_desc = VertexLayoutDesc{
                    .entries = &[_]VertexLayoutDesc.Entry{
                        .{
                            .buffer_handle = builtin_vertex_buffers.pos_uv.handle,
                            .attributes = TexturedVertex.getLayoutAttributes(),
                            .offset = 0,
                        },
                    },
                };

                builtin_pipeline_resources.textured_verts = .{
                    .program = try Backend.createTexturedVertsShader(),
                    .vertex_layout = .{
                        .handle = try Backend.createVertexLayout(vertex_layout_desc),
                        .desc = vertex_layout_desc,
                    },
                    .rasteriser_state = try Backend.createRasteriserState(),
                    .blend_state = try Backend.createBlendState(),
                    // TODO(hazeycode): create constant buffer of exactly the required size
                    .constant_buffer = try Backend.createConstantBuffer(0x1000),
                };
            }
        }

        pub fn deinit() void {
            Backend.deinit();
        }
        
    
        pub fn begin_frame(clear_colour: Colour) void {
            const bind_trace_zone = Profiler.zone_name_colour(@src(), "begin_frame", 0x00_00_ff_ff);
            defer bind_trace_zone.End();
            Backend.clearWithColour(
                clear_colour.r,
                clear_colour.g,
                clear_colour.b,
                clear_colour.a,
            );
        }

    
        // Core DrawList API

        pub fn begin(allocator: std.mem.Allocator) !DrawList {
            return DrawList{
                .entries = std.ArrayList(DrawList.Entry).init(allocator),
            };
        }

        pub fn setViewport(draw_list: *DrawList, viewport: Viewport) !void {
            try draw_list.entries.append(.{
                .set_viewport = viewport,
            });
        }

        pub fn bindPipelineResources(draw_list: *DrawList, resources: PipelineResources) !void {
            try draw_list.entries.append(.{
                .bind_pipeline_resources = resources,
            });
        }

        pub fn setProjectionTransform(draw_list: *DrawList, transform: Matrix) !void {
            try draw_list.entries.append(.{
                .set_projection_transform = transform,
            });
        }

        pub fn setViewTransform(draw_list: *DrawList, transform: Matrix) !void {
            try draw_list.entries.append(.{
                .set_view_transform = transform,
            });
        }

        pub fn setModelTransform(draw_list: *DrawList, transform: Matrix) !void {
            try draw_list.entries.append(.{
                .set_model_transform = transform,
            });
        }

        pub fn setColour(draw_list: *DrawList, colour: Colour) !void {
            try draw_list.entries.append(.{
                .set_colour = colour,
            });
        }

        pub fn bindTexture(draw_list: *DrawList, slot: u32, texture: Texture2d) !void {
            try draw_list.entries.append(.{
                .bind_texture = .{
                    .slot = slot,
                    .texture = texture,
                },
            });
        }

        pub fn draw(draw_list: *DrawList, vertex_offset: u32, vertex_count: u32) !void {
            try draw_list.entries.append(.{
                .draw = .{
                    .vertex_offset = vertex_offset,
                    .vertex_count = vertex_count,
                },
            });
        }

        pub fn submitDrawList(draw_list: *DrawList) !void {
            const trace_zone = Profiler.zone_name_colour(@src(), "graphics.submit_draw_list", 0x00_00_ff_00);
            defer trace_zone.End();
            
            var model = identityMatrix();
            var view = identityMatrix();
            var projection = identityMatrix();
            var current_colour = Colour.white;
            var constant_buffer_handle: BufferHandle = 0;

            for (draw_list.entries.items) |entry| {
                // const entry_trace_zone = Profiler.zone_name_colour(@src(), "drawlist entry", 0x00_00_ff_ff);
                // defer entry_trace_zone.End();
                
                switch (entry) {
                    .set_viewport => |viewport| {
                        const bind_trace_zone = Profiler.zone_name_colour(@src(), "set viewport", 0x00_00_ff_ff);
                        defer bind_trace_zone.End();
                        Backend.setViewport(viewport.x, viewport.y, viewport.width, viewport.height);
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
                        const bind_trace_zone = Profiler.zone_name_colour(@src(), "bind pipeline resources", 0x00_00_ff_ff);
                        defer bind_trace_zone.End();
                        Backend.setShaderProgram(resources.program);
                        Backend.bind_vertex_layout(resources.vertex_layout.handle);
                        Backend.setRasteriserState(resources.rasteriser_state);
                        Backend.setBlendState(resources.blend_state);
                        Backend.setConstantBuffer(resources.constant_buffer);
                        constant_buffer_handle = resources.constant_buffer;
                    },
                    .bind_texture => |desc| {
                        Backend.bindTexture(desc.slot, desc.texture.handle);
                    },
                    .draw => |desc| {
                        const draw_trace_zone = Profiler.zone_name_colour(@src(), "draw", 0x00_00_ff_ff);
                        defer draw_trace_zone.End();
                        try Backend.updateShaderConstantBuffer(
                            constant_buffer_handle,
                            std.mem.asBytes(&.{
                                .mvp = zmath.mul(zmath.mul(model, view), projection),
                                .colour = current_colour,
                            }),
                        );

                        Backend.draw(desc.vertex_offset, desc.vertex_count);
                    },
                }
            }

            if (builtin.mode == .Debug) {
                try Backend.logDebugMessages();
            }            
        }

        // High-level DrawList API

        pub fn drawUniformColourVerts(
            draw_list: *DrawList,
            resources: PipelineResources,
            colour: Colour,
            vertices: []const Vertex,
        ) !void {
            const vert_offset = builtin_vertex_buffers.pos.push(vertices);

            try bindPipelineResources(draw_list, resources);
            try setColour(draw_list, colour);
            try draw(draw_list, vert_offset, @intCast(u32, vertices.len));
        }

        pub fn drawTexturedVerts(
            draw_list: *DrawList,
            resources: PipelineResources,
            texture: Texture2d,
            vertices: []const TexturedVertex,
        ) !void {
            const vert_offset = builtin_vertex_buffers.pos_uv.push(vertices);

            try bindPipelineResources(draw_list, resources);
            try bindTexture(draw_list, 0, texture);
            try draw(draw_list, vert_offset, @intCast(u32, vertices.len));
        }

        pub fn drawTexturedQuad(
            draw_list: *DrawList,
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
            try drawTexturedVerts(
                draw_list,
                resources,
                args.texture,
                &rect.texturedVertices(args.uv_rect),
            );
        }

        // Rendering Primitives

        ///
        pub const DrawList = struct {
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
                    vertex_offset: u32,
                    vertex_count: u32,
                },
            };

            entries: std.ArrayList(Entry),
        };

        ///
        pub const PipelineResources = struct {
            program: ShaderProgramHandle,
            vertex_layout: VertexLayout,
            constant_buffer: BufferHandle,
            blend_state: BlendStateHandle,
            rasteriser_state: RasteriserStateHandle,
        };

        ///
        pub const VertexLayout = struct {
            handle: VertexLayoutHandle,
            desc: VertexLayoutDesc,
        };

        ///
        pub const Vertex = extern struct {
            pos: [3]f32,
        
            pub fn getLayoutAttributes() []const VertexLayoutDesc.Entry.Attribute {
                return &[_]VertexLayoutDesc.Entry.Attribute{
                    .{ .format = .f32x3 },
                };
            }
        };

        pub const TexturedVertex = extern struct {
            pos: [3]f32,
            uv: [2]f32,

            pub fn getLayoutAttributes() []const VertexLayoutDesc.Entry.Attribute {
                return &[_]VertexLayoutDesc.Entry.Attribute{
                    .{ .format = .f32x3 },
                    .{ .format = .f32x2 },
                };
            }
        };

        ///
        pub const Viewport = struct { x: u16, y: u16, width: u16, height: u16 };

        pub const Colour = extern struct {
            r: f32,
            g: f32,
            b: f32,
            a: f32,

            pub const black = fromRGB(0, 0, 0);
            pub const white = fromRGB(1, 1, 1);
            pub const red = fromRGB(1, 0, 0);
            pub const orange = fromRGB(1, 0.5, 0);

            pub fn fromRGB(r: f32, g: f32, b: f32) Colour {
                return .{ .r = r, .g = g, .b = b, .a = 1 };
            }

            pub fn fromRGBA(r: f32, g: f32, b: f32, a: f32) Colour {
                return .{ .r = r, .g = g, .b = b, .a = a };
            }

            /// Returns a Colour for a given hue, saturation and value
            /// h, s, v are assumed to be in the range 0...1
            pub fn fromHSV(h: f32, s: f32, v: f32) Colour {
                // Modified version of HSV TO RGB from here: https://www.tlbx.app/color-converter
                // TODO(hazeycode): compare performance & codegen of this vs zmath.hsvToRgb
                const hp = (h * 360) / 60;
                const c = v * s;
                const x = c * (1 - @fabs(@mod(hp, 2) - 1));
                const m = v - c;
                if (hp <= 1) {
                    return Colour.fromRGB(c + m, x + m, m);
                } else if (hp <= 2) {
                    return Colour.fromRGB(x + m, c + m, m);
                } else if (hp <= 3) {
                    return Colour.fromRGB(m, c + m, x + m);
                } else if (hp <= 4) {
                    return Colour.fromRGB(m, x + m, c + m);
                } else if (hp <= 5) {
                    return Colour.fromRGB(x + m, m, c + m);
                } else if (hp <= 6) {
                    return Colour.fromRGB(c + m, m, x + m);
                } else {
                    std.debug.assert(false);
                    return Colour.fromRGB(0, 0, 0);
                }
            }
        };

        pub const Rect = extern struct {
            min_x: f32,
            min_y: f32,
            max_x: f32,
            max_y: f32,

            pub fn vertices(self: Rect) [6]Vertex {
                return [_]Vertex{
                    .{ .pos = .{ self.min_x, self.min_y, 0.0 } },
                    .{ .pos = .{ self.min_x, self.max_y, 0.0 } },
                    .{ .pos = .{ self.max_x, self.max_y, 0.0 } },
                    .{ .pos = .{ self.max_x, self.max_y, 0.0 } },
                    .{ .pos = .{ self.max_x, self.min_y, 0.0 } },
                    .{ .pos = .{ self.min_x, self.min_y, 0.0 } },
                };
            }

            pub fn texturedVertices(self: Rect, uv_rect: Rect) [6]TexturedVertex {
                return [_]TexturedVertex{
                    TexturedVertex{
                        .pos = .{ self.min_x, self.min_y, 0.0 },
                        .uv = .{ uv_rect.min_x, uv_rect.min_y },
                    },
                    TexturedVertex{
                        .pos = .{ self.min_x, self.max_y, 0.0 },
                        .uv = .{ uv_rect.min_x, uv_rect.max_y },
                    },
                    TexturedVertex{
                        .pos = .{ self.max_x, self.max_y, 0.0 },
                        .uv = .{ uv_rect.max_x, uv_rect.max_y },
                    },
                    TexturedVertex{
                        .pos = .{ self.max_x, self.max_y, 0.0 },
                        .uv = .{ uv_rect.max_x, uv_rect.max_y },
                    },
                    TexturedVertex{
                        .pos = .{ self.max_x, self.min_y, 0.0 },
                        .uv = .{ uv_rect.max_x, uv_rect.min_y },
                    },
                    TexturedVertex{
                        .pos = .{ self.min_x, self.min_y, 0.0 },
                        .uv = .{ uv_rect.min_x, uv_rect.min_y },
                    },
                };
            }

            pub fn containsPoint(self: Rect, x: f32, y: f32) bool {
                return (x >= self.min_x and x <= self.max_x and y >= self.min_y and y <= self.max_y);
            }

            pub fn inset(self: Rect, left: f32, right: f32, top: f32, bottom: f32) Rect {
                return .{
                    .min_x = self.min_x + left,
                    .max_x = self.max_x - right,
                    .min_y = self.min_y + top,
                    .max_y = self.max_y - bottom,
                };
            }
        };

        ///
        pub const DebugGUI = struct {
            allocator: std.mem.Allocator,
            draw_list: *DrawList,
            canvas_width: f32,
            canvas_height: f32,
            cur_x: f32,
            cur_y: f32,
            text_verts: std.ArrayList(TexturedVertex),
            uniform_colour_verts: std.ArrayList(Vertex),
            state: *State,

            const inset = 4;
            const line_spacing = 4;

            // values for builtin debugfont
            const glyph_width = 7;
            const glyph_height = 12;

            pub const ElemId = u32;

            pub const State = struct {
                input: Input = .{},
                hover_id: ElemId = 0,
                active_id: ElemId = 0,
                keyboard_focus: ElemId = 0,
                text_cur_x: f32 = 0,
                text_cur_y: f32 = 0,
            };

            pub const Input = struct {
                mouse_btn_down: bool = false,
                mouse_btn_was_pressed: bool = false,
                mouse_btn_was_released: bool = false,
                mouse_x: f32 = undefined,
                mouse_y: f32 = undefined,

                /// Optional helper fn for mapping brucelib.platform.FrameInput to DebugGUI.Input
                /// `user_input` can be any weakly conforming type
                pub fn mapPlatformInput(self: *Input, user_input: anytype) void {
                    self.mouse_x = @intToFloat(f32, user_input.mouse_position.x);
                    self.mouse_y = @intToFloat(f32, user_input.mouse_position.y);

                    self.mouse_btn_was_pressed = false;
                    self.mouse_btn_was_released = false;

                    for (user_input.mouse_button_events) |mouse_ev| {
                        if (mouse_ev.button != .left) continue;

                        switch (mouse_ev.action) {
                            .press => {
                                self.mouse_btn_was_pressed = true;
                                self.mouse_btn_down = true;
                            },
                            .release => {
                                self.mouse_btn_was_released = true;
                                self.mouse_btn_down = false;
                            },
                        }
                    }
                }
            };

            pub fn begin(
                allocator: std.mem.Allocator,
                draw_list: *DrawList,
                canvas_width: f32,
                canvas_height: f32,
                state: *State,
            ) !DebugGUI {
                const projection = orthographic(canvas_width, canvas_height, 0, 1);
                try setProjectionTransform(draw_list, projection);

                const view = zmath.mul(
                    zmath.translation(-canvas_width / 2, -canvas_height / 2, 0),
                    zmath.scaling(1, -1, 1),
                );
                try setViewTransform(draw_list, view);

                return DebugGUI{
                    .allocator = allocator,
                    .draw_list = draw_list,
                    .canvas_width = canvas_width,
                    .canvas_height = canvas_height,
                    .cur_x = @intToFloat(f32, inset),
                    .cur_y = @intToFloat(f32, inset),
                    .text_verts = std.ArrayList(TexturedVertex).init(allocator),
                    .uniform_colour_verts = std.ArrayList(Vertex).init(allocator),
                    .state = state,
                };
            }

            pub fn end(self: *DebugGUI) !void {
                // calculate bounding rect
                var rect = Rect{ .min_x = 0, .min_y = 0, .max_x = 0, .max_y = 0 };
                for (self.text_verts.items) |v| {
                    if (v.pos[0] > rect.max_x) rect.max_x = v.pos[0];
                    if (v.pos[1] > rect.max_y) rect.max_y = v.pos[1];
                }
                for (self.uniform_colour_verts.items) |v| {
                    if (v.pos[0] > rect.max_x) rect.max_x = v.pos[0];
                    if (v.pos[1] > rect.max_y) rect.max_y = v.pos[0];
                }
                rect.max_x += @intToFloat(f32, inset);
                rect.max_y += @intToFloat(f32, inset);

                // draw background
                try self.drawColourRect(Colour.fromRGBA(0.13, 0.13, 0.13, 0.13), rect);

                // draw all text
                try drawTexturedVerts(
                    self.draw_list,
                    builtin_pipeline_resources.textured_verts_mono,
                    debugfont_texture,
                    self.text_verts.items,
                );

                // draw text cursor if there is an element with keyboard focus
                if (self.state.keyboard_focus > 0) {
                    try self.drawColourRect(
                        Colour.white,
                        .{
                            .min_x = self.state.text_cur_x - 1,
                            .min_y = self.state.text_cur_y - line_spacing / 2,
                            .max_x = self.state.text_cur_x + 1,
                            .max_y = self.state.text_cur_y + glyph_height + line_spacing / 2,
                        },
                    );
                }
            }

            pub fn label(
                self: *DebugGUI,
                comptime fmt: []const u8,
                args: anytype,
            ) !void {
                var temp_arena = std.heap.ArenaAllocator.init(self.allocator);
                defer temp_arena.deinit();
                const temp_allocator = temp_arena.allocator();

                const string = try std.fmt.allocPrint(temp_allocator, fmt, args);

                const bounding_rect = try drawText(
                    self.cur_x,
                    self.cur_y,
                    string,
                    &self.text_verts,
                );

                self.cur_y += (bounding_rect.max_y - bounding_rect.min_y);
            }

            pub fn textField(
                self: *DebugGUI,
                comptime T: type,
                comptime fmt: []const u8,
                value_ptr: *T,
            ) !void {
                const id = 1; // TODO(hazeycode): obtain some sort of unique identifier

                var temp_arena = std.heap.ArenaAllocator.init(self.allocator);
                defer temp_arena.deinit();
                const temp_allocator = temp_arena.allocator();

                const string = try std.fmt.allocPrint(temp_allocator, fmt, .{value_ptr.*});

                const text_rect = try drawText(self.cur_x, self.cur_y, string, &self.text_verts);

                const bounding_rect = text_rect.inset(-4, -3, -4, 1);
                try self.drawColourRectOutline(Colour.white, bounding_rect, 1);

                const input = self.state.input;
                const mouse_over = text_rect.containsPoint(input.mouse_x, input.mouse_y);

                if (id == self.state.active_id) {
                    if (input.mouse_btn_down and id == self.state.keyboard_focus) {
                        const column = @divFloor(
                            @floatToInt(
                                i32,
                                input.mouse_x - text_rect.min_x + @as(f32, glyph_width) / 2,
                            ),
                            glyph_width,
                        );
                        const capped_column = @intCast(
                            u32,
                            std.math.max(
                                0,
                                std.math.min(@intCast(i32, string.len), column),
                            ),
                        );

                        const line = 0;

                        const x_offset = capped_column * glyph_width;
                        const y_offset = line * (glyph_height + line_spacing);

                        self.state.text_cur_x = text_rect.min_x + @intToFloat(f32, x_offset);
                        self.state.text_cur_y = text_rect.min_y + @intToFloat(f32, y_offset);
                    }

                    if (input.mouse_btn_was_released) {
                        self.state.active_id = 0;
                    }
                } else if (id == self.state.hover_id) {
                    if (input.mouse_btn_was_pressed) {
                        if (mouse_over) {
                            self.state.active_id = id;
                            self.state.keyboard_focus = id;
                        } else {
                            self.state.keyboard_focus = 0;
                        }
                    }
                } else {
                    if (mouse_over) {
                        self.state.hover_id = id;
                    }
                }

                self.cur_y += (text_rect.max_y - text_rect.min_y);
            }

            fn drawColourRect(self: *DebugGUI, colour: Colour, rect: Rect) !void {
                var verts = try self.allocator.alloc(Vertex, 6);
                errdefer self.allocator.free(verts);

                std.mem.copy(Vertex, verts, &rect.vertices());

                try drawUniformColourVerts(
                    self.draw_list,
                    builtin_pipeline_resources.uniform_colour_verts,
                    colour,
                    verts,
                );
            }

            fn drawColourRectOutline(self: *DebugGUI, colour: Colour, rect: Rect, weight: f32) !void {
                const num_verts = 6;
                const num_sides = 4;

                var verts = try self.allocator.alloc(Vertex, num_verts * num_sides);
                errdefer self.allocator.free(verts);

                { // left side
                    const side_rect = Rect{
                        .min_x = rect.min_x,
                        .max_x = rect.min_x + weight,
                        .min_y = rect.min_y,
                        .max_y = rect.max_y,
                    };
                    const offset = 0 * num_verts;
                    std.mem.copy(
                        Vertex,
                        verts[offset..(offset + num_verts)],
                        &side_rect.vertices(),
                    );
                }

                { // right side
                    const side_rect = Rect{
                        .min_x = rect.max_x - weight,
                        .max_x = rect.max_x,
                        .min_y = rect.min_y,
                        .max_y = rect.max_y,
                    };
                    const offset = 1 * num_verts;
                    std.mem.copy(
                        Vertex,
                        verts[offset..(offset + num_verts)],
                        &side_rect.vertices(),
                    );
                }

                { // top side
                    const side_rect = Rect{
                        .min_x = rect.min_x,
                        .max_x = rect.max_x,
                        .min_y = rect.min_y,
                        .max_y = rect.min_y + weight,
                    };
                    const offset = 2 * num_verts;
                    std.mem.copy(
                        Vertex,
                        verts[offset..(offset + num_verts)],
                        &side_rect.vertices(),
                    );
                }

                { // bottom side
                    const side_rect = Rect{
                        .min_x = rect.min_x,
                        .max_x = rect.max_x,
                        .min_y = rect.max_y - weight,
                        .max_y = rect.max_y,
                    };
                    const offset = 3 * num_verts;
                    std.mem.copy(
                        Vertex,
                        verts[offset..(offset + num_verts)],
                        &side_rect.vertices(),
                    );
                }

                try drawUniformColourVerts(
                    self.draw_list,
                    builtin_pipeline_resources.uniform_colour_verts,
                    colour,
                    verts,
                );
            }

            fn drawText(
                cur_x: f32,
                cur_y: f32,
                string: []const u8,
                verts: *std.ArrayList(TexturedVertex),
            ) !Rect {
                var cur_line: u32 = 0;
                var column: u32 = 0;
                var max_column: u32 = 0;

                for (string) |c| {
                    const maybe_glyph_idx: ?u32 = switch (c) {
                        '0'...'9' => 0 + c - 48,
                        'a'...'z' => 10 + c - 97,
                        'A'...'Z' => 36 + c - 65,
                        ':' => 62,
                        ';' => 63,
                        '\'' => 64,
                        '"' => 65,
                        '\\' => 66,
                        ',' => 67,
                        '.' => 68,
                        '?' => 69,
                        '/' => 70,
                        '>' => 71,
                        '<' => 72,
                        '-' => 73,
                        '+' => 74,
                        '%' => 75,
                        '&' => 76,
                        '*' => 77,
                        '(' => 78,
                        ')' => 79,
                        '_' => 80,
                        '=' => 81,
                        else => null,
                    };
                    if (maybe_glyph_idx) |glyph_idx| {
                        const x = cur_x + @intToFloat(f32, column * glyph_width);
                        const y = cur_y + @intToFloat(f32, cur_line * (glyph_height + line_spacing));
                        const rect = Rect{
                            .min_x = x,
                            .min_y = y,
                            .max_x = x + glyph_width,
                            .max_y = y + glyph_height,
                        };

                        // debugfont only has a single row and is tightly packed
                        const u = @intToFloat(f32, glyph_width * glyph_idx);
                        const v = @intToFloat(f32, 0);
                        const uv_rect = Rect{
                            .min_x = u / @intToFloat(f32, debugfont_texture.width),
                            .min_y = v / @intToFloat(f32, debugfont_texture.height),
                            .max_x = (u + glyph_width) / @intToFloat(f32, debugfont_texture.width),
                            .max_y = (v + glyph_height) / @intToFloat(f32, debugfont_texture.height),
                        };

                        try verts.appendSlice(&rect.texturedVertices(uv_rect));

                        column += 1;
                        if (column > max_column) max_column = column;
                    } else switch (c) {
                        '\n', '\r' => {
                            cur_line += 1;
                            if (column > max_column) max_column = column;
                            column = 0;
                        },
                        ' ' => {
                            column += 1;
                            if (column > max_column) max_column = column;
                        },
                        else => {
                            std.debug.panic("graphics.DebugGUI unmapped character {}", .{c});
                        },
                    }
                }

                cur_line += 1;

                return Rect{
                    .min_x = cur_x,
                    .min_y = cur_y,
                    .max_x = cur_x + @intToFloat(f32, max_column * glyph_width),
                    .max_y = cur_y + @intToFloat(f32, cur_line * (glyph_height + line_spacing)),
                };
            }
        };
    };
}

test {
    std.testing.refAllDecls(@This());
}
