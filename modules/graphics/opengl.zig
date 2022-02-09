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

pub fn createDynamicVertexBufferWithBytes(bytes: []const u8) !types.VertexBufferHandle {
    var vbo: c.GLuint = undefined;
    c.glGenBuffers(1, &vbo);
    writeBytesToVertexBuffer(vbo, bytes);
    return vbo;
}

pub fn writeBytesToVertexBuffer(buffer_id: types.VertexBufferHandle, bytes: []const u8) !void {
    c.glBindBuffer(c.GL_ARRAY_BUFFER, buffer_id);
    c.glBufferData(c.GL_ARRAY_BUFFER, @intCast(c_long, bytes.len), bytes.ptr, c.GL_DYNAMIC_DRAW);
}

pub fn createVertexLayout(layout_desc: types.VertexLayoutDesc) types.VertexLayoutHandle {
    var vao: c.GLuint = undefined;
    c.glGenVertexArrays(1, &vao);
    c.glBindVertexArray(vao);

    for (layout_desc.entries) |entry, i| {
        c.glBindBuffer(c.GL_ARRAY_BUFFER, entry.buffer_handle);

        var attrib_offset: usize = 0;
        for (entry.attributes) |attr, j| {
            const num_components = attr.getNumComponents();
            const component_type = switch (attr) {
                .f32x3, .f32x4 => c.GL_FLOAT,
            };
            c.glVertexAttribPointer(
                @intCast(c_uint, j),
                @intCast(c_int, num_components),
                component_type,
                c.GL_FALSE,
                @intCast(c_int, entry.getStride()),
                if (attrib_offset == 0) null else @intToPtr(*anyopaque, attrib_offset),
            );
            attrib_offset += num_components * @sizeOf(f32);
        }

        c.glEnableVertexAttribArray(@intCast(c_uint, i));
    }

    return vao;
}

pub fn createRasteriserState() types.RasteriserStateHandle {
    return 0;
}

pub fn bindVertexLayout(layout_handle: types.VertexLayoutHandle) void {
    c.glBindVertexArray(layout_handle);
}

pub fn bindRasterizerState(_: types.RasteriserStateHandle) void {}

pub fn bindShaderProgram(program_handle: types.ShaderProgramHandle) void {
    c.glUseProgram(program_handle);
}

// TODO(hazeycode): generalise this
pub fn writeUniform(location: u32, components: []const f32) void {
    switch (components.len) {
        4 => c.glUniform4f(@intCast(c_int, location), components[0], components[1], components[2], components[3]),
        else => std.debug.assert(false),
    }
}

pub fn draw(offset: u32, count: u32) void {
    c.glDrawArrays(c.GL_TRIANGLES, @intCast(c_int, offset), @intCast(c_int, count));
}

pub fn createSolidColourShader() !types.ShaderProgramHandle {
    const vert_shader_src =
        \\#version 330 core
        \\layout (location = 0) in vec3 aPos;
        \\
        \\void main()
        \\{
        \\    gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);
        \\}
        \\
    ;

    const frag_shader_src =
        \\#version 330 core
        \\
        \\uniform vec4 colour_in;
        \\
        \\out vec4 colour_out;
        \\
        \\void main()
        \\{
        \\    colour_out = colour_in;
        \\}
        \\
    ;

    const vertex_shader = try compileShaderSource(.vertex, vert_shader_src);
    defer c.glDeleteShader(vertex_shader);

    const fragment_shader = try compileShaderSource(.fragment, frag_shader_src);
    defer c.glDeleteShader(fragment_shader);

    return createShaderProgram(vertex_shader, fragment_shader);
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
