const std = @import("std");

const common = @import("common.zig");
const VertexBufferHandle = common.VertexBufferHandle;
const VertexLayoutDesc = common.VertexLayoutDesc;
const VertexLayoutHandle = common.VertexLayoutHandle;
const TextureFormat = common.TextureFormat;
const TextureHandle = common.TextureHandle;
const ConstantBufferHandle = common.ConstantBufferHandle;
const RasteriserStateHandle = common.RasteriserStateHandle;
const BlendStateHandle = common.BlendStateHandle;
const ShaderProgramHandle = common.ShaderProgramHandle;

var allocator: std.mem.Allocator = undefined;

pub fn init(_allocator: std.mem.Allocator) !void {
    allocator = _allocator;
}

pub fn deinit() void {}

pub fn logDebugMessages() !void {
    std.debug.panic("Unimplemented", .{});
}

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

pub fn draw(offset: u32, count: u32) void {
    _ = offset;
    _ = count;
    std.debug.panic("Unimplemented", .{});
}

pub fn createDynamicVertexBufferWithBytes(bytes: []const u8) !VertexBufferHandle {
    _ = bytes;
    std.debug.panic("Unimplemented", .{});
    return 0;
}

pub fn writeBytesToVertexBuffer(buffer_id: VertexBufferHandle, offset: usize, bytes: []const u8) !usize {
    _ = buffer_id;
    _ = offset;
    _ = bytes;
    std.debug.panic("Unimplemented", .{});
    return 0;
}

pub fn createVertexLayout(layout_desc: VertexLayoutDesc) VertexLayoutHandle {
    _ = layout_desc;
    std.debug.panic("Unimplemented", .{});
    return 0;
}

pub fn useVertexLayout(layout_handle: VertexLayoutHandle) void {
    _ = layout_handle;
    std.debug.panic("Unimplemented", .{});
}

pub fn createTextureWithBytes(bytes: []const u8, format: TextureFormat) TextureHandle {
    _ = bytes;
    _ = format;
    std.debug.panic("Unimplemented", .{});
    return 0;
}

pub fn createConstantBuffer(size: usize) !ConstantBufferHandle {
    _ = size;
    std.debug.panic("Unimplemented", .{});
    return 0;
}

pub fn bindConstantBuffer(
    slot: u32,
    buffer_handle: ConstantBufferHandle,
) void {
    _ = slot;
    _ = buffer_handle;
    std.debug.panic("Unimplemented", .{});
}

pub fn writeShaderConstant(
    buffer_handle: ConstantBufferHandle,
    offset: usize,
    bytes: []const u8,
) !void {
    _ = buffer_handle;
    _ = offset;
    _ = bytes;
    std.debug.panic("Unimplemented", .{});
}

pub fn useConstantBuffer(buffer_handle: ConstantBufferHandle) void {
    _ = buffer_handle;
    std.debug.panic("Unimplemented", .{});
}

pub fn createRasteriserState() !RasteriserStateHandle {
    std.debug.panic("Unimplemented", .{});
}

pub fn useRasteriserState(_: RasteriserStateHandle) void {
    std.debug.panic("Unimplemented", .{});
}

pub fn createBlendState() !BlendStateHandle {
    std.debug.panic("Unimplemented", .{});
    return 0;
}

pub fn setBlendState(_: type.BlendStateHandle) void {
    std.debug.panic("Unimplemented", .{});
}

pub fn useShaderProgram(program_handle: ShaderProgramHandle) void {
    _ = program_handle;
    std.debug.panic("Unimplemented", .{});
}

pub fn createUniformColourShader() !ShaderProgramHandle {
    _ = allocator;
    std.debug.panic("Unimplemented", .{});
    return 0;
}
