#version 420 core

layout (binding = 0, std140) uniform UniformBlock {
    mat4 mvp;
    vec4 colour;
};

out vec4 colour_out;

void main() {
    colour_out = colour;
}
