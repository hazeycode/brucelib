const std = @import("std");

pub const zmath = @import("zmath");
pub const F32x4 = zmath.F32x4;
pub const Matrix = zmath.Mat;
pub const identity_matrix = zmath.identity;
pub const orthographic = zmath.orthographicLh;
pub const translation = zmath.translation;
pub const scaling = zmath.scaling;
pub const mul = zmath.mul;

pub const ShaderProgramHandle = u64;
pub const BufferHandle = u64;
pub const VertexLayoutHandle = u64;
pub const RasteriserStateHandle = u64;
pub const BlendStateHandle = u64;
pub const TextureHandle = u64;
pub const SamplerStateHandle = u64;
pub const FenceHandle = u64;

pub const FenceState = enum {
    already_signaled,
    timeout_expired,
    signaled,
};

pub const VertexLayoutDesc = struct {
    entries: []Entry,

    pub const Entry = struct {
        buffer_handle: BufferHandle,
        attributes: []const Attribute,
        offset: u32,

        /// Returns the stride of the entry, where attributes are assumed to be
        /// tightly packed
        pub fn get_stride(self: @This()) u32 {
            var res: u32 = 0;
            for (self.attributes) |attr| {
                res += attr.get_size();
            }
            return res;
        }

        pub const Attribute = struct {
            format: enum {
                f32x2,
                f32x3,
                f32x4,
            },

            pub inline fn get_num_components(self: @This()) u32 {
                return switch (self.format) {
                    .f32x2 => 2,
                    .f32x3 => 3,
                    .f32x4 => 4,
                };
            }

            pub inline fn get_size(self: @This()) u32 {
                return @intCast(u32, @sizeOf(f32)) * self.get_num_components();
            }
        };
    };
};

pub const TextureFormat = enum(u16) {
    uint8,
    rgba_u8,
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

    pub fn get_layout_attributes() []const VertexLayoutDesc.Entry.Attribute {
        return &[_]VertexLayoutDesc.Entry.Attribute{
            .{ .format = .f32x3 },
        };
    }
};

pub const ColouredVertex = extern struct {
    pos: [3]f32,
    rgba: [4]f32,

    pub fn get_layout_attributes() []const VertexLayoutDesc.Entry.Attribute {
        return &[_]VertexLayoutDesc.Entry.Attribute{
            .{ .format = .f32x3 },
            .{ .format = .f32x4 },
        };
    }
};

pub const TexturedVertex = extern struct {
    pos: [3]f32,
    uv: [2]f32,

    pub fn get_layout_attributes() []const VertexLayoutDesc.Entry.Attribute {
        return &[_]VertexLayoutDesc.Entry.Attribute{
            .{ .format = .f32x3 },
            .{ .format = .f32x2 },
        };
    }
};

///
pub const Viewport = struct {
    x: i32,
    y: i32,
    width: u16,
    height: u16,
};

pub const Colour = extern struct {
    r: f32,
    g: f32,
    b: f32,
    a: f32,

    pub const black = from_rgb(0, 0, 0);
    pub const white = from_rgb(1, 1, 1);
    pub const red = from_rgb(1, 0, 0);
    pub const orange = from_rgb(1, 0.5, 0);
    pub const sky_blue = from_rgb(135.0 / 255.0, 206.0 / 255.0, 235 / 255.0);

    pub fn from_rgb(r: f32, g: f32, b: f32) Colour {
        return .{ .r = r, .g = g, .b = b, .a = 1 };
    }

    pub fn from_rgba(r: f32, g: f32, b: f32, a: f32) Colour {
        return .{ .r = r, .g = g, .b = b, .a = a };
    }

    /// Returns a Colour for a given hue, saturation and value
    /// h, s, v are assumed to be in the range 0...1
    pub fn from_hsv(h: f32, s: f32, v: f32) Colour {
        // Modified version of HSV TO RGB from here: https://www.tlbx.app/color-converter
        // TODO(hazeycode): compare performance & codegen of this vs zmath.hsvToRgb
        const hp = (h * 360) / 60;
        const c = v * s;
        const x = c * (1 - @fabs(@mod(hp, 2) - 1));
        const m = v - c;
        if (hp <= 1) {
            return Colour.from_rgb(c + m, x + m, m);
        } else if (hp <= 2) {
            return Colour.from_rgb(x + m, c + m, m);
        } else if (hp <= 3) {
            return Colour.from_rgb(m, c + m, x + m);
        } else if (hp <= 4) {
            return Colour.from_rgb(m, x + m, c + m);
        } else if (hp <= 5) {
            return Colour.from_rgb(x + m, m, c + m);
        } else if (hp <= 6) {
            return Colour.from_rgb(c + m, m, x + m);
        } else {
            std.debug.assert(false);
            return Colour.from_rgb(0, 0, 0);
        }
    }
};

pub const WindingOrder = enum {
    clockwise,
    counter_clockwise,
};

pub const Rect = extern struct {
    min_x: f32,
    min_y: f32,
    max_x: f32,
    max_y: f32,

    pub fn vertices(self: Rect, winding_order: WindingOrder) [6]Vertex {
        const top_left = Vertex{ .pos = .{ self.min_x, self.max_y, 0.0 } };
        const bottom_left = Vertex{ .pos = .{ self.min_x, self.min_y, 0.0 } };
        const bottom_right = Vertex{ .pos = .{ self.max_x, self.min_y, 0.0 } };
        const top_right = Vertex{ .pos = .{ self.max_x, self.max_y, 0.0 } };
        return _vertices(Vertex, winding_order, top_left, bottom_left, bottom_right, top_right);
    }

    pub fn textured_vertices(self: Rect, winding_order: WindingOrder, uv_rect: Rect) [6]TexturedVertex {
        const top_left = TexturedVertex{
            .pos = .{ self.min_x, self.max_y, 0.0 },
            .uv = .{ uv_rect.min_x, uv_rect.min_y },
        };
        const bottom_left = TexturedVertex{
            .pos = .{ self.min_x, self.min_y, 0.0 },
            .uv = .{ uv_rect.min_x, uv_rect.max_y },
        };
        const bottom_right = TexturedVertex{
            .pos = .{ self.max_x, self.min_y, 0.0 },
            .uv = .{ uv_rect.max_x, uv_rect.max_y },
        };
        const top_right = TexturedVertex{
            .pos = .{ self.max_x, self.max_y, 0.0 },
            .uv = .{ uv_rect.max_x, uv_rect.min_y },
        };
        return _vertices(TexturedVertex, winding_order, top_left, bottom_left, bottom_right, top_right);
    }

    pub fn contains_point(self: Rect, x: f32, y: f32) bool {
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

    fn _vertices(
        comptime VertexType: type,
        winding_order: WindingOrder,
        top_left: VertexType,
        bottom_left: VertexType,
        bottom_right: VertexType,
        top_right: VertexType,
    ) [6]VertexType {
        return switch (winding_order) {
            .clockwise => [_]VertexType{
                // top-left triangle
                top_left,  top_right,    bottom_left,
                // bottom-right triangle
                top_right, bottom_right, bottom_left,
            },
            .counter_clockwise => [_]VertexType{
                // top-left triangle
                top_left,  bottom_left, top_right,
                // bottom-right triangle
                top_right, bottom_left, bottom_right,
            },
        };
    }
};
