const builtin = @import("builtin");
const std = @import("std");

const alsa = @import("zig-alsa");

pub const AlsaPlaybackStream = @This();

stream: *alsa.snd_pcm_t,
num_channels: u32,
sample_rate: u32,
bits_per_sample: u32,
write_cursor: usize = 0,
read_cursor: usize = 0,

pub fn init(target_framerate: u32) !AlsaPlaybackStream {
    var stream: ?*alsa.snd_pcm_t = null;
    _ = try alsa.checkError(alsa.snd_pcm_open(
        &stream,
        "default",
        alsa.snd_pcm_stream_t.PLAYBACK,
        alsa.SND_PCM_ASYNC,
    ));

    // hardware configuration...

    var hw_params: ?*alsa.snd_pcm_hw_params_t = null;
    _ = try alsa.checkError(alsa.snd_pcm_hw_params_malloc(&hw_params));
    defer alsa.snd_pcm_hw_params_free(hw_params);

    _ = try alsa.checkError(alsa.snd_pcm_hw_params_any(stream, hw_params));

    _ = try alsa.checkError(alsa.snd_pcm_hw_params_set_rate_resample(
        stream,
        hw_params,
        1,
    ));

    _ = try alsa.checkError(alsa.snd_pcm_hw_params_set_access(
        stream,
        hw_params,
        alsa.snd_pcm_access_t.RW_INTERLEAVED,
    ));

    _ = try alsa.checkError(alsa.snd_pcm_hw_params_set_format(
        stream,
        hw_params,
        switch (builtin.target.cpu.arch.endian()) {
            .Little => alsa.snd_pcm_format_t.FLOAT_LE,
            .Big => alsa.snd_pcm_format_t.FLOAT_BE,
        },
    ));

    const num_channels = 2;
    _ = try alsa.checkError(alsa.snd_pcm_hw_params_set_channels(
        stream,
        hw_params,
        num_channels,
    ));

    var sample_rate: c_uint = 48000;
    _ = try alsa.checkError(alsa.snd_pcm_hw_params_set_rate_near(
        stream,
        hw_params,
        &sample_rate,
        null,
    ));

    _ = try alsa.checkError(alsa.snd_pcm_hw_params(stream, hw_params));

    var buffer_frames: alsa.snd_pcm_uframes_t = undefined;
    _ = try alsa.checkError(alsa.snd_pcm_hw_params_get_buffer_size(
        hw_params,
        &buffer_frames,
    ));

    // const min_buffer_duration = 1 / @intCast(f32, target_framerate);

    // buffer_frames = @floatToInt(
    //     u32,
    //     min_buffer_duration * @intToFloat(f32, sample_rate / num_channels),
    // );

    // _ = try alsa.checkError(alsa.snd_pcm_hw_params_set_buffer_size(
    //     stream,
    //     hw_params,
    //     buffer_frames,
    // ));

    // software configuration...

    var sw_params: ?*alsa.snd_pcm_sw_params_t = null;
    _ = try alsa.checkError(alsa.snd_pcm_sw_params_malloc(&sw_params));
    defer alsa.snd_pcm_sw_params_free(sw_params);

    _ = try alsa.checkError(alsa.snd_pcm_sw_params_set_start_threshold(
        stream,
        sw_params,
        sample_rate / num_channels / target_framerate,
    ));

    // prepare stream

    _ = try alsa.checkError(alsa.snd_pcm_prepare(stream));

    return AlsaPlaybackStream{
        .stream = stream.?,
        .num_channels = num_channels,
        .sample_rate = sample_rate,
        .bits_per_sample = num_channels * @sizeOf(f32),
    };
}

pub fn deinit(self: *AlsaPlaybackStream) void {
    _ = alsa.snd_pcm_drain(self.stream);
    _ = alsa.snd_pcm_close(self.stream);
}

pub fn start(self: *AlsaPlaybackStream) !void {
    _ = try alsa.checkError(alsa.snd_pcm_start(self.stream));
}

pub fn stop(self: *AlsaPlaybackStream) !void {
    _ = try alsa.checkError(alsa.snd_pcm_drain(self.stream));
}

pub fn waitBufferReady(self: AlsaPlaybackStream) !void {
    const res = try alsa.checkError(alsa.snd_pcm_wait(self.stream, -1));
    switch (res) {
        0 => return error.TimedOut,
        1 => {},
        else => {
            std.log.warn("unexpected snd_pcm_wait return value {}", .{res});
        },
    }
}

pub fn getBufferFramesAvailable(self: *AlsaPlaybackStream) !usize {
    const avail = try alsa.checkError(alsa.snd_pcm_avail_update(self.stream));
    return @intCast(usize, avail);
}

pub fn getBufferFramesRewindable(self: *AlsaPlaybackStream) !usize {
    return try alsa.checkError(alsa.snd_pcm_rewindable(self.stream));
}

pub fn rewindBuffer(self: *AlsaPlaybackStream, frames: usize) !usize {
    const dist = try alsa.checkError(alsa.snd_pcm_rewind(
        self.stream,
        @intCast(alsa.snd_pcm_sframes_t, frames),
    ));
    self.write_cursor -= dist;
    return dist;
}

pub fn writeSamples(self: *AlsaPlaybackStream, samples: []f32) !usize {
    return try alsa.checkError(
        alsa.snd_pcm_writei(self.stream, samples.ptr, samples.len / self.num_channels),
    );
}

pub fn getLatency(self: *AlsaPlaybackStream) !usize {
    var io_latency: alsa.snd_pcm_sframes_t = undefined;
    _ = try alsa.checkError(alsa.snd_pcm_delay(self.stream, &io_latency));
    return self.write_cursor - self.read_cursor + @intCast(usize, io_latency);
}