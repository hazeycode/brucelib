#version 420 core

layout (binding = 0, std140) uniform UniformBlock {
    mat4 mvp;
    vec4 colour;
};

layout (location = 0) in vec3 aPos;

void main() {
    gl_Position = mvp * vec4(aPos.x, aPos.y, aPos.z, 1.0);
}
