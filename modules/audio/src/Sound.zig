const std = @import("std");

const Sound = @This();

pub const Priority = enum { low, high };

ptr: *anyopaque,
vtable: *const VTable,
channels: u16,
priority: Priority,

pub const sampleProto = fn (*anyopaque, u32, []f32) usize;

pub const VTable = struct {
    sample: sampleProto,
};

pub fn init(
    pointer: anytype,
    comptime sample_fn: fn (@TypeOf(pointer), u32, []f32) usize,
    channels: u16,
    priority: Priority,
) Sound {
    const Ptr = @TypeOf(pointer);
    const ptr_info = @typeInfo(Ptr);

    std.debug.assert(ptr_info == .Pointer); // Must be a pointer
    std.debug.assert(ptr_info.Pointer.size == .One); // Must be a single-item pointer

    const alignment = ptr_info.Pointer.alignment;

    const gen = struct {
        fn sampleImpl(ptr: *anyopaque, sample_rate: u32, buffer: []f32) usize {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return @call(
                .{ .modifier = .always_inline },
                sample_fn,
                .{ self, sample_rate, buffer },
            );
        }

        const vtable = VTable{
            .sample = sampleImpl,
        };
    };

    return .{
        .ptr = pointer,
        .vtable = &gen.vtable,
        .channels = channels,
        .priority = priority,
    };
}

pub inline fn sample(self: Sound, sample_rate: u32, buffer: []f32) usize {
    return self.vtable.sample(self.ptr, sample_rate, buffer);
}
