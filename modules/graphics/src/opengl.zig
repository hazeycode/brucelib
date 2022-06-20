const std = @import("std");
const gl = @import("zig-opengl");

const log = std.log.scoped(.@"brucelib.graphics.opengl");

const common = @import("common.zig");
const BufferHandle = common.BufferHandle;
const VertexLayoutDesc = common.VertexLayoutDesc;
const VertexLayoutHandle = common.VertexLayoutHandle;
const TextureFormat = common.TextureFormat;
const TextureHandle = common.TextureHandle;
const RasteriserStateHandle = common.RasteriserStateHandle;
const BlendStateHandle = common.BlendStateHandle;
const ShaderProgramHandle = common.ShaderProgramHandle;
const FenceHandle = common.FenceHandle;
const FenceState = common.FenceState;

var allocator: std.mem.Allocator = undefined;

pub fn init(comptime platform: anytype, _allocator: std.mem.Allocator) !void {
    allocator = _allocator;

    var null_context: ?*anyopaque = null;
    try gl.load(null_context, platform.getOpenGlProcAddress);

    gl.enable(gl.MULTISAMPLE);
}

pub fn deinit() void {}

pub fn sync() void {
    gl.finish();
}

pub fn fence() FenceHandle {
    return @ptrToInt(gl.fenceSync(gl.SYNC_GPU_COMMANDS_COMPLETE, 0));
}

pub fn wait_fence(fence_handle: FenceHandle, timeout: u64) !FenceState {
    const wait_res = gl.clientWaitSync(
        @intToPtr(gl.GLsync, fence_handle),
        gl.SYNC_FLUSH_COMMANDS_BIT,
        timeout,
    );
    return switch (wait_res) {
        gl.ALREADY_SIGNALED => FenceState.already_signaled,
        gl.TIMEOUT_EXPIRED => FenceState.timeout_expired,
        gl.CONDITION_SATISFIED => FenceState.signaled,
        gl.WAIT_FAILED => error.WaitFenceFailed, // TODO(hazeycode): map glError to error type
        else => error.UnknownState,
    };
}

pub fn log_debug_messages() !void {}

pub fn set_viewport(x: i32, y: i32, width: u16, height: u16) void {
    gl.viewport(x, y, width, height);
}

pub fn clear_with_colour(r: f32, g: f32, b: f32, a: f32) void {
    gl.clearColor(r, g, b, a);
    gl.clear(gl.COLOR_BUFFER_BIT);
}

pub fn draw(offset: u32, count: u32) void {
    gl.drawArrays(
        gl.TRIANGLES,
        @intCast(gl.GLint, offset),
        @intCast(gl.GLsizei, count),
    );
}

pub fn create_vertex_buffer_with_bytes(vertices: []const u8) !BufferHandle {
    var vbo: gl.GLuint = undefined;
    gl.genBuffers(1, &vbo);
    gl.bindBuffer(gl.ARRAY_BUFFER, vbo);
    gl.bufferData(gl.ARRAY_BUFFER, vertices.len, vertices.ptr, gl.STATIC_DRAW);
    return vbo;
}

pub fn create_vertex_buffer_persistent(size: u32) !BufferHandle {
    var vbo: gl.GLuint = undefined;
    gl.genBuffers(1, &vbo);
    gl.bindBuffer(gl.ARRAY_BUFFER, vbo);
    gl.bufferStorage(
        gl.ARRAY_BUFFER,
        @intCast(gl.GLsizei, size),
        null,
        gl.MAP_WRITE_BIT | gl.MAP_PERSISTENT_BIT | gl.MAP_COHERENT_BIT,
    );
    return vbo;
}

pub fn destroy_buffer(buffer_handle: BufferHandle) !void {
    const buffer = @intCast(gl.GLenum, buffer_handle);
    gl.deleteBuffers(1, &buffer);
}

pub fn map_buffer_persistent(
    buffer_handle: BufferHandle,
    size: usize,
    comptime alignment: u7,
) ![]align(alignment) u8 {
    const buffer = @intCast(gl.GLenum, buffer_handle);
    gl.bindBuffer(gl.ARRAY_BUFFER, buffer);

    const maybe_ptr = gl.mapBufferRange(
        gl.ARRAY_BUFFER,
        0,
        @intCast(isize, size),
        gl.MAP_WRITE_BIT | gl.MAP_PERSISTENT_BIT | gl.MAP_COHERENT_BIT,
    );

    if (maybe_ptr) |ptr| {
        return @alignCast(alignment, @ptrCast([*]u8, ptr)[0..size]);
    } else {
        return error.FailedToMapBuffer;
    }
}

