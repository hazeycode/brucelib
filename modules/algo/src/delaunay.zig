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
pub fn random_points(allocator: std.mem.Allocator, count: usize) ![]Point {
    var points = try allocator.alloc(Point, count);

    var rng = std.rand.DefaultPrng.init(0);
    for (points) |*p| p.* = .{
        rng.random().float(f32),
        rng.random().float(f32),
    };

    return points;
}

/// Returns the vertices of the mesh of a set of triangles
pub fn get_triangle_vertices(allocator: std.mem.Allocator, triangles: []const Triangle) ![]Point {    
    const max_verts = (triangles.len + 5) / 2;
    
    var point_buffer = try allocator.alloc(Point, max_verts);
    var cursor: usize = 0;
    
    for (triangles) |tri| {
        for (tri) |point| {
            var readback: usize = 0;
            while (cursor - readback > 0) : (readback += 1) {
                if (points_eq(point_buffer[readback], point)) {
                    point_buffer[cursor] = point;
                    cursor += 1;
                    break;
                }
            }
        }
    }
        
    return point_buffer;
}

// TODO(hazyecode): BowyerWatson3d

/// Calculates the Delaunay triangulation of a set of points using the bowyer-watson algorithm
/// Points must be in the range (0.0, 0.0)...(1.0, 1.0)
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
        Point{ 0, 10 },
        Point{ -10, -10 },
        Point{ 10, -10 },
    };
    triangle_list.append(super_tri);

    for (points) |point, i| {
        _ = i;
        // std.log.warn("insert point {}", .{i});
        
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
                    // std.log.warn("found invalidated triangle", .{});
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
                            points_eq(bad_edge[0], bad_edge_2[0]) and
                            points_eq(bad_edge[1], bad_edge_2[1])
                        ) {
                            try polygon.append(bad_edge);
                            // std.log.warn("found hole edge", .{});
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
                if ( // triangles match?
                    // TODO(hazeycode): vectorise:
                    points_eq(node.data[0], bad_tri[0]) and
                    points_eq(node.data[1], bad_tri[1]) and
                    points_eq(node.data[2], bad_tri[2])
                ) {
                    triangle_list.remove(node);
                    // std.log.warn("bad triangle removed", .{});
                    break;
                }
            }
        }

        // re-triangluate the polygon hole
        for (polygon.items) |edge| {
            var tri_node = try allocator.create(TriangleList.Node);
            tri_node.data = .{ point, edge[0], edge[1] };
            triangle_list.append(tri_node);
            // std.log.warn("triangle added", .{});
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
            var filter = false;
            test_super_tri: for (triangle.data) |vertex| {
                for (super_tri.data) |super_tri_vert| {
                    if (points_eq(super_tri_vert, vertex)) {
                        filter = true;
                        break :test_super_tri;
                    }
                }
            }
            if (filter == false) {
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

fn edges_eq(a: Edge, b: Edge) bool {
    return (points_eq(a[0], b[0]) and points_eq(a[1], b[1]));
}

fn tri_edges(triangle: Triangle) [3]Edge {
    return .{
        .{ triangle[0], triangle[1] },
        .{ triangle[1], triangle[2] },
        .{ triangle[2], triangle[0] },
    };
}


// Benchmarks ///////////////////////////////////////////////////////////////////////////////////////////////

/// Returns an array of random triangles, used for benchmarks
pub fn random_triangles(allocator: std.mem.Allocator, count: usize) ![]Triangle {
    var triangles = try allocator.alloc(Triangle, count);

    var rng = std.rand.DefaultPrng.init(0);
    for (triangles) |*p| p.* = .{
        .{ rng.random().float(f32), rng.random().float(f32) },
        .{ rng.random().float(f32), rng.random().float(f32) },
        .{ rng.random().float(f32), rng.random().float(f32) },
    };

    return triangles;
}


test "random_points" {
    var temp_arena = std.heap.ArenaAllocator.init(testing.allocator);
    defer temp_arena.deinit();
    
    var allocator = temp_arena.allocator();
    
    try benchmark(&allocator, struct {
        pub const args = [_]usize{  64, 256, 1024, 4096 };

        pub const arg_names = [_][]const u8{
            "64 random points",
            "256 random points",
            "1024 random points",
            "4096 random points",
        };

        pub fn bench_random_points(ctx: anytype, comptime count: usize) ![]Point {
            return try random_points(ctx.*, count);
        }
    });
}

test "bowyer-watson triangulate" {
    var temp_arena = std.heap.ArenaAllocator.init(testing.allocator);
    defer temp_arena.deinit();
    
    var allocator = temp_arena.allocator();
    
    var context = struct {
        allocator: std.mem.Allocator,
        data: [4][]Point,
    }{
        .allocator = allocator,
        .data = .{
            try random_points(allocator, 64),
            try random_points(allocator, 256),
            try random_points(allocator, 1024),
            try random_points(allocator, 2048),
        },
    };
    
    try benchmark(&context, struct {
        const range = @import("comptime_range.zig").range;
        pub const args = range(0, 3);

        pub const arg_names = [_][]const u8{
            "64 random points",
            "256 random points",
            "1024 random points",
            "2056 random points",
        };

        pub fn bench_bowyer_watson_2d(ctx: anytype, comptime data_idx: usize) ![]Triangle {
            return try bowyer_watson_2d(ctx.allocator, ctx.data[data_idx]);
        }
    });
}

test "get_triangle_vertices" {
    var temp_arena = std.heap.ArenaAllocator.init(testing.allocator);
    defer temp_arena.deinit();
    
    var allocator = temp_arena.allocator();
    
    var context = struct {
        allocator: std.mem.Allocator,
        data: [4][]Triangle,
    }{
        .allocator = allocator,
        .data = .{
            try random_triangles(allocator, 16),
            try random_triangles(allocator, 256),
            try random_triangles(allocator, 1024),
            try random_triangles(allocator, 4096),
        },
    };
     
    try benchmark(&context, struct {
        
        // TODO(hazeycode): this benchmark is stupid. using totally random triangles means that it's
        // likely that all the points are unique which will affect the performance characteristics
        // of get_triangle_vertices differently than a more realistic domain. Replace the random
        // traingles with random delaunay meshes (i.e. where all triangles are connected)
        
        const range = @import("comptime_range.zig").range;
        
        pub const args = range(0, 3);

        pub const arg_names = [_][]const u8{
            "16 random triangles",
            "256 random triangles",
            "1024 random triangles",
            "4096 random triangles",
        };

        pub fn bench_get_triangle_vertices(ctx: anytype, comptime data_idx: usize) ![]Point {
            return try get_triangle_vertices(ctx.allocator, ctx.data[data_idx]);
        }
    });
}
