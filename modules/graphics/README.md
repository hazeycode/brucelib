# graphics
**WARNING: WORK IN PROGRESS**

The graphics module provides an abstraaction over platform-specific graphics APIs and a simple push style API based on top of that. Common primitives and rendering routines are also provided.

This module **does not** handle graphics context creation. You must use some other means to do that, such as the [platform module](https://github.com/hazeycode/brucelib/tree/main/modules/platform)

### Supported backend APIs
- OpenGL (4.2 core profile or greater)
- D3D11
- Metal (not yet implemented)
- & more planned

The appropriate system libraries for the selected backend are required at runtime. But cross-compilation support is in-progress/planned.


### Example usage
```zig
// import the graphics module and select the backend to use
const graphics = @import("graphics").usingAPI(.default);

// initilise
try graphics.init(allocator);

// begin a new draw list
var draw_list = try graphics.beginDrawing(allocator);

// set the viewport
try draw_list.setViewport(0, 0, viewport_width, viewport_height);

// clear the viewport to black
try draw_list.clearViewport(graphics.Colour.black);

// draw a triangle with a solid uniform orange colour
try draw_list.drawUniformColourVerts(
    graphics.Colour.orange,
    &[_]graphics.Vertex{
        .{ .pos = .{ -0.5, -0.5, 0.0 } },
        .{ .pos = .{ 0.5, -0.5, 0.0 } },
        .{ .pos = .{ 0.0, 0.5, 0.0 } },
    },
);

// submit the drawlist for rendering
try graphics.submitDrawList(draw_list);

// cleanup
graphics.deinit();
```
For more usage examples, refer to the [brucelib examples](https://github.com/hazeycode/brucelib/tree/main/examples)


### Debug GUI

debugfont created with:

`pbmtext -builtin fixed -plain -nomargins -space 0 "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ:;'\"\\,.?/><-+%&*()_=" > data/debugfont.pbm
`

