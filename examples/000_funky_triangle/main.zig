const std = @import("std");

const platform = @import("platform");
const graphics = @import("graphics").usingAPI(.default);

const audio_on = true;

pub fn main() anyerror!void {
    try platform.run(.{
        .title = "000_funky_triangle",
        .window_size = .{
            .width = 854,
            .height = 480,
        },
        .init_fn = init,
        .deinit_fn = deinit,
        .frame_fn = frame,
        .audio_playback_fn = if (audio_on) audioPlayback else null,
    });
}

var state: struct {
    triangle_hue: f32 = 0,
    audio_cursor: u64 = 0,
    tone_hz: f32 = 440,
    volume: f32 = 0.67,
    debug_gui: graphics.DebugGUI.State = .{},
} = .{};

/// Called before the platform event loop begins
fn init(allocator: std.mem.Allocator) !void {
    try graphics.init(platform, allocator);
}

/// Called before the program terminates, after the `frame_fn` returns false
fn deinit() void {
    graphics.deinit();
}

/// Called every time the platform module wants a new frame to display to meet the target
/// framerate. The target framerate is determined by the platform layer using the display
/// refresh rate, frame metrics and the optional user set arg of `platform.run`:
/// `.requested_framerate`. `FrameInput` is passed as an argument, containing events and
/// other data used to produce the next frame.
fn frame(input: platform.FrameInput) !bool {
    if (input.quit_requested) {
        return false;
    }

    var draw_list = try graphics.beginDrawing(input.frame_arena_allocator);

    try draw_list.setViewport(0, 0, input.window_size.width, input.window_size.height);
    try draw_list.clearViewport(graphics.Colour.black);

    { // update and draw funky triangle
        state.triangle_hue = @mod(
            state.triangle_hue + @intToFloat(f32, input.target_frame_dt) / 1e9,
            1.0,
        );

        try draw_list.setProjectionTransform(graphics.identityMatrix());

        try draw_list.drawUniformColourVerts(
            graphics.Colour.fromHSV(state.triangle_hue, 0.5, 1.0),
            &[_]graphics.Vertex{
                .{ .pos = .{ -0.5, -0.5, 0.0 } },
                .{ .pos = .{ 0.5, -0.5, 0.0 } },
                .{ .pos = .{ 0.0, 0.5, 0.0 } },
            },
        );
    }

    { // update and draw debug overlay
        state.debug_gui.input.mouse_x = @intToFloat(f32, input.mouse_position.x);
        state.debug_gui.input.mouse_y = @intToFloat(f32, input.mouse_position.y);

        state.debug_gui.input.mouse_btn_was_pressed = false;
        state.debug_gui.input.mouse_btn_was_released = false;

        for (input.input_events.mouse_button_events) |mouse_ev| {
            if (mouse_ev.button.index != 1) continue;

            switch (mouse_ev.button.action) {
                .press => {
                    state.debug_gui.input.mouse_btn_was_pressed = true;
                    state.debug_gui.input.mouse_btn_down = true;
                },
                .release => {
                    state.debug_gui.input.mouse_btn_was_released = true;
                    state.debug_gui.input.mouse_btn_down = false;
                },
            }
        }

        var debug_gui = try graphics.DebugGUI.begin(
            input.frame_arena_allocator,
            &draw_list,
            @intToFloat(f32, input.window_size.width),
            @intToFloat(f32, input.window_size.height),
            &state.debug_gui,
        );

        try debug_gui.label(
            "{d:.2} ms update",
            .{@intToFloat(f32, input.debug_stats.prev_cpu_frame_elapsed) / 1e6},
        );

        const prev_frame_time_ms = @intToFloat(f32, input.prev_frame_elapsed) / 1e6;
        try debug_gui.label(
            "{d:.2} ms frame, {d:.0} FPS",
            .{ prev_frame_time_ms, 1e3 / prev_frame_time_ms },
        );

        try debug_gui.textField(f32, "{d:.2} Hz", &state.tone_hz);

        // try debug_gui.slider(u32, 20, 20_000, &state.tone_hz, 200);

        try debug_gui.label(
            "Mouse pos = ({}, {})",
            .{ input.mouse_position.x, input.mouse_position.y },
        );

        try debug_gui.end();
    }

    try graphics.submitDrawList(draw_list);

    return true;
}

/// Optional audio playback callback. If set it can be called at any time by the platform module
/// on a dedicated audio thread.
fn audioPlayback(stream: platform.AudioPlaybackStream) !void {
    const sin = std.math.sin;
    const pi = std.math.pi;
    const tao = 2 * pi;

    const sample_rate = @intToFloat(f32, stream.sample_rate);
    const num_frames = stream.sample_buf.len / stream.channels;

    var n: u32 = 0;
    while (n < num_frames) : (n += 1) {
        var sample = 0.5 * sin(
            @intToFloat(f32, state.audio_cursor + n) * (tao * state.tone_hz) / sample_rate,
        );
        sample *= state.volume;

        var channel: u32 = 0;
        while (channel < stream.channels) : (channel += 1) {
            stream.sample_buf[n * stream.channels + channel] = @floatCast(f32, sample);
        }
    }

    state.audio_cursor += num_frames;
}
