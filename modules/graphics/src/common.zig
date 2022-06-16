const std = @import("std");

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
                return @intCast(u32, @sizeOf(f32)) * self.getNumComponents();
            }
        };
    };
};

pub const TextureFormat = enum(u16) {
    uint8,
    rgba_u8,
};
