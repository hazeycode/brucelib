const std = @import("std");

const types = @import("types.zig");

pub fn setViewport(x: u16, y: u16, width: u16, height: u16) void {
    _ = x;
    _ = y;
    _ = width;
    _ = height;
    std.debug.panic("Unimplemented", .{});
}

pub fn clearWithColour(r: f32, g: f32, b: f32, a: f32) void {
    _ = r;
    _ = g;
    _ = b;
    _ = a;
    std.debug.panic("Unimplemented", .{});
}

pub fn createDynamicVertexBufferWithBytes(bytes: []const u8) types.VertexBufferHandle {
    _ = bytes;
    std.debug.panic("Unimplemented", .{});
    return 0;
}

pub fn writeBytesToVertexBuffer(buffer_id: types.VertexBufferHandle, bytes: []const u8) void {
    _ = buffer_id;
    _ = bytes;
    std.debug.panic("Unimplemented", .{});
}

pub fn createVertexLayout(layout_desc: types.VertexLayoutDesc) types.VertexLayoutHandle {
    _ = layout_desc;
    std.debug.panic("Unimplemented", .{});
    return 0;
}

pub fn bindVertexLayout(layout_handle: types.VertexLayoutHandle) void {
    _ = layout_handle;
    std.debug.panic("Unimplemented", .{});
}

pub fn bindShaderProgram(program_handle: u32) void {
    _ = program_handle;
    std.debug.panic("Unimplemented", .{});
}

pub fn writeUniform(location: u32, components: []const f32) void {
    _ = location;
    _ = components;
    std.debug.panic("Unimplemented", .{});
}

pub fn draw(offset: u32, count: usize) void {
    _ = offset;
    _ = count;
    std.debug.panic("Unimplemented", .{});
}

pub fn createSolidColourShader(allocator: std.mem.Allocator) !types.ShaderProgramHandle {
    _ = allocator;
    std.debug.panic("Unimplemented", .{});
    return 0;
}
