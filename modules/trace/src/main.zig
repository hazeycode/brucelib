const std = @import("std");
const Src = std.builtin.SourceLocation;

const NullProfiler = struct {
    pub const ZoneCtx = struct {
        pub inline fn Text(self: ZoneCtx, text: []const u8) void {
            _ = self;
            _ = text;
        }
        pub inline fn Name(self: ZoneCtx, name: []const u8) void {
            _ = self;
            _ = name;
        }
        pub inline fn Value(self: ZoneCtx, value: u64) void {
            _ = self;
            _ = value;
        }
        pub inline fn End(self: ZoneCtx) void {
            _ = self;
        }
    };

    pub inline fn init_thread() void {}
    pub inline fn set_thread_name(name: [*:0]const u8) void {
        _ = name;
    }

    pub inline fn zone(comptime src: Src) ZoneCtx {
        _ = src;
        return .{};
    }
    pub inline fn zone_name(comptime src: Src, name: [*:0]const u8) ZoneCtx {
        _ = src;
        _ = name;
        return .{};
    }
    pub inline fn zone_colour(comptime src: Src, color: u32) ZoneCtx {
        _ = src;
        _ = color;
        return .{};
    }
    pub inline fn zone_name_colour(comptime src: Src, name: [*:0]const u8, color: u32) ZoneCtx {
        _ = src;
        _ = name;
        _ = color;
        return .{};
    }
    pub inline fn zone_stack(comptime src: Src, depth: i32) ZoneCtx {
        _ = src;
        _ = depth;
        return .{};
    }
    pub inline fn zone_name_stack(comptime src: Src, name: [*:0]const u8, depth: i32) ZoneCtx {
        _ = src;
        _ = name;
        _ = depth;
        return .{};
    }
    pub inline fn zone_colour_stack(comptime src: Src, color: u32, depth: i32) ZoneCtx {
        _ = src;
        _ = color;
        _ = depth;
        return .{};
    }
    pub inline fn zone_name_colour_stack(comptime src: Src, name: [*:0]const u8, color: u32, depth: i32) ZoneCtx {
        _ = src;
        _ = name;
        _ = color;
        _ = depth;
        return .{};
    }

    pub inline fn alloc(ptr: ?*const anyopaque, size: usize) void {
        _ = ptr;
        _ = size;
    }
    pub inline fn free(ptr: ?*const anyopaque) void {
        _ = ptr;
    }
    pub inline fn secure_alloc(ptr: ?*const anyopaque, size: usize) void {
        _ = ptr;
        _ = size;
    }
    pub inline fn secure_free(ptr: ?*const anyopaque) void {
        _ = ptr;
    }
    pub inline fn alloc_stack(ptr: ?*const anyopaque, size: usize, depth: c_int) void {
        _ = ptr;
        _ = size;
        _ = depth;
    }
    pub inline fn free_stack(ptr: ?*const anyopaque, depth: c_int) void {
        _ = ptr;
        _ = depth;
    }
    pub inline fn secure_alloc_stack(ptr: ?*const anyopaque, size: usize, depth: c_int) void {
        _ = ptr;
        _ = size;
        _ = depth;
    }
    pub inline fn secure_free_stack(ptr: ?*const anyopaque, depth: c_int) void {
        _ = ptr;
        _ = depth;
    }

    pub inline fn alloc_name(ptr: ?*const anyopaque, size: usize, name: [*:0]const u8) void {
        _ = ptr;
        _ = size;
        _ = name;
    }
    pub inline fn free_name(ptr: ?*const anyopaque, name: [*:0]const u8) void {
        _ = ptr;
        _ = name;
    }
    pub inline fn secure_alloc_name(ptr: ?*const anyopaque, size: usize, name: [*:0]const u8) void {
        _ = ptr;
        _ = size;
        _ = name;
    }
    pub inline fn secure_free_name(ptr: ?*const anyopaque, name: [*:0]const u8) void {
        _ = ptr;
        _ = name;
    }
    pub inline fn alloc_name_stack(ptr: ?*const anyopaque, size: usize, depth: c_int, name: [*:0]const u8) void {
        _ = ptr;
        _ = size;
        _ = depth;
        _ = name;
    }
    pub inline fn free_name_stack(ptr: ?*const anyopaque, depth: c_int, name: [*:0]const u8) void {
        _ = ptr;
        _ = depth;
        _ = name;
    }
    pub inline fn secure_alloc_name_stack(ptr: ?*const anyopaque, size: usize, depth: c_int, name: [*:0]const u8) void {
        _ = ptr;
        _ = size;
        _ = depth;
        _ = name;
    }
    pub inline fn secure_free_name_stack(ptr: ?*const anyopaque, depth: c_int, name: [*:0]const u8) void {
        _ = ptr;
        _ = depth;
        _ = name;
    }

    pub inline fn message(text: []const u8) void {
        _ = text;
    }
    pub inline fn message_colour(text: []const u8, color: u32) void {
        _ = text;
        _ = color;
    }
    pub inline fn message_stack(text: []const u8, depth: c_int) void {
        _ = text;
        _ = depth;
    }
    pub inline fn message_colour_stack(text: []const u8, color: u32, depth: c_int) void {
        _ = text;
        _ = color;
        _ = depth;
    }

    pub inline fn frame_mark() void {}
    pub inline fn frame_mark_named(name: [*:0]const u8) void {
        _ = name;
    }
    pub inline fn frame_mark_start(name: [*:0]const u8) void {
        _ = name;
    }
    pub inline fn frame_mark_end(name: [*:0]const u8) void {
        _ = name;
    }
    pub inline fn frame_image(image: ?*const anyopaque, width: u16, height: u16, offset: u8, flip: c_int) void {
        _ = image;
        _ = width;
        _ = height;
        _ = offset;
        _ = flip;
    }

    pub inline fn fiber_enter(name: [*:0]const u8) void {
        _ = name;
    }
    pub inline fn fiber_leave() void {}

    pub inline fn plot(name: [*:0]const u8, val: f64) void {
        _ = name;
        _ = val;
    }
};

