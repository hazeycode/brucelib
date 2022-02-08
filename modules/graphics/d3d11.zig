const std = @import("std");
const builtin = @import("builtin");

const types = @import("types.zig");

const win32 = @import("zig-gamedev-win32");
const UINT = win32.base.UINT;
const FLOAT = win32.base.FLOAT;
const S_OK = win32.base.S_OK;
const dxgi = win32.dxgi;
const d3d = win32.d3d;
const d3d11 = win32.d3d11;
const d3dcompiler = win32.d3dcompiler;

extern fn getD3D11Device() *d3d11.IDevice;
extern fn getD3D11DeviceContext() *d3d11.IDeviceContext;
extern fn getD3D11RenderTargetView() *d3d11.IRenderTargetView;

var allocator: std.mem.Allocator = undefined;

const ShaderProgramList = std.ArrayList(struct {
    vs: *d3d11.IVertexShader,
    ps: *d3d11.IPixelShader,
    input_layout: *d3d11.IInputLayout,
});

var shader_programs: ShaderProgramList = undefined;

pub fn init(_allocator: std.mem.Allocator) void {
    allocator = _allocator;
    shader_programs = ShaderProgramList.init(allocator);
}

pub fn deinit() void {
    for (shader_programs.items) |program| {
        _ = program.vs.Release();
        _ = program.ps.Release();
        _ = program.input_layout.Release();
    }
    shader_programs.deinit();
}

pub fn setViewport(x: u16, y: u16, width: u16, height: u16) void {
    const viewports = [_]d3d11.VIEWPORT{
        .{
            .TopLeftX = @intToFloat(FLOAT, x),
            .TopLeftY = @intToFloat(FLOAT, y),
            .Width = @intToFloat(FLOAT, width),
            .Height = @intToFloat(FLOAT, height),
            .MinDepth = 0.0,
            .MaxDepth = 1.0,
        },
    };
    getD3D11DeviceContext().RSSetViewports(1, &viewports);
}

pub fn clearWithColour(r: f32, g: f32, b: f32, a: f32) void {
    const colour = [4]FLOAT{ r, g, b, a };
    getD3D11DeviceContext().ClearRenderTargetView(getD3D11RenderTargetView(), &colour);
}

pub fn createDynamicVertexBufferWithBytes(bytes: []const u8) !types.VertexBufferHandle {
    var buffer: ?*d3d11.IBuffer = null;
    const desc = d3d11.BUFFER_DESC{
        .ByteWidth = @intCast(UINT, bytes.len),
        .Usage = d3d11.USAGE_DEFAULT,
        .BindFlags = d3d11.BIND_VERTEX_BUFFER,
    };
    const subresouce_data = d3d11.SUBRESOURCE_DATA{
        .pSysMem = bytes.ptr,
    };
    try win32.hrErrorOnFail(getD3D11Device().CreateBuffer(
        &desc,
        &subresouce_data,
        &buffer,
    ));
    return @ptrToInt(buffer);
}

pub fn writeBytesToVertexBuffer(buffer_id: types.VertexBufferHandle, bytes: []const u8) void {
    _ = buffer_id;
    _ = bytes;
    std.debug.panic("Unimplemented", .{});
}

pub fn createVertexLayout(shader_program_handle: types.ShaderProgramHandle, _: types.VertexLayoutDesc) types.VertexLayoutHandle {
    return @ptrToInt(shader_programs.items[shader_program_handle].input_layout);
}

pub fn bindVertexLayout(layout_handle: types.VertexLayoutHandle) void {
    _ = layout_handle;
    std.debug.panic("Unimplemented", .{});
}

pub fn bindShaderProgram(program_handle: types.ShaderProgramHandle) void {
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

pub fn createSolidColourShader() !types.ShaderProgramHandle {
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

    const vs_bytecode = try compileHLSL(shader_src, "vs_main", "vs_5_0");
    defer _ = vs_bytecode.Release();

    const ps_bytecode = try compileHLSL(shader_src, "ps_main", "ps_5_0");
    defer _ = ps_bytecode.Release();

    const vs = try createVertexShader(vs_bytecode);
    errdefer _ = vs.Release();

    const ps = try createPixelShader(ps_bytecode);
    errdefer _ = ps.Release();

    const input_element_desc = [_]d3d11.INPUT_ELEMENT_DESC{
        .{
            .SemanticName = "POS",
            .SemanticIndex = 0,
            .Format = dxgi.FORMAT.R32G32B32_FLOAT,
            .InputSlot = 0,
            .AlignedByteOffset = 0,
            .InputSlotClass = d3d11.INPUT_CLASSIFICATION.INPUT_PER_VERTEX_DATA,
            .InstanceDataStepRate = 0,
        },
    };
    const input_layout = try createInputLayout(&input_element_desc, vs_bytecode);

    try shader_programs.append(.{
        .vs = vs,
        .ps = ps,
        .input_layout = input_layout,
    });

    return (shader_programs.items.len - 1);
}

fn createInputLayout(desc: []const d3d11.INPUT_ELEMENT_DESC, vs_bytecode: *d3d.IBlob) !*d3d11.IInputLayout {
    var res: ?*d3d11.IInputLayout = null;
    try win32.hrErrorOnFail(getD3D11Device().CreateInputLayout(
        @ptrCast(*const d3d11.INPUT_ELEMENT_DESC, desc.ptr),
        @intCast(UINT, desc.len),
        vs_bytecode.GetBufferPointer(),
        vs_bytecode.GetBufferSize(),
        &res,
    ));
    return res.?;
}

fn createVertexShader(bytecode: *d3d.IBlob) !*d3d11.IVertexShader {
    var res: ?*d3d11.IVertexShader = null;
    try win32.hrErrorOnFail(getD3D11Device().CreateVertexShader(
        bytecode.GetBufferPointer(),
        bytecode.GetBufferSize(),
        null,
        &res,
    ));
    return res.?;
}

fn createPixelShader(bytecode: *d3d.IBlob) !*d3d11.IPixelShader {
    var res: ?*d3d11.IPixelShader = null;
    try win32.hrErrorOnFail(getD3D11Device().CreatePixelShader(
        bytecode.GetBufferPointer(),
        bytecode.GetBufferSize(),
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
