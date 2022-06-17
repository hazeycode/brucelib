# brucelib.graphics
**WARNING: WORK IN PROGRESS**

This module **does not** handle graphics context creation. You must use some other means to do that, such as the [platform module](https://github.com/hazeycode/brucelib/tree/main/modules/platform)

### Selecting a backend API

A backend graphics API can be selected by overriding the module config default e.g.
```zig
const graphics = @import("brucelib.graphics").using(.{
    .backend_api = .opengl,
});
```
where `backend_api` is one of:

```zig
.opengl, // 4.4 core profile or greater
.d3d11,
.default // use the target platform default
```

* Support for other backend APIs is planned.


### Backend API abstraction

A backend API abstraction is lazily defined by the backend implementations weakly conforming to the same interface. The selected backend API is exported by the module.


### Usage

- Initilise the module with `init`, cleanup with `deinit`
- Call `begin_frame` at the start of your frame
- Use `sync` to force a CPU/GPU sync point (under review / development)
- Initilise `RenderList`


### RenderList API

The core of the module is the `RenderList` API, which is the primary interface for scheduling GPU work

```zig
set_viewport(Viewport) !void
clear_viewport(Colour) !void
bind_pipeline_resources(*PipelineResources) !void
set_projection_transform(Matrix) !void
set_view_transform(Matrix) !void
set_model_transform(Matrix) !void
set_colour(Colour) !void
bind_texture(slot: u32, Texture2d) !void
draw(vertex_offset: u32, vertex_count: u32) !void
```

### Builtin Renderers

As a matter of convenience, the following builtin Renderers are provided, which are particulary useful for quick prototyping

- `UniformColourVertsRenderer`
- `TexturedVertsRenderer`
- (more planned)


### Example usage
```zig
// import the graphics module, with the default configution (and backend)
const graphics = @import("brucelib.graphics").using(.{});


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

// init a builtin renderer
var renderer = try graphics.UniformColourVertsRenderer.init(1000);

loop {
   // being a new frame, clearing the render target with the specified colour
   try graphics.begin_frame(graphics.Colour.black);

   // create a new `RenderList` and set the viewport
   var render_list = try graphics.RenderList.init(frame_arena_allocator);
   try render_list.set_viewport(0, 0, viewport_width, viewport_height);
   
   // prepare a solid orange triangle for renderering
   try colour_verts_renderer.render(
      &render_list,
      graphics.Colour.orange,
      &[_]graphics.Vertex{
          .{ .pos = .{ -0.5, -0.5, 0.0 } },
          .{ .pos = .{ 0.5, -0.5, 0.0 } },
          .{ .pos = .{ 0.0, 0.5, 0.0 } },
      },
   );

   // submit the `RenderList` (this submits all the draw calls to GPU)
   try render_list.submit();
}

// cleanup
graphics.deinit();
```
For more usage examples, refer to the [brucelib examples](https://github.com/hazeycode/brucelib/tree/main/examples)


### DebugGUI

`graphics.debug_gui` provides an optional debug gui implemented ontop of the builtin Renderers and `RenderList` API.

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

