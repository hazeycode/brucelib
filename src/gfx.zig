const std = @import("std");

pub const api: enum {
    opengl,
} = .opengl;

pub const backend = switch (api) {
    .opengl => @import("gfx/opengl.zig"),
};

const types = @import("gfx/types.zig");
pub const ShaderProgramHandle = types.ShaderProgramHandle;
pub const VertexBufferHandle = types.VertexBufferHandle;
pub const VertexLayoutDesc = types.VertexLayoutDesc;
pub const VertexLayoutHandle = types.VertexLayoutHandle;

pub const Colour = packed struct {
    r: f32,
    g: f32,
    b: f32,
    a: f32,

    pub fn make(r: f32, g: f32, b: f32, a: f32) Colour {
        return .{ .r = r, .g = g, .b = b, .a = a };
    }

    pub const black = make(0, 0, 0, 1);
    pub const white = make(1, 1, 1, 1);
    pub const red = make(1, 0, 0, 1);
    pub const orange = make(1, 0.5, 0, 1);
};

pub const Rect = struct {
    min_x: f32,
    min_y: f32,
    max_x: f32,
    max_y: f32,
};

// TODO(chris): support for multiple vertex buffers (or slices into a single one) with caching
var _initilised: bool = false;
var _vertex_buffer: VertexBufferHandle = undefined;
var _vertex_layout: VertexLayoutHandle = undefined;
const _vertex_buffer_size = @sizeOf(f32) * 1e3;
var _default_shader_program: ShaderProgramHandle = undefined;

pub const DrawList = struct {
    pub const Entry = union(enum) {
        set_viewport: struct { x: u16, y: u16, width: u16, height: u16 },
        clear_viewport: Colour,
        set_draw_colour: Colour,
        draw_triangles: []const [3][3]f32,
        draw_quads: []const Rect,
    };

    entries: std.ArrayList(Entry),

    pub fn setViewport(self: *@This(), x: u16, y: u16, width: u16, height: u16) !void {
        try self.entries.append(.{ .set_viewport = .{ .x = x, .y = y, .width = width, .height = height } });
    }

    pub fn clearViewport(self: *@This(), colour: Colour) !void {
        try self.entries.append(.{ .clear_viewport = colour });
    }

    pub fn setDrawColour(self: *@This(), colour: Colour) !void {
        try self.entries.append(.{ .set_draw_colour = colour });
    }

    pub fn drawTriangles(self: *@This(), vertices: []const [3][3]f32) !void {
        try self.entries.append(.{ .draw_triangles = vertices });
    }

    pub fn drawQuads(self: *@This(), rects: []const Rect) !void {
        try self.entries.append(.{ .draw_triangles = rects });
    }
};

pub fn beginDrawing(allocator: std.mem.Allocator) !DrawList {
    if (_initilised == false) {
        _default_shader_program = try backend.createDefaultShaderProgram(allocator);

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
            .set_draw_colour => |_| {
                // TODO
            },
            .draw_triangles => |vertices| {
                // TODO(chris): only write to buffer if verts have changed
                backend.writeBytesToVertexBuffer(_vertex_buffer, std.mem.sliceAsBytes(vertices));
                backend.bindShaderProgram(_default_shader_program);
                backend.bindVertexLayout(_vertex_layout);
                backend.draw(0, 3);
            },
            .draw_quads => |_| {
                // TODO
            },
        }
    }
}
