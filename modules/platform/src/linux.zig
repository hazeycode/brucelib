const std = @import("std");

const log = std.log.scoped(.@"brucelib.platform.linux");

const common = @import("common.zig");
const ring_buffers = @import("ring_buffers.zig");

const X11 = @import("linux/X11.zig");

pub fn using(comptime module_config: common.ModuleConfig) type {
    const Profiler = module_config.Profiler;

    return struct {
        pub const InitFn = common.InitFn;
        pub const DeinitFn = common.DeinitFn;
        pub const FramePrepareFn = common.FramePrepareFn;
        pub const FrameFn = common.FrameFn;
        pub const FrameEndFn = common.FrameEndFn;
        pub const AudioPlaybackFn = common.AudioPlaybackFn;
        pub const FrameInput = common.FrameInput;
        pub const AudioPlaybackStream = common.AudioPlaybackStream;
        pub const WindowEvent = common.WindowEvent;
        pub const KeyEvent = common.KeyEvent;
        pub const MouseEvent = common.MouseEvent;
        pub const GamepadEvent = common.GamepadEvent;
        pub const MouseButton = common.MouseButton;
        pub const Key = common.Key;
        pub const GamepadState = common.GamepadState;

        const num_keys = std.meta.fields(Key).len;

        const AlsaPlaybackInterface = @import("linux/AlsaPlaybackInterface.zig");
        const AudioPlaybackInterface = AlsaPlaybackInterface;

        const GraphicsAPI = enum {
            opengl,
        };

        var target_framerate: u32 = undefined;

        var window_closed = false;
        var quit = false;

        var audio_playback = struct {
            user_cb: ?fn (AudioPlaybackStream) anyerror!u32 = null,
            interface: AudioPlaybackInterface = undefined,
            thread: std.Thread = undefined,
        }{};

        var window_events_buffer = ring_buffers.RingBufferStatic(WindowEvent, 256){};
        var key_events_buffer = ring_buffers.RingBufferStatic(KeyEvent, 256){};
        var mouse_events_buffer = ring_buffers.RingBufferStatic(MouseEvent, 256){};
        var gamepad_events_buffer = ring_buffers.RingBufferStatic(GamepadEvent, 1024){};

        pub fn getOpenGlProcAddress(_: ?*const anyopaque, entry_point: [:0]const u8) ?*const anyopaque {
            return X11.glx_get_proc_addr(?*const anyopaque, entry_point.ptr) catch null;
        }

        pub fn getSampleRate() u32 {
            return audio_playback.interface.sample_rate;
        }

        pub fn run(
            allocator: std.mem.Allocator,
            run_config: struct {
                graphics_api: GraphicsAPI = .opengl,
                requested_framerate: u16 = 0,
                title: []const u8 = "",
                window_size: struct {
                    width: u16,
                    height: u16,
                } = .{
                    .width = 854,
                    .height = 480,
                },
                target_input_poll_rate: u32 = 200,
                init_fn: InitFn,
                deinit_fn: DeinitFn,
                frame_prepare_fn: FramePrepareFn,
                frame_fn: FrameFn,
                frame_end_fn: FrameEndFn,
                audio_playback: ?struct {
                    request_sample_rate: u32 = 48000,
                    callback: AudioPlaybackFn = null,
                },
            },
        ) !void {
            var main_mem_arena = std.heap.ArenaAllocator.init(allocator);
            defer main_mem_arena.deinit();

            // TODO(hazeycode): downgrade target framerate if we miss alot
            target_framerate = if (run_config.requested_framerate == 0)
                60 // TODO(hazeycode): get monitor refresh rate
            else
                run_config.requested_framerate;

            var windowing = try X11.init_and_create_window(.{
                .title = run_config.title,
                .width = run_config.window_size.width,
                .height = run_config.window_size.height,
            });
            defer windowing.deinit();

            const audio_enabled = (run_config.audio_playback != null);

            if (audio_enabled) {
                audio_playback.user_cb = run_config.audio_playback.?.callback;

                const buffer_size_frames = std.math.ceilPowerOfTwoAssert(
                    u32,
                    3 * run_config.audio_playback.?.request_sample_rate / target_framerate,
                );

                audio_playback.interface = try AudioPlaybackInterface.init(
                    run_config.audio_playback.?.request_sample_rate,
                    buffer_size_frames,
                );

                log.info(
                    \\Initilised audio playback (ALSA):
                    \\  {} channels
                    \\  {} Hz
                    \\  {} bits per sample
                ,
                    .{
                        audio_playback.interface.num_channels,
                        audio_playback.interface.sample_rate,
                        audio_playback.interface.bits_per_sample,
                    },
                );
            }
            defer {
                if (audio_enabled) {
                    audio_playback.interface.deinit();
                }
            }

            try run_config.init_fn(main_mem_arena.allocator());
            defer run_config.deinit_fn(main_mem_arena.allocator());

            if (audio_enabled) {
                audio_playback.thread = try std.Thread.spawn(.{}, audio_thread, .{main_mem_arena.allocator()});
                audio_playback.thread.detach();
            }

            var prev_frame_elapsed: u64 = 0;
            var prev_cpu_elapsed: u64 = 0;

            var timer = try std.time.Timer.start();
            while (true) {
                const trace_zone = Profiler.zone_name_colour(
                    @src(),
                    "platform.linux main loop",
                    module_config.profile_marker_colour,
                );
                defer trace_zone.End();

                run_config.frame_prepare_fn();

                var cpu_frame_timer = try std.time.Timer.start();

                const target_frame_dt = @floatToInt(u64, (1 / @intToFloat(f64, target_framerate) * 1e9));

                var frame_mem_arena = std.heap.ArenaAllocator.init(main_mem_arena.allocator());
                defer frame_mem_arena.deinit();

                try windowing.poll_events(&window_events_buffer, &key_events_buffer, &mouse_events_buffer);

                const window_events = try window_events_buffer.drain(frame_mem_arena.allocator());
                const key_events = try key_events_buffer.drain(frame_mem_arena.allocator());
                const mouse_events = try mouse_events_buffer.drain(frame_mem_arena.allocator());
                const gamepad_events = try gamepad_events_buffer.drain(frame_mem_arena.allocator());

                quit = !(try run_config.frame_fn(.{
                    .frame_arena_allocator = frame_mem_arena.allocator(),
                    .target_frame_dt = target_frame_dt,
                    .prev_frame_elapsed = prev_frame_elapsed,
                    .window_events = window_events,
                    .key_events = key_events,
                    .mouse_events = mouse_events,
                    .gamepad_events = gamepad_events,
                    .window_size = .{
                        .width = windowing.window_width,
                        .height = windowing.window_height,
                    },
                    .debug_stats = .{
                        .prev_cpu_elapsed = prev_cpu_elapsed,
                    },
                }));

                prev_cpu_elapsed = cpu_frame_timer.read();

                {
                    const trace_zone_present = Profiler.zone_name_colour(
                        @src(),
                        "platform.linux present",
                        module_config.profile_marker_colour,
                    );
                    defer trace_zone_present.End();
                    windowing.present();

                    run_config.frame_end_fn();
                }

                prev_frame_elapsed = timer.lap();

                Profiler.frame_mark();

                if (quit) break;
            }
        }

        fn audio_thread(allocator: std.mem.Allocator) !void {
            Profiler.set_thread_name("Audio playback thread");

            var buffer = try allocator.alloc(
                f32,
                audio_playback.interface.buffer_frames * audio_playback.interface.num_channels,
            );
            defer allocator.free(buffer);

            var read_cur: usize = 0;
            var write_cur: usize = 0;
            var samples_queued: usize = 0;

            std.mem.set(f32, buffer, 0);

            { // write a couple of frames of silence
                const samples_silence = 2 * audio_playback.interface.sample_rate / target_framerate;
                std.debug.assert(samples_silence < buffer.len);

                _ = audio_playback.interface.writeSamples(buffer[0..(0 + samples_silence)]);
            }

            try audio_playback.interface.prepare();

            while (quit == false) {
                if (samples_queued > 0) {
                    var end = read_cur + samples_queued;
                    if (end > buffer.len) {
                        end = buffer.len;
                    }

                    if (end > read_cur) {
                        const samples = buffer[read_cur..end];

                        read_cur = (read_cur + samples.len) % buffer.len;

                        samples_queued -= samples.len;

                        if (audio_playback.interface.writeSamples(samples) == false) {
                            try audio_playback.interface.prepare();
                            continue;
                        }
                    }
                }

                const max_samples = 3 * audio_playback.interface.sample_rate / target_framerate;
                std.debug.assert(max_samples < buffer.len);

                if (samples_queued < max_samples) {
                    const end = if ((buffer.len - write_cur) > max_samples)
                        write_cur + max_samples
                    else
                        buffer.len;

                    const num_frames = try audio_playback.user_cb.?(.{
                        .sample_rate = audio_playback.interface.sample_rate,
                        .channels = audio_playback.interface.num_channels,
                        .sample_buf = buffer[write_cur..end],
                        .max_frames = @intCast(u32, end - write_cur) / audio_playback.interface.num_channels,
                    });

                    const num_samples = num_frames * audio_playback.interface.num_channels;

                    samples_queued += num_samples;

                    write_cur = (write_cur + num_samples) % buffer.len;
                }

                std.time.sleep(0);
            }
        }
    };
}
