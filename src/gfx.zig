const std = @import("std");

pub const API = enum {
    opengl,
    metal,
};

pub fn Interface(comptime api: API) type {
    return struct {
        pub const backend = switch (api) {
            .opengl => @import("gfx/opengl.zig"),
            .metal => @import("gfx/metal.zig"),
        };

        const types = @import("gfx/types.zig");
        pub const ShaderProgramHandle = types.ShaderProgramHandle;
        pub const VertexBufferHandle = types.VertexBufferHandle;
        pub const VertexLayoutDesc = types.VertexLayoutDesc;
        pub const VertexLayoutHandle = types.VertexLayoutHandle;

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

        pub const Colour = packed struct {
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

            pub fn fromHSV(h: f32, s: f32, v: f32) Colour {
                // TODO(hazeycode): branchless algorithm
                std.debug.assert(h >= 0.0 and h < 360.0);
                const c = s * v;
                const x = c * (1 - @fabs(@mod(h / 60.0, 2) - 1));
                const m = v - c;
                // zig fmt: off
        const rgb =
            if (h >= 0.0 and h < 60.0) [3]f32{ c, x, 0.0 }
            else if (h >= 60 and h < 120) [3]f32{ x, c, 0.0 }
            else if (h >= 120 and h < 180) [3]f32{ 0.0, c, x }
            else if (h >= 180 and h < 240) [3]f32{ 0.0, x, c }
            else if (h >= 240 and h < 300) [3]f32{ x, 0.0, c }
            else [3]f32{ c, 0.0, x };
        // zig fmt: on
                return .{
                    .r = rgb[0] + m,
                    .g = rgb[1] + m,
                    .b = rgb[2] + m,
                    .a = 1.0,
                };
            }
        };

        pub const Rect = struct {
            min_x: f32,
            min_y: f32,
            max_x: f32,
            max_y: f32,
        };

        pub fn beginDrawing(allocator: std.mem.Allocator) !DrawList {
            if (_initilised == false) {
                _solid_colour_shader = try backend.createSolidColourShader(allocator);

                const zeros = [_]u8{0} ** _vertex_buffer_size;
                _vertex_buffer = backend.createDynamicVertexBufferWithBytes(&zeros);
                _vertex_layout = backend.createVertexLayout(.{
                    .attributes = &[_]VertexLayoutDesc.Attribute{
                        .{
                            .buffer_handle = _vertex_buffer,
                            .num_components = 3,
                        },
                    },
                });

                _initilised = true;
            }
            return DrawList{
                .entries = std.ArrayList(DrawList.Entry).init(allocator),
            };
        }

        pub fn submitDrawList(draw_list: DrawList) void {
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
                        // TODO(hazeycode): only write to buffer if verts have changed
                        backend.writeBytesToVertexBuffer(_vertex_buffer, std.mem.sliceAsBytes(e.vertices));
                        backend.bindVertexLayout(_vertex_layout);
                        backend.bindShaderProgram(_solid_colour_shader);
                        backend.writeUniform(0, &.{ e.colour.r, e.colour.g, e.colour.b, e.colour.a });
                        backend.draw(0, e.vertices.len);
                    },
                }
            }
        }

        // temporary private stuff to get something going
        // TODO(hazeycode): support for multiple vertex buffers (or slices into a single one) with caching
        var _initilised: bool = false;
        var _vertex_buffer: VertexBufferHandle = undefined;
        var _vertex_layout: VertexLayoutHandle = undefined;
        const _vertex_buffer_size = @sizeOf(f32) * 1e3;
        var _solid_colour_shader: ShaderProgramHandle = undefined;
        var _draw_colour: Colour = undefined;
    };
}
