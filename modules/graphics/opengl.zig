const std = @import("std");

const types = @import("types.zig");

// TODO(chris): Remove epoxy system dependency
const c = @cImport({
    @cInclude("epoxy/gl.h");
});

var allocator: std.mem.Allocator = undefined;

pub fn init(_allocator: std.mem.Allocator) void {
    allocator = _allocator;
}

pub fn deinit() void {}

pub fn setViewport(x: u16, y: u16, width: u16, height: u16) void {
    c.glViewport(x, y, width, height);
}

pub fn clearWithColour(r: f32, g: f32, b: f32, a: f32) void {
    c.glClearColor(r, g, b, a);
    c.glClear(c.GL_COLOR_BUFFER_BIT);
}

pub fn draw(offset: u32, count: u32) void {
    c.glDrawArrays(c.GL_TRIANGLES, @intCast(c_int, offset), @intCast(c_int, count));
}

pub fn createDynamicVertexBufferWithBytes(bytes: []const u8) !types.VertexBufferHandle {
    var vbo: c.GLuint = undefined;
    c.glGenBuffers(1, &vbo);
    try writeBytesToVertexBuffer(vbo, bytes);
    return vbo;
}

pub fn writeBytesToVertexBuffer(buffer_id: types.VertexBufferHandle, bytes: []const u8) !void {
    c.glBindBuffer(c.GL_ARRAY_BUFFER, @intCast(c.GLenum, buffer_id));
    c.glBufferData(c.GL_ARRAY_BUFFER, @intCast(c.GLuint, bytes.len), bytes.ptr, c.GL_DYNAMIC_DRAW);
}

pub fn createVertexLayout(layout_desc: types.VertexLayoutDesc) !types.VertexLayoutHandle {
    var vao: c.GLuint = undefined;
    c.glGenVertexArrays(1, &vao);
    c.glBindVertexArray(@intCast(c.GLuint, vao));

    for (layout_desc.entries) |entry, i| {
        c.glBindBuffer(c.GL_ARRAY_BUFFER, @intCast(c.GLuint, entry.buffer_handle));

        var attrib_offset: usize = 0;
        for (entry.attributes) |attr, j| {
            const num_components = attr.getNumComponents();
            const component_type: c.GLenum = switch (attr.format) {
                .f32x3, .f32x4 => c.GL_FLOAT,
            };
            c.glVertexAttribPointer(
                @intCast(c.GLuint, j),
                @intCast(c.GLint, num_components),
                component_type,
                c.GL_FALSE,
                @intCast(c.GLsizei, entry.getStride()),
                if (attrib_offset == 0) null else @intToPtr(*anyopaque, attrib_offset),
            );
            attrib_offset += attr.getSize();
        }

        c.glEnableVertexAttribArray(@intCast(c.GLuint, i));
    }

    return vao;
}

pub fn useVertexLayout(layout_handle: types.VertexLayoutHandle) void {
    c.glBindVertexArray(@intCast(c.GLuint, layout_handle));
}

pub fn createConstantBuffer(size: usize) !types.ConstantBufferHandle {
    var ubo: c.GLuint = undefined;
    c.glGenBuffers(1, &ubo);
    c.glBindBuffer(c.GL_UNIFORM_BUFFER, ubo);
    c.glBufferData(
        c.GL_UNIFORM_BUFFER,
        @intCast(c.GLsizeiptr, size),
        null,
        c.GL_DYNAMIC_DRAW
    );
    return ubo;
}

pub fn bindConstantBuffer(
    slot: u32,
    buffer_handle: types.ConstantBufferHandle,
    offset: usize,
    width: usize,
) void {
    c.glBindBufferRange(
        c.GL_UNIFORM_BUFFER,
        slot,
        @intCast(c.GLuint, buffer_handle),
        @intCast(c.GLintptr, offset),
        @intCast(c.GLsizeiptr, width),
    );
}

