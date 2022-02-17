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

\* Console platform backends will not be provided by this repository. Registered developers will be granted access on request.


### Minimal usage example
```zig
const platform = @import("platform");

pub fn main() anyerror!void {
    try platform.run(.{
        .title = "hello, world",
        .pxwidth = 854,
        .pxheight = 480,
        .init_fn = init,
        .deinit_fn = deinit,
        .update_fn = update,
    });
}

fn init(_: std.mem.Allocator) !void {}

fn deinit() void {}

fn update(input: platform.Input) !bool {
    return (input.quit_requested == false);
}
```
For more usage examples, refer to the [brucelib examples](https://github.com/hazeycode/brucelib/tree/main/examples)
