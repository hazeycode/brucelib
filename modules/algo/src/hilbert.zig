//! Algorithms based on Hilbert curves (https://en.wikipedia.org/wiki/Hilbert_curve)

const std = @import("std");
const testing = std.testing;

const benchmark = @import("bench").benchmark;

pub const Point = [2]u32;

pub fn point_to_d(n: u32, point: Point) u32 {
    var x = point[0];
    var y = point[1];
    var rx = @as(u32, 0);
    var ry = @as(u32, 0);
    var d = @as(u32, 0);
    var s = n / 2;
    while (s > 0) : (s /= 2) {
        rx = (x & y) > 0;
        ry = (y & s) > 0;
        d += s * s * ((3 * rx) ^ ry);
        rotate(n, &x, &y, rx, ry);
    }
    return d;
}

pub fn point_from_d(n: u32, d: u32) Point {
    var x = @as(u32, 0);
    var y = @as(u32, 0);
    var rx = @as(u32, 0);
    var ry = @as(u32, 0);
    const t = d;
    var s = 1;
    while (s < n) : (s *= 2) {
        rx = 1 & (t / 2);
        ry = 1 & (t ^ rx);
        rotate(s, x, y, rx, ry);
        x.* += s * rx;
        y.* += s * ry;
    }
    return .{ x, y };
}

pub fn rotate(n: u32, x: *u32, y: *u32, rx: u32, ry: u32) void {
    if (ry == 0) {
        if (rx == 1) {
            x.* = n - 1 - x.*;
            y.* = n - 1 - y.*;
        }
        // swap
        var temp = x.*;
        x.* = y;
        y.* = temp;
    }
}

/// In-place Hilbert sort a set of points
/// An implementation of the algorithm described in:
/// [Fast Hilbert Sort Algorithm Without Using Hilbert Indices](https://www.researchgate.net/publication/313074453_Fast_Hilbert_Sort_Algorithm_Without_Using_Hilbert_Indices#pf8)
/// Also credit to Mohamed Badawy for clarifying typos in the pseudo code and providing working examples:
/// https://stackoverflow.com/a/66994116/16481771
// TODO(hazeycode): Compare this recursive version to an interative method
// TODO(hazeycode): 3d variant or generalise
pub fn sort_points_2d(args: struct {
    points: []Point,
    start: i32 = 0,
    end: i32,
    order: u32,
    axis_count: u32 = 0,
    axes_start: *u32,
    axis_idx: u32 = 0,
    dir: enum { forward, backward } = .forward,
    acc: u32 = 0,
}) void {
    const n = 2; // number of dimensions

    if (args.end <= args.start) return; // nothing to do for empty or singleton

    const part = partition_2d(
        args.points[0..],
        args.start,
        args.end,
        args.order,
        (args.axis_idx + args.axis_count) % n,
        switch (bit_test(args.axes_start.*, (args.axis_idx + args.axis_count) % n)) {
            true => .descending,
            false => .ascending,
        },
    );

    if (args.axis_count == n - 1) {
        // simulation done, go to next order

        if (args.order == 0) {
            return; // no more order to simulate
        }

        var next_axis_idx = //
            (args.axis_idx + n + n - switch (args.dir) {
            .forward => args.acc + 2,
            .backward => 2,
        }) % n;

        bit_flip(args.axes_start, next_axis_idx);
        bit_flip(args.axes_start, (args.axis_idx + args.axis_count) % n);

        sort_points_2d(.{
            .points = args.points,
            .start = args.start,
            .end = part - 1,
            .order = args.order - 1,
            .axes_start = args.axes_start,
            .axis_idx = next_axis_idx,
        });

        bit_flip(args.axes_start, (args.axis_idx + args.axis_count) % n);
        bit_flip(args.axes_start, next_axis_idx);

        next_axis_idx = //
            (args.axis_idx + n + n - switch (args.dir) {
            .forward => 2,
            .backward => args.acc + 2,
        }) % n;

        sort_points_2d(.{
            .points = args.points,
            .start = part,
            .end = args.end,
            .order = args.order - 1,
            .axes_start = args.axes_start,
            .axis_idx = next_axis_idx,
        });
    } else {
        sort_points_2d(.{
            .points = args.points,
            .start = args.start,
            .end = part - 1,
            .order = args.order,
            .axis_count = args.axis_count + 1,
            .axes_start = args.axes_start,
            .axis_idx = args.axis_idx,
            .acc = switch (args.dir) {
                .forward => args.acc + 1,
                .backward => 1,
            },
        });

        bit_flip(args.axes_start, (args.axis_idx + args.axis_count) % n);
        bit_flip(args.axes_start, (args.axis_idx + args.axis_count + 1) % n);

        sort_points_2d(.{
            .points = args.points,
            .start = part,
            .end = args.end,
            .order = args.order,
            .axis_count = args.axis_count + 1,
            .axes_start = args.axes_start,
            .axis_idx = args.axis_idx,
            .dir = .backward,
            .acc = switch (args.dir) {
                .forward => 1,
                .backward => args.acc + 1,
            },
        });

        bit_flip(args.axes_start, (args.axis_idx + args.axis_count + 1) % n);
        bit_flip(args.axes_start, (args.axis_idx + args.axis_count) % n);
    }
}