pub const ZtracyProfiler = struct {
    const ztracy = @import("vendored/ztracy/src/ztracy.zig");
    
    pub const ZoneCtx = ztracy.ZoneCtx;

    pub inline fn init_thread() void {
        ztracy.InitThread();
    }
    
    pub inline fn set_thread_name(name: [*:0]const u8) void {
        ztracy.SetThreadName(name);
    }

    pub inline fn zone(comptime src: Src) ZoneCtx {
        return ztracy.Zone(src);
    }
    pub inline fn zone_name(comptime src: Src, name: [*:0]const u8) ZoneCtx {
        return ztracy.ZoneN(src, name);
    }
    pub inline fn zone_colour(comptime src: Src, color: u32) ZoneCtx {
        return ztracy.ZoneC(src, color);
    }
    pub inline fn zone_name_colour(comptime src: Src, name: [*:0]const u8, color: u32) ZoneCtx {
        return ztracy.ZoneNC(src, name, color);
    }
    pub inline fn zone_stack(comptime src: Src, depth: i32) ZoneCtx {
        return ztracy.ZoneS(src, depth);
    }
    pub inline fn zone_name_stack(comptime src: Src, name: [*:0]const u8, depth: i32) ZoneCtx {
        return ztracy.ZoneNS(src, name, depth);
    }
    pub inline fn zone_colour_stack(comptime src: Src, color: u32, depth: i32) ZoneCtx {
        return ztracy.ZoneCS(src, color, depth);
    }
    pub inline fn zone_name_colour_stack(comptime src: Src, name: [*:0]const u8, color: u32, depth: i32) ZoneCtx {
        return ztracy.ZoneNCS(src, name, color, depth);
    }

    pub inline fn alloc(ptr: ?*const anyopaque, size: usize) void {
        ztracy.Alloc(ptr, size);
    }
    pub inline fn free(ptr: ?*const anyopaque) void {
        ztracy.Free(ptr);
    }
    pub inline fn secure_alloc(ptr: ?*const anyopaque, size: usize) void {
        ztracy.SecureAlloc(ptr, size);
    }
    pub inline fn secure_free(ptr: ?*const anyopaque) void {
        ztracy.SecureFree(ptr);
    }
    pub inline fn alloc_stack(ptr: ?*const anyopaque, size: usize, depth: c_int) void {
        ztracy.AllocS(ptr, size, depth);
    }
    pub inline fn free_stack(ptr: ?*const anyopaque, depth: c_int) void {
        ztracy.FreeS(ptr, depth);
    }
    pub inline fn secure_alloc_stack(ptr: ?*const anyopaque, size: usize, depth: c_int) void {
        ztracy.SecureAllocS(ptr, size, depth);
    }
    pub inline fn secure_free_stack(ptr: ?*const anyopaque, depth: c_int) void {
        ztracy.SecureFreeS(ptr, depth);
    }

    pub inline fn alloc_name(ptr: ?*const anyopaque, size: usize, name: [*:0]const u8) void {
        ztracy.AllocN(ptr, size, name);
    }
    pub inline fn free_name(ptr: ?*const anyopaque, name: [*:0]const u8) void {
        ztracy.FreeN(ptr, name);
    }
    pub inline fn secure_alloc_name(ptr: ?*const anyopaque, size: usize, name: [*:0]const u8) void {
        ztracy.SecureAllocN(ptr, size, name);
    }
    pub inline fn secure_free_name(ptr: ?*const anyopaque, name: [*:0]const u8) void {
        ztracy.SecureFreeN(ptr, name);
    }
    pub inline fn alloc_name_stack(ptr: ?*const anyopaque, size: usize, depth: c_int, name: [*:0]const u8) void {
        ztracy.AllocNS(ptr, size, depth, name);
    }
    pub inline fn free_name_stack(ptr: ?*const anyopaque, depth: c_int, name: [*:0]const u8) void {
        ztracy.FreeNS(ptr, depth, name);
    }
    pub inline fn secure_alloc_name_stack(ptr: ?*const anyopaque, size: usize, depth: c_int, name: [*:0]const u8) void {
        ztracy.SecureAllocNS(ptr, size, depth, name);
    }
    pub inline fn secure_free_name_stack(ptr: ?*const anyopaque, depth: c_int, name: [*:0]const u8) void {
        ztracy.SecureFreeNS(ptr, depth, name);
    }

    pub inline fn message(text: []const u8) void {
        ztracy.Message(text);
    }
    pub inline fn message_colour(text: []const u8, color: u32) void {
        ztracy.MessageC(text, color);
    }
    pub inline fn message_stack(text: []const u8, depth: c_int) void {
        ztracy.MessageS(text, depth);
    }
    pub inline fn message_colour_stack(text: []const u8, color: u32, depth: c_int) void {
        ztracy.MessageCS(text, color, depth);
    }

    pub inline fn frame_mark() void {
        ztracy.FrameMark();
    }
    pub inline fn frame_mark_named(name: [*:0]const u8) void {
        ztracy.FrameMarkNamed(name);
    }
    pub inline fn frame_mark_start(name: [*:0]const u8) void {
        ztracy.FrameMarkStart(name);
    }
    pub inline fn frame_mark_end(name: [*:0]const u8) void {
        ztracy.FrameMarkEnd(name);
    }
    pub inline fn frame_image(image: ?*const anyopaque, width: u16, height: u16, offset: u8, flip: c_int) void {
        ztracy.FrameImage(image, width, height, offset, flip);
    }

    pub inline fn fiber_enter(name: [*:0]const u8) void {
        ztracy.FiberEnter(name);
    }
    pub inline fn fiber_leave() void {
        ztracy.FiverLeave();
    }

    pub inline fn plot(name: [*:0]const u8, val: anytype) void {
        switch (@TypeOf(val)) {
            f32 => ztracy.PlotF(name, val),
            u64 => ztracy.PlotU(name, val),
            i64 => ztracy.PlotI(name, val),
            else => @compileError("Unsupported type"),
        }
    }
};

