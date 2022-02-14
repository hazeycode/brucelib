#version 330 core

in vec2 texCoord;

uniform sampler2D texture;

out vec4 colour_out;

void main() {
    colour_out = vec4(1, 1, 1, texture2D(texture, texCoord));
}
