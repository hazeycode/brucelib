# brucelib.graphics
**WARNING: WORK IN PROGRESS**

This module **does not** handle graphics context creation. You must use some other means to do that, such as the [platform module](https://github.com/hazeycode/brucelib/tree/main/modules/platform)

### Selecting a backend API

A backend graphics API is selected at comptime with `usingBackendAPI(backend_api)` where `backend_api` is one of:

```zig
.opengl, // 4.4 core profile or greater
.d3d11,
.default // use the target platform default
```

* Support for other backend APIs is planned.


```zig
const graphics = @import("brucelib.graphics").usingBackendAPI(.default);
```

The appropriate system libraries for the selected backend are required at runtime. But cross-compilation support is in-progress/planned.

### Backend API abstraction

A backend API abstraction is lazily defined by the backend implementations weakly conforming to the same interface. The selected backend API is exposed by the namespace returned by `usingBackendAPI`. Refer to the implementation of `DrawList` for usage examples.


### DrawList API

`graphics.DrawList` provides higher-level rendering procedures. The public interface of `DrawList` could be categoried into two sets, the Core API, and the Render API, which provides a convenient layer on top of the Core API.

DrawList Core API

```zig
beginDrawing(std.mem.Allocator) !DrawList

setViewport(*DrawList, Viewport) !void

clearViewport(*DrawList, Colour) !void

bindPipelineResources(*DrawList, *PipelineResources) !void

setProjectionTransform(*DrawList, Matrix) !void

setViewTransform(*DrawList, Matrix) !void

setModelTransform(*DrawList, Matrix) !void

setColour(*DrawList, Colour) !void

bindTexture(*DrawList, slot: u32, Texture2d) !void

submitDrawList(*DrawList) !void
```

DrawList Render API

```zig
drawUniformColourVerts(*DrawList, PipelineResources, Colour, []const Vertex) !void

drawTexturedVerts(*DrawList, PipelineResources, Texture2d, []const TexturedVertex) !void

drawTexturedQuad(
    *DrawList,
    PipelineResources,
    args: struct {
        texture: Texture2d,
        uv_rect: Rect = .{
            .min_x = 0,
            .min_y = 0,
            .max_x = 1,
            .max_y = 1,
        },
    },
) !void

```


### Example usage
```zig
// import the graphics module and select the backend to use
const graphics = @import("brucelib.graphics").usingBackendAPI(.default);

// initilise graphics with a strucure that weakly specifies graphics context
try graphics.init(allocator, .{
    pub fn getOpenGlProcAddress(_: ?*const anyopaque, entry_point: [:0]const u8) ?*const anyopaque {
        // call platform gl proc loader here
    }

    pub fn getD3D11Device() *d3d11.IDevice {
        // return d3d11 device here
    }

    pub fn getD3D11DeviceContext() *d3d11.IDeviceContext {
        // return d3d11 device context here
    }

    pub fn getD3D11RenderTargetView() *d3d11.IRenderTargetView {
        // return d3d11 render target view here
    }
});

// begin a new draw list
var draw_list = try graphics.beginDrawing(allocator);

// set the viewport
try graphics.setViewport(&draw_list, 0, 0, viewport_width, viewport_height);

// clear the viewport to black
try graphics.clearViewport(&draw_list, graphics.Colour.black);

// draw a triangle with a solid uniform orange colour using the builtin pipeline
try graphics.drawUniformColourVerts(
    &draw_list,
    graphics.builtin_pipeline_resources.uniform_colour_verts,
    graphics.Colour.orange,
    &[_]graphics.Vertex{
        .{ .pos = .{ -0.5, -0.5, 0.0 } },
        .{ .pos = .{ 0.5, -0.5, 0.0 } },
        .{ .pos = .{ 0.0, 0.5, 0.0 } },
    },
);

// submit the drawlist for rendering
try graphics.submitDrawList(&draw_list);

// cleanup
graphics.deinit();
```
For more usage examples, refer to the [brucelib examples](https://github.com/hazeycode/brucelib/tree/main/examples)


### DebugGUI

`graphics.DebugGUI` provides an optional debug gui implemented ontop of the DrawList API.

The builtin debugfont was created with:

`pbmtext -builtin fixed -plain -nomargins -space 0 "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ:;'\"\\,.?/><-+%&*()_=" > data/debugfont.pbm
`


### Vendored libs

Each vendored library is listed below with the license it is under; also see the [NOTICE](NOTICE) file.

| Name | Description | License |
| :--- | :---------- | :------ |
| [zwin32](https://github.com/michal-z/zig-gamedev/tree/main/libs/zwin32) | Zig bindings for Win32 from Michal Ziulek's [zig-gamedev](https://github.com/michal-z/zig-gamedev) project | MIT |
| [zmath](https://github.com/michal-z/zig-gamedev/tree/main/libs/zmath) | SIMD math library from Michal Ziulek's [zig-gamedev](https://github.com/michal-z/zig-gamedev) project | MIT |
| [stb_image](https://github.com/nothings/stb/blob/master/stb_image.h) | stb_image.h from Sean Barrett's [stb](https://github.com/nothings/stb) lib | MIT |
| [zmesh](https://github.com/michal-z/zig-gamedev/tree/main/libs/zmesh) | Zig bindings for [par_shapes](https://github.com/prideout/par/blob/master/par_shapes.h), [meshoptimizer](https://github.com/zeux/meshoptimizer) and [cgltf](https://github.com/jkuhlmann/cgltf) from Michal Ziulek's [zig-gamedev](https://github.com/michal-z/zig-gamedev) | both MIT |