pub fn unmap_buffer(buffer_handle: BufferHandle) void {
    const buffer = @intCast(gl.GLenum, buffer_handle);
    gl.bindBuffer(gl.ARRAY_BUFFER, buffer);

    _ = gl.unmapBuffer(gl.ARRAY_BUFFER);
}

pub fn create_vertex_layout(layout_desc: VertexLayoutDesc) !VertexLayoutHandle {
    var vao: gl.GLuint = undefined;
    gl.genVertexArrays(1, &vao);
    gl.bindVertexArray(@intCast(gl.GLuint, vao));

    for (layout_desc.entries) |entry, i| {
        gl.bindBuffer(gl.ARRAY_BUFFER, @intCast(gl.GLuint, entry.buffer_handle));

        var attrib_offset: usize = 0;
        for (entry.attributes) |attr, j| {
            const num_components = attr.get_num_components();
            const component_type: gl.GLenum = switch (attr.format) {
                .f32x2, .f32x3, .f32x4 => gl.FLOAT,
            };
            gl.enableVertexAttribArray(@intCast(gl.GLuint, j));
            gl.vertexAttribPointer(
                @intCast(gl.GLuint, j),
                @intCast(gl.GLint, num_components),
                component_type,
                gl.FALSE,
                @intCast(gl.GLsizei, entry.get_stride()),
                if (attrib_offset == 0) null else @intToPtr(*anyopaque, attrib_offset),
            );
            attrib_offset += attr.get_size();
        }

        gl.enableVertexAttribArray(@intCast(gl.GLuint, i));
    }

    return vao;
}

pub fn bind_vertex_layout(layout_handle: VertexLayoutHandle) void {
    gl.bindVertexArray(@intCast(gl.GLuint, layout_handle));
}

pub fn createTexture2dWithBytes(bytes: []const u8, width: u32, height: u32, format: TextureFormat) !TextureHandle {
    var texture: gl.GLuint = undefined;
    gl.genTextures(1, &texture);
    gl.bindTexture(gl.TEXTURE_2D, texture);
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.REPEAT);
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.REPEAT);
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
    gl.pixelStorei(gl.UNPACK_ALIGNMENT, 1);
    gl.texImage2D(
        gl.TEXTURE_2D,
        0,
        formatToGlInternalFormat(format),
        @intCast(gl.GLsizei, width),
        @intCast(gl.GLsizei, height),
        0,
        formatToGlFormat(format),
        formatToGlDataType(format),
        bytes.ptr,
    );
    return texture;
}

pub fn bind_texture(slot: u32, texture_handle: TextureHandle) void {
    // skip binding 0, which is used for the uniform block
    const binding = 1 + switch (slot) {
        0 => @as(gl.GLenum, gl.TEXTURE0),
        1 => gl.TEXTURE1,
        else => {
            std.debug.assert(false);
            return;
        },
    };
    gl.activeTexture(@intCast(gl.GLenum, binding));
    gl.bindTexture(gl.TEXTURE_2D, @intCast(gl.GLuint, texture_handle));
}

pub fn create_constant_buffer(size: usize) !BufferHandle {
    var ubo: gl.GLuint = undefined;
    gl.genBuffers(1, &ubo);
    gl.bindBuffer(gl.UNIFORM_BUFFER, ubo);
    gl.bufferData(gl.UNIFORM_BUFFER, @intCast(gl.GLsizeiptr, size), null, gl.DYNAMIC_DRAW);
    return ubo;
}

pub fn update_shader_constant_buffer(
    buffer_handle: BufferHandle,
    bytes: []const u8,
) !void {
    const ubo = @intCast(gl.GLuint, buffer_handle);
    gl.bindBuffer(gl.UNIFORM_BUFFER, ubo);
    gl.bufferSubData(
        gl.UNIFORM_BUFFER,
        @intCast(gl.GLintptr, 0),
        @intCast(gl.GLsizeiptr, bytes.len),
        bytes.ptr,
    );
    gl.bindBufferBase(gl.UNIFORM_BUFFER, 0, ubo);
}

pub fn set_constant_buffer(buffer_handle: BufferHandle) void {
    gl.bindBuffer(gl.UNIFORM_BUFFER, @intCast(gl.GLuint, buffer_handle));
}

pub fn create_raster_state() !RasteriserStateHandle {
    return 0;
}

pub fn set_raster_state(_: RasteriserStateHandle) void {
    gl.enable(gl.CULL_FACE);
    gl.cullFace(gl.BACK);
}

pub fn create_blend_state() !BlendStateHandle {
    return 0;
}

pub fn set_blend_state(_: BlendStateHandle) void {
    gl.enable(gl.BLEND);
    gl.blendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA);
}

pub fn set_shader_program(program_handle: ShaderProgramHandle) void {
    gl.useProgram(@intCast(gl.GLuint, program_handle));
}

