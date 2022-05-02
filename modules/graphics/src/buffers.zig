const std = @import("std");

const common = @import("common.zig");
const VertexBufferHandle = common.VertexBufferHandle;

pub fn withBackend(comptime backend: anytype) type {
    return struct {
        pub fn VertexBuffer(comptime vertex_type: type) type {
            return struct {
                pub const VertexType: type = vertex_type;

                handle: VertexBufferHandle,
                capacity: u32,
                write_cursor: u32,
                mapped: ?[]VertexType,

                pub fn init(capacity: u32) !@This() {
                    const size = capacity * @sizeOf(VertexType);
                    const handle = try backend.createVertexBuffer(size);
                    return @This(){
                        .handle = handle,
                        .capacity = capacity,
                        .write_cursor = 0,
                        .mapped = null,
                    };
                }

                pub fn deinit(self: @This()) void {
                    if (self.mapped != null) self.unmap();
                    backend.destroyVertexBuffer(self.handle);
                }

                pub fn map(self: *@This()) !void {
                    std.debug.assert(self.mapped == null);

                    const size = self.capacity * @sizeOf(VertexType);
                    const bytes = try backend.mapBuffer(
                        self.handle,
                        0,
                        size,
                        @alignOf(VertexType),
                    );
                    self.mapped = std.mem.bytesAsSlice(VertexType, bytes);
                }

                pub fn unmap(self: *@This()) void {
                    std.debug.assert(self.mapped != null);

                    backend.unmapBuffer(self.handle);
                    self.mapped = null;
                }

                /// Writes vertices at the write cursor and moves the cursor forward
                /// Returns the offset in the buffer of the first vertex that was written
                pub fn append(self: *@This(), vertices: []const VertexType) u32 {
                    self.overwrite(self.write_cursor, vertices);
                    const position = self.write_cursor;
                    self.write_cursor += @intCast(u32, vertices.len);
                    return position;
                }

                pub fn overwrite(self: *@This(), offset: u32, vertices: []const VertexType) void {
                    std.debug.assert(self.mapped != null);

                    if (self.mapped) |buffer| {
                        const elems = vertices[0..];
                        std.mem.copy(
                            VertexType,
                            buffer[offset..(offset + elems.len)],
                            elems,
                        );
                    } else {
                        std.debug.panic("Unimplemented", .{});
                    }
                }

                pub fn clear(self: *@This(), write_zeros: bool) void {
                    if (write_zeros) {
                        std.debug.assert(self.mapped != null);

                        if (self.mapped) |buffer| {
                            for (buffer) |*v| v.* = std.mem.zeroes(VertexType);
                        } else {
                            std.debug.panic("Unimplemented", .{});
                        }
                    }

                    self.write_cursor = 0;
                }
            };
        }
    };
}
