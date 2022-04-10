const builtin = @import("builtin");
const std = @import("std");
const testing = std.testing;

const alsa = @import("main.zig");

test "pcm playback" {
    var device: ?*alsa.snd_pcm_t = null;
    _ = try alsa.checkError(alsa.snd_pcm_open(
        &device,
        "default",
        alsa.snd_pcm_stream_t.PLAYBACK,
        0,
    ));

    var hw_params: ?*alsa.snd_pcm_hw_params_t = null;
    _ = try alsa.checkError(alsa.snd_pcm_hw_params_malloc(&hw_params));
    defer alsa.snd_pcm_hw_params_free(hw_params);

    _ = try alsa.checkError(alsa.snd_pcm_hw_params_any(device, hw_params));

    _ = try alsa.checkError(alsa.snd_pcm_hw_params_set_rate_resample(
        device,
        hw_params,
        1,
    ));

    _ = try alsa.checkError(alsa.snd_pcm_hw_params_set_access(
        device,
        hw_params,
        alsa.snd_pcm_access_t.RW_INTERLEAVED,
    ));

    _ = try alsa.checkError(alsa.snd_pcm_hw_params_set_format(
        device,
        hw_params,
        switch (builtin.target.cpu.arch.endian()) {
            .Little => alsa.snd_pcm_format_t.FLOAT_LE,
            .Big => alsa.snd_pcm_format_t.FLOAT_BE,
        },
    ));

    const num_channels = 2;
    _ = try alsa.checkError(alsa.snd_pcm_hw_params_set_channels(
        device,
        hw_params,
        num_channels,
    ));

    var sample_rate: c_uint = 44100;
    _ = try alsa.checkError(alsa.snd_pcm_hw_params_set_rate_near(
        device,
        hw_params,
        &sample_rate,
        null,
    ));

    _ = try alsa.checkError(alsa.snd_pcm_hw_params(device, hw_params));

    var buffer_frames: alsa.snd_pcm_uframes_t = undefined;
    _ = try alsa.checkError(alsa.snd_pcm_hw_params_get_buffer_size(
        hw_params,
        &buffer_frames,
    ));

    var buffer = try std.testing.allocator.alloc(f32, buffer_frames * num_channels);
    defer std.testing.allocator.free(buffer);

    const pitch: f32 = 261.63;
    const radians_per_sec = pitch * 2 * std.math.pi;
    const sec_per_frame = 1 / @intToFloat(f32, sample_rate);

    _ = try alsa.checkError(alsa.snd_pcm_prepare(device));

    var frame: usize = 0;
    while (frame < buffer_frames) : (frame += 1) {
        const s = std.math.sin((@intToFloat(f32, frame) * sec_per_frame) * radians_per_sec);
        var channel: usize = 0;
        while (channel < num_channels) : (channel += 1) {
            buffer[frame * num_channels + channel] = s;
        }
    }

    std.log.warn(
        "playing {} seconds of samples...",
        .{buffer_frames / sample_rate},
    );

    if (alsa.snd_pcm_writei(
        device,
        @ptrCast(*anyopaque, buffer),
        buffer_frames,
    ) < 0) {
        _ = try alsa.checkError(alsa.snd_pcm_prepare(device));
    }

    _ = try alsa.checkError(alsa.snd_pcm_drain(device));

    _ = try alsa.checkError(alsa.snd_pcm_close(device));
}
