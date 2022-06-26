const std = @import("std");

/// A simple, generic, "lockfree" Single-Producer-Single-Consumer ring buffer backed by a statically-sized buffer
pub fn RingBufferStatic(comptime ItemType: type, comptime capacity: usize) type {
    return struct {
        buffer: [capacity]ItemType = .{undefined} ** capacity,
        read_cursor: usize = 0,
        write_cursor: usize = 0,
        count: std.atomic.Atomic(usize) = std.atomic.Atomic(usize).init(0),

        /// Called by the publisher. Pushes an item into the buffer at the write cursor. Returns an error if the buffer is full.
        pub fn push(self: *@This(), item: ItemType) !void {
            var count = self.count.load(.Monotonic);
            if (count + 1 >= self.buffer.len) return error.BufferFull;
            self.buffer[self.write_cursor] = item;
            self.write_cursor += 1;
            if (self.write_cursor >= self.buffer.len) self.write_cursor = 0;
            count = self.count.load(.Acquire);
            while (self.count.tryCompareAndSwap(count, count + 1, .Release, .Monotonic)) |new_val| {
                count = new_val;
            }
        }

        /// Called by the consumer. Copies the entire content of the buffer from the read cursor, emptying the ring buffer
        /// Returns a slice to the copied items, the caller is responsible for referenced memory
        pub fn drain(self: *@This(), allocator: std.mem.Allocator) ![]ItemType {
            var count = self.count.load(.Monotonic);
            var copy = try allocator.alloc(ItemType, count);
            var copied: usize = 0;
            while (copied < count) {
                const remaining = count - copied;
                const items = self.buffer[self.read_cursor..];
                const max = std.math.min(items.len, remaining);
                std.mem.copy(ItemType, copy[copied..], items[0..max]);
                self.read_cursor = (self.read_cursor + 1) % self.buffer.len;
                copied += max;
            }
            count = self.count.load(.Acquire);
            while (self.count.tryCompareAndSwap(
                count,
                count - copied,
                .Release,
                .Monotonic,
            )) |new_val| {
                count = new_val;
            }
            return copy;
        }
    };
}
