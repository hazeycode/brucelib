const std = @import("std");

pub const ShaderProgramHandle = u64;
pub const ConstantBufferHandle = u64;
pub const VertexBufferHandle = u64;
pub const VertexLayoutHandle = u64;
pub const RasteriserStateHandle = u64;
pub const BlendStateHandle = u64;
pub const TextureHandle = u64;
pub const SamplerStateHandle = u64;

pub const VertexLayoutDesc = struct {
    entries: []Entry,

    pub const Entry = struct {
        buffer_handle: VertexBufferHandle,
        attributes: []const Attribute,
        offset: u32,

        /// Returns the stride of the entry, where attributes are assumed to be
        /// tightly packed
        pub fn getStride(self: @This()) u32 {
            var res: u32 = 0;
            for (self.attributes) |attr| {
                res += attr.getSize();
            }
            return res;
        }

        pub const Attribute = struct {
            format: enum {
                f32x2,
                f32x3,
                f32x4,
            },

            pub inline fn getNumComponents(self: @This()) u32 {
                return switch (self.format) {
                    .f32x2 => 2,
                    .f32x3 => 3,
                    .f32x4 => 4,
                };
            }

            pub inline fn getSize(self: @This()) u32 {
                return switch (self.format) {
                    .f32x2, .f32x3, .f32x4 => @intCast(u32, @sizeOf(f32)) * self.getNumComponents(),
                };
            }
        };
    };
};

pub const TextureFormat = enum(u16) {
    uint8,
};

pub const VertexPosition = [3]f32;
pub const VertexIndex = u16;
pub const VertexUV = [2]f32;

pub const TexturedVertex = extern struct {
    pos: VertexPosition,
    uv: VertexUV,
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
