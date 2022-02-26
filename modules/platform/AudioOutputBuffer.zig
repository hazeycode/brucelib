/// audio frame cursor indicating where in time samples will be written to
cursor: u64,

/// the number of frames that will be overwritten
rewrite: u64,

/// number of output channels
channels: u32,

/// sample rate of the output stream
sample_rate: u32,

/// the minimum number of frames that should be written to supply enough audio not to underflow
min_frames: usize,

/// the maximum number of frames that can be written before overflowing the output stream
/// note: you may choose to overwrite at no cost but it may not sound good depending on your audio
max_frames: usize,

/// the buffer to write samples into
sample_buf: []f32,
