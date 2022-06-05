//! Algorithms for constructing Delaunay triangulations

const std = @import("std");
const testing = std.testing;
const sqrt = std.math.sqrt;

const zmath = @import("zmath");
const Matrix = zmath.Mat;
const determinant = zmath.determinant;

const benchmark = @import("bench").benchmark;

pub const Point = [2]f32;
pub const Triangle = [3]Point;
pub const Edge = [2]Point;

/// Returns an array of random Points
pub fn random_points(comptime count: comptime_int) [count]Point {
    @setEvalBranchQuota(1000000);

    comptime var points: [count]Point = undefined;

    comptime var rng = std.rand.DefaultPrng.init(0);
    inline for (points) |*p| p.* = .{
        comptime rng.random().float(f32),
        comptime rng.random().float(f32),
    };

    return points;
}

// TODO(hazyecode): BowyerWatson3d

/// Calculates the Delaunay triangulation of a set of points using the bowyer-watson algorithm
/// Points must be in the range (0.0, 0.0)...(1.0, 1.0) and in counter-clockwise winding order
/// Caller owns the returned slice
/// TODO(hazeycode): Optimsations
pub fn bowyer_watson_2d(allocator: std.mem.Allocator, points: []const Point) ![]Triangle {
    const TriangleList = std.TailQueue(Triangle);
    var triangle_list = TriangleList{};

    var bad_triangles = std.ArrayList(Triangle).init(allocator);
    defer bad_triangles.deinit();

    var polygon = std.ArrayList(Edge).init(allocator);
    defer polygon.deinit();

    const super_tri = try allocator.create(TriangleList.Node);
    defer allocator.destroy(super_tri);
    super_tri.data = Triangle{
        Point{ -10, -10 },
        Point{ 0, 10 },
        Point{ 10, -10 },
    };
    triangle_list.append(super_tri);

    for (points) |point| {
        { // find all triangles invalidated by insertion of this point
            var maybe_tri = triangle_list.first;
            while (maybe_tri) |tri| {
                defer maybe_tri = tri.next;
                const a = tri.data[0];
                const b = tri.data[1];
                const c = tri.data[2];
                const det = determinant(Matrix{
                    .{ a[0], a[1], a[0] * a[0] + a[1] * a[1], 1 },
                    .{ b[0], b[1], b[0] * b[0] + b[1] * b[1], 1 },
                    .{ c[0], c[1], c[0] * c[0] + c[1] * c[1], 1 },
                    .{ point[0], point[1], point[0] * point[0] + point[1] * point[1], 1 },
                });
                const point_in_circ = det[0] > 0;
                if (point_in_circ) {
                    try bad_triangles.append(tri.data);
                }
            }
        }

        // find boundary of polygon hole
        for (bad_triangles.items) |bad_tri| {
            for (tri_edges(bad_tri)) |bad_edge| {
                test_edges: for (bad_triangles.items) |bad_tri_2| {
                    for (tri_edges(bad_tri_2)) |bad_edge_2| {
                        if ( // edges match?
                        // TODO(hazeycode): vectorise:
                        points_eq(bad_edge[0], bad_edge_2[0]) and points_eq(
                            bad_edge[1],
                            bad_edge_2[1],
                        )) {
                            try polygon.append(bad_edge);
                            break :test_edges;
                        }
                    }
                }
            }
        }

        // remove bad triangles
        for (bad_triangles.items) |bad_tri| {
            var maybe_node = triangle_list.first;
            while (maybe_node) |node| {
                defer maybe_node = node.next;
                // zig fmt: off
                if ( // triangles match?
                    // TODO(hazeycode): vectorise:
                    points_eq(node.data[0], bad_tri[0])
                    and points_eq(node.data[1], bad_tri[1])
                    and points_eq(node.data[2], bad_tri[2])
                ) {
                // zig fmt: on
                    triangle_list.remove(node);
                    break;
                }
            }
        }

        // re-triangluate the polygon hole
        for (polygon.items) |edge| {
            var tri_node = try allocator.create(TriangleList.Node);
            tri_node.data = .{ point, edge[0], edge[1] };
            triangle_list.append(tri_node);
        }

        bad_triangles.clearRetainingCapacity();
        polygon.clearRetainingCapacity();
    }

    { // filter and return slice of triangles
        var res = std.ArrayList(Triangle).init(allocator);
        errdefer res.deinit();

        var maybe_triangle = triangle_list.first;
        while (maybe_triangle) |triangle| {
            defer maybe_triangle = triangle.next;
            var remove = false;
            for (triangle.data) |vertex| {
                for (super_tri.data) |super_tri_vert| {
                    if (points_eq(super_tri_vert, vertex)) {
                        remove = true;
                        break;
                    }
                }
            }
            if (remove == false) {
                try res.append(triangle.data);
            }
        }

        return res.items;
    }
}

fn sub(a: Point, b: Point) Point {
    return .{ a[0] - b[0], a[1] - b[1] };
}

fn distance_sq(a: Point, b: Point) f32 {
    var res: f32 = 0;
    const delta = sub(b, a);
    comptime var i = 0;
    inline while (i < delta.len) : (i += 1) {
        res += delta[i] * delta[i];
    }
    return res;
}

fn points_eq(a: Point, b: Point) bool {
    return distance_sq(a, b) < 1e-9;
}

fn tri_edges(triangle: Triangle) [3]Edge {
    return .{
        .{ triangle[0], triangle[1] },
        .{ triangle[1], triangle[2] },
        .{ triangle[2], triangle[0] },
    };
}

// Benchmarks ///////////////////////////////////////////////////////////////////////////////////////////////

test "bowyer-watson triangulate" {
    try benchmark(struct {
        pub const args = [_][]const Point{
            &random_points(64),
            &random_points(256),
            &random_points(1024),
            &random_points(2056),
        };

        pub const arg_names = [_][]const u8{
            "64 random points",
            "256 random points",
            "1024 random points",
            "2056 random points",
        };

        pub fn triangluate_bowyer_watson_2d(ps: []const Point) ![]Triangle {
            return try bowyer_watson_2d(testing.allocator, ps);
        }
    });
}
