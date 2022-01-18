const std = @import("std");

pub const Input = @This();

frame_arena_allocator: std.mem.Allocator,
key_presses: []KeyPressEvent,
key_releases: []Key,
mouse_button_presses: []MouseButtonEvent,
mouse_button_releases: []MouseButtonEvent,
canvas_width: u16,
canvas_height: u16,
quit_requested: bool,

pub const MouseButtonEvent = struct {
    button: u16,
    x: i16,
    y: i16,
};

pub const KeyPressEvent = struct {
    key: Key,
    repeat_count: u32,
};

pub const KeyReleaseEvent = Key;

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
    semi_colon,
    equals,
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
    function,
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
