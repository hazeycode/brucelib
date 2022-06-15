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

    /// Initilise the platform module and run loop using the following configuration
    try platform.run(.{

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

        /// Called before the platform event loop begins
        .init_fn = init,
        
        /// Called before the program terminates, after the `frame_fn` returns false
        .deinit_fn = deinit,

        /// Called every time the platform module wants a new frame to display to meet the target
        /// framerate. The target framerate is determined by the platform layer using the display
        /// refresh rate, frame metrics and the optional user set arg of `platform.run`:
        /// `.requested_framerate`. `FrameInput` is passed as an argument, containing events and
        /// other data used to produce the next frame.
        .frame_fn = frame,

        /// Optional audio playback config
        .audio_playback = .{
            .request_sample_rate = 44100,
            .callback = audioPlayback,
        },
    });
}

fn init(_: std.mem.Allocator) !void {
}

fn deinit(_: std.mem.Allocator) void {
}

fn frame(input: platform.Input) !bool {
    return (input.quit_requested == false);
}

fn audioPlayback(_: platform.AudioPlaybackStream) !u32 {
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

