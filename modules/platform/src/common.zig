const std = @import("std");

pub const ModuleConfig = struct {
    Profiler: type = @import("NullProfiler.zig"),
    profile_marker_colour: u32 = 0x00_AA_AA_00,
};

pub const InitFn = fn (std.mem.Allocator) anyerror!void;
pub const DeinitFn = fn (std.mem.Allocator) void;
pub const FramePrepareFn = fn () void;
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

    /// This is the estimated interval (nanoseconds) until the next frame is displayed.
    /// NOTE: This will not necessarily reflect the requested refresh rate and may be
    /// adjusted up or down depending on the user's display and whether we are missing
    /// or beating the current target refresh rate.
    target_frame_dt: u64,

    /// This was the interval (nanoseconds) between the previous frame and the one
    /// previous to that.
    prev_frame_elapsed: u64,

    /// Window events that happened before the current frame
    window_events: []WindowEvent,

    /// Keyboard events that happened before the current frame
    key_events: []KeyEvent,

    /// Mouse events that happened before the current frame
    mouse_events: []MouseEvent,

    /// Gamepad events that happened before the current frame
    gamepad_events: []GamepadEvent,

    /// The current window size / framebuffer dimensions
    window_size: struct { width: u16, height: u16 },

    /// Various debug stats, used for displaying debug information
    debug_stats: struct {
        /// This is how long was taken doing actual work on the CPU in the previous frame
        prev_cpu_elapsed: u64,
    },
};

pub const WindowEvent = struct {
    window_id: u32,
    action: enum { resized, closed },
    width: u16,
    height: u16,
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

pub const MouseEvent = struct {
    // TODO(hazeycode): Scroll wheel
    pub const Action = enum { moved, button_pressed, button_released };
    action: Action,
    button: MouseButton,
    x: i32,
    y: i32,
};

pub const GamepadEvent = struct {
    pub const Action = enum { none, connected, disconnected };
    user_index: u32,
    action: Action,
    state: GamepadState,
};

/// Represents the state of a gamepad with the canonical Xbox 360 layout and precision
pub const GamepadState = struct {
    buttons: packed struct {
        dpad_up: u1 = 0,
        dpad_down: u1 = 0,
        dpad_left: u1 = 0,
        dpad_right: u1 = 0,
        start: u1 = 0,
        back: u1 = 0,
        left_thumb: u1 = 0,
        right_thumb: u1 = 0,
        left_shoulder: u1 = 0,
        right_shoulder: u1 = 0,
        a: u1 = 0,
        b: u1 = 0,
        x: u1 = 0,
        y: u1 = 0,
    } = .{},
    left_thumb_x: i16 = 0,
    left_thumb_y: i16 = 0,
    right_thumb_x: i16 = 0,
    right_thumb_y: i16 = 0,
    left_trigger: u8 = 0,
    right_trigger: u8 = 0,
};

pub const MouseButton = enum(u8) { none = 0, left = 1, middle = 2, right = 3, };

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
