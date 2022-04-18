pub const SoundBuffer = struct {
    channels: u16,
    sample_rate: u32,
    samples: []f32,
};
