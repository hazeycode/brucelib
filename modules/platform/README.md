# brucelib.platform
**WARNING: WORK IN PROGRESS**

The platform module abstracts the target operating system and SDKs and provides an opaque interface for getting input events, create a graphics context, synchronise with the display refresh, write out audio for playback, etc.

### Supported platforms
| Platform | Status |
| -------- | ------ |
| Linux | in-progress |
| Windows | in-progress |
| MacOS | planned | 
| iOS | planned |
| Android | planned |
| * Nintendo Switch | planned |


\* Console platform backends are not public. Registered developers will be granted access on request.

The platform module is configured with a Profiler. You can provide an `void` for none, your own type which conforms to the common interface, or use one provided by the [trace](https://github.com/hazeycode/brucelib/tree/main/modules/trace) module such as `trace.ZTracyProfiler`

### Minimal usage example
```zig
// using the default module dependencies. See `platform.ModuleDependencies` for available options.
const platform = @import("brucelib.platform").using(.{});

pub fn main() anyerror!void {

    /// Initilise an allocator of your choice
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    /// Initilise the platform module and run loop using the following configuration
    try platform.run(allocator, .{

        /// The application title and the window title if the target platform has those
        .title = "hello, world",

        /// The size of the framebuffer and if in windowed mode the default starting size for the
        /// window
        .window_size = .{
            .width = 854,
            .height = 480,
        },

        /// Requests that the platform module syncronises with the display refresh at the specified
        /// rate (Hz). Depending on the platform and connected display the requested rate may not
        /// be fullfilled. The `frame_fn` is passed `target_frame_dt` in the `FrameInput` struct
        /// each time it is called which represents the actual frame time we are trying to hit this
        /// frame. platform also exposes `target_framerate` as a public var. Which may be adjusted
        /// according to performance metrics and/or display changes.
        .requested_framerate = null,

        /// Optionally specify a target input polling rate (Hz), the default is 200 Hz.
        /// For reference 1000 Hz is the max poll rate of USB 1
        .target_input_poll_rate = 200,

        /// Called on the main thread before the platform event loop begins
        .init_fn = init,
        
        /// Called before the program terminates, on the main thread, sometime after the `frame_fn`
        /// returns false
        .deinit_fn = deinit,

        /// Called at the before each frame
        /// May be called either on the main thread or on a separate display thread depending on
        /// the target platform
        .frame_prepare_fn = frame_prepare,

        /// Called every time the platform module wants a new frame to display to meet the target
        /// framerate. The target framerate is determined by the platform layer using the display
        /// refresh rate, frame metrics and the optional user set arg of `platform.run`:
        /// `.requested_framerate`. `FrameInput` is passed as an argument, containing events and
        /// other data used to produce the next frame.
        /// May be called either on the main thread or on a separate display thread depending on
        /// the target platform
        .frame_fn = frame,

        /// Called after the frame has been presented
        /// May be called either on the main thread or on a separate display thread depending on
        /// the target platform
        .frame_end_fn = frame_end,

        /// Optional audio playback config, specify playback device options and a callback that
        /// may be called on the main thread or a dedicated audio thread depending on the target
        /// platform
        .audio_playback = .{
            .request_sample_rate = 44100,
            .callback = audio_playback,
        },
    });
}

fn init(_: std.mem.Allocator) !void {
}

fn deinit(_: std.mem.Allocator) void {
}

fn frame_prepare() void {
    // use this to flush any gpu submissions that were submitted after the last frame
    // was presented
}

fn frame(input: platform.Input) !bool {
    return (input.quit_requested == false);
}

fn frame_end() void {
    // schedule work ahead of the next frame
    // and do any nessesary synchronisation
}

fn audio_playback(_: platform.AudioPlaybackStream) !u32 {
    // return the number of audio frames that were written to the stream
}
```
For more usage examples, refer to the [brucelib examples](https://github.com/hazeycode/brucelib/tree/main/examples)


### Vendored libs

Each vendored library is listed below with the license it is under; also see the [NOTICE](NOTICE) file.

| Name | Description | License |
| :--- | :---------- | :------ |
| [zwin32](https://github.com/michal-z/zig-gamedev/tree/main/libs/zwin32) | Zig bindings for Win32 from Michal Ziulek's [zig-gamedev](https://github.com/michal-z/zig-gamedev) project | MIT |
| [zig-alsa](https://github.com/hazeycode/zig-alsa) | Zig bindings for [ALSA](https://github.com/alsa-project/alsa-lib) | 0BSD |

