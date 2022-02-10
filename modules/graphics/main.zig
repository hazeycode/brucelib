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

        const pi = std.math.pi;
        const tao = 2 * std.math.pi;

        pub const DrawList = struct {
            pub const Entry = union(enum) {
                set_viewport: struct { x: u16, y: u16, width: u16, height: u16 },
                clear_viewport: Colour,
                draw_verts: struct {
                    colour: Colour,
                    vertices: []const [3]f32,
                },
            };

            entries: std.ArrayList(Entry),

            pub fn setViewport(self: *@This(), x: u16, y: u16, width: u16, height: u16) !void {
                try self.entries.append(.{ .set_viewport = .{ .x = x, .y = y, .width = width, .height = height } });
            }

            pub fn clearViewport(self: *@This(), colour: Colour) !void {
                try self.entries.append(.{ .clear_viewport = colour });
            }

            pub fn drawTriangles(self: *@This(), colour: Colour, vertices: []const [3][3]f32) !void {
                try self.entries.append(.{ .draw_verts = .{
                    .colour = colour,
                    .vertices = std.mem.bytesAsSlice([3]f32, std.mem.sliceAsBytes(vertices)),
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

        pub const Rect = struct {
            min_x: f32,
            min_y: f32,
            max_x: f32,
            max_y: f32,
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
            for (draw_list.entries.items) |entry| {
                switch (entry) {
                    .set_viewport => |viewport| {
                        backend.setViewport(viewport.x, viewport.y, viewport.width, viewport.height);
                    },
                    .clear_viewport => |colour| {
                        backend.clearWithColour(colour.r, colour.g, colour.b, colour.a);
                    },
                    .draw_verts => |e| {
                        //TODO(hazeycode): cache constant buffer binding state
                        backend.bindConstantBuffer(0, _constant_buffer, 0, @sizeOf(Colour));

                        //TODO(hazeycode): only write to buffer if verts have changed
                        try backend.writeBytesToVertexBuffer(_vertex_buffer, std.mem.sliceAsBytes(e.vertices));

                        backend.useShaderProgram(_solid_colour_shader);
                        backend.useRasteriserState(_rasteriser_state);
                        backend.useVertexLayout(_vertex_layout);

                        { // update colour constant
                            var buf: [@sizeOf(Colour)]u8 = undefined;
                            const src = std.mem.sliceAsBytes(@ptrCast([*]const f32, &e.colour)[0 .. @sizeOf(Colour) / @sizeOf(f32)]);
                            std.mem.copy(u8, buf[0..], src[0..]);
                            try backend.writeShaderConstant(_constant_buffer, 0, &buf);
                        }

                        backend.useConstantBuffer(_constant_buffer);

                        backend.draw(0, @intCast(u32, e.vertices.len));
                    },
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
