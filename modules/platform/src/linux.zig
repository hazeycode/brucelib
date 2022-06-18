const std = @import("std");

const common = @import("common.zig");
const X11 = @import("linux/X11.zig");

const log = std.log.scoped(.@"brucelib.platform.linux");

pub fn using(comptime config: common.ModuleConfig) type {
    const Profiler = config.Profiler;

    return struct {
        pub const InitFn = common.InitFn;
        pub const DeinitFn = common.DeinitFn;
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

        const soundio = @import("soundio.zig");
        const AudioPlaybackInterface = soundio.Interface(log, audio_playback_cb);

        const GraphicsAPI = enum {
            opengl,
        };

        var target_framerate: u32 = undefined;

        var window_closed = false;
        var quit = false;

        var audio_playback = struct {
            user_cb: ?fn (AudioPlaybackStream) anyerror!u32 = null,
            interface: AudioPlaybackInterface = undefined,
        }{};

        pub fn getOpenGlProcAddress(_: ?*const anyopaque, entry_point: [:0]const u8) ?*const anyopaque {
            return X11.glx_get_proc_addr(?*const anyopaque, entry_point.ptr) catch null;
        }

        pub fn get_sample_rate() u32 {
            return audio_playback.interface.outstream.sample_rate;
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

                audio_playback.interface = try AudioPlaybackInterface.init();

                // TODO(hazeycode): move libsoundio specific stuff to soundio.zig
                log.info("{} channels, {} Hz" ,
                    .{
                        audio_playback.interface.outstream.layout.channel_count,
                        audio_playback.interface.outstream.sample_rate,
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
            
            try audio_playback.interface.start();

            var prev_frame_elapsed: u64 = 0;
            var prev_cpu_elapsed: u64 = 0;

            var timer = try std.time.Timer.start();
            while (true) {
                defer Profiler.frame_mark();

                const outer_trace_zone = Profiler.zone_name_colour(
                    @src(),
                    "platform main loop",
                    config.profile_marker_colour,
                );
                defer outer_trace_zone.End();

                prev_frame_elapsed = timer.lap();

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

                const target_frame_dt = @floatToInt(u64, (1 / @intToFloat(f64, target_framerate) * 1e9));

                {
                    const frame_trace_zone = Profiler.zone_name_colour(
                        @src(),
                        "platform request frame",
                        config.profile_marker_colour,
                    );
                    defer frame_trace_zone.End();

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
                }

                prev_cpu_elapsed = timer.read();

                {
                    const trace_zone = Profiler.zone_name_colour(
                        @src(),
                        "frame commit",
                        config.profile_marker_colour,
                    );
                    defer trace_zone.End();
                    args.frame_end_fn();
                }

                {
                    const trace_zone = Profiler.zone_name_colour(
                        @src(),
                        "platform swap_buffers",
                        config.profile_marker_colour,
                    );
                    defer trace_zone.End();
                    windowing.swap_buffers();
                }

                if (quit) break;
            }
        }
    
        // TODO(hazeycode): move libsoundio specific stuff to soundio.zig
        fn audio_playback_cb(
            maybe_outstream: ?*soundio.SoundIoOutStream,
            frame_count_min: c_int,
            frame_count_max: c_int,
        ) callconv(.C) void {            
            const outstream = maybe_outstream.?;
            const layout = &outstream.layout;
            const max_samples = @intCast(u32, frame_count_max * layout.channel_count);
            
            // TODO(hazeycode): size this buffer better
            _ = frame_count_min;
            var buffer: [0x100000]f32 = undefined;
            std.debug.assert(buffer.len >= max_samples);
                    
            var frames_remaining = frame_count_max;
            while (frames_remaining > 0) {
                var frame_count = frames_remaining;
                
                var areas: [*]soundio.SoundIoChannelArea = undefined;
                soundio.err(soundio.soundio_outstream_begin_write(
                    outstream,
                    @ptrCast([*c][*c]soundio.SoundIoChannelArea, &areas),
                    &frame_count,
                )) catch |err| {
                    log.err("soundio error: {}", .{err});
                };
                
                const sample_count = @intCast(u32, frame_count * layout.channel_count);
                
                if (frame_count == 0) break;
                
                const frames_available = audio_playback.user_cb.?(.{
                    .sample_rate = @intCast(u32, outstream.sample_rate),
                    .channels = @intCast(u32, layout.channel_count),
                    .sample_buf = buffer[0..sample_count],
                    .max_frames = @intCast(u32, frame_count),
                }) catch |err| on_error: {
                    log.err("audio playback failed with error: {}", .{err});
                    break :on_error 0;
                };
                
                const num_samples = frames_available * @intCast(u32, layout.channel_count);
                
                // TODO(hazeycode): make this cheaper
                for (buffer[0..num_samples]) |sample, i| {
                    const channel = i % @intCast(usize, layout.channel_count);
                    const channel_ptr = areas[channel].ptr.?;
                    const sample_ptr = &channel_ptr[@intCast(usize, areas[channel].step) * @divFloor(i, @intCast(usize, layout.channel_count))];
                    @ptrCast(*f32, @alignCast(@alignOf(f32), sample_ptr)).* = sample;
                }
                
                soundio.err(soundio.soundio_outstream_end_write(outstream)) catch |err| {
                   log.err("soundio error: {}", .{err});
                };
                
                // log.info("wrote {} frames of audio", .{frame_count});
                
                frames_remaining -= frame_count;
            }
        }
    };
}
