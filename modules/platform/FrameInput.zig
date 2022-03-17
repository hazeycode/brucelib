//! This file defines the structure that is passed to the frame fn by the platform layer

const std = @import("std");

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

/// All input events that occured since the last frame
input_events: struct {
    key_events: []KeyEvent,
    mouse_button_events: []MouseButtonEvent,
},

/// The current mouse pointer position relative to the window
mouse_position: struct {
    x: i32,
    y: i32,
} = .{ .x = 0, .y = 0 },

/// The current window size / framebuffer dimensions
window_size: struct {
    width: u16,
    height: u16,
},

/// Various debug stats, used for displaying debug information
debug_stats: struct {
    /// This is how long was taken doing actual work on the CPU for the previous frame
    prev_cpu_frame_elapsed: u64,

    /// Rolling average interval (milliseconds) between the audio read and write cursors
    audio_latency_avg_ms: f32,
},

pub const MouseButtonEvent = struct {
    button: struct {
        action: enum { press, release },
        index: u16,
    },
    x: i32,
    y: i32,
};

pub const KeyEvent = struct {
    action: union(enum) {
        press: void,
        release: void,
        repeat: u32,
    },
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