pub fn writeShaderConstant(
    buffer_handle: types.ConstantBufferHandle,
    offset: usize,
    bytes: []const u8,
) void {
    c.glBindBuffer(c.GL_UNIFORM_BUFFER, @intCast(c.GLuint, buffer_handle));
    c.glBufferSubData(
        c.GL_UNIFORM_BUFFER,
        @intCast(c.GLintptr, offset),
        @intCast(c.GLsizeiptr, bytes.len),
        bytes.ptr,
    );
}

pub fn useConstantBuffer(buffer_handle: types.ConstantBufferHandle) void {
    c.glBindBuffer(c.GL_UNIFORM_BUFFER, @intCast(c.GLuint, buffer_handle));
}

pub fn createRasteriserState() !types.RasteriserStateHandle {
    return 0;
}

pub fn useRasteriserState(_: types.RasteriserStateHandle) void {}

pub fn useShaderProgram(program_handle: types.ShaderProgramHandle) void {
    c.glUseProgram(@intCast(c.GLuint, program_handle));
}

pub fn createSolidColourShader() !types.ShaderProgramHandle {
    const vert_shader_src =
        \\#version 420 core
        \\
        \\layout (location = 0) in vec3 aPos;
        \\
        \\void main() {
        \\    gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);
        \\}
        \\
    ;

    const frag_shader_src =
        \\#version 420 core
        \\
        \\layout (std140, binding = 0) uniform UniformBlock {
        \\    vec4 colour;
        \\};
        \\
        \\out vec4 colour_out;
        \\
        \\void main() {
        \\    colour_out = colour;
        \\}
        \\
    ;

    const vertex_shader = try compileShaderSource(.vertex, vert_shader_src);
    defer c.glDeleteShader(vertex_shader);

    const fragment_shader = try compileShaderSource(.fragment, frag_shader_src);
    defer c.glDeleteShader(fragment_shader);

    return try createShaderProgram(vertex_shader, fragment_shader);
}

fn compileShaderSource(stage: enum { vertex, fragment }, source: [:0]const u8) !u32 {
    var temp_arena = std.heap.ArenaAllocator.init(allocator);
    defer temp_arena.deinit();

    const shader = c.glCreateShader(switch (stage) {
        .vertex => c.GL_VERTEX_SHADER,
        .fragment => c.GL_FRAGMENT_SHADER,
    });
    errdefer c.glDeleteShader(shader);

    c.glShaderSource(shader, 1, @ptrCast([*c]const [*c]const u8, &source), null);
    c.glCompileShader(shader);

    var compile_status: c.GLint = undefined;
    c.glGetShaderiv(shader, c.GL_COMPILE_STATUS, &compile_status);
    if (compile_status == 0) {
        var log_len: c.GLint = undefined;
        c.glGetShaderiv(shader, c.GL_INFO_LOG_LENGTH, &log_len);
        if (log_len > 0) {
            const log_buffer = try temp_arena.allocator().alloc(u8, @intCast(usize, log_len));
            c.glGetShaderInfoLog(shader, log_len, &log_len, @ptrCast([*c]u8, log_buffer));
            std.log.err("{s}", .{log_buffer});
        }

        return error.ShaderCompilationFailed;
    }

    return shader;
}

fn createShaderProgram(vertex_shader_handle: u32, fragment_shader_handle: u32) !u32 {
    var temp_arena = std.heap.ArenaAllocator.init(allocator);
    defer temp_arena.deinit();

    const program = c.glCreateProgram();
    errdefer c.glDeleteProgram(program);

    c.glAttachShader(program, vertex_shader_handle);
    c.glAttachShader(program, fragment_shader_handle);

    c.glLinkProgram(program);

    var link_status: c.GLint = undefined;
    c.glGetProgramiv(program, c.GL_LINK_STATUS, &link_status);
    if (link_status == 0) {
        var log_len: c.GLint = undefined;
        c.glGetProgramiv(program, c.GL_INFO_LOG_LENGTH, &log_len);
        if (log_len > 0) {
            const log_buffer = try temp_arena.allocator().alloc(u8, @intCast(usize, log_len));
            c.glGetProgramInfoLog(program, log_len, &log_len, log_buffer.ptr);
            std.log.err("{s}", .{log_buffer});
        }
        return error.FailedToLinkShaderProgram;
    }

    return program;
}
