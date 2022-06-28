const std = @import("std");

const util = @import("brucelib.util");
const Profiler = util.ZtracyProfiler;

const platform = @import("brucelib.platform").using(.{ .Profiler = Profiler });

const graphics = @import("brucelib.graphics").using(.{
    .Platform = platform,
    .Profiler = Profiler,
});
const identity_matrix = graphics.zmath.identity;
const orthographic = graphics.zmath.orthographicLh;

const audio_enabled = false;

pub fn main() anyerror!void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    var root_allocator = gpa.allocator();

    try platform.run(root_allocator, .{
        .title = "000-funky-triangle",
        .window_size = .{
            .width = 854,
            .height = 480,
        },
        .init_fn = init,
        .deinit_fn = deinit,
        .frame_prepare_fn = frame_prepare,
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
    try graphics.init(allocator);
    colour_verts_renderer = try graphics.UniformColourVertsRenderer.init(1000);
}

/// Called before the program terminates, after the `frame_fn` returns false
fn deinit(_: std.mem.Allocator) void {
    graphics.deinit();
}

/// Called before each frame. Use to flush and pending gpu submissions
fn frame_prepare() void {
    graphics.begin_frame();
}

/// Called every time the platform module wants a new frame to display to meet the target
/// framerate. The target framerate is determined by the platform layer using the display
/// refresh rate, frame metrics and the optional user set arg of `platform.run`:
/// `.requested_framerate`. `FrameInput` is passed as an argument, containing events and
/// other data used to produce the next frame.
fn frame(input: platform.FrameInput) !bool {
    for (input.window_events) |event| switch (event.action) {
        .closed => return false,
        else => {},
    };

    try colour_verts_renderer.prepare();

    var render_list = try graphics.RenderList.init(input.frame_arena_allocator);

    try render_list.set_viewport(.{
        .x = 0,
        .y = 0,
        .width = input.window_size.width,
        .height = input.window_size.height,
    });

    try render_list.clear_viewport(graphics.Colour.black);

    try funky_triangle(input, &render_list);

    try debug_overlay(input, &render_list);

    colour_verts_renderer.commit();

    try render_list.submit();

    return true;
}

/// Called after the frame is presented
fn frame_end() void {
    graphics.end_frame();
}

fn funky_triangle(input: platform.FrameInput, render_list: *graphics.RenderList) !void {
    state.triangle_hue = @mod(
        state.triangle_hue + @intToFloat(f32, input.target_frame_dt) / 1e9,
        1.0,
    );

    try render_list.set_projection_transform(identity_matrix());

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
    try graphics.debug_gui.begin(
        render_list,
        @intToFloat(f32, input.window_size.width),
        @intToFloat(f32, input.window_size.height),
        &state.debug_gui,
    );

    graphics.debug_gui.state.input = .{};
    for (input.mouse_window_events) |event| {
        switch (event.action) {
            .button_pressed => {
                graphics.debug_gui.state.input.mouse_btn_was_pressed = true;
                graphics.debug_gui.state.input.mouse_btn_down = true;
            },
            .button_released => {
                graphics.debug_gui.state.input.mouse_btn_was_released = true;
                graphics.debug_gui.state.input.mouse_btn_down = false;
            },
        }
        graphics.debug_gui.state.input.mouse_x = @intToFloat(f32, event.x);
        graphics.debug_gui.state.input.mouse_y = @intToFloat(f32, event.y);
    }

    try graphics.debug_gui.label(
        input.frame_arena_allocator,
        "{d:.2} ms update",
        .{@intToFloat(f32, input.debug_stats.prev_cpu_elapsed) / 1e6},
    );

    const prev_frame_time_ms = @intToFloat(f32, input.prev_frame_elapsed) / 1e6;
    try graphics.debug_gui.label(
        input.frame_arena_allocator,
        "{d:.2} ms frame, {d:.0} FPS",
        .{ prev_frame_time_ms, 1e3 / prev_frame_time_ms },
    );

    graphics.debug_gui.separator();

    if (audio_enabled) {
        try graphics.debug_gui.text_field(input.frame_arena_allocator, f32, "{d:.2} Hz", &state.tone_hz);
        graphics.debug_gui.same_line();
        try graphics.debug_gui.toggle_button(input.frame_arena_allocator, "mute", .{}, &state.mute);

        // try debug_gui.slider(u32, 20, 20_000, &state.tone_hz, 200);

        graphics.debug_gui.separator();
    }

    try graphics.debug_gui.label(
        input.frame_arena_allocator,
        "Mouse pos = ({}, {})",
        .{ input.mouse_screen_x, input.mouse_screen_y },
    );

    try graphics.debug_gui.end(input.frame_arena_allocator);
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
        var sample = 0.5 * sin(
            @intToFloat(f32, state.audio_cursor + n) * (tao * state.tone_hz) / sample_rate,
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
