const std = @import("std");

const util = @import("brucelib.util");

const platform = @import("brucelib.platform").using(.{
    .Profiler = util.ZtracyProfiler,
});

const graphics = @import("brucelib.graphics").using(.{
    .Profiler = util.ZtracyProfiler,
});

const audio_enabled = true;

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
        .frame_end_fn = frame_end,
        .audio_playback = if (audio_enabled) .{
            .callback = audio_playback,
        } else null,
    });
}

var state: struct {
    triangle_hue: f32 = 0,
    audio_cursor: u64 = 0,
    tone_hz: f32 = 440,
    volume: f32 = 0.67,
    mute: bool = true,
    debug_gui: graphics.DebugGui.State = .{},
} = .{};

var colour_verts_renderer: graphics.UniformColourVertsRenderer = undefined;


/// Called before the platform event loop begins
fn init(allocator: std.mem.Allocator) !void {
    try graphics.init(allocator, platform);
    colour_verts_renderer = try graphics.UniformColourVertsRenderer.init(1000);
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
    
    graphics.begin_frame(graphics.Colour.black);

    var render_list = try graphics.RenderList.init(input.frame_arena_allocator);

    try render_list.set_viewport(.{
        .x = 0,
        .y = 0,
        .width = input.window_size.width,
        .height = input.window_size.height,
    });

    try funky_triangle(input, &render_list);
    
    try debug_overlay(input, &render_list);

    try render_list.submit();

    return true;
}

fn funky_triangle(input: platform.FrameInput, render_list: *graphics.RenderList) !void {
    state.triangle_hue = @mod(
        state.triangle_hue + @intToFloat(f32, input.target_frame_dt) / 1e9,
        1.0,
    );

    try render_list.set_projection_transform(graphics.identity_matrix());

    try colour_verts_renderer.render(
        render_list,
        graphics.Colour.from_hsv(state.triangle_hue, 0.5, 1.0),
        &[_]graphics.Vertex{
            .{ .pos = .{ -0.5, -0.5, 0.0 } },
            .{ .pos = .{ 0.5, -0.5, 0.0 } },
            .{ .pos = .{ 0.0, 0.5, 0.0 } },
        },
    );
}

fn debug_overlay(input: platform.FrameInput, render_list: *graphics.RenderList) !void {
    state.debug_gui.input.map_platform_input(input.user_input);

    try graphics.debug_gui.begin(
        render_list,
        @intToFloat(f32, input.window_size.width),
        @intToFloat(f32, input.window_size.height),
        &state.debug_gui,
    );

    try graphics.debug_gui.label(
        "{d:.2} ms update",
        .{@intToFloat(f32, input.debug_stats.prev_cpu_elapsed) / 1e6},
    );

    const prev_frame_time_ms = @intToFloat(f32, input.prev_frame_elapsed) / 1e6;
    try graphics.debug_gui.label(
        "{d:.2} ms frame, {d:.0} FPS",
        .{ prev_frame_time_ms, 1e3 / prev_frame_time_ms },
    );
    
    graphics.debug_gui.separator();
    
    if (audio_enabled) {
        try graphics.debug_gui.text_field(f32, "{d:.2} Hz", &state.tone_hz);
        graphics.debug_gui.same_line();
        try graphics.debug_gui.toggle_button("mute", .{}, &state.mute);
    
        // try debug_gui.slider(u32, 20, 20_000, &state.tone_hz, 200);
    
        graphics.debug_gui.separator();
    }
    
    try graphics.debug_gui.label(
        "Mouse pos = ({}, {})",
        .{ input.user_input.mouse_position.x, input.user_input.mouse_position.y },
    );

    try graphics.debug_gui.end();
}

/// Called after `frame`, just before the frame is commited, gives us a chance to sync gpu and/or
/// schedule work to do ahead of the next frame
fn frame_end() void {
    graphics.sync();
}

/// Optional audio playback callback. If set it can be called at any time by the platform module
/// on a dedicated audio thread.
fn audio_playback(stream: platform.AudioPlaybackStream) !u32 {
    const sin = std.math.sinh;
    const pi = std.math.pi;
    const tao = 2 * pi;

    const sample_rate = @intToFloat(f32, stream.sample_rate);
    const num_frames = stream.max_frames;

    var n: u32 = 0;
    while (n < num_frames) : (n += 1) {
        var sample = sin(
            (@intToFloat(f32, state.audio_cursor + n) * 1 / sample_rate) * state.tone_hz * tao,
        );
        sample *= if (state.mute) 0 else state.volume;

        var channel: u32 = 0;
        while (channel < stream.channels) : (channel += 1) {
            stream.sample_buf[n * stream.channels + channel] = @floatCast(f32, sample);
        }
    }

    const frames_written = num_frames;

    state.audio_cursor += frames_written;

    return frames_written;
}
