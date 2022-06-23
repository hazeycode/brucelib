const std = @import("std");

const common = @import("common.zig");
const X11 = @import("linux/X11.zig");

const log = std.log.scoped(.@"brucelib.platform.linux");

pub fn using(comptime config: common.ModuleConfig) type {
    const Profiler = config.Profiler;

    return struct {
        pub const InitFn = common.InitFn;
        pub const DeinitFn = common.DeinitFn;
        pub const FramePrepareFn = common.FramePrepareFn;
        pub const FrameFn = common.FrameFn;
        pub const FrameEndFn = common.FrameEndFn;
        pub const AudioPlaybackFn = common.AudioPlaybackFn;
        pub const FrameInput = common.FrameInput;
        pub const AudioPlaybackStream = common.AudioPlaybackStream;
        pub const KeyEvent = common.KeyEvent;
        pub const MouseButton = common.MouseButton;
        pub const MouseButtonEvent = common.MouseButtonEvent;
        pub const Key = common.Key;

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

        pub fn getOpenGlProcAddress(_: ?*const anyopaque, entry_point: [:0]const u8) ?*const anyopaque {
            return X11.glx_get_proc_addr(?*const anyopaque, entry_point.ptr) catch null;
        }

        pub fn getSampleRate() u32 {
            return audio_playback.interface.sample_rate;
        }

        pub fn run(args: struct {
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
            init_fn: InitFn,
            deinit_fn: DeinitFn,
            frame_prepare_fn: FramePrepareFn,
            frame_fn: FrameFn,
            frame_end_fn: FrameEndFn,
            audio_playback: ?struct {
                request_sample_rate: u32 = 48000,
                callback: AudioPlaybackFn = null,
            },
        }) !void {
            var gpa = std.heap.GeneralPurposeAllocator(.{}){};
            defer _ = gpa.deinit();

            var allocator = gpa.allocator();

            // TODO(hazeycode): get monitor refresh and shoot for that, downgrade if we miss alot
            target_framerate = if (args.requested_framerate == 0) 60 else args.requested_framerate;

            var windowing = try X11.init_and_create_window(.{
                .title = args.title,
                .width = args.window_size.width,
                .height = args.window_size.height,
            });
            defer windowing.deinit();

            const audio_enabled = (args.audio_playback != null);

            if (audio_enabled) {
                audio_playback.user_cb = args.audio_playback.?.callback;

                const buffer_size_frames = std.math.ceilPowerOfTwoAssert(
                    u32,
                    3 * args.audio_playback.?.request_sample_rate / target_framerate,
                );

                audio_playback.interface = try AudioPlaybackInterface.init(
                    args.audio_playback.?.request_sample_rate,
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

            try args.init_fn(allocator);
            defer args.deinit_fn(allocator);

            if (audio_enabled) {
                audio_playback.thread = try std.Thread.spawn(.{}, audioThread, .{allocator});
                audio_playback.thread.detach();
            }

            var prev_frame_elapsed: u64 = 0;
            var prev_cpu_elapsed: u64 = 0;

            var timer = try std.time.Timer.start();
            while (true) {
                const trace_zone = Profiler.zone_name_colour(
                    @src(),
                    "platform.linux main loop",
                    config.profile_marker_colour,
                );
                defer trace_zone.End();
                
                args.frame_prepare_fn();
                
                var cpu_frame_timer = try std.time.Timer.start();
                
                const target_frame_dt = @floatToInt(u64, (1 / @intToFloat(f64, target_framerate) * 1e9));
                                            
                var frame_mem_arena = std.heap.ArenaAllocator.init(allocator);
                defer frame_mem_arena.deinit();

                const arena_allocator = frame_mem_arena.allocator();

                var key_events = std.ArrayList(KeyEvent).init(arena_allocator);
                var mouse_button_events = std.ArrayList(MouseButtonEvent).init(arena_allocator);

                while (windowing.next_event()) |event| {
                    switch (event) {
                        .window_closed => {
                            window_closed = true;
                        },
                        .window_resize => {},
                        .key => |key_event| {
                            try key_events.append(key_event);
                        },
                        .mouse_button => |mouse_button_event| {
                            try mouse_button_events.append(mouse_button_event);
                        },
                    }
                }

                const mouse_pos = windowing.get_mouse_pos();
                
                quit = !(try args.frame_fn(.{
                    .frame_arena_allocator = arena_allocator,
                    .quit_requested = window_closed,
                    .target_frame_dt = target_frame_dt,
                    .prev_frame_elapsed = prev_frame_elapsed,
                    .user_input = .{
                        .key_events = key_events.items,
                        .mouse_button_events = mouse_button_events.items,
                        .mouse_position = .{
                            .x = mouse_pos.x,
                            .y = mouse_pos.y,
                        },
                    },
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
                        config.profile_marker_colour,
                    );
                    defer trace_zone_present.End();
                    windowing.present();
                    
                    args.frame_end_fn();
                }

                prev_frame_elapsed = timer.lap();
                
                Profiler.frame_mark();
                
                if (quit) break;
            }
        }

        fn audioThread(allocator: std.mem.Allocator) !void {
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
