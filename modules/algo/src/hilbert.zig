//! Algorithms based on Hilbert curves


const std = @import("std");
const testing = std.testing;


pub const Point = [2]u32;


/// In-place Hilbert sort a set of points
/// An implementation of the algorithm described in:
/// [Fast Hilbert Sort Algorithm Without Using Hilbert Indices](https://www.researchgate.net/publication/313074453_Fast_Hilbert_Sort_Algorithm_Without_Using_Hilbert_Indices#pf8)
// TODO(hazeycode): Compare this recursive version to an interative method
// TODO(hazeycode): measure & optimise
// TODO(hazeycode): 3d variant or generalise
pub fn sort_2d(args: struct {
    points: []Point,
    order: u32,
    axis_count: u32 = 0,
    axes_start: u32 = 0,
    axis_idx: u32 = 0,
    dir: enum { forward, backward } = .forward,
    acc: u32 = 0,
}) void {
    const n = 2; // number of dimensions
    
    var axes_start = args.axes_start;
    
    if (args.points.len <= 1) return; // nothing to do for empty or singleton
    
    const part = partition_2d(
        args.points,
        args.order,
        (args.axis_idx + args.axis_count) % n,
        switch (bit_test(axes_start, (args.axis_idx + args.axis_count) % n)) {
            true => .descending,
            false => .ascending,
        },
    );
    
    if (args.axis_count == n - 1) {
        // simulation done, go to next order
        
        if (args.order == 0) return; // no more order to simulate
        
        var next_axis_idx = //
            (args.axis_idx + n + n - switch (args.dir) { .forward => args.acc + 2, .backward => 2 }) % n;
        
        bit_flip(&axes_start, next_axis_idx);
        bit_flip(&axes_start, (args.axis_idx + args.axis_count) % n);
        
        sort_2d(.{
            .points = args.points[0..part - 1],
            .order = args.order - 1,
            .axes_start = axes_start,
            .axis_idx = next_axis_idx,
        });
        
        bit_flip(&axes_start, (args.axis_idx + args.axis_count) % n);
        bit_flip(&axes_start, next_axis_idx);
        
        next_axis_idx = //
            (args.axis_idx + n + n - switch (args.dir) { .forward => 2, .backward => args.acc + 2 }) % n;
        
        sort_2d(.{
            .points = args.points[part..],
            .order = args.order - 1,
            .axes_start =  axes_start,
            .axis_idx = next_axis_idx,
        });
    }
    else {
        sort_2d(.{
            .points = args.points[0..part - 1],
            .order = args.order,
            .axis_count = args.axis_count + 1,
            .axes_start = axes_start,
            .axis_idx = args.axis_idx,
            .acc = switch (args.dir) { .forward => args.acc + 1, .backward => 1 },
        });
        
        bit_flip(&axes_start, (args.axis_idx + args.axis_count) % n);
        bit_flip(&axes_start, (args.axis_idx + args.axis_count + 1) % n);
        
        sort_2d(.{
            .points = args.points[part..],
            .order = args.order,
            .axis_count = args.axis_count + 1,
            .axes_start = axes_start,
            .axis_idx = args.axis_idx,
            .dir = .backward,
            .acc = switch (args.dir) { .forward => 1, .backward => args.acc + 1 },
        });
        
        bit_flip(&axes_start, (args.axis_idx + args.axis_count + 1) % n);
        bit_flip(&axes_start, (args.axis_idx + args.axis_count) % n); 
    }
}

// swap  7  for  8
// partition @  8
// partition @  1
// swap  1  for  5
// partition @  2
// swap  2  for  7
// swap  3  for  6
// partition @  4
// partition @  2
// partition @  3
// swap  5  for  6
// partition @  6
// partition @  5
// partition @  7
// [[2, 2], [1, 6], [3, 7], [3, 6], [3, 5], [2, 5], [2, 4], [3, 4], [5, 6]]

/// Binary partition a set of points
fn partition_2d(points: []Point, order: u32, axis: u32, dir: enum { ascending, descending }) u32 {
    var i = @as(usize, 0);
    var j = points.len;
    while (true) {
        while (i < j and
            bit_test(points[i][axis], order) == (dir == .descending)) {
            i += 1;
        }
        while (i < j and
            bit_test(points[j][axis], order) != (dir == .descending)) {
            j -= 1;
        }
        
        if (j <= i) {
            std.log.warn("\npartition @ {}", .{i});
            return @intCast(u32, i);
        }
        
        { // swap
            std.log.warn("\nswap {} for {}", .{i, j});
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
    var points = [_]Point{
        .{2, 2}, .{2, 4}, .{3, 4}, .{2, 5}, .{3, 5}, .{1, 6}, .{3, 6}, .{5, 6}, .{3, 7}
    };
    
    sort_2d(.{ .points = &points, .order = 2 });
    
    try testing.expectEqualSlices(
        Point,
        &.{ .{2, 2}, .{1, 6}, .{3, 7}, .{3, 6}, .{3, 5}, .{2, 5}, .{2, 4}, .{3, 4}, .{5, 6} },
        &points,
    );
}

