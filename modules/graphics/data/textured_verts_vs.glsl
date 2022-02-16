#version 420 core

layout (binding = 0, std140) uniform UniformBlock {
    mat4 mvp;
    vec4 colour;
};

layout (location = 0) in vec3 in_pos;
layout (location = 1) in vec2 in_tex_coord;

out vec2 tex_coord;

void main() {
    gl_Position = mvp * vec4(in_pos.x, in_pos.y, in_pos.z, 1.0);
    tex_coord = in_tex_coord;
}
