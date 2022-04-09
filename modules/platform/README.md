# platform
**WARNING: WORK IN PROGRESS**

The platform module abstracts the target operating system and SDKs and provides an opaque interface. The design descisions regarding this interface are driven by the considerable differences between how platforms do things and the need for a simple interface for getting input events, creating graphics contexts, synchronising with the display refresh, piping out audio, etc.

### Supported platforms
| Platform | Status |
| -------- | ------ |
| Linux | in-progress |
| Windows | in-progress |
| MacOS | in-progress | 
| iOS | planned |
| Android | planned |
| * Nintendo Switch | planned |

The appropriate system libraries for the selected backend are required at runtime. But cross-compilation support is in-progress/planned.

TODO: detail dependencies

\* Console platform backends are not public. Registered developers will be granted access on request.


### Minimal usage example
```zig
const platform = @import("brucelib.platform");

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

        /// Optional audio playback callback. If set it can be called at any time by the platform
        /// module on a dedicated audio thread.
        .audio_playback_fn = audioPlayback,
    });
}

fn init(_: std.mem.Allocator) !void {
}

fn deinit() void {
}

fn frame(input: platform.Input) !bool {
    return (input.quit_requested == false);
}

fn audioPlayback(_: platform.AudioPlaybackStream) !void {
}
```
For more usage examples, refer to the [brucelib examples](https://github.com/hazeycode/brucelib/tree/main/examples)


### Vendored libs

Each vendored library is listed below with the license it is under; also see the [NOTICE](NOTICE) file.

| Name | Description | License |
| :--- | :---------- | :------ |
| [zwin32](https://github.com/michal-z/zig-gamedev/tree/main/libs/zwin32) | Zig bindings for Win32 from Michal Ziulek's [zig-gamedev](https://github.com/michal-z/zig-gamedev) project | MIT |
| [zig-objcrt](https://github.com/hazeycode/zig-objcrt) | Zig bindings for the [Objective-C runtime](https://developer.apple.com/documentation/objectivec/objective-c_runtime#see-also) | 0BSD |
| [zig-alsa](https://github.com/hazeycode/zig-alsa) | Zig bindings for [ALSA](https://github.com/alsa-project/alsa-lib) | 0BSD |

