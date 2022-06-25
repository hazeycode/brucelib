const std = @import("std");

const log = std.log.scoped(.@"graphics.buffers");

const common = @import("common.zig");
const BufferHandle = common.BufferHandle;
const FenceHandle = common.FenceHandle;

pub const Config = struct {
    Backend: type,
    Profiler: type = @import("NullProfiler.zig"),
    profile_marker_colour: u32 = 0x00_00_AA_AA,
};

pub fn using(comptime config: Config) type {
    const Backend = config.Backend;
    const Profiler = config.Profiler;

    return struct {
        /// Use this kind of vertex buffer for vertex data that doesn't change
        pub fn VertexBufferStatic(comptime vertex_type: type) type {
            return struct {
                pub const VertexType: type = vertex_type;

                staging: std.ArrayList(VertexType),
                handle: BufferHandle,

                pub fn init(allocator: std.mem.Allocator) @This() {
                    return @This(){
                        .staging = std.ArrayList(VertexType).init(allocator),
                        .handle = undefined,
                    };
                }

                pub fn deinit(self: *@This()) void {
                    Backend.destroy_buffer(self.handle);
                    self.handle = 0;
                }

                pub fn stage(self: *@This(), vertices: []VertexType) !usize {
                    const offset = self.staging.items.len;
                    try self.staging.appendSlice(vertices);
                    return offset;
                }

                pub fn commit(self: *@This()) !void {
                    const trace_zone = Profiler.zone_name_colour(
                        @src(),
                        "graphics.VertexBufferStatic.commit",
                        config.profile_marker_colour,
                    );
                    defer trace_zone.End();
                    self.handle = try Backend.create_vertex_buffer_with_bytes(
                        std.mem.sliceAsBytes(self.staging.items),
                    );
                }
            };
        }

        /// A persistently mapped vertex ring-buffer
        /// Use this kind of vertex buffer for vertex data that changes frequently
        /// Has fallbacks for backends that do not support persistently mapped buffers
        pub fn VertexBufferDynamic(comptime vertex_type: type) type {
            return if (Backend.supports_persistently_mapped_buffers) struct {
                pub const VertexType: type = vertex_type;

                handle: BufferHandle,
                capacity: u32,
                write_cursor: u32,
                mapped: []VertexType,
                maybe_fence: ?FenceHandle,

                pub fn init(capacity: u32) !@This() {
                    const trace_zone = Profiler.zone_name_colour(
                        @src(),
                        "graphics.VertexBufferDynamic.init",
                        config.profile_marker_colour,
                    );
                    defer trace_zone.End();

                    const size = capacity * @sizeOf(VertexType);
                    const handle = try Backend.create_vertex_buffer_persistent(size);
                    const bytes = try Backend.map_buffer_persistent(handle, size, @alignOf(VertexType));
                    return @This(){
                        .handle = handle,
                        .capacity = capacity,
                        .write_cursor = 0,
                        .mapped = std.mem.bytesAsSlice(VertexType, bytes),
                        .maybe_fence = null,
                    };
                }

                pub fn deinit(self: *@This()) void {
                    Backend.unmap_buffer(self.handle);
                    Backend.destroy_buffer(self.handle);
                    self.handle = 0;
                    self.capacity = 0;
                    self.write_cursor = 0;
                    self.mapped = &.{};
                }

                /// Pushes vertices into the ring buffer at the write cursor and moves the cursor forward
                /// Returns the offset in the buffer of the first vertex that was written
                pub fn push(self: *@This(), vertices: []const VertexType) !u32 {
                    const trace_zone = Profiler.zone_name_colour(
                        @src(),
                        "graphics.VertexBufferDynamic.push",
                        config.profile_marker_colour,
                    );
                    defer trace_zone.End();

                    std.debug.assert(vertices.len <= self.mapped.len);

                    if (self.maybe_fence) |fence| {
                        _ = try Backend.wait_fence(fence, 0);
                    }

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

                    self.maybe_fence = Backend.fence();

                    return position;
                }
            } else struct {
                pub const VertexType: type = vertex_type;

                handle: BufferHandle,
                capacity: u32,
                write_cursor: u32,

                pub fn init(capacity: u32) !@This() {
                    log.debug("Persistently mapped buffers not supported by backend; using fallback", .{});

                    const trace_zone = Profiler.zone_name_colour(
                        @src(),
                        "graphics.VertexBufferDynamic.init",
                        config.profile_marker_colour,
                    );
                    defer trace_zone.End();

                    const size = capacity * @sizeOf(VertexType);
                    const handle = try Backend.create_vertex_buffer_dynamic(size);
                    return @This(){
                        .handle = handle,
                        .capacity = capacity,
                        .write_cursor = 0,
                    };
                }

                pub fn deinit(self: *@This()) void {
                    Backend.destroy_buffer(self.handle);
                    self.handle = 0;
                    self.capacity = 0;
                    self.write_cursor = 0;
                }

                /// Pushes vertices into the ring buffer at the write cursor and moves the cursor forward
                /// Returns the offset in the buffer of the first vertex that was written
                pub fn push(self: *@This(), vertices: []const VertexType) !u32 {
                    const trace_zone = Profiler.zone_name_colour(
                        @src(),
                        "graphics.VertexBufferDynamic.push",
                        config.profile_marker_colour,
                    );
                    defer trace_zone.End();

                    var mapped = std.mem.bytesAsSlice(
                        VertexType,
                        try Backend.map_buffer(
                            self.handle,
                            self.capacity * @sizeOf(VertexType),
                            @alignOf(VertexType),
                        ),
                    );
                    defer Backend.unmap_buffer(self.handle);

                    const remaining = mapped.len - self.write_cursor;
                    if (remaining < vertices.len) {
                        self.write_cursor = 0;
                    }

                    const position = self.write_cursor;

                    std.mem.copy( // TODO(hazeycode): investigate/profile 16-byte aligned mem copy
                        VertexType,
                        mapped[self.write_cursor..],
                        vertices[0..],
                    );

                    self.write_cursor += @intCast(u32, vertices.len);

                    return position;
                }
            };
        }
    };
}
