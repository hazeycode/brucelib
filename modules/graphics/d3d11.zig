const std = @import("std");
const builtin = @import("builtin");

const types = @import("types.zig");

const win32 = @import("zig-gamedev-win32");
const S_OK = win32.base.S_OK;
const d3d = win32.d3d;
const d3d11 = win32.d3d11;
const d3dcompiler = win32.d3dcompiler;

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

    const shader_src =
        \\struct vs_in {
        \\    float3 position_local : POS;
        \\};
        \\
        \\struct vs_out {
        \\    float4 position_clip : SV_POSITION;
        \\};
        \\
        \\vs_out vs_main(vs_in input) {
        \\    vs_out output = (vs_out)0;
        \\    output.position_clip = float4(input.position_local, 1.0);
        \\    return output;
        \\}
        \\
        \\float4 ps_main(vs_out input) : SV_TARGET {
        \\    return float4( 1.0, 0.0, 1.0, 1.0 );
        \\}
        \\
    ;

    _ = try compileVertexShader(shader_src, "vs_main");
    _ = try compilePixelShader(shader_src, "ps_main");

    return 0;
}

fn compileVertexShader(source: [:0]const u8, entrypoint: [:0]const u8) !*d3d11.IVertexShader {
    var res: ?*d3d11.IVertexShader = null;

    const vs_blob = try compileHLSL(source, entrypoint, "vs_5_0");
    defer _ = vs_blob.Release();

    try win32.hrErrorOnFail(getD3D11Device().CreateVertexShader(
        vs_blob.GetBufferPointer(),
        vs_blob.GetBufferSize(),
        null,
        &res,
    ));

    _ = vs_blob.Release();

    return res.?;
}

fn compilePixelShader(source: [:0]const u8, entrypoint: [:0]const u8) !*d3d11.IPixelShader {
    var res: ?*d3d11.IPixelShader = null;

    const ps_blob = try compileHLSL(source, entrypoint, "ps_5_0");
    defer _ = ps_blob.Release();

    try win32.hrErrorOnFail(getD3D11Device().CreatePixelShader(
        ps_blob.GetBufferPointer(),
        ps_blob.GetBufferSize(),
        null,
        &res,
    ));

    return res.?;
}

fn compileHLSL(source: [:0]const u8, entrypoint: [:0]const u8, target: [:0]const u8) !*d3d.IBlob {
    var compile_flags = d3dcompiler.COMPILE_ENABLE_STRICTNESS;
    if (builtin.mode == .Debug) {
        compile_flags |= d3dcompiler.COMPILE_DEBUG;
    }

    var blob: *d3d.IBlob = undefined;
    var err_blob: *d3d.IBlob = undefined;

    const compile_result = d3dcompiler.D3DCompile(
        source.ptr,
        source.len,
        null,
        null,
        null,
        entrypoint,
        target,
        compile_flags,
        0,
        &blob,
        &err_blob,
    );

    if (compile_result != S_OK) {
        const err_msg = @ptrCast([*c]const u8, err_blob.GetBufferPointer());
        std.log.err("Failed to compile shader:\n{s}", .{err_msg});
        _ = err_blob.Release();
        return win32.hrToError(compile_result);
    }

    return blob;
}

extern fn getD3D11Device() *d3d11.IDevice;
