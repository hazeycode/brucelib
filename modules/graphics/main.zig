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
        pub const VertexLayoutDesc = types.VertexLayoutDesc;
        pub const TextureHandle = types.TextureHandle;

        pub const VertexPosition = [3]f32;
        pub const VertexIndex = u16;
        pub const VertexUV = [2]f32;

        pub const TexturedVertex = extern struct {
            pos: VertexPosition,
            uv: VertexUV,
        };

        pub const DrawList = struct {
            pub const Entry = union(enum) {
                set_viewport: struct { x: u16, y: u16, width: u16, height: u16 },
                clear_viewport: Colour,
                tris_solid_colour: struct {
                    colour: Colour,
                    vertices: []const VertexPosition,
                },
                tris_textured: struct {
                    texture: TextureHandle,
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

            pub fn drawVerts(self: *@This(), colour: Colour, verts: []const VertexPosition) !void {
                try self.entries.append(.{ .tris_solid_colour = .{
                    .colour = colour,
                    .vertices = verts,
                } });
            }

            pub fn drawTriangles(self: *@This(), colour: Colour, triangles: []const [3]VertexPosition) !void {
                try self.entries.append(.{ .tris_solid_colour = .{
                    .colour = colour,
                    .vertices = std.mem.bytesAsSlice(VertexPosition, std.mem.sliceAsBytes(triangles)),
                } });
            }

            pub fn drawTexturedTriangles(_: *@This(), _: Texture, _: []const Rect) !void {}
        };

        pub const Texture = extern struct {
            handle: types.TextureHandle,
            width: u32,
            height: u32,
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
                const bg_colour = Colour.fromRGBA(0.2, 0.2, 0.2, 0.3);
                const menu_size = 42;

                const rect = Rect{
                    .min_x = -1,
                    .min_y = 1,
                    .max_x = 1,
                    .max_y = 1 - menu_size / self.canvas_height,
                };

                const verts = try self.allocator.alloc(VertexPosition, 6);
                errdefer self.allocator.free(verts);

                std.mem.copy(VertexPosition, verts, &rect.vertices());

                try self.draw_list.drawVerts(bg_colour, verts);
            }

            pub fn endMenu(_: *DebugGUI) void {}

            pub fn label(_: *DebugGUI, fmt: []const u8, args: anytype) void {
                _ = fmt;
                _ = args;
            }
        };

        pub fn init(allocator: std.mem.Allocator) !void {
            backend.init(allocator);

            _solid_colour_shader = try backend.createSolidColourShader();

            _constant_buffer = try backend.createConstantBuffer(0x1000);

            _rasteriser_state = try backend.createRasteriserState();

            const zeros = [_]u8{0} ** _vertex_buffer_size;
            _vertex_buffer = try backend.createDynamicVertexBufferWithBytes(&zeros);
            _vertex_layout = try backend.createVertexLayout(.{
                .entries = &[_]VertexLayoutDesc.Entry{
                    .{
                        .buffer_handle = _vertex_buffer,
                        .attributes = &[_]VertexLayoutDesc.Entry.Attribute{
                            .{ .format = .f32x3 },
                        },
                        .offset = 0,
                    },
                },
            });
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
            // TODO(hazeycode): sort draw list to minimise pipeline state changes
            var vert_cur: u32 = 0;
            for (draw_list.entries.items) |entry| {
                switch (entry) {
                    .set_viewport => |viewport| {
                        backend.setViewport(viewport.x, viewport.y, viewport.width, viewport.height);
                    },
                    .clear_viewport => |colour| {
                        backend.clearWithColour(colour.r, colour.g, colour.b, colour.a);
                    },
                    .tris_solid_colour => |desc| {
                        //TODO(hazeycode): cache constant buffer binding state
                        backend.bindConstantBuffer(0, _constant_buffer, 0, @sizeOf(Colour));

                        //TODO(hazeycode): cache hashes of written ranges
                        _ = try backend.writeBytesToVertexBuffer(
                            _vertex_buffer,
                            vert_cur * @sizeOf(VertexPosition),
                            std.mem.sliceAsBytes(desc.vertices),
                        );

                        backend.useShaderProgram(_solid_colour_shader);
                        backend.useRasteriserState(_rasteriser_state);
                        backend.useVertexLayout(_vertex_layout);

                        { // update colour constant
                            var buf: [@sizeOf(Colour)]u8 = undefined;
                            const src_ptr = @ptrCast([*]const f32, &desc.colour);
                            const src = std.mem.sliceAsBytes(src_ptr[0 .. @sizeOf(Colour) / @sizeOf(f32)]);
                            std.mem.copy(u8, buf[0..], src[0..]);
                            try backend.writeShaderConstant(_constant_buffer, 0, &buf);
                        }

                        backend.useConstantBuffer(_constant_buffer);

                        backend.draw(vert_cur, @intCast(u32, desc.vertices.len));

                        vert_cur += @intCast(u32, desc.vertices.len);
                    },
                    .tris_textured => |_| {},
                }
            }
        }

        // temporary private stuff to get something going
        // TODO(hazeycode): support for multiple vertex buffers (or slices into a single one) with caching
        var _vertex_buffer: VertexBufferHandle = undefined;
        var _vertex_layout: VertexLayoutHandle = undefined;
        const _vertex_buffer_size = @sizeOf(f32) * 1e3;
        var _rasteriser_state: RasteriserStateHandle = undefined;
        var _constant_buffer: ConstantBufferHandle = undefined;
        var _solid_colour_shader: ShaderProgramHandle = undefined;
        var _draw_colour: Colour = undefined;
    };
}

test {
    std.testing.refAllDecls(@This());
}
