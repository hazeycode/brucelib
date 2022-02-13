#version 420 core

layout (std140, binding = 0) uniform UniformBlock {
    vec4 colour;
};

out vec4 colour_out;

void main() {
    colour_out = colour;
}
