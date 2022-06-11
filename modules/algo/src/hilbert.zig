//! Algorithms based on Hilbert curves


const std = @import("std");
const testing = std.testing;


pub const Point = [2]u32;


/// In-place Hilbert sort a set of points
/// An implementation of the algorithm described in:
/// [Fast Hilbert Sort Algorithm Without Using Hilbert Indices](https://www.researchgate.net/publication/313074453_Fast_Hilbert_Sort_Algorithm_Without_Using_Hilbert_Indices#pf8)
/// Also credit to Mohamed Badawy for clarifying typos in the pseudo code and providing working examples:
/// https://stackoverflow.com/a/66994116/16481771
// TODO(hazeycode): Compare this recursive version to an interative method
// TODO(hazeycode): measure & optimise
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
            (args.axis_idx + n + n - switch (args.dir) { .forward => args.acc + 2, .backward => 2 }) % n;
                
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
            (args.axis_idx + n + n - switch (args.dir) { .forward => 2, .backward => args.acc + 2 }) % n;
        
        sort_points_2d(.{
            .points = args.points,
            .start = part,
            .end = args.end,
            .order = args.order - 1,
            .axes_start = args.axes_start,
            .axis_idx = next_axis_idx,
        });
    }
    else {   
        sort_points_2d(.{
            .points = args.points,
            .start = args.start,
            .end = part - 1,
            .order = args.order,
            .axis_count = args.axis_count + 1,
            .axes_start = args.axes_start,
            .axis_idx = args.axis_idx,
            .acc = switch (args.dir) { .forward => args.acc + 1, .backward => 1 },
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
            .acc = switch (args.dir) { .forward => 1, .backward => args.acc + 1 },
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
            bit_test(points[i][axis], order) == (dir == .descending)) {
            i += 1;
        }
        while (i < j and
            bit_test(points[j][axis], order) != (dir == .descending)) {
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
    var points = [_]Point{
        .{2, 2}, .{2, 4}, .{3, 4}, .{2, 5}, .{3, 5}, .{1, 6}, .{3, 6}, .{5, 6}, .{3, 7}
    };
    
    var axis: u32 = 0;
    sort_points_2d(.{ .points = &points, .end = points.len - 1, .order = 2, .axes_start = &axis });
    
    try testing.expectEqualSlices(
        Point,
        &.{ .{2, 2}, .{1, 6}, .{3, 7}, .{3, 6}, .{3, 5}, .{2, 5}, .{2, 4}, .{3, 4}, .{5, 6} },
        &points,
    ); 
}



