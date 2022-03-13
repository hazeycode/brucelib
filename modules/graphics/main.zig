const builtin = @import("builtin");
const std = @import("std");

pub const API = enum {
    default,
    opengl,
    metal,
    d3d11,
};

pub fn usingAPI(comptime api: API) type {
    return struct {
        pub const backend = switch (api) {
            .default => switch (builtin.os.tag) {
                .linux => @import("opengl.zig"),
                .macos => @import("metal.zig"),
                .windows => @import("d3d11.zig"),
                else => @compileError("Unsupported target"),
            },
            .opengl => @import("opengl.zig"),
            .metal => @import("metal.zig"),
            .d3d11 => @import("d3d11.zig"),
        };

        pub const Texture2d = @import("texture.zig").withBackend(backend).Texture2d;

        const common = @import("common.zig");
        pub const ShaderProgramHandle = common.ShaderProgramHandle;
        pub const ConstantBufferHandle = common.ConstantBufferHandle;
        pub const VertexBufferHandle = common.VertexBufferHandle;
        pub const VertexLayoutHandle = common.VertexLayoutHandle;
        pub const RasteriserStateHandle = common.RasteriserStateHandle;
        pub const BlendStateHandle = common.BlendStateHandle;
        pub const TextureHandle = common.TextureHandle;
        pub const SamplerStateHandle = common.SamplerStateHandle;
        pub const VertexLayoutDesc = common.VertexLayoutDesc;
        pub const TextureFormat = common.TextureFormat;
        pub const VertexPosition = common.VertexPosition;
        pub const VertexIndex = common.VertexIndex;
        pub const VertexUV = common.VertexUV;
        pub const TexturedVertex = common.TexturedVertex;
        pub const Colour = common.Colour;
        pub const Rect = common.Rect;

        const zmath = @import("zmath");
        pub const F32x4 = zmath.F32x4;
        pub const Matrix = zmath.Mat;

        pub const identityMatrix = zmath.identity;
        pub const orthographic = zmath.orthographicLh;

        pub const DrawList = struct {
            pub const Entry = union(enum) {
                set_viewport: struct { x: u16, y: u16, width: u16, height: u16 },
                clear_viewport: Colour,
                set_projection_transform: Matrix,
                set_view_transform: Matrix,
                set_model_transform: Matrix,
                uniform_colour_verts: struct {
                    colour: Colour,
                    vertices: []const VertexPosition,
                },
                textured_verts: struct {
                    texture: Texture2d,
                    vertices: []const TexturedVertex,
                },
            };

            entries: std.ArrayList(Entry),

            pub fn setViewport(self: *@This(), x: u16, y: u16, width: u16, height: u16) !void {
                try self.entries.append(.{ .set_viewport = .{ .x = x, .y = y, .width = width, .height = height } });
            }

            pub fn clearViewport(self: *@This(), colour: Colour) !void {
                try self.entries.append(.{ .clear_viewport = colour });
            }

            pub fn setProjectionTransform(self: *@This(), transform: Matrix) !void {
                try self.entries.append(.{ .set_projection_transform = transform });
            }

            pub fn setViewTransform(self: *@This(), transform: Matrix) !void {
                try self.entries.append(.{ .set_view_transform = transform });
            }

            pub fn setModelTransform(self: *@This(), transform: Matrix) !void {
                try self.entries.append(.{ .set_model_transform = transform });
            }

            pub fn drawUniformColourVerts(self: *@This(), colour: Colour, vertices: []const VertexPosition) !void {
                try self.entries.append(.{ .uniform_colour_verts = .{
                    .colour = colour,
                    .vertices = vertices,
                } });
            }

            pub fn drawTexturedVerts(self: *@This(), texture: Texture2d, vertices: []const TexturedVertex) !void {
                try self.entries.append(.{ .textured_verts = .{
                    .texture = texture,
                    .vertices = vertices,
                } });
            }
        };

        const PipelineResources = struct {
            program: ShaderProgramHandle,
            vertex_buffer: VertexBufferHandle,
            vertex_layout: VertexLayoutHandle,
            rasteriser_state: RasteriserStateHandle,
            blend_state: BlendStateHandle,
            constant_buffer: ConstantBufferHandle,
        };

        var pipeline_resources: struct {
            uniform_colour_tris: PipelineResources,
            textured_tris: PipelineResources,
        } = undefined;

        const ShaderConstants = extern struct {
            mvp: Matrix,
            colour: Colour,
        };

        var debugfont_texture: Texture2d = undefined;

        pub fn init(allocator: std.mem.Allocator) !void {
            try backend.init(allocator);

            debugfont_texture = try Texture2d.fromPBM(allocator, @embedFile("data/debugfont.pbm"));

            {
                const zeros = [_]u8{0} ** 1e6;
                const vertex_buffer = try backend.createDynamicVertexBufferWithBytes(&zeros);
                const vertex_layout = try backend.createVertexLayout(.{
                    .entries = &[_]VertexLayoutDesc.Entry{
                        .{
                            .buffer_handle = vertex_buffer,
                            .attributes = &[_]VertexLayoutDesc.Entry.Attribute{
                                .{ .format = .f32x3 },
                            },
                            .offset = 0,
                        },
                    },
                });

                pipeline_resources.uniform_colour_tris = .{
                    .program = try backend.createUniformColourShader(),
                    .vertex_buffer = vertex_buffer,
                    .vertex_layout = vertex_layout,
                    .rasteriser_state = try backend.createRasteriserState(),
                    .blend_state = try backend.createBlendState(),
                    .constant_buffer = try backend.createConstantBuffer(0x1000),
                };
            }

            {
                const zeros = [_]u8{0} ** 1e6;
                const vertex_buffer = try backend.createDynamicVertexBufferWithBytes(&zeros);
                const vertex_layout = try backend.createVertexLayout(.{
                    .entries = &[_]VertexLayoutDesc.Entry{
                        .{
                            .buffer_handle = vertex_buffer,
                            .attributes = &[_]VertexLayoutDesc.Entry.Attribute{
                                .{ .format = .f32x3 },
                                .{ .format = .f32x2 },
                            },
                            .offset = 0,
                        },
                    },
                });

                pipeline_resources.textured_tris = .{
                    .program = try backend.createTexturedVertsShader(),
                    .vertex_buffer = vertex_buffer,
                    .vertex_layout = vertex_layout,
                    .rasteriser_state = try backend.createRasteriserState(),
                    .blend_state = try backend.createBlendState(),
                    .constant_buffer = try backend.createConstantBuffer(0x1000),
                };
            }
        }

        pub fn deinit() void {
            backend.deinit();
        }

        pub fn beginDrawing(allocator: std.mem.Allocator) !DrawList {
            return DrawList{
                .entries = std.ArrayList(DrawList.Entry).init(allocator),
            };
        }

        pub fn submitDrawList(draw_list: DrawList) !void {
            var model = zmath.identity();
            var view = zmath.identity();
            var projection = zmath.identity();

            var uniform_colour_vert_cur: u32 = 0;
            var textured_vert_cur: u32 = 0;

            for (draw_list.entries.items) |entry| {
                switch (entry) {
                    .set_viewport => |viewport| {
                        backend.setViewport(viewport.x, viewport.y, viewport.width, viewport.height);
                    },
                    .clear_viewport => |colour| {
                        backend.clearWithColour(colour.r, colour.g, colour.b, colour.a);
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
                    .uniform_colour_verts => |desc| {
                        const resources = pipeline_resources.uniform_colour_tris;

                        //TODO(hazeycode): cache hashes of written ranges
                        _ = try backend.writeBytesToVertexBuffer(
                            resources.vertex_buffer,
                            uniform_colour_vert_cur * @sizeOf(VertexPosition),
                            std.mem.sliceAsBytes(desc.vertices),
                        );

                        backend.setShaderProgram(resources.program);

                        backend.setVertexLayout(resources.vertex_layout);

                        backend.setRasteriserState(resources.rasteriser_state);

                        backend.setBlendState(resources.blend_state);

                        // update shaders constants
                        const constants = ShaderConstants{
                            .mvp = zmath.mul(zmath.mul(model, view), projection),
                            .colour = desc.colour,
                        };
                        try backend.updateShaderConstantBuffer(resources.constant_buffer, std.mem.asBytes(&constants));

                        backend.setConstantBuffer(resources.constant_buffer);

                        backend.draw(uniform_colour_vert_cur, @intCast(u32, desc.vertices.len));

                        uniform_colour_vert_cur += @intCast(u32, desc.vertices.len);
                    },
                    .textured_verts => |desc| {
                        const resources = pipeline_resources.textured_tris;

                        //TODO(hazeycode): cache hashes of written ranges
                        _ = try backend.writeBytesToVertexBuffer(
                            resources.vertex_buffer,
                            textured_vert_cur * @sizeOf(TexturedVertex),
                            std.mem.sliceAsBytes(desc.vertices),
                        );

                        backend.setShaderProgram(resources.program);

                        backend.setVertexLayout(resources.vertex_layout);

                        backend.setTexture(0, desc.texture.handle);

                        backend.setRasteriserState(resources.rasteriser_state);

                        backend.setBlendState(resources.blend_state);

                        // update shaders constants
                        const constants = ShaderConstants{
                            .mvp = zmath.mul(zmath.mul(model, view), projection),
                            .colour = Colour.white,
                        };
                        try backend.updateShaderConstantBuffer(resources.constant_buffer, std.mem.asBytes(&constants));

                        backend.setConstantBuffer(resources.constant_buffer);

                        backend.draw(textured_vert_cur, @intCast(u32, desc.vertices.len));

                        textured_vert_cur += @intCast(u32, desc.vertices.len);
                    },
                }
            }

            if (builtin.mode == .Debug) {
                try backend.logDebugMessages();
            }
        }

        pub const DebugGUI = struct {
            allocator: std.mem.Allocator,
            draw_list: *DrawList,
            canvas_width: f32,
            canvas_height: f32,
            cur_x: f32,
            cur_y: f32,
            text_verts: std.ArrayList(TexturedVertex),
            uniform_colour_verts: std.ArrayList(VertexPosition),
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
            };

            pub fn begin(
                allocator: std.mem.Allocator,
                draw_list: *DrawList,
                canvas_width: f32,
                canvas_height: f32,
                state: *State,
            ) !DebugGUI {
                const projection = orthographic(canvas_width, canvas_height, 0, 1);
                try draw_list.setProjectionTransform(projection);

                const view = zmath.mul(
                    zmath.translation(-canvas_width / 2, -canvas_height / 2, 0),
                    zmath.scaling(1, -1, 1),
                );
                try draw_list.setViewTransform(view);

                return DebugGUI{
                    .allocator = allocator,
                    .draw_list = draw_list,
                    .canvas_width = canvas_width,
                    .canvas_height = canvas_height,
                    .cur_x = @intToFloat(f32, inset),
                    .cur_y = @intToFloat(f32, inset),
                    .text_verts = std.ArrayList(TexturedVertex).init(allocator),
                    .uniform_colour_verts = std.ArrayList(VertexPosition).init(allocator),
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
                    if (v[0] > rect.max_x) rect.max_x = v[0];
                    if (v[1] > rect.max_y) rect.max_y = v[0];
                }
                rect.max_x += @intToFloat(f32, inset);
                rect.max_y += @intToFloat(f32, inset);

                // draw background
                try self.drawColourRect(Colour.fromRGBA(0.13, 0.13, 0.13, 0.67), rect);

                // draw all text
                try self.draw_list.drawTexturedVerts(debugfont_texture, self.text_verts.items);

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

                const bounding_rect = try drawText(self.cur_x, self.cur_y, string, &self.text_verts);

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
                        const line = 0;
                        const column = std.math.max(
                            0,
                            @intCast(
                                u32,
                                std.math.min(
                                    string.len,
                                    @divFloor(
                                        @floatToInt(i32, input.mouse_x - text_rect.min_x + @as(f32, glyph_width) / 2),
                                        glyph_width,
                                    ),
                                ),
                            ),
                        );
                        self.state.text_cur_x = text_rect.min_x + @intToFloat(f32, column * glyph_width);
                        self.state.text_cur_y = text_rect.min_y + @intToFloat(f32, line * (glyph_height + line_spacing));
                    }

                    if (input.mouse_btn_was_released) {
                        self.state.active_id = 0;
                    }
                }
                else if (id == self.state.hover_id) {
                    if (input.mouse_btn_was_pressed) {
                        if (mouse_over) {
                            self.state.active_id = id;
                            self.state.keyboard_focus = id;
                        }
                        else {
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
                var verts = try self.allocator.alloc(VertexPosition, 6);
                errdefer self.allocator.free(verts);

                std.mem.copy(VertexPosition, verts, &rect.vertices());

                try self.draw_list.drawUniformColourVerts(colour, verts);
            }

            fn drawColourRectOutline(self: *DebugGUI, colour: Colour, rect: Rect, weight: f32) !void {
                const num_verts = 6;
                const num_sides = 4;

                var verts = try self.allocator.alloc(VertexPosition, num_verts * num_sides);
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
                        VertexPosition,
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
                        VertexPosition,
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
                        VertexPosition,
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
                        VertexPosition,
                        verts[offset..(offset + num_verts)],
                        &side_rect.vertices(),
                    );
                }

                try self.draw_list.drawUniformColourVerts(colour, verts);
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
