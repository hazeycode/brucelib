# brucelib.audio
**WARNING: WORK IN PROGRESS**

Currently `Mixer` is limited to 16 input channels and stereo output. But this will be configurable in future revisions.

Initilise a `Mixer` with:
```zig
var audio_mixer = audio.Mixer.init();
```

Periodically call `Mixer.mix` with a buffer, i.e. from your audio callback, to get mixed samples out.

A `Mixer` provides a `play` function for playing sound sources. We pass a pointer to a sound source, a priority and an initial gain. The input channel index that was bound is returned, or null if there was none available.

NOTE: high priority sounds will eject low priority sounds if there are no free channels available.

NOTE: sound sources are unbound from input channels once they finish playing (when the sample fn writes 0 samples) or when stopped.

A sound source can be any structure that implements a function returning a `Sound`, of the form:
```zig
pub fn sound(self: *@This(), priority: Sound.Priority) Sound
```

There are currently 2 "builtin" sound source types provided by the module, `SineWave` and `BufferedSound`. Here's an example of playing a sine wave:

```zig
// play a Middle-A sine wave tone
var sine_wave = audio.SineWave{ .freq = 440.0 };
_ = audio_mixer.play(&sine_wave, .high, 1.0);
```

And an example usage of `BufferedSound`, which is constructed with `SoundBuffer` returned from the provided Wav file loader:

```zig
// play a wav file, looped
const reader = ... // a std.io.Reader
var music = audio.BufferedSound{
    .buffer = try audio.wav.read(allocator, reader),
    .loop = true,
};
_ = audio_mixer.play(&music, .high, 1.0);

// don't forget to free the allocated memory at some point
allocator.free(music.buffer.samples);
```

`audio.wav` also provides a `readFromBytes` fn for convenience.

Use `Mixer.setInputSourceGain` to change the gain of a playing sound. Note that it is cheaper to directly set the gain on an input channel by it's index, in certain situations where one knows the input channel index definately.

`Mixer.stop` and `Mixer.stopAll` to stop a single or all playing sounds respectively.

... more to come
