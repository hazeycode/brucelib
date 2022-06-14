const std = @import("std");

const ZtracyProfiler = @import("brucelib.trace").ZtracyProfiler;

const platform = @import("brucelib.platform").with(ZtracyProfiler);
const graphics = @import("brucelib.graphics").usingBackendAPI(.default);

const audio_on = false;

pub fn main() anyerror!void {
    try platform.run(.{
        .title = "000-funky-triangle",
        .window_size = .{
            .width = 854,
            .height = 480,
        },
        .init_fn = init,
        .deinit_fn = deinit,
        .frame_fn = frame,
        .audio_playback = if (audio_on) .{
            .callback = audioPlayback,
        } else null,
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
    try graphics.init(allocator, platform);
}

/// Called before the program terminates, after the `frame_fn` returns false
fn deinit(_: std.mem.Allocator) void {
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

    try graphics.setViewport(&draw_list, .{
        .x = 0,
        .y = 0,
        .width = input.window_size.width,
        .height = input.window_size.height,
    });
    try graphics.clearViewport(&draw_list, graphics.Colour.black);

    { // update and draw funky triangle
        state.triangle_hue = @mod(
            state.triangle_hue + @intToFloat(f32, input.target_frame_dt) / 1e9,
            1.0,
        );

        try graphics.setProjectionTransform(&draw_list, graphics.identityMatrix());

        try graphics.drawUniformColourVerts(
            &draw_list,
            graphics.builtin_pipeline_resources.uniform_colour_verts,
            graphics.Colour.fromHSV(state.triangle_hue, 0.5, 1.0),
            &[_]graphics.Vertex{
                .{ .pos = .{ -0.5, -0.5, 0.0 } },
                .{ .pos = .{ 0.5, -0.5, 0.0 } },
                .{ .pos = .{ 0.0, 0.5, 0.0 } },
            },
        );
    }

    { // update and draw debug overlay
        state.debug_gui.input.mapPlatformInput(input.user_input);

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
            .{ input.user_input.mouse_position.x, input.user_input.mouse_position.y },
        );

        try debug_gui.end();
    }

    try graphics.submitDrawList(&draw_list);

    return true;
}

/// Optional audio playback callback. If set it can be called at any time by the platform module
/// on a dedicated audio thread.
fn audioPlayback(stream: platform.AudioPlaybackStream) !u32 {
    const sin = std.math.sinh;
    const pi = std.math.pi;
    const tao = 2 * pi;

    const sample_rate = @intToFloat(f32, stream.sample_rate);
    const num_frames = stream.max_frames;

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

    const frames_written = num_frames;

    state.audio_cursor += frames_written;

    return frames_written;
}