/// Binary partition a set of points
fn partition_2d(
    points: []Point,
    start: i32,
    end: i32,
    order: u32,
    axis: u32,
    dir: enum { ascending, descending },
) i32 {
    var i = @intCast(u32, start);
    var j = @intCast(u32, end);
    while (true) {
        while (i < j and
            bit_test(points[i][axis], order) == (dir == .descending))
        {
            i += 1;
        }
        while (i < j and
            bit_test(points[j][axis], order) != (dir == .descending))
        {
            j -= 1;
        }

        if (j <= i) {
            return @intCast(i32, i);
        }

        { // swap
            const temp = points[j];
            points[j] = points[i];
            points[i] = temp;
        }
    }
}

inline fn bit_test(value: u32, pos: u32) bool {
    return (value & (@as(u32, 1) << @intCast(u5, pos)) > 0);
}

inline fn bit_flip(value_ptr: *u32, pos: u32) void {
    value_ptr.* ^= @as(u32, 1) << @intCast(u5, pos);
}

// Tests ====================================================================================================

test "hilbert sort" {
    var points = [_]Point{ .{ 2, 2 }, .{ 2, 4 }, .{ 3, 4 }, .{ 2, 5 }, .{ 3, 5 }, .{ 1, 6 }, .{ 3, 6 }, .{ 5, 6 }, .{ 3, 7 } };

    var axis: u32 = 0;
    sort_points_2d(.{ .points = &points, .end = points.len - 1, .order = 2, .axes_start = &axis });

    try testing.expectEqualSlices(
        Point,
        &.{ .{ 2, 2 }, .{ 1, 6 }, .{ 3, 7 }, .{ 3, 6 }, .{ 3, 5 }, .{ 2, 5 }, .{ 2, 4 }, .{ 3, 4 }, .{ 5, 6 } },
        &points,
    );
}

// Benchmarks ===============================================================================================

fn random_points(allocator: std.mem.Allocator, count: usize) ![]Point {
    var points = try allocator.alloc(Point, count);

    var rng = std.rand.DefaultPrng.init(0);
    for (points) |*p| p.* = .{
        rng.random().int(u32),
        rng.random().int(u32),
    };

    return points;
}

test "benchmark hilbert sort points 2d" {
    var temp_arena = std.heap.ArenaAllocator.init(testing.allocator);
    defer temp_arena.deinit();

    var allocator = temp_arena.allocator();

    try benchmark(&struct {
        data: [20]struct { order: u32, points: []Point },
    }{
        .data = .{
            .{ .order = 1, .points = try random_points(allocator, 64) },
            .{ .order = 1, .points = try random_points(allocator, 256) },
            .{ .order = 1, .points = try random_points(allocator, 1024) },
            .{ .order = 1, .points = try random_points(allocator, 4096) },
            .{ .order = 2, .points = try random_points(allocator, 64) },
            .{ .order = 2, .points = try random_points(allocator, 256) },
            .{ .order = 2, .points = try random_points(allocator, 1024) },
            .{ .order = 2, .points = try random_points(allocator, 4096) },
            .{ .order = 3, .points = try random_points(allocator, 64) },
            .{ .order = 3, .points = try random_points(allocator, 256) },
            .{ .order = 3, .points = try random_points(allocator, 1024) },
            .{ .order = 3, .points = try random_points(allocator, 4096) },
            .{ .order = 4, .points = try random_points(allocator, 64) },
            .{ .order = 4, .points = try random_points(allocator, 256) },
            .{ .order = 4, .points = try random_points(allocator, 1024) },
            .{ .order = 4, .points = try random_points(allocator, 4096) },
            .{ .order = 5, .points = try random_points(allocator, 64) },
            .{ .order = 5, .points = try random_points(allocator, 256) },
            .{ .order = 5, .points = try random_points(allocator, 1024) },
            .{ .order = 5, .points = try random_points(allocator, 4096) },
        },
    }, struct {
        const range = @import("comptime_range.zig").range;
        pub const args = range(0, 19);

        pub const arg_names = [_][]const u8{
            "64 random points, order 1",
            "256 random points, order 1",
            "1024 random points, order 1",
            "4096 random points, order 1",
            "64 random points, order 2",
            "256 random points, order 2",
            "1024 random points, order 2",
            "4096 random points, order 2",
            "64 random points, order 3",
            "256 random points, order 3",
            "1024 random points, order 3",
            "4096 random points, order 3",
            "64 random points, order 4",
            "256 random points, order 4",
            "1024 random points, order 4",
            "4096 random points, order 4",
            "64 random points, order 5",
            "256 random points, order 5",
            "1024 random points, order 5",
            "4096 random points, order 5",
        };

        pub fn bench_hilbert_sort_points_2d(ctx: anytype, comptime data_idx: usize) ![]Point {
            var axis: u32 = 0;
            sort_points_2d(.{
                .points = ctx.data[data_idx].points,
                .end = @intCast(i32, ctx.data[data_idx].points.len - 1),
                .order = ctx.data[data_idx].order,
                .axes_start = &axis,
            });
            return ctx.data[data_idx].points;
        }
    });
}
