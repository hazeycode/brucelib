const std = @import("std");

const log = std.log.scoped(.@"brucelib.audio");

const Sound = @import("Sound.zig");

const sin = std.math.sin;
const pi = std.math.pi;
const tao = 2 * pi;

pub const SineWave = struct {
    freq: f32,
    cursor: usize = 0,

    pub fn sound(self: *@This(), priority: Sound.Priority) Sound {
        return Sound.init(@ptrCast(*anyopaque, self), @This().sample, 1, priority);
    }

    pub fn sample(ptr: *anyopaque, sample_rate: u32, buffer: []f32) usize {
        const self = @ptrCast(*SineWave, @alignCast(@alignOf(*SineWave), ptr));

        for (buffer) |*s, i| {
            s.* = 0.5 * sin(
                @intToFloat(f32, self.cursor + i) * (tao * self.freq) / @intToFloat(f32, sample_rate),
            );
        }
        self.cursor += buffer.len;
        return buffer.len;
    }
};

/// Provides an interface for mixing multiple sounds together into an output buffer
// TODO(hazeycode): support for channel configs other than stereo
pub const Mixer = struct {
    // TODO(hazeycode): comptime Mixer params
    const num_inputs = 16;
    const input_buf_len = 2048;

    inputs: [num_inputs]Input,
    mutex: std.Thread.Mutex = .{},

    /// Represents an input channel that can be mixed with others
    const Input = struct {
        sound: ?Sound = null,
        gain: f32 = 0.67, // 0.0...1.0
        sends: [2]f32 = .{ 1.0, 1.0 }, // 0.0...1.0
        buffer: [input_buf_len]f32 = .{0} ** input_buf_len,
    };

    pub fn init() @This() {
        var res: @This() = .{ .inputs = undefined };
        for (res.inputs) |*input| input.* = .{};
        return res;
    }

    /// Play a sound
    /// Binds the sound to a free input channel or overrides a lower priority one
    /// Will be unbound if&when `sample_fn` writes no samples or when the user calls `stop` or `stopAll`
    /// Returns the input channel index that was bound or null if sound can't be played
    pub fn play(self: *@This(), sound_source: anytype, priority: Sound.Priority) ?u32 {
        std.debug.assert(@typeInfo(@TypeOf(sound_source)) == .Pointer);

        if (self.bindInput(sound_source, priority)) |input_channel_idx| {
            return input_channel_idx;
        } else {
            log.warn("No free mixer channels to play sound", .{});
            std.debug.assert(priority != .high);
        }
        return null;
    }

    /// Stop a playing sound by input channel index
    pub fn stop(self: *@This(), channel: u32) void {
        self.mutex.lock();
        defer self.mutex.unlock();

        self.inputs[channel].sound = null;
        log.debug("Stopped playing sound on mixer channel {}", .{channel});
    }

    /// Stop all playing sounds
    pub fn stopAll(self: *@This()) void {
        var i: usize = 0;
        while (i < self.inputs.len) : (i += 1) {
            self.stop(i);
        }
    }

    /// Mixes all input channel and write to the given buffer
    pub fn mix(
        self: *@This(),
        num_frames: u32,
        out_channels: u32,
        sample_rate: u32,
        sample_buf: []f32,
    ) void {
        self.mutex.lock();
        defer self.mutex.unlock();

        var frames_remaining: u32 = num_frames;
        while (frames_remaining > 0) {

            // buffer up input samples
            for (self.inputs) |*input, i| {
                if (input.sound) |*sound| {
                    const num_samples = num_frames * sound.channels;
                    const got_samples = sound.sample(
                        sample_rate,
                        input.buffer[0..num_samples],
                    );

                    // unbind if no samples were written
                    if (got_samples == 0) {
                        stop(self, @intCast(u32, i));
                    }
                }
            }

            const frames = num_frames;

            var n: u32 = 0;
            while (n < frames) : (n += 1) {
                var samples: [2]f32 = .{ 0, 0 };

                for (self.inputs) |input| {
                    if (input.sound) |sound| {
                        switch (sound.channels) {
                            1 => {
                                samples[0] += input.sends[0] * input.gain * input.buffer[n];
                                samples[1] += input.sends[1] * input.gain * input.buffer[n];
                            },
                            2 => {
                                samples[0] += input.sends[0] * input.gain * input.buffer[n * 2 + 0];
                                samples[1] += input.sends[1] * input.gain * input.buffer[n * 2 + 1];
                            },
                            else => std.debug.panic(
                                "Input has unsupported number of channels: {}",
                                .{sound.channels},
                            ),
                        }
                    }
                }

                sample_buf[n * out_channels + 0] = samples[0];
                sample_buf[n * out_channels + 1] = samples[1];
            }

            frames_remaining -= frames;
        }
    }

    /// Binds the sound to a free mixer channel or overrides a lower priority one
    /// Will be unbound if&when `sample_fn` writes no samples
    /// Returns the mixer channel index that was bound
    fn bindInput(self: *@This(), sound_source: anytype, priority: Sound.Priority) ?u32 {
        std.debug.assert(@typeInfo(@TypeOf(sound_source)) == .Pointer);

        self.mutex.lock();
        defer self.mutex.unlock();

        for (self.inputs) |*input, i| {
            if (input.sound == null) {
                input.sound = sound_source.sound(priority);
                return @intCast(u32, i);
            }
        }
        // If the sound is high priority, see if there is a lower priority sound
        // that we can it swap for
        if (priority == .high) {
            for (self.inputs) |*input, i| {
                if (input.sound.?.priority == .low) {
                    input.sound = sound_source.sound(priority);
                    return @intCast(u32, i);
                }
            }
        }
        return null;
    }
};

test {
    std.testing.refAllDecls(@This());
}
