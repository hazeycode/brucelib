const std = @import("std");
const builtin = @import("builtin");

const backend = switch (builtin.os.tag) {
    .linux => @import("linux.zig"),
    .macos => @import("macos.zig"),
    .windows => @import("win32.zig"),
    else => @compileError("Unsupported target"),
};

pub usingnamespace backend;

pub const FrameInput = @import("FrameInput.zig");

pub const AudioPlaybackBuffer = struct {
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
};

pub fn audioEnabled() bool {
    return (backend.audio_playback.enabled and switch (builtin.os.tag) {
        .windows => true,
        else => false,
    });
}

/// Get a buffer to write audio to. `audioPlaybackCommit` should be called as soon
/// as possible following this.
/// the caller is responsible for free'ing the allocated sample buffer
pub fn audioPlaybackBegin(allocator: std.mem.Allocator) !AudioPlaybackBuffer {
    if (audioEnabled() == false) {
        return AudioPlaybackBuffer{
            .cursor = 0,
            .rewrite = 0,
            .channels = 0,
            .sample_rate = 0,
            .min_frames = 0,
            .max_frames = 0,
            .sample_buf = undefined,
        };
    }

    const num_channels = backend.audio_playback.stream.num_channels;
    const sample_rate = backend.audio_playback.stream.sample_rate;

    const samples_per_frame = sample_rate / backend.target_framerate;
    const frames_per_frame = samples_per_frame / num_channels;

    const min_frames = frames_per_frame * 2;

    var samples_queued = @atomicLoad(usize, &backend.audio_playback.samples_queued, .Monotonic);

    const max_samples = backend.audio_playback.ring_buf.len / 2;

    var max_frames = max_samples / num_channels;
    if (max_frames < min_frames) max_frames = min_frames;

    const rewrite = @intCast(
        u32,
        std.math.max(0, @intCast(i64, samples_queued) - min_frames * num_channels),
    );

    // if (rewrite > 0) std.log.debug("rewrite {} samples", .{rewrite});

    samples_queued = @atomicLoad(usize, &backend.audio_playback.samples_queued, .Acquire);
    while (@cmpxchgWeak(
        usize,
        &backend.audio_playback.samples_queued,
        samples_queued,
        samples_queued - @intCast(usize, rewrite),
        .Release,
        .Monotonic,
    )) |val| {
        samples_queued = val;
    }

    backend.audio_playback.write_cursor -= rewrite / num_channels;

    return AudioPlaybackBuffer{
        .cursor = backend.audio_playback.write_cursor,
        .rewrite = rewrite / num_channels,
        .channels = num_channels,
        .sample_rate = sample_rate,
        .min_frames = min_frames,
        .max_frames = max_frames,
        .sample_buf = try allocator.alloc(f32, max_samples),
    };
}

/// queues the given audio buffer for the audio thread to write to the playback stream
pub fn audioPlaybackCommit(buffer: AudioPlaybackBuffer, num_frames: usize) void {
    if (audioEnabled() == false) {
        return;
    }

    std.debug.assert(num_frames <= buffer.max_frames);
    std.debug.assert(num_frames >= buffer.min_frames);

    const num_samples = num_frames * buffer.channels;

    { // move write_cur back to rewrite
        var i: usize = 0;
        while (i < buffer.rewrite * buffer.channels) : (i += 1) {
            backend.audio_playback.ring_write_cur = if (backend.audio_playback.ring_write_cur == 0) backend.audio_playback.ring_buf.len - 1 else backend.audio_playback.ring_write_cur - 1;
        }
    }

    { // copy samples from user buffer into ring buffer
        var i: usize = 0;
        while (i < num_samples) : (i += 1) {
            backend.audio_playback.ring_buf[backend.audio_playback.ring_write_cur] = buffer.sample_buf[i];
            backend.audio_playback.ring_write_cur = (backend.audio_playback.ring_write_cur + 1) % backend.audio_playback.ring_buf.len;
        }
    }

    std.debug.assert(backend.audio_playback.read_cursor <= backend.audio_playback.write_cursor);

    backend.audio_playback.latency[backend.audio_playback.latency_cur] = backend.audio_playback.write_cursor - backend.audio_playback.read_cursor;

    if (backend.audio_playback.latency_cur + 1 == backend.max_audio_latency_samples) {
        backend.audio_playback.latency_avg = 0;
        var i: usize = 0;
        while (i < backend.max_audio_latency_samples) : (i += 1) {
            backend.audio_playback.latency_avg += backend.audio_playback.latency[i];
        }
        backend.audio_playback.latency_avg /= backend.max_audio_latency_samples;
        backend.audio_playback.latency_cur = 0;
    } else backend.audio_playback.latency_cur += 1;

    backend.audio_playback.write_cursor += num_frames;

    var samples_queued = @atomicLoad(usize, &backend.audio_playback.samples_queued, .Acquire);
    while (@cmpxchgWeak(
        usize,
        &backend.audio_playback.samples_queued,
        samples_queued,
        samples_queued + num_samples,
        .Release,
        .Monotonic,
    )) |val| {
        samples_queued = val;
    }

    // std.log.debug("write cur = {}", .{backend.audio_playback.ring_write_cur});
}

test {
    std.testing.refAllDecls(@This());
}
