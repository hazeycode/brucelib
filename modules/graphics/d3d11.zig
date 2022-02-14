const std = @import("std");
const builtin = @import("builtin");

const types = @import("types.zig");

const win32 = @import("zig-gamedev-win32");
const BOOL = win32.base.BOOL;
const TRUE = win32.base.TRUE;
const FALSE = win32.base.FALSE;
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

const VertexLayoutList = std.ArrayList(struct {
    buffers: []*d3d11.IBuffer,
    strides: []UINT,
    offsets: []UINT,
});

var vertex_layouts: VertexLayoutList = undefined;

const ConstantBufferList = std.ArrayList(struct {
    slot: UINT,
    buffer: *d3d11.IBuffer,
});

var constant_buffers: ConstantBufferList = undefined;

const TextureResourcesList = std.ArrayList(struct {
    texture2d: *d3d11.ITexture2D,
    shader_res_view: *d3d11.IShaderResourceView,
    sampler_state: *d3d11.ISamplerState,
});

var textures: TextureResourcesList = undefined;

pub fn init(_allocator: std.mem.Allocator) void {
    allocator = _allocator;
    shader_programs = ShaderProgramList.init(allocator);
    vertex_layouts = VertexLayoutList.init(allocator);
    constant_buffers = ConstantBufferList.init(allocator);
    textures = TextureResourcesList.init(allocator);
}

pub fn deinit() void {
    for (textures.items) |texture| {
        _ = texture.texture2d.Release();
        _ = texture.shader_res_view.Release();
    }
    textures.deinit();

    for (constant_buffers.items) |constant_buffer| {
        _ = constant_buffer.buffer.Release();
    }
    constant_buffers.deinit();

    for (vertex_layouts.items) |layout| {
        allocator.free(layout.buffers);
        allocator.free(layout.strides);
        allocator.free(layout.offsets);
    }
    vertex_layouts.deinit();

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

    // TODO(hazeycode): delete in favour of setRenderTarget fn?
    const render_target_views = [_]*d3d11.IRenderTargetView{
        getD3D11RenderTargetView(),
    };
    getD3D11DeviceContext().OMSetRenderTargets(
        1,
        @ptrCast([*]const d3d11.IRenderTargetView, &render_target_views),
        null,
    );
}

pub fn clearWithColour(r: f32, g: f32, b: f32, a: f32) void {
    const colour = [4]FLOAT{ r, g, b, a };
    getD3D11DeviceContext().ClearRenderTargetView(getD3D11RenderTargetView(), &colour);
}

pub fn draw(offset: u32, count: u32) void {
    const device_ctx = getD3D11DeviceContext();
    device_ctx.IASetPrimitiveTopology(d3d11.PRIMITIVE_TOPOLOGY.TRIANGLELIST);
    device_ctx.Draw(count, offset);
}

pub fn createDynamicVertexBufferWithBytes(bytes: []const u8) !types.VertexBufferHandle {
    var buffer: ?*d3d11.IBuffer = null;
    const desc = d3d11.BUFFER_DESC{
        .ByteWidth = @intCast(UINT, bytes.len),
        .Usage = d3d11.USAGE_DYNAMIC,
        .BindFlags = d3d11.BIND_VERTEX_BUFFER,
        .CPUAccessFlags = d3d11.CPU_ACCESS_WRITE,
    };
    const subresouce_data = d3d11.SUBRESOURCE_DATA{
        .pSysMem = bytes.ptr,
    };
    try win32.hrErrorOnFail(getD3D11Device().CreateBuffer(
        &desc,
        &subresouce_data,
        &buffer,
    ));
    return @ptrToInt(buffer.?);
}

pub fn writeBytesToVertexBuffer(buffer_handle: types.VertexBufferHandle, offset: usize, bytes: []const u8) !usize {
    const vertex_buffer = @intToPtr(*d3d11.IResource, buffer_handle);
    const device_ctx = getD3D11DeviceContext();
    var subresource = std.mem.zeroes(d3d11.MAPPED_SUBRESOURCE);
    try win32.hrErrorOnFail(device_ctx.Map(
        vertex_buffer,
        0,
        d3d11.MAP.WRITE_DISCARD,
        0,
        &subresource,
    ));
    std.mem.copy(u8, @ptrCast([*]u8, subresource.pData)[offset..(offset + bytes.len)], bytes);
    device_ctx.Unmap(vertex_buffer, 0);
    return bytes.len;
}

