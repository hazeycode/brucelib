const c = @cImport({
    @cInclude("GL/gl.h");
});

pub fn setViewport(x: u16, y: u16, width: u16, height: u16) void {
    c.glViewport(x, y, width, height);
}

pub fn clear(r: f32, g: f32, b: f32) void {
    c.glClearColor(r, g, b, 1);
    c.glClear(c.GL_COLOR_BUFFER_BIT);
}
