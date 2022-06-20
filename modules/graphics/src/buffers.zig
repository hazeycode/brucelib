const std = @import("std");

const common = @import("common.zig");
const BufferHandle = common.BufferHandle;

pub fn using_backend(comptime Backend: type) type {
    return struct {
        
        pub fn VertexBufferStatic(comptime vertex_type: type) type {
            return struct {
                pub const VertexType: type = vertex_type;
                
                handle: BufferHandle,
                
                pub fn init(vertices: []VertexType) !@This() {
                    return @This(){
                        .handle = try Backend.create_vertex_buffer_with_bytes(std.mem.sliceAsBytes(vertices)),
                    };
                }
                
                pub fn deinit(self: *@This()) void {
                    Backend.destroy_vertex_buffer(self.handle);
                    self.handle = 0;
                }
            };
        }

        pub fn VertexBufferDynamic(comptime vertex_type: type) type {
            return struct {
                pub const VertexType: type = vertex_type;

                handle: BufferHandle,
                capacity: u32,
                write_cursor: u32,
                mapped: []VertexType,

                pub fn init(capacity: u32) !@This() {
                    const size = capacity * @sizeOf(VertexType);
                    const handle = try Backend.create_vertex_buffer_persistent(size);
                    const bytes = try Backend.map_buffer_persistent(handle, size, @alignOf(VertexType));
                    return @This(){
                        .handle = handle,
                        .capacity = capacity,
                        .write_cursor = 0,
                        .mapped = std.mem.bytesAsSlice(VertexType, bytes),
                    };
                }

                pub fn deinit(self: *@This()) void {
                    Backend.unmap_buffer(self.handle);
                    Backend.destroy_vertex_buffer(self.handle);
                    self.handle = 0;
                    self.capacity = 0;
                    self.write_cursor = 0;
                    self.mapped = .{};
                }

                /// Pushes vertices into the ring buffer at the write cursor and moves the cursor forward
                /// Returns the offset in the buffer of the first vertex that was written
                pub fn push(self: *@This(), vertices: []const VertexType) u32 {
                    std.debug.assert(vertices.len <= self.mapped.len);

                    const remaining = self.mapped.len - self.write_cursor;
                    if (remaining < vertices.len) {
                        self.write_cursor = 0;
                    }

                    const position = self.write_cursor;

                    std.mem.copy( // TODO(hazeycode): investigate/profile 16-byte aligned mem copy
                        VertexType,
                        self.mapped[self.write_cursor..],
                        vertices[0..],
                    );

                    self.write_cursor += @intCast(u32, vertices.len);

                    return position;
                }
            };
        }
    };
}