pub fn createVertexLayout(vertex_layout_desc: types.VertexLayoutDesc) !types.VertexLayoutHandle {
    const num_entries = vertex_layout_desc.entries.len;

    var buffers = try allocator.alloc(*d3d11.IBuffer, num_entries);
    errdefer allocator.free(buffers);

    var strides = try allocator.alloc(UINT, num_entries);
    errdefer allocator.free(strides);

    var offsets = try allocator.alloc(UINT, num_entries);
    errdefer allocator.free(offsets);

    for (vertex_layout_desc.entries) |entry, i| {
        buffers[i] = @intToPtr(*d3d11.IBuffer, entry.buffer_handle);
        strides[i] = entry.getStride();
        offsets[i] = entry.offset;
    }

    try vertex_layouts.append(.{
        .buffers = buffers,
        .strides = strides,
        .offsets = offsets,
    });

    return (vertex_layouts.items.len - 1);
}

pub fn setVertexLayout(vertex_layout_handle: types.VertexLayoutHandle) void {
    const vertex_layout = vertex_layouts.items[vertex_layout_handle];
    getD3D11DeviceContext().IASetVertexBuffers(
        0,
        1,
        vertex_layout.buffers.ptr,
        vertex_layout.strides.ptr,
        vertex_layout.offsets.ptr,
    );
}

pub fn createTexture2dWithBytes(bytes: []const u8, width: u32, height: u32, format: types.TextureFormat) !types.TextureHandle {
    var texture: ?*d3d11.ITexture2D = null;
    {
        const desc = d3d11.TEXTURE2D_DESC{
            .Width = width,
            .Height = height,
            .MipLevels = 1,
            .ArraySize = 1,
            .Format = formatToDxgiFormat(format),
            .SampleDesc = .{
                .Count = 1,
                .Quality = 0,
            },
            .Usage = d3d11.USAGE_DEFAULT,
            .BindFlags = d3d11.BIND_SHADER_RESOURCE,
            .CPUAccessFlags = 0,
            .MiscFlags = 0,
        };
        const subresouce_data = d3d11.SUBRESOURCE_DATA{
            .pSysMem = bytes.ptr,
            .SysMemPitch = switch (format) {
                .uint8 => width,
            },
        };
        try win32.hrErrorOnFail(getD3D11Device().CreateTexture2D(
            &desc,
            &subresouce_data,
            &texture,
        ));
    }

    var shader_res_view: ?*d3d11.IShaderResourceView = null;
    {
        try win32.hrErrorOnFail(getD3D11Device().CreateShaderResourceView(
            @ptrCast(*d3d11.IResource, texture.?),
            null,
            &shader_res_view,
        ));
    }

    var sampler_state: ?*d3d11.ISamplerState = null;
    {
        const desc = d3d11.SAMPLER_DESC{
            .Filter = .MIN_MAG_MIP_POINT,
            .AddressU = .WRAP,
            .AddressV = .WRAP,
            .AddressW = .WRAP,
            .MipLODBias = 0,
            .MaxAnisotropy = 1,
            .ComparisonFunc = .NEVER,
            .BorderColor = .{ 0, 0, 0, 0 },
            .MinLOD = 0,
            .MaxLOD = 0,
        };
        try win32.hrErrorOnFail(getD3D11Device().CreateSamplerState(
            &desc,
            &sampler_state,
        ));
    }

    try textures.append(.{
        .texture2d = texture.?,
        .shader_res_view = shader_res_view.?,
        .sampler_state = sampler_state.?,
    });

    return (textures.items.len - 1);
}

pub fn setTexture(slot: u32, texture_handle: types.TextureHandle) void {
    const samplers = [_]*d3d11.ISamplerState{
        textures.items[texture_handle].sampler_state,
    };
    getD3D11DeviceContext().PSSetSamplers(0, 1, &samplers);

    const shader_res_views = [_]*d3d11.IShaderResourceView{
        textures.items[texture_handle].shader_res_view,
    };
    getD3D11DeviceContext().PSSetShaderResources(slot, 1, &shader_res_views);
}

pub fn createConstantBuffer(size: usize) !types.ConstantBufferHandle {
    var buffer: ?*d3d11.IBuffer = null;
    const desc = d3d11.BUFFER_DESC{
        .ByteWidth = @intCast(UINT, size),
        .Usage = d3d11.USAGE_DYNAMIC,
        .BindFlags = d3d11.BIND_CONSTANT_BUFFER,
        .CPUAccessFlags = d3d11.CPU_ACCESS_WRITE,
    };
    try win32.hrErrorOnFail(getD3D11Device().CreateBuffer(
        &desc,
        null,
        &buffer,
    ));
    errdefer _ = buffer.?.Release();

    try constant_buffers.append(.{
        .slot = undefined,
        .buffer = buffer.?,
    });

    return (constant_buffers.items.len - 1);
}

pub fn bindConstantBuffer(
    slot: u32,
    buffer_handle: types.ConstantBufferHandle,
    _: usize,
    _: usize,
) void {
    constant_buffers.items[buffer_handle].slot = slot;
}

