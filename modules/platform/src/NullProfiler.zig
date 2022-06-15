const std = @import("std");
const Src = std.builtin.SourceLocation;

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

pub inline fn set_thread_name(_: [*:0]const u8) void {}

pub inline fn zone(comptime _: Src) ZoneCtx {return .{};}
pub inline fn zone_name(comptime _: Src, _: [*:0]const u8) ZoneCtx {return .{};}
pub inline fn zone_colour(comptime _: Src, _: u32) ZoneCtx {return .{};}
pub inline fn zone_name_colour(comptime _: Src, _: [*:0]const u8, _: u32) ZoneCtx {return .{};}
pub inline fn zone_stack(comptime _: Src, _: i32) ZoneCtx {return .{};}
pub inline fn zone_name_stack(comptime _: Src, _: [*:0]const u8, _: i32) ZoneCtx {return .{};}
pub inline fn zone_colour_stack(comptime _: Src, _: u32, _: i32) ZoneCtx {return .{};}
pub inline fn zone_name_colour_stack(comptime _: Src, _: [*:0]const u8, _: u32, _: i32) ZoneCtx {return .{};}

pub inline fn alloc(_: ?*const anyopaque, _: usize) void {}
pub inline fn free(_: ?*const anyopaque) void {}
pub inline fn secure_alloc(_: ?*const anyopaque, _: usize) void {}
pub inline fn secure_free(_: ?*const anyopaque) void {}
pub inline fn alloc_stack(_: ?*const anyopaque, _: usize, _: c_int) void {}
pub inline fn free_stack(_: ?*const anyopaque, _: c_int) void {}
pub inline fn secure_alloc_stack(_: ?*const anyopaque, _: usize, _: c_int) void {}
pub inline fn secure_free_stack(_: ?*const anyopaque, _: c_int) void {}

pub inline fn alloc_name(_: ?*const anyopaque, _: usize, _: [*:0]const u8) void {}
pub inline fn free_name(_: ?*const anyopaque, _: [*:0]const u8) void {}
pub inline fn secure_alloc_name(_: ?*const anyopaque, _: usize, _: [*:0]const u8) void {}
pub inline fn secure_free_name(_: ?*const anyopaque, _: [*:0]const u8) void {}
pub inline fn alloc_name_stack(_: ?*const anyopaque, _: usize, _: c_int, _: [*:0]const u8) void {}
pub inline fn free_name_stack(_: ?*const anyopaque, _: c_int, _: [*:0]const u8) void {}
pub inline fn secure_alloc_name_stack(_: ?*const anyopaque, _: usize, _: c_int, _: [*:0]const u8) void {}
pub inline fn secure_free_name_stack(_: ?*const anyopaque, _: c_int, _: [*:0]const u8) void {}

pub inline fn message(_: []const u8) void {}
pub inline fn message_colour(_: []const u8, _: u32) void {}
pub inline fn message_stack(_: []const u8, _: c_int) void {}
pub inline fn message_colour_stack(_: []const u8, _: u32, _: c_int) void {}

pub inline fn frame_mark() void {}
pub inline fn frame_mark_named(_: [*:0]const u8) void {}
pub inline fn frame_mark_start(_: [*:0]const u8) void {}
pub inline fn frame_mark_end(_: [*:0]const u8) void {}
pub inline fn frame_image(_: ?*const anyopaque, _: u16, _: u16, _: u8, _: c_int) void {}

pub inline fn fiber_enter(_: [*:0]const u8) void {}
pub inline fn fiber_leave() void {}

pub inline fn plot(_: [*:0]const u8, _: anytype) void {}
