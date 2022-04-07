//! This file defines the structure that is passed to the audio playback fn by the platform layer

/// The sample rate of the output stream
sample_rate: u32,

/// The number of output channels
channels: u32,

/// The buffer to write samples to
sample_buf: []f32,
