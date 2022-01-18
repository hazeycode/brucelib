pub const ShaderProgramHandle = u32;
pub const VertexBufferHandle = u32;
pub const VertexLayoutHandle = u32;

pub const VertexLayoutDesc = struct {
    pub const Attribute = struct {
        buffer_handle: VertexBufferHandle,
        num_components: u32,
    };
    attributes: []Attribute,
};
