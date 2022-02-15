const std = @import("std");
const core = @import("core");

pub fn usingAPI(comptime api: core.GraphicsAPI) type {
    return struct {
        pub const backend = switch (api) {
            .opengl => @import("opengl.zig"),
            .metal => @import("metal.zig"),
            .d3d11 => @import("d3d11.zig"),
        };

        const types = @import("types.zig");
        pub const ShaderProgramHandle = types.ShaderProgramHandle;
        pub const ConstantBufferHandle = types.ConstantBufferHandle;
        pub const VertexBufferHandle = types.VertexBufferHandle;
        pub const VertexLayoutHandle = types.VertexLayoutHandle;
        pub const RasteriserStateHandle = types.RasteriserStateHandle;
        pub const BlendStateHandle = types.BlendStateHandle;
        pub const TextureHandle = types.TextureHandle;
        pub const SamplerStateHandle = types.SamplerStateHandle;
        pub const VertexLayoutDesc = types.VertexLayoutDesc;

        pub const VertexPosition = [3]f32;
        pub const VertexIndex = u16;
        pub const VertexUV = [2]f32;

        pub const TexturedVertex = extern struct {
            pos: VertexPosition,
            uv: VertexUV,
        };

        const PipelineResources = struct {
            program: ShaderProgramHandle,
            vertex_buffer: VertexBufferHandle,
            vertex_layout: VertexLayoutHandle,
            rasteriser_state: RasteriserStateHandle,
            blend_state: BlendStateHandle,
            constant_buffer: ConstantBufferHandle = 0,
        };

        var pipeline_resources: struct {
            uniform_colour_tris: PipelineResources,
            textured_tris: PipelineResources,
        } = undefined;

        var debugfont_texture: Texture2d = undefined;

        pub fn init(allocator: std.mem.Allocator) !void {
            backend.init(allocator);

            debugfont_texture = try Texture2d.fromPBM(allocator, @embedFile("data/debugfont.pbm"));

            {
                const zeros = [_]u8{0} ** (@sizeOf(f32) * 1e3);
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
                const zeros = [_]u8{0} ** (@sizeOf(f32) * 1e3);
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
                    .uniform_colour_verts => |desc| {
                        const resources = pipeline_resources.uniform_colour_tris;

                        //TODO(hazeycode): cache constant buffer binding state
                        backend.bindConstantBuffer(
                            0,
                            resources.constant_buffer,
                            0,
                            @sizeOf(Colour),
                        );

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

                        { // update colour constant
                            var buf: [@sizeOf(Colour)]u8 = undefined;
                            const src_ptr = @ptrCast([*]const f32, &desc.colour);
                            const src = std.mem.sliceAsBytes(src_ptr[0 .. @sizeOf(Colour) / @sizeOf(f32)]);
                            std.mem.copy(u8, buf[0..], src[0..]);
                            try backend.writeShaderConstant(resources.constant_buffer, 0, &buf);
                        }

                        backend.setConstantBuffer(resources.constant_buffer);

                        backend.draw(uniform_colour_vert_cur, @intCast(u32, desc.vertices.len));

                        uniform_colour_vert_cur += @intCast(u32, desc.vertices.len);
                    },
                    .textured_verts => |desc| {
                        _ = textured_vert_cur;
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

                        backend.draw(textured_vert_cur, @intCast(u32, desc.vertices.len));

                        textured_vert_cur += @intCast(u32, desc.vertices.len);
                    },
                }
            }
        }

        pub const DrawList = struct {
            pub const Entry = union(enum) {
                set_viewport: struct { x: u16, y: u16, width: u16, height: u16 },
                clear_viewport: Colour,
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
            /// Modified version of HSV TO RGB from here: https://www.tlbx.app/color-converter
            pub fn fromHSV(h: f32, s: f32, v: f32) Colour {
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

            pub fn vertices(self: Rect) [6]VertexPosition {
                return [_]VertexPosition{
                    VertexPosition{ self.min_x, self.min_y, 0.0 },
                    VertexPosition{ self.min_x, self.max_y, 0.0 },
                    VertexPosition{ self.max_x, self.max_y, 0.0 },
                    VertexPosition{ self.max_x, self.max_y, 0.0 },
                    VertexPosition{ self.max_x, self.min_y, 0.0 },
                    VertexPosition{ self.min_x, self.min_y, 0.0 },
                };
            }

            pub fn texturedVertices(self: Rect, uv_rect: Rect) [6]TexturedVertex {
                return [_]TexturedVertex{
                    TexturedVertex{ .pos = .{ self.min_x, self.min_y, 0.0 }, .uv = .{ uv_rect.min_x, uv_rect.min_y } },
                    TexturedVertex{ .pos = .{ self.min_x, self.max_y, 0.0 }, .uv = .{ uv_rect.min_x, uv_rect.max_y } },
                    TexturedVertex{ .pos = .{ self.max_x, self.max_y, 0.0 }, .uv = .{ uv_rect.max_x, uv_rect.max_y } },
                    TexturedVertex{ .pos = .{ self.max_x, self.max_y, 0.0 }, .uv = .{ uv_rect.max_x, uv_rect.max_y } },
                    TexturedVertex{ .pos = .{ self.max_x, self.min_y, 0.0 }, .uv = .{ uv_rect.max_x, uv_rect.min_y } },
                    TexturedVertex{ .pos = .{ self.min_x, self.min_y, 0.0 }, .uv = .{ uv_rect.min_x, uv_rect.min_y } },
                };
            }
        };

        pub const Texture2d = extern struct {
            handle: types.TextureHandle,
            format: types.TextureFormat,
            width: u32,
            height: u32,

            pub fn fromPBM(allocator: std.mem.Allocator, pbm_bytes: []const u8) !Texture2d {
                return try pbm.parse(allocator, pbm_bytes);
            }
        };

        pub const DebugGUI = struct {
            allocator: std.mem.Allocator,
            draw_list: *DrawList,
            canvas_width: f32,
            canvas_height: f32,

            pub fn begin(allocator: std.mem.Allocator, canvas_width: f32, canvas_height: f32, draw_list: *DrawList) DebugGUI {
                return .{
                    .allocator = allocator,
                    .draw_list = draw_list,
                    .canvas_width = canvas_width,
                    .canvas_height = canvas_height,
                };
            }

            pub fn end(_: *DebugGUI) void {}

            pub fn beginMenu(self: *DebugGUI, _: enum { top, left, bottom, right }) !void {
                const bg_colour = Colour.fromRGBA(0.13, 0.13, 0.13, 1.0);
                const menu_size = 42;
                // const menu_inset = 2;

                const rect = Rect{
                    .min_x = -1,
                    .min_y = 1,
                    .max_x = 1,
                    .max_y = 1 - menu_size / self.canvas_height,
                };

                _ = bg_colour;
                {
                    var verts = try self.allocator.alloc(VertexPosition, 6);
                    errdefer self.allocator.free(verts);

                    std.mem.copy(VertexPosition, verts, &rect.vertices());

                    try self.draw_list.drawUniformColourVerts(bg_colour, verts);
                }

                {
                    const uv_rect = Rect{
                        .min_x = 0,
                        .min_y = 0,
                        .max_x = 1,
                        .max_y = 1,
                    };

                    var verts = try self.allocator.alloc(TexturedVertex, 6);
                    errdefer self.allocator.free(verts);

                    std.mem.copy(TexturedVertex, verts, &rect.texturedVertices(uv_rect));

                    try self.draw_list.drawTexturedVerts(debugfont_texture, verts);
                }
            }

            pub fn endMenu(_: *DebugGUI) void {}

            pub fn label(_: *DebugGUI, fmt: []const u8, args: anytype) void {
                _ = fmt;
                _ = args;
            }
        };

        pub const pbm = struct {
            pub fn parse(allocator: std.mem.Allocator, bytes: []const u8) !Texture2d {
                var parser = Parser{
                    .bytes = bytes,
                    .cur = 0,
                };
                return parser.parse(allocator);
            }

            pub const Parser = struct {
                bytes: []const u8,
                cur: usize,

                fn parse(self: *@This(), allocator: std.mem.Allocator) !Texture2d {
                    var texture_bytes = std.ArrayList(u8).init(allocator);
                    defer texture_bytes.deinit();

                    const magic_number = try self.magicNumber();
                    self.whitespace();
                    const width = self.integer();
                    self.whitespace();
                    const height = self.integer();
                    self.whitespace();
                    switch (magic_number) {
                        .p1 => {
                            const format = types.TextureFormat.uint8;

                            for (self.bytes[self.cur..]) |c| {
                                if (isWhitespace(c)) continue;
                                try texture_bytes.append(switch (c) {
                                    '1' => 255,
                                    else => 0,
                                });
                            }

                            std.debug.assert(texture_bytes.items.len == width * height);

                            const handle = try backend.createTexture2dWithBytes(
                                texture_bytes.items,
                                width,
                                height,
                                format,
                            );

                            return Texture2d{
                                .handle = handle,
                                .format = format,
                                .width = width,
                                .height = height,
                            };
                        },
                        .p4 => return error.Unimplemented,
                    }
                }

                fn magicNumber(self: *@This()) !enum { p1, p4 } {
                    if (self.bytes[self.cur] != 'P') return error.BadFormat;
                    self.cur += 1;
                    defer self.cur += 1;
                    switch (self.bytes[self.cur]) {
                        '1' => return .p1,
                        '4' => return .p4,
                        else => return error.BadFormat,
                    }
                }

                fn whitespace(self: *@This()) void {
                    while (isWhitespace(self.bytes[self.cur])) {
                        self.cur += 1;
                    }
                }

                inline fn isWhitespace(char: u8) bool {
                    const whitespace_chars = "    \n\r";
                    inline for (whitespace_chars) |wsc| if (wsc == char) return true;
                    return false;
                }

                fn integer(self: *@This()) u32 {
                    var res: u32 = 0;
                    for (self.bytes[self.cur..]) |c| {
                        self.cur += 1;
                        if (isWhitespace(c)) break;
                        res = (res << 3) +% (res << 1) +% (c -% '0');
                    }
                    return res;
                }
            };
        };
    };
}

test {
    std.testing.refAllDecls(@This());
}
