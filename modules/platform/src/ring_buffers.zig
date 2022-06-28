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
            if (count + 1 > self.buffer.len) return error.BufferFull;
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
                self.read_cursor = (self.read_cursor + max) % self.buffer.len;
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

const testing = std.testing;
const range = @import("comptime_range.zig").range;

test "RingBufferStatic single-threaded producer-consumer" {
    const capacity = 100;
    var ring = RingBufferStatic(u64, capacity){};
    var counter: u64 = 0;

    try testing.expectEqual(@as(usize, 0), ring.read_cursor);
    try testing.expectEqual(@as(usize, 0), ring.write_cursor);
    try testing.expectEqual(@as(usize, 0), ring.count.load(.Monotonic));

    try ring.push(counter);
    counter += 1;

    try testing.expectEqual(@as(usize, 0), ring.read_cursor);
    try testing.expectEqual(@as(usize, 1), ring.write_cursor);
    try testing.expectEqual(@as(usize, 1), ring.count.load(.Monotonic));

    inline for (range(1, capacity - 1)) |_| {
        try ring.push(counter);
        counter += 1;
    }

    try testing.expectEqual(@as(usize, 0), ring.read_cursor);
    try testing.expectEqual(@as(usize, 0), ring.write_cursor);
    try testing.expectEqual(@as(usize, capacity), ring.count.load(.Monotonic));

    try testing.expectError(error.BufferFull, ring.push(counter));

    try testing.expectEqual(@as(usize, 0), ring.read_cursor);
    try testing.expectEqual(@as(usize, 0), ring.write_cursor);
    try testing.expectEqual(@as(usize, capacity), ring.count.load(.Monotonic));

    const contents = try ring.drain(testing.allocator);
    defer testing.allocator.free(contents);

    try testing.expectEqual(@as(usize, 0), ring.read_cursor);
    try testing.expectEqual(@as(usize, 0), ring.write_cursor);
    try testing.expectEqual(@as(usize, 0), ring.count.load(.Monotonic));

    var expected: [capacity]u64 = undefined;
    for (expected) |*elem, i| elem.* = i;

    try testing.expectEqualSlices(u64, &expected, contents);
}

test "RingBufferStatic async producer" {
    const capacity = 100;
    const RingBuffer = RingBufferStatic(u64, capacity);
    var ring = RingBuffer{};

    const Producer = struct {
        thread: std.Thread,

        pub fn start(ring_buf: *RingBuffer) !@This() {
            return @This(){
                .thread = try std.Thread.spawn(.{}, run, .{ring_buf}),
            };
        }

        pub fn run(ring_buf: *RingBuffer) !void {
            var counter: u64 = 0;
            inline for (range(0, capacity - 1)) |_| {
                while (true) {
                    ring_buf.push(counter) catch continue;
                    break;
                }
                counter += 1;
            }
        }
    };

    var producer = try Producer.start(&ring);

    producer.thread.join();

    try testing.expectEqual(@as(usize, 0), ring.read_cursor);
    try testing.expectEqual(@as(usize, 0), ring.write_cursor);
    try testing.expectEqual(@as(usize, capacity), ring.count.load(.Monotonic));

    const contents = try ring.drain(testing.allocator);
    defer testing.allocator.free(contents);

    try testing.expectEqual(@as(usize, 0), ring.read_cursor);
    try testing.expectEqual(@as(usize, 0), ring.write_cursor);
    try testing.expectEqual(@as(usize, 0), ring.count.load(.Monotonic));

    var expected: [capacity]u64 = undefined;
    for (expected) |*elem, i| elem.* = i;

    try testing.expectEqualSlices(u64, &expected, contents);

    producer = try Producer.start(&ring);

    var i: u64 = 0;
    while (i < capacity) {
        const part = try ring.drain(testing.allocator);
        defer testing.allocator.free(part);

        for (part) |val| {
            try testing.expectEqual(i, val);
            i += 1;
        }
    }
}