pub fn writeShaderConstant(
    buffer_handle: types.ConstantBufferHandle,
    offset: usize,
    bytes: []const u8,
) !void {
    const constant_buffer = @ptrCast(
        *d3d11.IResource,
        constant_buffers.items[buffer_handle].buffer,
    );
    const device_ctx = getD3D11DeviceContext();
    var subresource = std.mem.zeroes(d3d11.MAPPED_SUBRESOURCE);
    try win32.hrErrorOnFail(device_ctx.Map(
        constant_buffer,
        0,
        d3d11.MAP.WRITE_DISCARD,
        0,
        &subresource,
    ));
    std.mem.copy(
        u8,
        @ptrCast([*]u8, subresource.pData)[offset..(offset + bytes.len)],
        bytes,
    );
    device_ctx.Unmap(constant_buffer, 0);
}

pub fn setConstantBuffer(buffer_handle: types.ConstantBufferHandle) void {
    const buffer = constant_buffers.items[buffer_handle];
    const buffers = [_]*d3d11.IBuffer{buffer.buffer};
    getD3D11DeviceContext().VSSetConstantBuffers(
        buffer.slot,
        1,
        @ptrCast([*]const *d3d11.IBuffer, &buffers),
    );
    getD3D11DeviceContext().PSSetConstantBuffers(
        buffer.slot,
        1,
        @ptrCast([*]const *d3d11.IBuffer, &buffers),
    );
}

pub fn createRasteriserState() !types.RasteriserStateHandle {
    var res: ?*d3d11.IRasterizerState = null;
    const desc = d3d11.RASTERIZER_DESC{
        .FrontCounterClockwise = TRUE,
    };
    try win32.hrErrorOnFail(getD3D11Device().CreateRasterizerState(&desc, &res));
    return @ptrToInt(res);
}

pub fn setRasteriserState(state_handle: types.RasteriserStateHandle) void {
    const state = @intToPtr(*d3d11.IRasterizerState, state_handle);
    getD3D11DeviceContext().RSSetState(state);
}

pub fn createBlendState() !types.BlendStateHandle {
    var blend_state: ?*d3d11.IBlendState = null;
    var rt_blend_descs: [8]d3d11.RENDER_TARGET_BLEND_DESC = undefined;
    rt_blend_descs[0] = .{
        .BlendEnable = TRUE,
        .SrcBlend = .SRC_ALPHA,
        .DestBlend = .INV_SRC_ALPHA,
        .BlendOp = .ADD,
        .SrcBlendAlpha = .ONE,
        .DestBlendAlpha = .ZERO,
        .BlendOpAlpha = .ADD,
        .RenderTargetWriteMask = d3d11.COLOR_WRITE_ENABLE_ALL,
    };
    const desc = d3d11.BLEND_DESC{
        .AlphaToCoverageEnable = FALSE,
        .IndependentBlendEnable = FALSE,
        .RenderTarget = rt_blend_descs,
    };
    try win32.hrErrorOnFail(getD3D11Device().CreateBlendState(
        &desc,
        &blend_state,
    ));
    return @ptrToInt(blend_state.?);
}

pub fn setBlendState(blend_state_handle: types.BlendStateHandle) void {
    const blend_state = @intToPtr(*d3d11.IBlendState, blend_state_handle);
    getD3D11DeviceContext().OMSetBlendState(
        blend_state,
        null,
        0xffffffff,
    );
}

pub fn setShaderProgram(program_handle: types.ShaderProgramHandle) void {
    const device_ctx = getD3D11DeviceContext();
    const shader_program = shader_programs.items[program_handle];
    device_ctx.IASetInputLayout(shader_program.input_layout);
    device_ctx.VSSetShader(shader_program.vs, null, 0);
    device_ctx.PSSetShader(shader_program.ps, null, 0);
}

pub fn createUniformColourShader() !types.ShaderProgramHandle {
    const shader_src = @embedFile("data/uniform_colour.hlsl");

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
            .SemanticName = "POSITION",
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

pub fn createTexturedVertsShader() !types.ShaderProgramHandle {
    const shader_src = @embedFile("data/textured_verts.hlsl");

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
            .SemanticName = "POSITION",
            .SemanticIndex = 0,
            .Format = dxgi.FORMAT.R32G32B32_FLOAT,
            .InputSlot = 0,
            .AlignedByteOffset = 0,
            .InputSlotClass = d3d11.INPUT_CLASSIFICATION.INPUT_PER_VERTEX_DATA,
            .InstanceDataStepRate = 0,
        },
        .{
            .SemanticName = "TEXCOORD",
            .SemanticIndex = 0,
            .Format = dxgi.FORMAT.R32G32_FLOAT,
            .InputSlot = 0,
            .AlignedByteOffset = 12,
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

fn formatToDxgiFormat(format: types.TextureFormat) dxgi.FORMAT {
    return switch (format) {
        .uint8 => dxgi.FORMAT.R8_UNORM,
    };
}
