pub const ShaderProgramHandle = u64;
pub const VertexBufferHandle = u64;
pub const VertexLayoutHandle = u64;

pub const VertexLayoutDesc = struct {
    pub const Attribute = struct {
        buffer_handle: VertexBufferHandle,
        num_components: u32,
    };
    attributes: []Attribute,
};
