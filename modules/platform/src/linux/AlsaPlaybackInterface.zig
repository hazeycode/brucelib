const builtin = @import("builtin");
const std = @import("std");

const alsa = @import("zig-alsa");

pub const AlsaPlaybackInterface = @This();

stream: *alsa.snd_pcm_t,
num_channels: u32,
sample_rate: u32,
bits_per_sample: u32,
buffer_frames: alsa.snd_pcm_uframes_t,
write_cursor: usize = 0,
read_cursor: usize = 0,

pub fn init(requested_sample_rate: u32, buffer_frames_requested: usize) !AlsaPlaybackInterface {
    var stream: *alsa.snd_pcm_t = undefined; 
    _ = try alsa.checkError(alsa.snd_pcm_open(
        @ptrCast(*?*alsa.snd_pcm_t, &stream),
        "default",
        alsa.snd_pcm_stream_t.PLAYBACK,
        alsa.SND_PCM_ASYNC,
    ));

    // hardware configuration...

    var hw_params: *alsa.snd_pcm_hw_params_t = undefined;
    _ = try alsa.checkError(
        alsa.snd_pcm_hw_params_malloc(
            @ptrCast(*?*alsa.snd_pcm_hw_params_t, &hw_params),
        ),
    );
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

    var sample_rate: c_uint = requested_sample_rate;
    _ = try alsa.checkError(alsa.snd_pcm_hw_params_set_rate_near(
        stream,
        hw_params,
        &sample_rate,
        null,
    ));

    _ = try alsa.checkError(alsa.snd_pcm_hw_params(stream, hw_params));

    var buf_frames: c_ulong = buffer_frames_requested;
    _ = try alsa.checkError(alsa.snd_pcm_hw_params_set_buffer_size_near(
        stream,
        hw_params,
        &buf_frames,
    ));

    std.log.debug("alsa buffer size: {} frames", .{buf_frames});

    // software configuration...

    // var sw_params: ?*alsa.snd_pcm_sw_params_t = null;
    // _ = try alsa.checkError(alsa.snd_pcm_sw_params_malloc(&sw_params));
    // defer alsa.snd_pcm_sw_params_free(sw_params);

    // _ = try alsa.checkError(alsa.snd_pcm_sw_params_set_start_threshold(
    //     stream,
    //     sw_params,
    //     sample_rate / num_channels / target_framerate,
    // ));

    return AlsaPlaybackInterface{
        .stream = stream,
        .num_channels = num_channels,
        .sample_rate = sample_rate,
        .bits_per_sample = num_channels * @sizeOf(f32),
        .buffer_frames = buf_frames,
    };
}

pub fn deinit(self: *AlsaPlaybackInterface) void {
    _ = alsa.snd_pcm_close(self.stream);
}

pub fn start(self: *AlsaPlaybackInterface) !void {
    _ = try alsa.checkError(alsa.snd_pcm_start(self.stream));
}

pub fn stop(self: *AlsaPlaybackInterface) !void {
    _ = try alsa.checkError(alsa.snd_pcm_drain(self.stream));
}

pub fn prepare(self: *AlsaPlaybackInterface) !void {
    _ = try alsa.checkError(alsa.snd_pcm_prepare(self.stream));
}

pub fn waitBufferReady(self: AlsaPlaybackInterface) !void {
    const res = try alsa.checkError(alsa.snd_pcm_wait(self.stream, -1));
    switch (res) {
        0 => return error.TimedOut,
        1 => {},
        else => {
            std.log.warn("unexpected snd_pcm_wait return value {}", .{res});
        },
    }
}

pub fn getBufferFramesAvailable(self: *AlsaPlaybackInterface) !usize {
    const avail = try alsa.checkError(alsa.snd_pcm_avail_update(self.stream));
    return @intCast(usize, avail);
}

pub fn getBufferFramesRewindable(self: *AlsaPlaybackInterface) !usize {
    return try alsa.checkError(alsa.snd_pcm_rewindable(self.stream));
}

pub fn rewindBuffer(self: *AlsaPlaybackInterface, frames: usize) !usize {
    const dist = try alsa.checkError(alsa.snd_pcm_rewind(
        self.stream,
        @intCast(alsa.snd_pcm_sframes_t, frames),
    ));
    self.write_cursor -= dist;
    return dist;
}

pub fn writeSamples(self: *AlsaPlaybackInterface, samples: []f32) bool {
    const res = alsa.snd_pcm_writei(self.stream, samples.ptr, samples.len / self.num_channels);
    return (res >= 0);
}

pub fn getLatency(self: *AlsaPlaybackInterface) !usize {
    var io_latency: alsa.snd_pcm_sframes_t = undefined;
    _ = try alsa.checkError(alsa.snd_pcm_delay(self.stream, &io_latency));
    return self.write_cursor - self.read_cursor + @intCast(usize, io_latency);
}
