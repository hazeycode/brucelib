#version 420 core

layout (binding = 1) uniform sampler2D texture_sampler;

in vec2 tex_coord;

out vec4 out_colour;

void main() {
    out_colour = texture(texture_sampler, tex_coord);
}
