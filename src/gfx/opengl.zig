const std = @import("std");

const types = @import("types.zig");

const c = @cImport({
    @cInclude("epoxy/gl.h");
    @cInclude("epoxy/glx.h"); // TODO(chris): only include this when actually using glx
});

pub fn setViewport(x: u16, y: u16, width: u16, height: u16) void {
    c.glViewport(x, y, width, height);
}

pub fn clearWithColour(r: f32, g: f32, b: f32, a: f32) void {
    c.glClearColor(r, g, b, a);
    c.glClear(c.GL_COLOR_BUFFER_BIT);
}

pub fn createDynamicVertexBufferWithBytes(bytes: []const u8) types.VertexBufferHandle {
    var vbo: c.GLuint = undefined;
    c.glGenBuffers(1, &vbo);
    writeBytesToVertexBuffer(vbo, bytes);
    return vbo;
}

pub fn writeBytesToVertexBuffer(buffer_id: types.VertexBufferHandle, bytes: []const u8) void {
    c.glBindBuffer(c.GL_ARRAY_BUFFER, buffer_id);
    c.glBufferData(c.GL_ARRAY_BUFFER, @intCast(c_long, bytes.len), bytes.ptr, c.GL_DYNAMIC_DRAW);
}

pub fn createVertexLayout(layout_desc: types.VertexLayoutDesc) types.VertexLayoutHandle {
    var vao: c.GLuint = undefined;
    c.glGenVertexArrays(1, &vao);
    c.glBindVertexArray(vao);

    const stride: usize = blk: {
        var temp: usize = 0;
        for (layout_desc.attributes) |attrib_desc| {
            std.debug.assert(attrib_desc.num_components > 0 and attrib_desc.num_components <= 4);
            temp += attrib_desc.num_components * @sizeOf(f32);
        }
        break :blk temp;
    };

    var byte_offset: usize = 0;
    for (layout_desc.attributes) |attrib_desc, i| {
        c.glBindBuffer(c.GL_ARRAY_BUFFER, attrib_desc.buffer_handle);

        c.glVertexAttribPointer(
            @intCast(c_uint, i),
            @intCast(c_int, attrib_desc.num_components),
            c.GL_FLOAT,
            c.GL_FALSE,
            @intCast(c_int, stride),
            if (byte_offset == 0) null else @intToPtr(*anyopaque, byte_offset),
        );

        c.glEnableVertexAttribArray(@intCast(c_uint, i));

        byte_offset += attrib_desc.num_components * @sizeOf(f32);
    }

    return vao;
}

pub fn bindVertexLayout(layout_handle: types.VertexLayoutHandle) void {
    c.glBindVertexArray(layout_handle);
}

pub fn bindShaderProgram(program_handle: u32) void {
    c.glUseProgram(program_handle);
}

pub fn writeUniform(location: u32, components: []const f32) void {
    switch (components.len) {
        4 => c.glUniform4f(@intCast(c_int, location), components[0], components[1], components[2], components[3]),
        else => std.debug.assert(false),
    }
}

pub fn draw(offset: u32, count: usize) void {
    c.glDrawArrays(c.GL_TRIANGLES, @intCast(c_int, offset), @intCast(c_int, count));
}

pub fn createSolidColourShader(allocator: std.mem.Allocator) !types.ShaderProgramHandle {
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

    const vertex_shader = try compileShaderSource(allocator, .vertex, vert_shader_src);
    defer c.glDeleteShader(vertex_shader);

    const fragment_shader = try compileShaderSource(allocator, .fragment, frag_shader_src);
    defer c.glDeleteShader(fragment_shader);

    return createShaderProgram(allocator, vertex_shader, fragment_shader);
}

fn compileShaderSource(allocator: std.mem.Allocator, stage: enum { vertex, fragment }, source: [:0]const u8) !u32 {
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
            const log_buffer = try allocator.alloc(u8, @intCast(usize, log_len));
            defer allocator.free(log_buffer);
            c.glGetShaderInfoLog(shader, log_len, &log_len, @ptrCast([*c]u8, log_buffer));
            std.log.err("{s}", .{log_buffer});
        }

        return error.ShaderCompilationFailed;
    }

    return shader;
}

fn createShaderProgram(allocator: std.mem.Allocator, vertex_shader_handle: u32, fragment_shader_handle: u32) !u32 {
    const program = c.glCreateProgram();
    errdefer c.glDeleteProgram(program);

    c.glAttachShader(program, vertex_shader_handle);
    c.glAttachShader(program, fragment_shader_handle);

    c.glLinkProgram(program);

    var link_status: c.GLint = undefined;
    c.glGetProgramiv(program, c.GL_LINK_STATUS, &link_status);
    if (link_status == 0) {
        var log_len: c.GLint = undefined;
        if (log_len > 0) {
            const log_buffer = try allocator.alloc(u8, @intCast(usize, log_len));
            defer allocator.free(log_buffer);
            c.glGetProgramInfoLog(program, log_len, &log_len, log_buffer.ptr);
            std.log.err("{s}", .{log_buffer});
        }
        return error.FailedToLinkShaderProgram;
    }

    return program;
}