pub fn createUniformColourShader() !ShaderProgramHandle {
    const vert_shader_src = @embedFile("../data/uniform_colour_vs.glsl");
    const frag_shader_src = @embedFile("../data/uniform_colour_fs.glsl");

    const vertex_shader = try compileShaderSource(.vertex, vert_shader_src);
    defer gl.deleteShader(vertex_shader);

    const fragment_shader = try compileShaderSource(.fragment, frag_shader_src);
    defer gl.deleteShader(fragment_shader);

    return try createShaderProgram(vertex_shader, fragment_shader);
}

pub fn createTexturedVertsShader() !ShaderProgramHandle {
    const vert_shader_src = @embedFile("../data/textured_verts_vs.glsl");
    const frag_shader_src = @embedFile("../data/textured_verts_fs.glsl");

    const vertex_shader = try compileShaderSource(.vertex, vert_shader_src);
    defer gl.deleteShader(vertex_shader);

    const fragment_shader = try compileShaderSource(.fragment, frag_shader_src);
    defer gl.deleteShader(fragment_shader);

    return try createShaderProgram(vertex_shader, fragment_shader);
}

pub fn createTexturedVertsMonoShader() !ShaderProgramHandle {
    const vert_shader_src = @embedFile("../data/textured_verts_vs.glsl");
    const frag_shader_src = @embedFile("../data/textured_verts_mono_fs.glsl");

    const vertex_shader = try compileShaderSource(.vertex, vert_shader_src);
    defer gl.deleteShader(vertex_shader);

    const fragment_shader = try compileShaderSource(.fragment, frag_shader_src);
    defer gl.deleteShader(fragment_shader);

    return try createShaderProgram(vertex_shader, fragment_shader);
}

fn compileShaderSource(stage: enum { vertex, fragment }, source: [:0]const u8) !u32 {
    var temp_arena = std.heap.ArenaAllocator.init(allocator);
    defer temp_arena.deinit();

    const shader = gl.createShader(switch (stage) {
        .vertex => gl.VERTEX_SHADER,
        .fragment => gl.FRAGMENT_SHADER,
    });
    errdefer gl.deleteShader(shader);

    gl.shaderSource(shader, 1, @ptrCast([*c]const [*c]const u8, &source), null);
    gl.compileShader(shader);

    var compile_status: gl.GLint = undefined;
    gl.getShaderiv(shader, gl.COMPILE_STATUS, &compile_status);
    if (compile_status == 0) {
        var log_len: gl.GLint = undefined;
        gl.getShaderiv(shader, gl.INFO_LOG_LENGTH, &log_len);
        if (log_len > 0) {
            const log_buffer = try temp_arena.allocator().alloc(u8, @intCast(usize, log_len));
            gl.getShaderInfoLog(shader, log_len, &log_len, @ptrCast([*c]u8, log_buffer));
            log.err("{s}", .{log_buffer});
        }

        return error.ShaderCompilationFailed;
    }

    return shader;
}

fn createShaderProgram(vertex_shader_handle: u32, fragment_shader_handle: u32) !u32 {
    var temp_arena = std.heap.ArenaAllocator.init(allocator);
    defer temp_arena.deinit();

    const program = gl.createProgram();
    errdefer gl.deleteProgram(program);

    gl.attachShader(program, vertex_shader_handle);
    gl.attachShader(program, fragment_shader_handle);

    gl.linkProgram(program);

    var link_status: gl.GLint = undefined;
    gl.getProgramiv(program, gl.LINK_STATUS, &link_status);
    if (link_status == 0) {
        var log_len: gl.GLint = undefined;
        gl.getProgramiv(program, gl.INFO_LOG_LENGTH, &log_len);
        if (log_len > 0) {
            const log_buffer = try temp_arena.allocator().alloc(u8, @intCast(usize, log_len));
            gl.getProgramInfoLog(program, log_len, &log_len, log_buffer.ptr);
            log.err("{s}", .{log_buffer});
        }
        return error.FailedToLinkShaderProgram;
    }

    return program;
}

fn formatToGlInternalFormat(format: TextureFormat) gl.GLint {
    return switch (format) {
        .uint8 => gl.R8,
        .rgba_u8 => gl.RGBA,
    };
}

fn formatToGlFormat(format: TextureFormat) gl.GLenum {
    return switch (format) {
        .uint8 => gl.RED,
        .rgba_u8 => gl.RGBA,
    };
}

fn formatToGlDataType(format: TextureFormat) gl.GLenum {
    return switch (format) {
        .uint8 => gl.UNSIGNED_BYTE,
        .rgba_u8 => gl.UNSIGNED_BYTE,
    };
}
