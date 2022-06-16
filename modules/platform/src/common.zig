const std = @import("std");

pub const ModuleConfig = struct {
    Profiler: type = @import("NullProfiler.zig"),
};

pub const InitFn = fn (std.mem.Allocator) anyerror!void;
pub const DeinitFn = fn (std.mem.Allocator) void;
pub const FrameFn = fn (FrameInput) anyerror!bool;
pub const FrameEndFn = fn () void;
pub const AudioPlaybackFn = fn (AudioPlaybackStream) anyerror!u32;

/// Defines the structure that is passed to the audio playback fn by the platform layer
pub const AudioPlaybackStream = struct {
    /// The sample rate of the output stream
    sample_rate: u32,

    /// The number of output channels
    channels: u32,

    /// The buffer to write samples to
    sample_buf: []f32,

    /// Maximum number of frames to write
    max_frames: u32,
};

/// Defines the structure that is passed to the frame fn by the platform layer
pub const FrameInput = struct {
    /// Temporary allocator whose memory is valid for the duration of the current frame
    frame_arena_allocator: std.mem.Allocator,

    /// True if the user tried to close the window, gives us a chance to save state,
    /// present a quit dialog, etc.
    quit_requested: bool,

    /// This is the estimated interval (nanoseconds) until the next frame is displayed.
    /// NOTE: This will not necessarily reflect the requested refresh rate and may be
    /// adjusted up or down depending on the user's display and whether we are missing
    /// or beating the current target refresh rate.
    target_frame_dt: u64,

    /// This was the interval (nanoseconds) between the previous frame and the one
    /// previous to that.
    prev_frame_elapsed: u64,

    /// All user input events that happened before the current frame
    user_input: struct {
        key_events: []KeyEvent,
        mouse_button_events: []MouseButtonEvent,
        mouse_position: struct { x: i32, y: i32 },
    },

    /// The current window size / framebuffer dimensions
    window_size: struct { width: u16, height: u16 },
    
    /// Various debug stats, used for displaying debug information
    debug_stats: struct {
        /// This is how long was taken doing actual work on the CPU in the previous frame
        prev_cpu_elapsed: u64,
    },
};

pub const Event = union(enum) {
    window_closed: WindowClosedEvent,
    window_resize: WindowResizeEvent,
    key: KeyEvent,
    mouse_button: MouseButtonEvent,
};

pub const WindowClosedEvent = struct {
    window_id: u32,
};

pub const WindowResizeEvent = struct {
    window_id: u32,
    width: u16,
    height: u16,
};

pub const MouseButton = enum(u8) { left = 1, middle = 2, right = 3 };

pub const MouseButtonEvent = struct {
    action: enum { press, release },
    button: MouseButton,
    x: i32,
    y: i32,
};

pub const KeyEvent = struct {
    pub const Action = union(enum) {
        press: void,
        release: void,
        repeat: u32,
    };

    action: Action,
    key: Key,
};

pub const KeyReleaseEvent = Key;

/// Represents a physical key position, using a typical QWERTY layout
pub const Key = enum {
    unknown,
    space,
    apostrophe,
    comma,
    minus,
    period,
    slash,
    zero,
    one,
    two,
    three,
    four,
    five,
    six,
    seven,
    eight,
    nine,
    semicolon,
    equal,
    a,
    b,
    c,
    d,
    e,
    f,
    g,
    h,
    i,
    j,
    k,
    l,
    m,
    n,
    o,
    p,
    q,
    r,
    s,
    t,
    u,
    v,
    w,
    x,
    y,
    z,
    bracket_left,
    bracket_right,
    backslash,
    grave_accent,
    world1,
    world2,
    escape,
    enter,
    tab,
    backspace,
    insert,
    delete,
    right,
    left,
    down,
    up,
    pageup,
    pagedown,
    home,
    end,
    capslock,
    scrolllock,
    numlock,
    printscreen,
    pause,
    f1,
    f2,
    f3,
    f4,
    f5,
    f6,
    f7,
    f8,
    f9,
    f10,
    f11,
    f12,
    f13,
    f14,
    f15,
    f16,
    f17,
    f18,
    f19,
    f20,
    f21,
    f22,
    f23,
    f24,
    f25,
    keypad_0,
    keypad_1,
    keypad_2,
    keypad_3,
    keypad_4,
    keypad_5,
    keypad_6,
    keypad_7,
    keypad_8,
    keypad_9,
    keypad_decimal,
    keypad_divide,
    keypad_multiply,
    keypad_subtract,
    keypad_add,
    keypad_enter,
    keypad_equal,
    shift_left,
    shift_right,
    ctrl_left,
    ctrl_right,
    alt_left,
    alt_right,
    super_left,
    super_right,
    menu,
};
