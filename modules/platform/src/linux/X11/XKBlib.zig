pub const __builtin_bswap16 = @import("std").zig.c_builtins.__builtin_bswap16;
pub const __builtin_bswap32 = @import("std").zig.c_builtins.__builtin_bswap32;
pub const __builtin_bswap64 = @import("std").zig.c_builtins.__builtin_bswap64;
pub const __builtin_signbit = @import("std").zig.c_builtins.__builtin_signbit;
pub const __builtin_signbitf = @import("std").zig.c_builtins.__builtin_signbitf;
pub const __builtin_popcount = @import("std").zig.c_builtins.__builtin_popcount;
pub const __builtin_ctz = @import("std").zig.c_builtins.__builtin_ctz;
pub const __builtin_clz = @import("std").zig.c_builtins.__builtin_clz;
pub const __builtin_sqrt = @import("std").zig.c_builtins.__builtin_sqrt;
pub const __builtin_sqrtf = @import("std").zig.c_builtins.__builtin_sqrtf;
pub const __builtin_sin = @import("std").zig.c_builtins.__builtin_sin;
pub const __builtin_sinf = @import("std").zig.c_builtins.__builtin_sinf;
pub const __builtin_cos = @import("std").zig.c_builtins.__builtin_cos;
pub const __builtin_cosf = @import("std").zig.c_builtins.__builtin_cosf;
pub const __builtin_exp = @import("std").zig.c_builtins.__builtin_exp;
pub const __builtin_expf = @import("std").zig.c_builtins.__builtin_expf;
pub const __builtin_exp2 = @import("std").zig.c_builtins.__builtin_exp2;
pub const __builtin_exp2f = @import("std").zig.c_builtins.__builtin_exp2f;
pub const __builtin_log = @import("std").zig.c_builtins.__builtin_log;
pub const __builtin_logf = @import("std").zig.c_builtins.__builtin_logf;
pub const __builtin_log2 = @import("std").zig.c_builtins.__builtin_log2;
pub const __builtin_log2f = @import("std").zig.c_builtins.__builtin_log2f;
pub const __builtin_log10 = @import("std").zig.c_builtins.__builtin_log10;
pub const __builtin_log10f = @import("std").zig.c_builtins.__builtin_log10f;
pub const __builtin_abs = @import("std").zig.c_builtins.__builtin_abs;
pub const __builtin_fabs = @import("std").zig.c_builtins.__builtin_fabs;
pub const __builtin_fabsf = @import("std").zig.c_builtins.__builtin_fabsf;
pub const __builtin_floor = @import("std").zig.c_builtins.__builtin_floor;
pub const __builtin_floorf = @import("std").zig.c_builtins.__builtin_floorf;
pub const __builtin_ceil = @import("std").zig.c_builtins.__builtin_ceil;
pub const __builtin_ceilf = @import("std").zig.c_builtins.__builtin_ceilf;
pub const __builtin_trunc = @import("std").zig.c_builtins.__builtin_trunc;
pub const __builtin_truncf = @import("std").zig.c_builtins.__builtin_truncf;
pub const __builtin_round = @import("std").zig.c_builtins.__builtin_round;
pub const __builtin_roundf = @import("std").zig.c_builtins.__builtin_roundf;
pub const __builtin_strlen = @import("std").zig.c_builtins.__builtin_strlen;
pub const __builtin_strcmp = @import("std").zig.c_builtins.__builtin_strcmp;
pub const __builtin_object_size = @import("std").zig.c_builtins.__builtin_object_size;
pub const __builtin___memset_chk = @import("std").zig.c_builtins.__builtin___memset_chk;
pub const __builtin_memset = @import("std").zig.c_builtins.__builtin_memset;
pub const __builtin___memcpy_chk = @import("std").zig.c_builtins.__builtin___memcpy_chk;
pub const __builtin_memcpy = @import("std").zig.c_builtins.__builtin_memcpy;
pub const __builtin_expect = @import("std").zig.c_builtins.__builtin_expect;
pub const __builtin_nanf = @import("std").zig.c_builtins.__builtin_nanf;
pub const __builtin_huge_valf = @import("std").zig.c_builtins.__builtin_huge_valf;
pub const __builtin_inff = @import("std").zig.c_builtins.__builtin_inff;
pub const __builtin_isnan = @import("std").zig.c_builtins.__builtin_isnan;
pub const __builtin_isinf = @import("std").zig.c_builtins.__builtin_isinf;
pub const __builtin_isinf_sign = @import("std").zig.c_builtins.__builtin_isinf_sign;
pub const u_int8_t = u8;
pub const u_int16_t = c_ushort;
pub const u_int32_t = c_uint;
pub const caddr_t = [*c]u8;
pub const u_char = u8;
pub const u_short = c_ushort;
pub const ushort = c_ushort;
pub const u_int = c_uint;
pub const uint = c_uint;
pub const u_long = c_ulong;
pub const ulong = c_ulong;
pub const quad_t = c_longlong;
pub const u_quad_t = c_ulonglong;
pub const XID = c_ulong;
pub const Mask = c_ulong;
pub const Atom = c_ulong;
pub const VisualID = c_ulong;
pub const Time = c_ulong;
pub const Window = XID;
pub const Drawable = XID;
pub const Font = XID;
pub const Pixmap = XID;
pub const Cursor = XID;
pub const Colormap = XID;
pub const GContext = XID;
pub const KeySym = XID;
pub const KeyCode = u8;
pub const ptrdiff_t = c_long;
pub const wchar_t = c_int;
pub const max_align_t = extern struct {
    __clang_max_align_nonce1: c_longlong align(8),
    __clang_max_align_nonce2: c_longdouble align(16),
};
pub extern fn _Xmblen(str: [*c]u8, len: c_int) c_int;
pub const XPointer = [*c]u8;
pub const struct__XExtData = extern struct {
    number: c_int,
    next: [*c]struct__XExtData,
    free_private: ?fn ([*c]struct__XExtData) callconv(.C) c_int,
    private_data: XPointer,
};
pub const XExtData = struct__XExtData;
pub const XExtCodes = extern struct {
    extension: c_int,
    major_opcode: c_int,
    first_event: c_int,
    first_error: c_int,
};
pub const XPixmapFormatValues = extern struct {
    depth: c_int,
    bits_per_pixel: c_int,
    scanline_pad: c_int,
};
pub const XGCValues = extern struct {
    function: c_int,
    plane_mask: c_ulong,
    foreground: c_ulong,
    background: c_ulong,
    line_width: c_int,
    line_style: c_int,
    cap_style: c_int,
    join_style: c_int,
    fill_style: c_int,
    fill_rule: c_int,
    arc_mode: c_int,
    tile: Pixmap,
    stipple: Pixmap,
    ts_x_origin: c_int,
    ts_y_origin: c_int,
    font: Font,
    subwindow_mode: c_int,
    graphics_exposures: c_int,
    clip_x_origin: c_int,
    clip_y_origin: c_int,
    clip_mask: Pixmap,
    dash_offset: c_int,
    dashes: u8,
};
pub const struct__XGC = opaque {};
pub const GC = ?*struct__XGC;
pub const Visual = extern struct {
    ext_data: [*c]XExtData,
    visualid: VisualID,
    class: c_int,
    red_mask: c_ulong,
    green_mask: c_ulong,
    blue_mask: c_ulong,
    bits_per_rgb: c_int,
    map_entries: c_int,
};
pub const Depth = extern struct {
    depth: c_int,
    nvisuals: c_int,
    visuals: [*c]Visual,
};
pub const struct__XDisplay = opaque {};
pub const Screen = extern struct {
    ext_data: [*c]XExtData,
    display: ?*struct__XDisplay,
    root: Window,
    width: c_int,
    height: c_int,
    mwidth: c_int,
    mheight: c_int,
    ndepths: c_int,
    depths: [*c]Depth,
    root_depth: c_int,
    root_visual: [*c]Visual,
    default_gc: GC,
    cmap: Colormap,
    white_pixel: c_ulong,
    black_pixel: c_ulong,
    max_maps: c_int,
    min_maps: c_int,
    backing_store: c_int,
    save_unders: c_int,
    root_input_mask: c_long,
};
pub const ScreenFormat = extern struct {
    ext_data: [*c]XExtData,
    depth: c_int,
    bits_per_pixel: c_int,
    scanline_pad: c_int,
};
pub const XSetWindowAttributes = extern struct {
    background_pixmap: Pixmap,
    background_pixel: c_ulong,
    border_pixmap: Pixmap,
    border_pixel: c_ulong,
    bit_gravity: c_int,
    win_gravity: c_int,
    backing_store: c_int,
    backing_planes: c_ulong,
    backing_pixel: c_ulong,
    save_under: c_int,
    event_mask: c_long,
    do_not_propagate_mask: c_long,
    override_redirect: c_int,
    colormap: Colormap,
    cursor: Cursor,
};
pub const XWindowAttributes = extern struct {
    x: c_int,
    y: c_int,
    width: c_int,
    height: c_int,
    border_width: c_int,
    depth: c_int,
    visual: [*c]Visual,
    root: Window,
    class: c_int,
    bit_gravity: c_int,
    win_gravity: c_int,
    backing_store: c_int,
    backing_planes: c_ulong,
    backing_pixel: c_ulong,
    save_under: c_int,
    colormap: Colormap,
    map_installed: c_int,
    map_state: c_int,
    all_event_masks: c_long,
    your_event_mask: c_long,
    do_not_propagate_mask: c_long,
    override_redirect: c_int,
    screen: [*c]Screen,
};
pub const XHostAddress = extern struct {
    family: c_int,
    length: c_int,
    address: [*c]u8,
};
pub const XServerInterpretedAddress = extern struct {
    typelength: c_int,
    valuelength: c_int,
    type: [*c]u8,
    value: [*c]u8,
};
pub const struct_funcs = extern struct {
    create_image: ?fn (?*struct__XDisplay, [*c]Visual, c_uint, c_int, c_int, [*c]u8, c_uint, c_uint, c_int, c_int) callconv(.C) [*c]struct__XImage,
    destroy_image: ?fn ([*c]struct__XImage) callconv(.C) c_int,
    get_pixel: ?fn ([*c]struct__XImage, c_int, c_int) callconv(.C) c_ulong,
    put_pixel: ?fn ([*c]struct__XImage, c_int, c_int, c_ulong) callconv(.C) c_int,
    sub_image: ?fn ([*c]struct__XImage, c_int, c_int, c_uint, c_uint) callconv(.C) [*c]struct__XImage,
    add_pixel: ?fn ([*c]struct__XImage, c_long) callconv(.C) c_int,
};
pub const struct__XImage = extern struct {
    width: c_int,
    height: c_int,
    xoffset: c_int,
    format: c_int,
    data: [*c]u8,
    byte_order: c_int,
    bitmap_unit: c_int,
    bitmap_bit_order: c_int,
    bitmap_pad: c_int,
    depth: c_int,
    bytes_per_line: c_int,
    bits_per_pixel: c_int,
    red_mask: c_ulong,
    green_mask: c_ulong,
    blue_mask: c_ulong,
    obdata: XPointer,
    f: struct_funcs,
};
pub const XImage = struct__XImage;
pub const XWindowChanges = extern struct {
    x: c_int,
    y: c_int,
    width: c_int,
    height: c_int,
    border_width: c_int,
    sibling: Window,
    stack_mode: c_int,
};
pub const XColor = extern struct {
    pixel: c_ulong,
    red: c_ushort,
    green: c_ushort,
    blue: c_ushort,
    flags: u8,
    pad: u8,
};
pub const XSegment = extern struct {
    x1: c_short,
    y1: c_short,
    x2: c_short,
    y2: c_short,
};
pub const XPoint = extern struct {
    x: c_short,
    y: c_short,
};
pub const XRectangle = extern struct {
    x: c_short,
    y: c_short,
    width: c_ushort,
    height: c_ushort,
};
pub const XArc = extern struct {
    x: c_short,
    y: c_short,
    width: c_ushort,
    height: c_ushort,
    angle1: c_short,
    angle2: c_short,
};
pub const XKeyboardControl = extern struct {
    key_click_percent: c_int,
    bell_percent: c_int,
    bell_pitch: c_int,
    bell_duration: c_int,
    led: c_int,
    led_mode: c_int,
    key: c_int,
    auto_repeat_mode: c_int,
};
pub const XKeyboardState = extern struct {
    key_click_percent: c_int,
    bell_percent: c_int,
    bell_pitch: c_uint,
    bell_duration: c_uint,
    led_mask: c_ulong,
    global_auto_repeat: c_int,
    auto_repeats: [32]u8,
};
pub const XTimeCoord = extern struct {
    time: Time,
    x: c_short,
    y: c_short,
};
pub const XModifierKeymap = extern struct {
    max_keypermod: c_int,
    modifiermap: [*c]KeyCode,
};
pub const Display = struct__XDisplay;
pub const struct__XPrivate = opaque {};
pub const struct__XrmHashBucketRec = opaque {};
const struct_unnamed_1 = extern struct {
    ext_data: [*c]XExtData,
    private1: ?*struct__XPrivate,
    fd: c_int,
    private2: c_int,
    proto_major_version: c_int,
    proto_minor_version: c_int,
    vendor: [*c]u8,
    private3: XID,
    private4: XID,
    private5: XID,
    private6: c_int,
    resource_alloc: ?fn (?*struct__XDisplay) callconv(.C) XID,
    byte_order: c_int,
    bitmap_unit: c_int,
    bitmap_pad: c_int,
    bitmap_bit_order: c_int,
    nformats: c_int,
    pixmap_format: [*c]ScreenFormat,
    private8: c_int,
    release: c_int,
    private9: ?*struct__XPrivate,
    private10: ?*struct__XPrivate,
    qlen: c_int,
    last_request_read: c_ulong,
    request: c_ulong,
    private11: XPointer,
    private12: XPointer,
    private13: XPointer,
    private14: XPointer,
    max_request_size: c_uint,
    db: ?*struct__XrmHashBucketRec,
    private15: ?fn (?*struct__XDisplay) callconv(.C) c_int,
    display_name: [*c]u8,
    default_screen: c_int,
    nscreens: c_int,
    screens: [*c]Screen,
    motion_buffer: c_ulong,
    private16: c_ulong,
    min_keycode: c_int,
    max_keycode: c_int,
    private17: XPointer,
    private18: XPointer,
    private19: c_int,
    xdefaults: [*c]u8,
};
pub const _XPrivDisplay = [*c]struct_unnamed_1;
pub const XKeyEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    window: Window,
    root: Window,
    subwindow: Window,
    time: Time,
    x: c_int,
    y: c_int,
    x_root: c_int,
    y_root: c_int,
    state: c_uint,
    keycode: c_uint,
    same_screen: c_int,
};
pub const XKeyPressedEvent = XKeyEvent;
pub const XKeyReleasedEvent = XKeyEvent;
pub const XButtonEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    window: Window,
    root: Window,
    subwindow: Window,
    time: Time,
    x: c_int,
    y: c_int,
    x_root: c_int,
    y_root: c_int,
    state: c_uint,
    button: c_uint,
    same_screen: c_int,
};
pub const XButtonPressedEvent = XButtonEvent;
pub const XButtonReleasedEvent = XButtonEvent;
pub const XMotionEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    window: Window,
    root: Window,
    subwindow: Window,
    time: Time,
    x: c_int,
    y: c_int,
    x_root: c_int,
    y_root: c_int,
    state: c_uint,
    is_hint: u8,
    same_screen: c_int,
};
pub const XPointerMovedEvent = XMotionEvent;
pub const XCrossingEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    window: Window,
    root: Window,
    subwindow: Window,
    time: Time,
    x: c_int,
    y: c_int,
    x_root: c_int,
    y_root: c_int,
    mode: c_int,
    detail: c_int,
    same_screen: c_int,
    focus: c_int,
    state: c_uint,
};
pub const XEnterWindowEvent = XCrossingEvent;
pub const XLeaveWindowEvent = XCrossingEvent;
pub const XFocusChangeEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    window: Window,
    mode: c_int,
    detail: c_int,
};
pub const XFocusInEvent = XFocusChangeEvent;
pub const XFocusOutEvent = XFocusChangeEvent;
pub const XKeymapEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    window: Window,
    key_vector: [32]u8,
};
pub const XExposeEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    window: Window,
    x: c_int,
    y: c_int,
    width: c_int,
    height: c_int,
    count: c_int,
};
pub const XGraphicsExposeEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    drawable: Drawable,
    x: c_int,
    y: c_int,
    width: c_int,
    height: c_int,
    count: c_int,
    major_code: c_int,
    minor_code: c_int,
};
pub const XNoExposeEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    drawable: Drawable,
    major_code: c_int,
    minor_code: c_int,
};
pub const XVisibilityEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    window: Window,
    state: c_int,
};
pub const XCreateWindowEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    parent: Window,
    window: Window,
    x: c_int,
    y: c_int,
    width: c_int,
    height: c_int,
    border_width: c_int,
    override_redirect: c_int,
};
pub const XDestroyWindowEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    event: Window,
    window: Window,
};
pub const XUnmapEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    event: Window,
    window: Window,
    from_configure: c_int,
};
pub const XMapEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    event: Window,
    window: Window,
    override_redirect: c_int,
};
pub const XMapRequestEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    parent: Window,
    window: Window,
};
pub const XReparentEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    event: Window,
    window: Window,
    parent: Window,
    x: c_int,
    y: c_int,
    override_redirect: c_int,
};
pub const XConfigureEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    event: Window,
    window: Window,
    x: c_int,
    y: c_int,
    width: c_int,
    height: c_int,
    border_width: c_int,
    above: Window,
    override_redirect: c_int,
};
pub const XGravityEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    event: Window,
    window: Window,
    x: c_int,
    y: c_int,
};
pub const XResizeRequestEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    window: Window,
    width: c_int,
    height: c_int,
};
pub const XConfigureRequestEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    parent: Window,
    window: Window,
    x: c_int,
    y: c_int,
    width: c_int,
    height: c_int,
    border_width: c_int,
    above: Window,
    detail: c_int,
    value_mask: c_ulong,
};
pub const XCirculateEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    event: Window,
    window: Window,
    place: c_int,
};
pub const XCirculateRequestEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    parent: Window,
    window: Window,
    place: c_int,
};
pub const XPropertyEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    window: Window,
    atom: Atom,
    time: Time,
    state: c_int,
};
pub const XSelectionClearEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    window: Window,
    selection: Atom,
    time: Time,
};
pub const XSelectionRequestEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    owner: Window,
    requestor: Window,
    selection: Atom,
    target: Atom,
    property: Atom,
    time: Time,
};
pub const XSelectionEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    requestor: Window,
    selection: Atom,
    target: Atom,
    property: Atom,
    time: Time,
};
pub const XColormapEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    window: Window,
    colormap: Colormap,
    new: c_int,
    state: c_int,
};
const union_unnamed_2 = extern union {
    b: [20]u8,
    s: [10]c_short,
    l: [5]c_long,
};
pub const XClientMessageEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    window: Window,
    message_type: Atom,
    format: c_int,
    data: union_unnamed_2,
};
pub const XMappingEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    window: Window,
    request: c_int,
    first_keycode: c_int,
    count: c_int,
};
pub const XErrorEvent = extern struct {
    type: c_int,
    display: ?*Display,
    resourceid: XID,
    serial: c_ulong,
    error_code: u8,
    request_code: u8,
    minor_code: u8,
};
pub const XAnyEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    window: Window,
};
pub const XGenericEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    extension: c_int,
    evtype: c_int,
};
pub const XGenericEventCookie = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    extension: c_int,
    evtype: c_int,
    cookie: c_uint,
    data: ?*anyopaque,
};
pub const union__XEvent = extern union {
    type: c_int,
    xany: XAnyEvent,
    xkey: XKeyEvent,
    xbutton: XButtonEvent,
    xmotion: XMotionEvent,
    xcrossing: XCrossingEvent,
    xfocus: XFocusChangeEvent,
    xexpose: XExposeEvent,
    xgraphicsexpose: XGraphicsExposeEvent,
    xnoexpose: XNoExposeEvent,
    xvisibility: XVisibilityEvent,
    xcreatewindow: XCreateWindowEvent,
    xdestroywindow: XDestroyWindowEvent,
    xunmap: XUnmapEvent,
    xmap: XMapEvent,
    xmaprequest: XMapRequestEvent,
    xreparent: XReparentEvent,
    xconfigure: XConfigureEvent,
    xgravity: XGravityEvent,
    xresizerequest: XResizeRequestEvent,
    xconfigurerequest: XConfigureRequestEvent,
    xcirculate: XCirculateEvent,
    xcirculaterequest: XCirculateRequestEvent,
    xproperty: XPropertyEvent,
    xselectionclear: XSelectionClearEvent,
    xselectionrequest: XSelectionRequestEvent,
    xselection: XSelectionEvent,
    xcolormap: XColormapEvent,
    xclient: XClientMessageEvent,
    xmapping: XMappingEvent,
    xerror: XErrorEvent,
    xkeymap: XKeymapEvent,
    xgeneric: XGenericEvent,
    xcookie: XGenericEventCookie,
    pad: [24]c_long,
};
pub const XEvent = union__XEvent;
pub const XCharStruct = extern struct {
    lbearing: c_short,
    rbearing: c_short,
    width: c_short,
    ascent: c_short,
    descent: c_short,
    attributes: c_ushort,
};
pub const XFontProp = extern struct {
    name: Atom,
    card32: c_ulong,
};
pub const XFontStruct = extern struct {
    ext_data: [*c]XExtData,
    fid: Font,
    direction: c_uint,
    min_char_or_byte2: c_uint,
    max_char_or_byte2: c_uint,
    min_byte1: c_uint,
    max_byte1: c_uint,
    all_chars_exist: c_int,
    default_char: c_uint,
    n_properties: c_int,
    properties: [*c]XFontProp,
    min_bounds: XCharStruct,
    max_bounds: XCharStruct,
    per_char: [*c]XCharStruct,
    ascent: c_int,
    descent: c_int,
};
pub const XTextItem = extern struct {
    chars: [*c]u8,
    nchars: c_int,
    delta: c_int,
    font: Font,
};
pub const XChar2b = extern struct {
    byte1: u8,
    byte2: u8,
};
pub const XTextItem16 = extern struct {
    chars: [*c]XChar2b,
    nchars: c_int,
    delta: c_int,
    font: Font,
};
pub const XEDataObject = extern union {
    display: ?*Display,
    gc: GC,
    visual: [*c]Visual,
    screen: [*c]Screen,
    pixmap_format: [*c]ScreenFormat,
    font: [*c]XFontStruct,
};
pub const XFontSetExtents = extern struct {
    max_ink_extent: XRectangle,
    max_logical_extent: XRectangle,
};
pub const struct__XOM = opaque {};
pub const XOM = ?*struct__XOM;
pub const struct__XOC = opaque {};
pub const XOC = ?*struct__XOC;
pub const XFontSet = ?*struct__XOC;
pub const XmbTextItem = extern struct {
    chars: [*c]u8,
    nchars: c_int,
    delta: c_int,
    font_set: XFontSet,
};
pub const XwcTextItem = extern struct {
    chars: [*c]wchar_t,
    nchars: c_int,
    delta: c_int,
    font_set: XFontSet,
};
pub const XOMCharSetList = extern struct {
    charset_count: c_int,
    charset_list: [*c][*c]u8,
};
pub const XOMOrientation_LTR_TTB: c_int = 0;
pub const XOMOrientation_RTL_TTB: c_int = 1;
pub const XOMOrientation_TTB_LTR: c_int = 2;
pub const XOMOrientation_TTB_RTL: c_int = 3;
pub const XOMOrientation_Context: c_int = 4;
pub const XOrientation = c_uint;
pub const XOMOrientation = extern struct {
    num_orientation: c_int,
    orientation: [*c]XOrientation,
};
pub const XOMFontInfo = extern struct {
    num_font: c_int,
    font_struct_list: [*c][*c]XFontStruct,
    font_name_list: [*c][*c]u8,
};
pub const struct__XIM = opaque {};
pub const XIM = ?*struct__XIM;
pub const struct__XIC = opaque {};
pub const XIC = ?*struct__XIC;
pub const XIMProc = ?fn (XIM, XPointer, XPointer) callconv(.C) void;
pub const XICProc = ?fn (XIC, XPointer, XPointer) callconv(.C) c_int;
pub const XIDProc = ?fn (?*Display, XPointer, XPointer) callconv(.C) void;
pub const XIMStyle = c_ulong;
pub const XIMStyles = extern struct {
    count_styles: c_ushort,
    supported_styles: [*c]XIMStyle,
};
pub const XVaNestedList = ?*anyopaque;
pub const XIMCallback = extern struct {
    client_data: XPointer,
    callback: XIMProc,
};
pub const XICCallback = extern struct {
    client_data: XPointer,
    callback: XICProc,
};
pub const XIMFeedback = c_ulong;
const union_unnamed_3 = extern union {
    multi_byte: [*c]u8,
    wide_char: [*c]wchar_t,
};
pub const struct__XIMText = extern struct {
    length: c_ushort,
    feedback: [*c]XIMFeedback,
    encoding_is_wchar: c_int,
    string: union_unnamed_3,
};
pub const XIMText = struct__XIMText;
pub const XIMPreeditState = c_ulong;
pub const struct__XIMPreeditStateNotifyCallbackStruct = extern struct {
    state: XIMPreeditState,
};
pub const XIMPreeditStateNotifyCallbackStruct = struct__XIMPreeditStateNotifyCallbackStruct;
pub const XIMResetState = c_ulong;
pub const XIMStringConversionFeedback = c_ulong;
const union_unnamed_4 = extern union {
    mbs: [*c]u8,
    wcs: [*c]wchar_t,
};
pub const struct__XIMStringConversionText = extern struct {
    length: c_ushort,
    feedback: [*c]XIMStringConversionFeedback,
    encoding_is_wchar: c_int,
    string: union_unnamed_4,
};
pub const XIMStringConversionText = struct__XIMStringConversionText;
pub const XIMStringConversionPosition = c_ushort;
pub const XIMStringConversionType = c_ushort;
pub const XIMStringConversionOperation = c_ushort;
pub const XIMForwardChar: c_int = 0;
pub const XIMBackwardChar: c_int = 1;
pub const XIMForwardWord: c_int = 2;
pub const XIMBackwardWord: c_int = 3;
pub const XIMCaretUp: c_int = 4;
pub const XIMCaretDown: c_int = 5;
pub const XIMNextLine: c_int = 6;
pub const XIMPreviousLine: c_int = 7;
pub const XIMLineStart: c_int = 8;
pub const XIMLineEnd: c_int = 9;
pub const XIMAbsolutePosition: c_int = 10;
pub const XIMDontChange: c_int = 11;
pub const XIMCaretDirection = c_uint;
pub const struct__XIMStringConversionCallbackStruct = extern struct {
    position: XIMStringConversionPosition,
    direction: XIMCaretDirection,
    operation: XIMStringConversionOperation,
    factor: c_ushort,
    text: [*c]XIMStringConversionText,
};
pub const XIMStringConversionCallbackStruct = struct__XIMStringConversionCallbackStruct;
pub const struct__XIMPreeditDrawCallbackStruct = extern struct {
    caret: c_int,
    chg_first: c_int,
    chg_length: c_int,
    text: [*c]XIMText,
};
pub const XIMPreeditDrawCallbackStruct = struct__XIMPreeditDrawCallbackStruct;
pub const XIMIsInvisible: c_int = 0;
pub const XIMIsPrimary: c_int = 1;
pub const XIMIsSecondary: c_int = 2;
pub const XIMCaretStyle = c_uint;
pub const struct__XIMPreeditCaretCallbackStruct = extern struct {
    position: c_int,
    direction: XIMCaretDirection,
    style: XIMCaretStyle,
};
pub const XIMPreeditCaretCallbackStruct = struct__XIMPreeditCaretCallbackStruct;
pub const XIMTextType: c_int = 0;
pub const XIMBitmapType: c_int = 1;
pub const XIMStatusDataType = c_uint;
const union_unnamed_5 = extern union {
    text: [*c]XIMText,
    bitmap: Pixmap,
};
pub const struct__XIMStatusDrawCallbackStruct = extern struct {
    type: XIMStatusDataType,
    data: union_unnamed_5,
};
pub const XIMStatusDrawCallbackStruct = struct__XIMStatusDrawCallbackStruct;
pub const struct__XIMHotKeyTrigger = extern struct {
    keysym: KeySym,
    modifier: c_int,
    modifier_mask: c_int,
};
pub const XIMHotKeyTrigger = struct__XIMHotKeyTrigger;
pub const struct__XIMHotKeyTriggers = extern struct {
    num_hot_key: c_int,
    key: [*c]XIMHotKeyTrigger,
};
pub const XIMHotKeyTriggers = struct__XIMHotKeyTriggers;
pub const XIMHotKeyState = c_ulong;
pub const XIMValuesList = extern struct {
    count_values: c_ushort,
    supported_values: [*c][*c]u8,
};
pub extern var _Xdebug: c_int;
pub extern fn XLoadQueryFont(?*Display, [*c]const u8) [*c]XFontStruct;
pub extern fn XQueryFont(?*Display, XID) [*c]XFontStruct;
pub extern fn XGetMotionEvents(?*Display, Window, Time, Time, [*c]c_int) [*c]XTimeCoord;
pub extern fn XDeleteModifiermapEntry([*c]XModifierKeymap, KeyCode, c_int) [*c]XModifierKeymap;
pub extern fn XGetModifierMapping(?*Display) [*c]XModifierKeymap;
pub extern fn XInsertModifiermapEntry([*c]XModifierKeymap, KeyCode, c_int) [*c]XModifierKeymap;
pub extern fn XNewModifiermap(c_int) [*c]XModifierKeymap;
pub extern fn XCreateImage(?*Display, [*c]Visual, c_uint, c_int, c_int, [*c]u8, c_uint, c_uint, c_int, c_int) [*c]XImage;
pub extern fn XInitImage([*c]XImage) c_int;
pub extern fn XGetImage(?*Display, Drawable, c_int, c_int, c_uint, c_uint, c_ulong, c_int) [*c]XImage;
pub extern fn XGetSubImage(?*Display, Drawable, c_int, c_int, c_uint, c_uint, c_ulong, c_int, [*c]XImage, c_int, c_int) [*c]XImage;
pub extern fn XOpenDisplay([*c]const u8) ?*Display;
pub extern fn XrmInitialize() void;
pub extern fn XFetchBytes(?*Display, [*c]c_int) [*c]u8;
pub extern fn XFetchBuffer(?*Display, [*c]c_int, c_int) [*c]u8;
pub extern fn XGetAtomName(?*Display, Atom) [*c]u8;
pub extern fn XGetAtomNames(?*Display, [*c]Atom, c_int, [*c][*c]u8) c_int;
pub extern fn XGetDefault(?*Display, [*c]const u8, [*c]const u8) [*c]u8;
pub extern fn XDisplayName([*c]const u8) [*c]u8;
pub extern fn XKeysymToString(KeySym) [*c]u8;
pub extern fn XSynchronize(?*Display, c_int) ?fn (?*Display) callconv(.C) c_int;
pub extern fn XSetAfterFunction(?*Display, ?fn (?*Display) callconv(.C) c_int) ?fn (?*Display) callconv(.C) c_int;
pub extern fn XInternAtom(?*Display, [*c]const u8, c_int) Atom;
pub extern fn XInternAtoms(?*Display, [*c][*c]u8, c_int, c_int, [*c]Atom) c_int;
pub extern fn XCopyColormapAndFree(?*Display, Colormap) Colormap;
pub extern fn XCreateColormap(?*Display, Window, [*c]Visual, c_int) Colormap;
pub extern fn XCreatePixmapCursor(?*Display, Pixmap, Pixmap, [*c]XColor, [*c]XColor, c_uint, c_uint) Cursor;
pub extern fn XCreateGlyphCursor(?*Display, Font, Font, c_uint, c_uint, [*c]const XColor, [*c]const XColor) Cursor;
pub extern fn XCreateFontCursor(?*Display, c_uint) Cursor;
pub extern fn XLoadFont(?*Display, [*c]const u8) Font;
pub extern fn XCreateGC(?*Display, Drawable, c_ulong, [*c]XGCValues) GC;
pub extern fn XGContextFromGC(GC) GContext;
pub extern fn XFlushGC(?*Display, GC) void;
pub extern fn XCreatePixmap(?*Display, Drawable, c_uint, c_uint, c_uint) Pixmap;
pub extern fn XCreateBitmapFromData(?*Display, Drawable, [*c]const u8, c_uint, c_uint) Pixmap;
pub extern fn XCreatePixmapFromBitmapData(?*Display, Drawable, [*c]u8, c_uint, c_uint, c_ulong, c_ulong, c_uint) Pixmap;
pub extern fn XCreateSimpleWindow(?*Display, Window, c_int, c_int, c_uint, c_uint, c_uint, c_ulong, c_ulong) Window;
pub extern fn XGetSelectionOwner(?*Display, Atom) Window;
pub extern fn XCreateWindow(?*Display, Window, c_int, c_int, c_uint, c_uint, c_uint, c_int, c_uint, [*c]Visual, c_ulong, [*c]XSetWindowAttributes) Window;
pub extern fn XListInstalledColormaps(?*Display, Window, [*c]c_int) [*c]Colormap;
pub extern fn XListFonts(?*Display, [*c]const u8, c_int, [*c]c_int) [*c][*c]u8;
pub extern fn XListFontsWithInfo(?*Display, [*c]const u8, c_int, [*c]c_int, [*c][*c]XFontStruct) [*c][*c]u8;
pub extern fn XGetFontPath(?*Display, [*c]c_int) [*c][*c]u8;
pub extern fn XListExtensions(?*Display, [*c]c_int) [*c][*c]u8;
pub extern fn XListProperties(?*Display, Window, [*c]c_int) [*c]Atom;
pub extern fn XListHosts(?*Display, [*c]c_int, [*c]c_int) [*c]XHostAddress;
pub extern fn XKeycodeToKeysym(?*Display, KeyCode, c_int) KeySym;
pub extern fn XLookupKeysym([*c]XKeyEvent, c_int) KeySym;
pub extern fn XGetKeyboardMapping(?*Display, KeyCode, c_int, [*c]c_int) [*c]KeySym;
pub extern fn XStringToKeysym([*c]const u8) KeySym;
pub extern fn XMaxRequestSize(?*Display) c_long;
pub extern fn XExtendedMaxRequestSize(?*Display) c_long;
pub extern fn XResourceManagerString(?*Display) [*c]u8;
pub extern fn XScreenResourceString([*c]Screen) [*c]u8;
pub extern fn XDisplayMotionBufferSize(?*Display) c_ulong;
pub extern fn XVisualIDFromVisual([*c]Visual) VisualID;
pub extern fn XInitThreads() c_int;
pub extern fn XLockDisplay(?*Display) void;
pub extern fn XUnlockDisplay(?*Display) void;
pub extern fn XInitExtension(?*Display, [*c]const u8) [*c]XExtCodes;
pub extern fn XAddExtension(?*Display) [*c]XExtCodes;
pub extern fn XFindOnExtensionList([*c][*c]XExtData, c_int) [*c]XExtData;
pub extern fn XEHeadOfExtensionList(XEDataObject) [*c][*c]XExtData;
pub extern fn XRootWindow(?*Display, c_int) Window;
pub extern fn XDefaultRootWindow(?*Display) Window;
pub extern fn XRootWindowOfScreen([*c]Screen) Window;
pub extern fn XDefaultVisual(?*Display, c_int) [*c]Visual;
pub extern fn XDefaultVisualOfScreen([*c]Screen) [*c]Visual;
pub extern fn XDefaultGC(?*Display, c_int) GC;
pub extern fn XDefaultGCOfScreen([*c]Screen) GC;
pub extern fn XBlackPixel(?*Display, c_int) c_ulong;
pub extern fn XWhitePixel(?*Display, c_int) c_ulong;
pub extern fn XAllPlanes() c_ulong;
pub extern fn XBlackPixelOfScreen([*c]Screen) c_ulong;
pub extern fn XWhitePixelOfScreen([*c]Screen) c_ulong;
pub extern fn XNextRequest(?*Display) c_ulong;
pub extern fn XLastKnownRequestProcessed(?*Display) c_ulong;
pub extern fn XServerVendor(?*Display) [*c]u8;
pub extern fn XDisplayString(?*Display) [*c]u8;
pub extern fn XDefaultColormap(?*Display, c_int) Colormap;
pub extern fn XDefaultColormapOfScreen([*c]Screen) Colormap;
pub extern fn XDisplayOfScreen([*c]Screen) ?*Display;
pub extern fn XScreenOfDisplay(?*Display, c_int) [*c]Screen;
pub extern fn XDefaultScreenOfDisplay(?*Display) [*c]Screen;
pub extern fn XEventMaskOfScreen([*c]Screen) c_long;
pub extern fn XScreenNumberOfScreen([*c]Screen) c_int;
pub const XErrorHandler = ?fn (?*Display, [*c]XErrorEvent) callconv(.C) c_int;
pub extern fn XSetErrorHandler(XErrorHandler) XErrorHandler;
pub const XIOErrorHandler = ?fn (?*Display) callconv(.C) c_int;
pub extern fn XSetIOErrorHandler(XIOErrorHandler) XIOErrorHandler;
pub const XIOErrorExitHandler = ?fn (?*Display, ?*anyopaque) callconv(.C) void;
pub extern fn XSetIOErrorExitHandler(?*Display, XIOErrorExitHandler, ?*anyopaque) void;
pub extern fn XListPixmapFormats(?*Display, [*c]c_int) [*c]XPixmapFormatValues;
pub extern fn XListDepths(?*Display, c_int, [*c]c_int) [*c]c_int;
pub extern fn XReconfigureWMWindow(?*Display, Window, c_int, c_uint, [*c]XWindowChanges) c_int;
pub extern fn XGetWMProtocols(?*Display, Window, [*c][*c]Atom, [*c]c_int) c_int;
pub extern fn XSetWMProtocols(?*Display, Window, [*c]Atom, c_int) c_int;
pub extern fn XIconifyWindow(?*Display, Window, c_int) c_int;
pub extern fn XWithdrawWindow(?*Display, Window, c_int) c_int;
pub extern fn XGetCommand(?*Display, Window, [*c][*c][*c]u8, [*c]c_int) c_int;
pub extern fn XGetWMColormapWindows(?*Display, Window, [*c][*c]Window, [*c]c_int) c_int;
pub extern fn XSetWMColormapWindows(?*Display, Window, [*c]Window, c_int) c_int;
pub extern fn XFreeStringList([*c][*c]u8) void;
pub extern fn XSetTransientForHint(?*Display, Window, Window) c_int;
pub extern fn XActivateScreenSaver(?*Display) c_int;
pub extern fn XAddHost(?*Display, [*c]XHostAddress) c_int;
pub extern fn XAddHosts(?*Display, [*c]XHostAddress, c_int) c_int;
pub extern fn XAddToExtensionList([*c][*c]struct__XExtData, [*c]XExtData) c_int;
pub extern fn XAddToSaveSet(?*Display, Window) c_int;
pub extern fn XAllocColor(?*Display, Colormap, [*c]XColor) c_int;
pub extern fn XAllocColorCells(?*Display, Colormap, c_int, [*c]c_ulong, c_uint, [*c]c_ulong, c_uint) c_int;
pub extern fn XAllocColorPlanes(?*Display, Colormap, c_int, [*c]c_ulong, c_int, c_int, c_int, c_int, [*c]c_ulong, [*c]c_ulong, [*c]c_ulong) c_int;
pub extern fn XAllocNamedColor(?*Display, Colormap, [*c]const u8, [*c]XColor, [*c]XColor) c_int;
pub extern fn XAllowEvents(?*Display, c_int, Time) c_int;
pub extern fn XAutoRepeatOff(?*Display) c_int;
pub extern fn XAutoRepeatOn(?*Display) c_int;
pub extern fn XBell(?*Display, c_int) c_int;
pub extern fn XBitmapBitOrder(?*Display) c_int;
pub extern fn XBitmapPad(?*Display) c_int;
pub extern fn XBitmapUnit(?*Display) c_int;
pub extern fn XCellsOfScreen([*c]Screen) c_int;
pub extern fn XChangeActivePointerGrab(?*Display, c_uint, Cursor, Time) c_int;
pub extern fn XChangeGC(?*Display, GC, c_ulong, [*c]XGCValues) c_int;
pub extern fn XChangeKeyboardControl(?*Display, c_ulong, [*c]XKeyboardControl) c_int;
pub extern fn XChangeKeyboardMapping(?*Display, c_int, c_int, [*c]KeySym, c_int) c_int;
pub extern fn XChangePointerControl(?*Display, c_int, c_int, c_int, c_int, c_int) c_int;
pub extern fn XChangeProperty(?*Display, Window, Atom, Atom, c_int, c_int, [*c]const u8, c_int) c_int;
pub extern fn XChangeSaveSet(?*Display, Window, c_int) c_int;
pub extern fn XChangeWindowAttributes(?*Display, Window, c_ulong, [*c]XSetWindowAttributes) c_int;
pub extern fn XCheckIfEvent(?*Display, [*c]XEvent, ?fn (?*Display, [*c]XEvent, XPointer) callconv(.C) c_int, XPointer) c_int;
pub extern fn XCheckMaskEvent(?*Display, c_long, [*c]XEvent) c_int;
pub extern fn XCheckTypedEvent(?*Display, c_int, [*c]XEvent) c_int;
pub extern fn XCheckTypedWindowEvent(?*Display, Window, c_int, [*c]XEvent) c_int;
pub extern fn XCheckWindowEvent(?*Display, Window, c_long, [*c]XEvent) c_int;
pub extern fn XCirculateSubwindows(?*Display, Window, c_int) c_int;
pub extern fn XCirculateSubwindowsDown(?*Display, Window) c_int;
pub extern fn XCirculateSubwindowsUp(?*Display, Window) c_int;
pub extern fn XClearArea(?*Display, Window, c_int, c_int, c_uint, c_uint, c_int) c_int;
pub extern fn XClearWindow(?*Display, Window) c_int;
pub extern fn XCloseDisplay(?*Display) c_int;
pub extern fn XConfigureWindow(?*Display, Window, c_uint, [*c]XWindowChanges) c_int;
pub extern fn XConnectionNumber(?*Display) c_int;
pub extern fn XConvertSelection(?*Display, Atom, Atom, Atom, Window, Time) c_int;
pub extern fn XCopyArea(?*Display, Drawable, Drawable, GC, c_int, c_int, c_uint, c_uint, c_int, c_int) c_int;
pub extern fn XCopyGC(?*Display, GC, c_ulong, GC) c_int;
pub extern fn XCopyPlane(?*Display, Drawable, Drawable, GC, c_int, c_int, c_uint, c_uint, c_int, c_int, c_ulong) c_int;
pub extern fn XDefaultDepth(?*Display, c_int) c_int;
pub extern fn XDefaultDepthOfScreen([*c]Screen) c_int;
pub extern fn XDefaultScreen(?*Display) c_int;
pub extern fn XDefineCursor(?*Display, Window, Cursor) c_int;
pub extern fn XDeleteProperty(?*Display, Window, Atom) c_int;
pub extern fn XDestroyWindow(?*Display, Window) c_int;
pub extern fn XDestroySubwindows(?*Display, Window) c_int;
pub extern fn XDoesBackingStore([*c]Screen) c_int;
pub extern fn XDoesSaveUnders([*c]Screen) c_int;
pub extern fn XDisableAccessControl(?*Display) c_int;
pub extern fn XDisplayCells(?*Display, c_int) c_int;
pub extern fn XDisplayHeight(?*Display, c_int) c_int;
pub extern fn XDisplayHeightMM(?*Display, c_int) c_int;
pub extern fn XDisplayKeycodes(?*Display, [*c]c_int, [*c]c_int) c_int;
pub extern fn XDisplayPlanes(?*Display, c_int) c_int;
pub extern fn XDisplayWidth(?*Display, c_int) c_int;
pub extern fn XDisplayWidthMM(?*Display, c_int) c_int;
pub extern fn XDrawArc(?*Display, Drawable, GC, c_int, c_int, c_uint, c_uint, c_int, c_int) c_int;
pub extern fn XDrawArcs(?*Display, Drawable, GC, [*c]XArc, c_int) c_int;
pub extern fn XDrawImageString(?*Display, Drawable, GC, c_int, c_int, [*c]const u8, c_int) c_int;
pub extern fn XDrawImageString16(?*Display, Drawable, GC, c_int, c_int, [*c]const XChar2b, c_int) c_int;
pub extern fn XDrawLine(?*Display, Drawable, GC, c_int, c_int, c_int, c_int) c_int;
pub extern fn XDrawLines(?*Display, Drawable, GC, [*c]XPoint, c_int, c_int) c_int;
pub extern fn XDrawPoint(?*Display, Drawable, GC, c_int, c_int) c_int;
pub extern fn XDrawPoints(?*Display, Drawable, GC, [*c]XPoint, c_int, c_int) c_int;
pub extern fn XDrawRectangle(?*Display, Drawable, GC, c_int, c_int, c_uint, c_uint) c_int;
pub extern fn XDrawRectangles(?*Display, Drawable, GC, [*c]XRectangle, c_int) c_int;
pub extern fn XDrawSegments(?*Display, Drawable, GC, [*c]XSegment, c_int) c_int;
pub extern fn XDrawString(?*Display, Drawable, GC, c_int, c_int, [*c]const u8, c_int) c_int;
pub extern fn XDrawString16(?*Display, Drawable, GC, c_int, c_int, [*c]const XChar2b, c_int) c_int;
pub extern fn XDrawText(?*Display, Drawable, GC, c_int, c_int, [*c]XTextItem, c_int) c_int;
pub extern fn XDrawText16(?*Display, Drawable, GC, c_int, c_int, [*c]XTextItem16, c_int) c_int;
pub extern fn XEnableAccessControl(?*Display) c_int;
pub extern fn XEventsQueued(?*Display, c_int) c_int;
pub extern fn XFetchName(?*Display, Window, [*c][*c]u8) c_int;
pub extern fn XFillArc(?*Display, Drawable, GC, c_int, c_int, c_uint, c_uint, c_int, c_int) c_int;
pub extern fn XFillArcs(?*Display, Drawable, GC, [*c]XArc, c_int) c_int;
pub extern fn XFillPolygon(?*Display, Drawable, GC, [*c]XPoint, c_int, c_int, c_int) c_int;
pub extern fn XFillRectangle(?*Display, Drawable, GC, c_int, c_int, c_uint, c_uint) c_int;
pub extern fn XFillRectangles(?*Display, Drawable, GC, [*c]XRectangle, c_int) c_int;
pub extern fn XFlush(?*Display) c_int;
pub extern fn XForceScreenSaver(?*Display, c_int) c_int;
pub extern fn XFree(?*anyopaque) c_int;
pub extern fn XFreeColormap(?*Display, Colormap) c_int;
pub extern fn XFreeColors(?*Display, Colormap, [*c]c_ulong, c_int, c_ulong) c_int;
pub extern fn XFreeCursor(?*Display, Cursor) c_int;
pub extern fn XFreeExtensionList([*c][*c]u8) c_int;
pub extern fn XFreeFont(?*Display, [*c]XFontStruct) c_int;
pub extern fn XFreeFontInfo([*c][*c]u8, [*c]XFontStruct, c_int) c_int;
pub extern fn XFreeFontNames([*c][*c]u8) c_int;
pub extern fn XFreeFontPath([*c][*c]u8) c_int;
pub extern fn XFreeGC(?*Display, GC) c_int;
pub extern fn XFreeModifiermap([*c]XModifierKeymap) c_int;
pub extern fn XFreePixmap(?*Display, Pixmap) c_int;
pub extern fn XGeometry(?*Display, c_int, [*c]const u8, [*c]const u8, c_uint, c_uint, c_uint, c_int, c_int, [*c]c_int, [*c]c_int, [*c]c_int, [*c]c_int) c_int;
pub extern fn XGetErrorDatabaseText(?*Display, [*c]const u8, [*c]const u8, [*c]const u8, [*c]u8, c_int) c_int;
pub extern fn XGetErrorText(?*Display, c_int, [*c]u8, c_int) c_int;
pub extern fn XGetFontProperty([*c]XFontStruct, Atom, [*c]c_ulong) c_int;
pub extern fn XGetGCValues(?*Display, GC, c_ulong, [*c]XGCValues) c_int;
pub extern fn XGetGeometry(?*Display, Drawable, [*c]Window, [*c]c_int, [*c]c_int, [*c]c_uint, [*c]c_uint, [*c]c_uint, [*c]c_uint) c_int;
pub extern fn XGetIconName(?*Display, Window, [*c][*c]u8) c_int;
pub extern fn XGetInputFocus(?*Display, [*c]Window, [*c]c_int) c_int;
pub extern fn XGetKeyboardControl(?*Display, [*c]XKeyboardState) c_int;
pub extern fn XGetPointerControl(?*Display, [*c]c_int, [*c]c_int, [*c]c_int) c_int;
pub extern fn XGetPointerMapping(?*Display, [*c]u8, c_int) c_int;
pub extern fn XGetScreenSaver(?*Display, [*c]c_int, [*c]c_int, [*c]c_int, [*c]c_int) c_int;
pub extern fn XGetTransientForHint(?*Display, Window, [*c]Window) c_int;
pub extern fn XGetWindowProperty(?*Display, Window, Atom, c_long, c_long, c_int, Atom, [*c]Atom, [*c]c_int, [*c]c_ulong, [*c]c_ulong, [*c][*c]u8) c_int;
pub extern fn XGetWindowAttributes(?*Display, Window, [*c]XWindowAttributes) c_int;
pub extern fn XGrabButton(?*Display, c_uint, c_uint, Window, c_int, c_uint, c_int, c_int, Window, Cursor) c_int;
pub extern fn XGrabKey(?*Display, c_int, c_uint, Window, c_int, c_int, c_int) c_int;
pub extern fn XGrabKeyboard(?*Display, Window, c_int, c_int, c_int, Time) c_int;
pub extern fn XGrabPointer(?*Display, Window, c_int, c_uint, c_int, c_int, Window, Cursor, Time) c_int;
pub extern fn XGrabServer(?*Display) c_int;
pub extern fn XHeightMMOfScreen([*c]Screen) c_int;
pub extern fn XHeightOfScreen([*c]Screen) c_int;
pub extern fn XIfEvent(?*Display, [*c]XEvent, ?fn (?*Display, [*c]XEvent, XPointer) callconv(.C) c_int, XPointer) c_int;
pub extern fn XImageByteOrder(?*Display) c_int;
pub extern fn XInstallColormap(?*Display, Colormap) c_int;
pub extern fn XKeysymToKeycode(?*Display, KeySym) KeyCode;
pub extern fn XKillClient(?*Display, XID) c_int;
pub extern fn XLookupColor(?*Display, Colormap, [*c]const u8, [*c]XColor, [*c]XColor) c_int;
pub extern fn XLowerWindow(?*Display, Window) c_int;
pub extern fn XMapRaised(?*Display, Window) c_int;
pub extern fn XMapSubwindows(?*Display, Window) c_int;
pub extern fn XMapWindow(?*Display, Window) c_int;
pub extern fn XMaskEvent(?*Display, c_long, [*c]XEvent) c_int;
pub extern fn XMaxCmapsOfScreen([*c]Screen) c_int;
pub extern fn XMinCmapsOfScreen([*c]Screen) c_int;
pub extern fn XMoveResizeWindow(?*Display, Window, c_int, c_int, c_uint, c_uint) c_int;
pub extern fn XMoveWindow(?*Display, Window, c_int, c_int) c_int;
pub extern fn XNextEvent(?*Display, [*c]XEvent) c_int;
pub extern fn XNoOp(?*Display) c_int;
pub extern fn XParseColor(?*Display, Colormap, [*c]const u8, [*c]XColor) c_int;
pub extern fn XParseGeometry([*c]const u8, [*c]c_int, [*c]c_int, [*c]c_uint, [*c]c_uint) c_int;
pub extern fn XPeekEvent(?*Display, [*c]XEvent) c_int;
pub extern fn XPeekIfEvent(?*Display, [*c]XEvent, ?fn (?*Display, [*c]XEvent, XPointer) callconv(.C) c_int, XPointer) c_int;
pub extern fn XPending(?*Display) c_int;
pub extern fn XPlanesOfScreen([*c]Screen) c_int;
pub extern fn XProtocolRevision(?*Display) c_int;
pub extern fn XProtocolVersion(?*Display) c_int;
pub extern fn XPutBackEvent(?*Display, [*c]XEvent) c_int;
pub extern fn XPutImage(?*Display, Drawable, GC, [*c]XImage, c_int, c_int, c_int, c_int, c_uint, c_uint) c_int;
pub extern fn XQLength(?*Display) c_int;
pub extern fn XQueryBestCursor(?*Display, Drawable, c_uint, c_uint, [*c]c_uint, [*c]c_uint) c_int;
pub extern fn XQueryBestSize(?*Display, c_int, Drawable, c_uint, c_uint, [*c]c_uint, [*c]c_uint) c_int;
pub extern fn XQueryBestStipple(?*Display, Drawable, c_uint, c_uint, [*c]c_uint, [*c]c_uint) c_int;
pub extern fn XQueryBestTile(?*Display, Drawable, c_uint, c_uint, [*c]c_uint, [*c]c_uint) c_int;
pub extern fn XQueryColor(?*Display, Colormap, [*c]XColor) c_int;
pub extern fn XQueryColors(?*Display, Colormap, [*c]XColor, c_int) c_int;
pub extern fn XQueryExtension(?*Display, [*c]const u8, [*c]c_int, [*c]c_int, [*c]c_int) c_int;
pub extern fn XQueryKeymap(?*Display, [*c]u8) c_int;
pub extern fn XQueryPointer(?*Display, Window, [*c]Window, [*c]Window, [*c]c_int, [*c]c_int, [*c]c_int, [*c]c_int, [*c]c_uint) c_int;
pub extern fn XQueryTextExtents(?*Display, XID, [*c]const u8, c_int, [*c]c_int, [*c]c_int, [*c]c_int, [*c]XCharStruct) c_int;
pub extern fn XQueryTextExtents16(?*Display, XID, [*c]const XChar2b, c_int, [*c]c_int, [*c]c_int, [*c]c_int, [*c]XCharStruct) c_int;
pub extern fn XQueryTree(?*Display, Window, [*c]Window, [*c]Window, [*c][*c]Window, [*c]c_uint) c_int;
pub extern fn XRaiseWindow(?*Display, Window) c_int;
pub extern fn XReadBitmapFile(?*Display, Drawable, [*c]const u8, [*c]c_uint, [*c]c_uint, [*c]Pixmap, [*c]c_int, [*c]c_int) c_int;
pub extern fn XReadBitmapFileData([*c]const u8, [*c]c_uint, [*c]c_uint, [*c][*c]u8, [*c]c_int, [*c]c_int) c_int;
pub extern fn XRebindKeysym(?*Display, KeySym, [*c]KeySym, c_int, [*c]const u8, c_int) c_int;
pub extern fn XRecolorCursor(?*Display, Cursor, [*c]XColor, [*c]XColor) c_int;
pub extern fn XRefreshKeyboardMapping([*c]XMappingEvent) c_int;
pub extern fn XRemoveFromSaveSet(?*Display, Window) c_int;
pub extern fn XRemoveHost(?*Display, [*c]XHostAddress) c_int;
pub extern fn XRemoveHosts(?*Display, [*c]XHostAddress, c_int) c_int;
pub extern fn XReparentWindow(?*Display, Window, Window, c_int, c_int) c_int;
pub extern fn XResetScreenSaver(?*Display) c_int;
pub extern fn XResizeWindow(?*Display, Window, c_uint, c_uint) c_int;
pub extern fn XRestackWindows(?*Display, [*c]Window, c_int) c_int;
pub extern fn XRotateBuffers(?*Display, c_int) c_int;
pub extern fn XRotateWindowProperties(?*Display, Window, [*c]Atom, c_int, c_int) c_int;
pub extern fn XScreenCount(?*Display) c_int;
pub extern fn XSelectInput(?*Display, Window, c_long) c_int;
pub extern fn XSendEvent(?*Display, Window, c_int, c_long, [*c]XEvent) c_int;
pub extern fn XSetAccessControl(?*Display, c_int) c_int;
pub extern fn XSetArcMode(?*Display, GC, c_int) c_int;
pub extern fn XSetBackground(?*Display, GC, c_ulong) c_int;
pub extern fn XSetClipMask(?*Display, GC, Pixmap) c_int;
pub extern fn XSetClipOrigin(?*Display, GC, c_int, c_int) c_int;
pub extern fn XSetClipRectangles(?*Display, GC, c_int, c_int, [*c]XRectangle, c_int, c_int) c_int;
pub extern fn XSetCloseDownMode(?*Display, c_int) c_int;
pub extern fn XSetCommand(?*Display, Window, [*c][*c]u8, c_int) c_int;
pub extern fn XSetDashes(?*Display, GC, c_int, [*c]const u8, c_int) c_int;
pub extern fn XSetFillRule(?*Display, GC, c_int) c_int;
pub extern fn XSetFillStyle(?*Display, GC, c_int) c_int;
pub extern fn XSetFont(?*Display, GC, Font) c_int;
pub extern fn XSetFontPath(?*Display, [*c][*c]u8, c_int) c_int;
pub extern fn XSetForeground(?*Display, GC, c_ulong) c_int;
pub extern fn XSetFunction(?*Display, GC, c_int) c_int;
pub extern fn XSetGraphicsExposures(?*Display, GC, c_int) c_int;
pub extern fn XSetIconName(?*Display, Window, [*c]const u8) c_int;
pub extern fn XSetInputFocus(?*Display, Window, c_int, Time) c_int;
pub extern fn XSetLineAttributes(?*Display, GC, c_uint, c_int, c_int, c_int) c_int;
pub extern fn XSetModifierMapping(?*Display, [*c]XModifierKeymap) c_int;
pub extern fn XSetPlaneMask(?*Display, GC, c_ulong) c_int;
pub extern fn XSetPointerMapping(?*Display, [*c]const u8, c_int) c_int;
pub extern fn XSetScreenSaver(?*Display, c_int, c_int, c_int, c_int) c_int;
pub extern fn XSetSelectionOwner(?*Display, Atom, Window, Time) c_int;
pub extern fn XSetState(?*Display, GC, c_ulong, c_ulong, c_int, c_ulong) c_int;
pub extern fn XSetStipple(?*Display, GC, Pixmap) c_int;
pub extern fn XSetSubwindowMode(?*Display, GC, c_int) c_int;
pub extern fn XSetTSOrigin(?*Display, GC, c_int, c_int) c_int;
pub extern fn XSetTile(?*Display, GC, Pixmap) c_int;
pub extern fn XSetWindowBackground(?*Display, Window, c_ulong) c_int;
pub extern fn XSetWindowBackgroundPixmap(?*Display, Window, Pixmap) c_int;
pub extern fn XSetWindowBorder(?*Display, Window, c_ulong) c_int;
pub extern fn XSetWindowBorderPixmap(?*Display, Window, Pixmap) c_int;
pub extern fn XSetWindowBorderWidth(?*Display, Window, c_uint) c_int;
pub extern fn XSetWindowColormap(?*Display, Window, Colormap) c_int;
pub extern fn XStoreBuffer(?*Display, [*c]const u8, c_int, c_int) c_int;
pub extern fn XStoreBytes(?*Display, [*c]const u8, c_int) c_int;
pub extern fn XStoreColor(?*Display, Colormap, [*c]XColor) c_int;
pub extern fn XStoreColors(?*Display, Colormap, [*c]XColor, c_int) c_int;
pub extern fn XStoreName(?*Display, Window, [*c]const u8) c_int;
pub extern fn XStoreNamedColor(?*Display, Colormap, [*c]const u8, c_ulong, c_int) c_int;
pub extern fn XSync(?*Display, c_int) c_int;
pub extern fn XTextExtents([*c]XFontStruct, [*c]const u8, c_int, [*c]c_int, [*c]c_int, [*c]c_int, [*c]XCharStruct) c_int;
pub extern fn XTextExtents16([*c]XFontStruct, [*c]const XChar2b, c_int, [*c]c_int, [*c]c_int, [*c]c_int, [*c]XCharStruct) c_int;
pub extern fn XTextWidth([*c]XFontStruct, [*c]const u8, c_int) c_int;
pub extern fn XTextWidth16([*c]XFontStruct, [*c]const XChar2b, c_int) c_int;
pub extern fn XTranslateCoordinates(?*Display, Window, Window, c_int, c_int, [*c]c_int, [*c]c_int, [*c]Window) c_int;
pub extern fn XUndefineCursor(?*Display, Window) c_int;
pub extern fn XUngrabButton(?*Display, c_uint, c_uint, Window) c_int;
pub extern fn XUngrabKey(?*Display, c_int, c_uint, Window) c_int;
pub extern fn XUngrabKeyboard(?*Display, Time) c_int;
pub extern fn XUngrabPointer(?*Display, Time) c_int;
pub extern fn XUngrabServer(?*Display) c_int;
pub extern fn XUninstallColormap(?*Display, Colormap) c_int;
pub extern fn XUnloadFont(?*Display, Font) c_int;
pub extern fn XUnmapSubwindows(?*Display, Window) c_int;
pub extern fn XUnmapWindow(?*Display, Window) c_int;
pub extern fn XVendorRelease(?*Display) c_int;
pub extern fn XWarpPointer(?*Display, Window, Window, c_int, c_int, c_uint, c_uint, c_int, c_int) c_int;
pub extern fn XWidthMMOfScreen([*c]Screen) c_int;
pub extern fn XWidthOfScreen([*c]Screen) c_int;
pub extern fn XWindowEvent(?*Display, Window, c_long, [*c]XEvent) c_int;
pub extern fn XWriteBitmapFile(?*Display, [*c]const u8, Pixmap, c_uint, c_uint, c_int, c_int) c_int;
pub extern fn XSupportsLocale() c_int;
pub extern fn XSetLocaleModifiers([*c]const u8) [*c]u8;
pub extern fn XOpenOM(?*Display, ?*struct__XrmHashBucketRec, [*c]const u8, [*c]const u8) XOM;
pub extern fn XCloseOM(XOM) c_int;
pub extern fn XSetOMValues(XOM, ...) [*c]u8;
pub extern fn XGetOMValues(XOM, ...) [*c]u8;
pub extern fn XDisplayOfOM(XOM) ?*Display;
pub extern fn XLocaleOfOM(XOM) [*c]u8;
pub extern fn XCreateOC(XOM, ...) XOC;
pub extern fn XDestroyOC(XOC) void;
pub extern fn XOMOfOC(XOC) XOM;
pub extern fn XSetOCValues(XOC, ...) [*c]u8;
pub extern fn XGetOCValues(XOC, ...) [*c]u8;
pub extern fn XCreateFontSet(?*Display, [*c]const u8, [*c][*c][*c]u8, [*c]c_int, [*c][*c]u8) XFontSet;
pub extern fn XFreeFontSet(?*Display, XFontSet) void;
pub extern fn XFontsOfFontSet(XFontSet, [*c][*c][*c]XFontStruct, [*c][*c][*c]u8) c_int;
pub extern fn XBaseFontNameListOfFontSet(XFontSet) [*c]u8;
pub extern fn XLocaleOfFontSet(XFontSet) [*c]u8;
pub extern fn XContextDependentDrawing(XFontSet) c_int;
pub extern fn XDirectionalDependentDrawing(XFontSet) c_int;
pub extern fn XContextualDrawing(XFontSet) c_int;
pub extern fn XExtentsOfFontSet(XFontSet) [*c]XFontSetExtents;
pub extern fn XmbTextEscapement(XFontSet, [*c]const u8, c_int) c_int;
pub extern fn XwcTextEscapement(XFontSet, [*c]const wchar_t, c_int) c_int;
pub extern fn Xutf8TextEscapement(XFontSet, [*c]const u8, c_int) c_int;
pub extern fn XmbTextExtents(XFontSet, [*c]const u8, c_int, [*c]XRectangle, [*c]XRectangle) c_int;
pub extern fn XwcTextExtents(XFontSet, [*c]const wchar_t, c_int, [*c]XRectangle, [*c]XRectangle) c_int;
pub extern fn Xutf8TextExtents(XFontSet, [*c]const u8, c_int, [*c]XRectangle, [*c]XRectangle) c_int;
pub extern fn XmbTextPerCharExtents(XFontSet, [*c]const u8, c_int, [*c]XRectangle, [*c]XRectangle, c_int, [*c]c_int, [*c]XRectangle, [*c]XRectangle) c_int;
pub extern fn XwcTextPerCharExtents(XFontSet, [*c]const wchar_t, c_int, [*c]XRectangle, [*c]XRectangle, c_int, [*c]c_int, [*c]XRectangle, [*c]XRectangle) c_int;
pub extern fn Xutf8TextPerCharExtents(XFontSet, [*c]const u8, c_int, [*c]XRectangle, [*c]XRectangle, c_int, [*c]c_int, [*c]XRectangle, [*c]XRectangle) c_int;
pub extern fn XmbDrawText(?*Display, Drawable, GC, c_int, c_int, [*c]XmbTextItem, c_int) void;
pub extern fn XwcDrawText(?*Display, Drawable, GC, c_int, c_int, [*c]XwcTextItem, c_int) void;
pub extern fn Xutf8DrawText(?*Display, Drawable, GC, c_int, c_int, [*c]XmbTextItem, c_int) void;
pub extern fn XmbDrawString(?*Display, Drawable, XFontSet, GC, c_int, c_int, [*c]const u8, c_int) void;
pub extern fn XwcDrawString(?*Display, Drawable, XFontSet, GC, c_int, c_int, [*c]const wchar_t, c_int) void;
pub extern fn Xutf8DrawString(?*Display, Drawable, XFontSet, GC, c_int, c_int, [*c]const u8, c_int) void;
pub extern fn XmbDrawImageString(?*Display, Drawable, XFontSet, GC, c_int, c_int, [*c]const u8, c_int) void;
pub extern fn XwcDrawImageString(?*Display, Drawable, XFontSet, GC, c_int, c_int, [*c]const wchar_t, c_int) void;
pub extern fn Xutf8DrawImageString(?*Display, Drawable, XFontSet, GC, c_int, c_int, [*c]const u8, c_int) void;
pub extern fn XOpenIM(?*Display, ?*struct__XrmHashBucketRec, [*c]u8, [*c]u8) XIM;
pub extern fn XCloseIM(XIM) c_int;
pub extern fn XGetIMValues(XIM, ...) [*c]u8;
pub extern fn XSetIMValues(XIM, ...) [*c]u8;
pub extern fn XDisplayOfIM(XIM) ?*Display;
pub extern fn XLocaleOfIM(XIM) [*c]u8;
pub extern fn XCreateIC(XIM, ...) XIC;
pub extern fn XDestroyIC(XIC) void;
pub extern fn XSetICFocus(XIC) void;
pub extern fn XUnsetICFocus(XIC) void;
pub extern fn XwcResetIC(XIC) [*c]wchar_t;
pub extern fn XmbResetIC(XIC) [*c]u8;
pub extern fn Xutf8ResetIC(XIC) [*c]u8;
pub extern fn XSetICValues(XIC, ...) [*c]u8;
pub extern fn XGetICValues(XIC, ...) [*c]u8;
pub extern fn XIMOfIC(XIC) XIM;
pub extern fn XFilterEvent([*c]XEvent, Window) c_int;
pub extern fn XmbLookupString(XIC, [*c]XKeyPressedEvent, [*c]u8, c_int, [*c]KeySym, [*c]c_int) c_int;
pub extern fn XwcLookupString(XIC, [*c]XKeyPressedEvent, [*c]wchar_t, c_int, [*c]KeySym, [*c]c_int) c_int;
pub extern fn Xutf8LookupString(XIC, [*c]XKeyPressedEvent, [*c]u8, c_int, [*c]KeySym, [*c]c_int) c_int;
pub extern fn XVaCreateNestedList(c_int, ...) XVaNestedList;
pub extern fn XRegisterIMInstantiateCallback(?*Display, ?*struct__XrmHashBucketRec, [*c]u8, [*c]u8, XIDProc, XPointer) c_int;
pub extern fn XUnregisterIMInstantiateCallback(?*Display, ?*struct__XrmHashBucketRec, [*c]u8, [*c]u8, XIDProc, XPointer) c_int;
pub const XConnectionWatchProc = ?fn (?*Display, XPointer, c_int, c_int, [*c]XPointer) callconv(.C) void;
pub extern fn XInternalConnectionNumbers(?*Display, [*c][*c]c_int, [*c]c_int) c_int;
pub extern fn XProcessInternalConnection(?*Display, c_int) void;
pub extern fn XAddConnectionWatch(?*Display, XConnectionWatchProc, XPointer) c_int;
pub extern fn XRemoveConnectionWatch(?*Display, XConnectionWatchProc, XPointer) void;
pub extern fn XSetAuthorization([*c]u8, c_int, [*c]u8, c_int) void;
pub extern fn _Xmbtowc([*c]wchar_t, [*c]u8, c_int) c_int;
pub extern fn _Xwctomb([*c]u8, wchar_t) c_int;
pub extern fn XGetEventData(?*Display, [*c]XGenericEventCookie) c_int;
pub extern fn XFreeEventData(?*Display, [*c]XGenericEventCookie) void;
pub const struct__XkbStateRec = extern struct {
    group: u8,
    locked_group: u8,
    base_group: c_ushort,
    latched_group: c_ushort,
    mods: u8,
    base_mods: u8,
    latched_mods: u8,
    locked_mods: u8,
    compat_state: u8,
    grab_mods: u8,
    compat_grab_mods: u8,
    lookup_mods: u8,
    compat_lookup_mods: u8,
    ptr_buttons: c_ushort,
};
pub const XkbStateRec = struct__XkbStateRec;
pub const XkbStatePtr = [*c]struct__XkbStateRec;
pub const struct__XkbMods = extern struct {
    mask: u8,
    real_mods: u8,
    vmods: c_ushort,
};
pub const XkbModsRec = struct__XkbMods;
pub const XkbModsPtr = [*c]struct__XkbMods;
pub const struct__XkbKTMapEntry = extern struct {
    active: c_int,
    level: u8,
    mods: XkbModsRec,
};
pub const XkbKTMapEntryRec = struct__XkbKTMapEntry;
pub const XkbKTMapEntryPtr = [*c]struct__XkbKTMapEntry;
pub const struct__XkbKeyType = extern struct {
    mods: XkbModsRec,
    num_levels: u8,
    map_count: u8,
    map: XkbKTMapEntryPtr,
    preserve: XkbModsPtr,
    name: Atom,
    level_names: [*c]Atom,
};
pub const XkbKeyTypeRec = struct__XkbKeyType;
pub const XkbKeyTypePtr = [*c]struct__XkbKeyType;
pub const struct__XkbBehavior = extern struct {
    type: u8,
    data: u8,
};
pub const XkbBehavior = struct__XkbBehavior;
pub const struct__XkbAnyAction = extern struct {
    type: u8,
    data: [7]u8,
};
pub const XkbAnyAction = struct__XkbAnyAction;
pub const struct__XkbModAction = extern struct {
    type: u8,
    flags: u8,
    mask: u8,
    real_mods: u8,
    vmods1: u8,
    vmods2: u8,
};
pub const XkbModAction = struct__XkbModAction;
pub const struct__XkbGroupAction = extern struct {
    type: u8,
    flags: u8,
    group_XXX: u8,
};
pub const XkbGroupAction = struct__XkbGroupAction;
pub const struct__XkbISOAction = extern struct {
    type: u8,
    flags: u8,
    mask: u8,
    real_mods: u8,
    group_XXX: u8,
    affect: u8,
    vmods1: u8,
    vmods2: u8,
};
pub const XkbISOAction = struct__XkbISOAction;
pub const struct__XkbPtrAction = extern struct {
    type: u8,
    flags: u8,
    high_XXX: u8,
    low_XXX: u8,
    high_YYY: u8,
    low_YYY: u8,
};
pub const XkbPtrAction = struct__XkbPtrAction;
pub const struct__XkbPtrBtnAction = extern struct {
    type: u8,
    flags: u8,
    count: u8,
    button: u8,
};
pub const XkbPtrBtnAction = struct__XkbPtrBtnAction;
pub const struct__XkbPtrDfltAction = extern struct {
    type: u8,
    flags: u8,
    affect: u8,
    valueXXX: u8,
};
pub const XkbPtrDfltAction = struct__XkbPtrDfltAction;
pub const struct__XkbSwitchScreenAction = extern struct {
    type: u8,
    flags: u8,
    screenXXX: u8,
};
pub const XkbSwitchScreenAction = struct__XkbSwitchScreenAction;
pub const struct__XkbCtrlsAction = extern struct {
    type: u8,
    flags: u8,
    ctrls3: u8,
    ctrls2: u8,
    ctrls1: u8,
    ctrls0: u8,
};
pub const XkbCtrlsAction = struct__XkbCtrlsAction;
pub const struct__XkbMessageAction = extern struct {
    type: u8,
    flags: u8,
    message: [6]u8,
};
pub const XkbMessageAction = struct__XkbMessageAction;
pub const struct__XkbRedirectKeyAction = extern struct {
    type: u8,
    new_key: u8,
    mods_mask: u8,
    mods: u8,
    vmods_mask0: u8,
    vmods_mask1: u8,
    vmods0: u8,
    vmods1: u8,
};
pub const XkbRedirectKeyAction = struct__XkbRedirectKeyAction;
pub const struct__XkbDeviceBtnAction = extern struct {
    type: u8,
    flags: u8,
    count: u8,
    button: u8,
    device: u8,
};
pub const XkbDeviceBtnAction = struct__XkbDeviceBtnAction;
pub const struct__XkbDeviceValuatorAction = extern struct {
    type: u8,
    device: u8,
    v1_what: u8,
    v1_ndx: u8,
    v1_value: u8,
    v2_what: u8,
    v2_ndx: u8,
    v2_value: u8,
};
pub const XkbDeviceValuatorAction = struct__XkbDeviceValuatorAction;
pub const union__XkbAction = extern union {
    any: XkbAnyAction,
    mods: XkbModAction,
    group: XkbGroupAction,
    iso: XkbISOAction,
    ptr: XkbPtrAction,
    btn: XkbPtrBtnAction,
    dflt: XkbPtrDfltAction,
    screen: XkbSwitchScreenAction,
    ctrls: XkbCtrlsAction,
    msg: XkbMessageAction,
    redirect: XkbRedirectKeyAction,
    devbtn: XkbDeviceBtnAction,
    devval: XkbDeviceValuatorAction,
    type: u8,
};
pub const XkbAction = union__XkbAction;
pub const struct__XkbControls = extern struct {
    mk_dflt_btn: u8,
    num_groups: u8,
    groups_wrap: u8,
    internal: XkbModsRec,
    ignore_lock: XkbModsRec,
    enabled_ctrls: c_uint,
    repeat_delay: c_ushort,
    repeat_interval: c_ushort,
    slow_keys_delay: c_ushort,
    debounce_delay: c_ushort,
    mk_delay: c_ushort,
    mk_interval: c_ushort,
    mk_time_to_max: c_ushort,
    mk_max_speed: c_ushort,
    mk_curve: c_short,
    ax_options: c_ushort,
    ax_timeout: c_ushort,
    axt_opts_mask: c_ushort,
    axt_opts_values: c_ushort,
    axt_ctrls_mask: c_uint,
    axt_ctrls_values: c_uint,
    per_key_repeat: [32]u8,
};
pub const XkbControlsRec = struct__XkbControls;
pub const XkbControlsPtr = [*c]struct__XkbControls;
pub const struct__XkbServerMapRec = extern struct {
    num_acts: c_ushort,
    size_acts: c_ushort,
    acts: [*c]XkbAction,
    behaviors: [*c]XkbBehavior,
    key_acts: [*c]c_ushort,
    explicit: [*c]u8,
    vmods: [16]u8,
    vmodmap: [*c]c_ushort,
};
pub const XkbServerMapRec = struct__XkbServerMapRec;
pub const XkbServerMapPtr = [*c]struct__XkbServerMapRec;
pub const struct__XkbSymMapRec = extern struct {
    kt_index: [4]u8,
    group_info: u8,
    width: u8,
    offset: c_ushort,
};
pub const XkbSymMapRec = struct__XkbSymMapRec;
pub const XkbSymMapPtr = [*c]struct__XkbSymMapRec;
pub const struct__XkbClientMapRec = extern struct {
    size_types: u8,
    num_types: u8,
    types: XkbKeyTypePtr,
    size_syms: c_ushort,
    num_syms: c_ushort,
    syms: [*c]KeySym,
    key_sym_map: XkbSymMapPtr,
    modmap: [*c]u8,
};
pub const XkbClientMapRec = struct__XkbClientMapRec;
pub const XkbClientMapPtr = [*c]struct__XkbClientMapRec;
pub const struct__XkbSymInterpretRec = extern struct {
    sym: KeySym,
    flags: u8,
    match: u8,
    mods: u8,
    virtual_mod: u8,
    act: XkbAnyAction,
};
pub const XkbSymInterpretRec = struct__XkbSymInterpretRec;
pub const XkbSymInterpretPtr = [*c]struct__XkbSymInterpretRec;
pub const struct__XkbCompatMapRec = extern struct {
    sym_interpret: XkbSymInterpretPtr,
    groups: [4]XkbModsRec,
    num_si: c_ushort,
    size_si: c_ushort,
};
pub const XkbCompatMapRec = struct__XkbCompatMapRec;
pub const XkbCompatMapPtr = [*c]struct__XkbCompatMapRec;
pub const struct__XkbIndicatorMapRec = extern struct {
    flags: u8,
    which_groups: u8,
    groups: u8,
    which_mods: u8,
    mods: XkbModsRec,
    ctrls: c_uint,
};
pub const XkbIndicatorMapRec = struct__XkbIndicatorMapRec;
pub const XkbIndicatorMapPtr = [*c]struct__XkbIndicatorMapRec;
pub const struct__XkbIndicatorRec = extern struct {
    phys_indicators: c_ulong,
    maps: [32]XkbIndicatorMapRec,
};
pub const XkbIndicatorRec = struct__XkbIndicatorRec;
pub const XkbIndicatorPtr = [*c]struct__XkbIndicatorRec;
pub const struct__XkbKeyNameRec = extern struct {
    name: [4]u8,
};
pub const XkbKeyNameRec = struct__XkbKeyNameRec;
pub const XkbKeyNamePtr = [*c]struct__XkbKeyNameRec;
pub const struct__XkbKeyAliasRec = extern struct {
    real: [4]u8,
    alias: [4]u8,
};
pub const XkbKeyAliasRec = struct__XkbKeyAliasRec;
pub const XkbKeyAliasPtr = [*c]struct__XkbKeyAliasRec;
pub const struct__XkbNamesRec = extern struct {
    keycodes: Atom,
    geometry: Atom,
    symbols: Atom,
    types: Atom,
    compat: Atom,
    vmods: [16]Atom,
    indicators: [32]Atom,
    groups: [4]Atom,
    keys: XkbKeyNamePtr,
    key_aliases: XkbKeyAliasPtr,
    radio_groups: [*c]Atom,
    phys_symbols: Atom,
    num_keys: u8,
    num_key_aliases: u8,
    num_rg: c_ushort,
};
pub const XkbNamesRec = struct__XkbNamesRec;
pub const XkbNamesPtr = [*c]struct__XkbNamesRec;
pub const struct__XkbGeometry = opaque {};
pub const XkbGeometryPtr = ?*struct__XkbGeometry;
pub const struct__XkbDesc = extern struct {
    dpy: ?*struct__XDisplay,
    flags: c_ushort,
    device_spec: c_ushort,
    min_key_code: KeyCode,
    max_key_code: KeyCode,
    ctrls: XkbControlsPtr,
    server: XkbServerMapPtr,
    map: XkbClientMapPtr,
    indicators: XkbIndicatorPtr,
    names: XkbNamesPtr,
    compat: XkbCompatMapPtr,
    geom: XkbGeometryPtr,
};
pub const XkbDescRec = struct__XkbDesc;
pub const XkbDescPtr = [*c]struct__XkbDesc;
pub const struct__XkbMapChanges = extern struct {
    changed: c_ushort,
    min_key_code: KeyCode,
    max_key_code: KeyCode,
    first_type: u8,
    num_types: u8,
    first_key_sym: KeyCode,
    num_key_syms: u8,
    first_key_act: KeyCode,
    num_key_acts: u8,
    first_key_behavior: KeyCode,
    num_key_behaviors: u8,
    first_key_explicit: KeyCode,
    num_key_explicit: u8,
    first_modmap_key: KeyCode,
    num_modmap_keys: u8,
    first_vmodmap_key: KeyCode,
    num_vmodmap_keys: u8,
    pad: u8,
    vmods: c_ushort,
};
pub const XkbMapChangesRec = struct__XkbMapChanges;
pub const XkbMapChangesPtr = [*c]struct__XkbMapChanges;
pub const struct__XkbControlsChanges = extern struct {
    changed_ctrls: c_uint,
    enabled_ctrls_changes: c_uint,
    num_groups_changed: c_int,
};
pub const XkbControlsChangesRec = struct__XkbControlsChanges;
pub const XkbControlsChangesPtr = [*c]struct__XkbControlsChanges;
pub const struct__XkbIndicatorChanges = extern struct {
    state_changes: c_uint,
    map_changes: c_uint,
};
pub const XkbIndicatorChangesRec = struct__XkbIndicatorChanges;
pub const XkbIndicatorChangesPtr = [*c]struct__XkbIndicatorChanges;
pub const struct__XkbNameChanges = extern struct {
    changed: c_uint,
    first_type: u8,
    num_types: u8,
    first_lvl: u8,
    num_lvls: u8,
    num_aliases: u8,
    num_rg: u8,
    first_key: u8,
    num_keys: u8,
    changed_vmods: c_ushort,
    changed_indicators: c_ulong,
    changed_groups: u8,
};
pub const XkbNameChangesRec = struct__XkbNameChanges;
pub const XkbNameChangesPtr = [*c]struct__XkbNameChanges;
pub const struct__XkbCompatChanges = extern struct {
    changed_groups: u8,
    first_si: c_ushort,
    num_si: c_ushort,
};
pub const XkbCompatChangesRec = struct__XkbCompatChanges;
pub const XkbCompatChangesPtr = [*c]struct__XkbCompatChanges;
pub const struct__XkbChanges = extern struct {
    device_spec: c_ushort,
    state_changes: c_ushort,
    map: XkbMapChangesRec,
    ctrls: XkbControlsChangesRec,
    indicators: XkbIndicatorChangesRec,
    names: XkbNameChangesRec,
    compat: XkbCompatChangesRec,
};
pub const XkbChangesRec = struct__XkbChanges;
pub const XkbChangesPtr = [*c]struct__XkbChanges;
pub const struct__XkbComponentNames = extern struct {
    keymap: [*c]u8,
    keycodes: [*c]u8,
    types: [*c]u8,
    compat: [*c]u8,
    symbols: [*c]u8,
    geometry: [*c]u8,
};
pub const XkbComponentNamesRec = struct__XkbComponentNames;
pub const XkbComponentNamesPtr = [*c]struct__XkbComponentNames;
pub const struct__XkbComponentName = extern struct {
    flags: c_ushort,
    name: [*c]u8,
};
pub const XkbComponentNameRec = struct__XkbComponentName;
pub const XkbComponentNamePtr = [*c]struct__XkbComponentName;
pub const struct__XkbComponentList = extern struct {
    num_keymaps: c_int,
    num_keycodes: c_int,
    num_types: c_int,
    num_compat: c_int,
    num_symbols: c_int,
    num_geometry: c_int,
    keymaps: XkbComponentNamePtr,
    keycodes: XkbComponentNamePtr,
    types: XkbComponentNamePtr,
    compat: XkbComponentNamePtr,
    symbols: XkbComponentNamePtr,
    geometry: XkbComponentNamePtr,
};
pub const XkbComponentListRec = struct__XkbComponentList;
pub const XkbComponentListPtr = [*c]struct__XkbComponentList;
pub const struct__XkbDeviceLedInfo = extern struct {
    led_class: c_ushort,
    led_id: c_ushort,
    phys_indicators: c_uint,
    maps_present: c_uint,
    names_present: c_uint,
    state: c_uint,
    names: [32]Atom,
    maps: [32]XkbIndicatorMapRec,
};
pub const XkbDeviceLedInfoRec = struct__XkbDeviceLedInfo;
pub const XkbDeviceLedInfoPtr = [*c]struct__XkbDeviceLedInfo;
pub const struct__XkbDeviceInfo = extern struct {
    name: [*c]u8,
    type: Atom,
    device_spec: c_ushort,
    has_own_state: c_int,
    supported: c_ushort,
    unsupported: c_ushort,
    num_btns: c_ushort,
    btn_acts: [*c]XkbAction,
    sz_leds: c_ushort,
    num_leds: c_ushort,
    dflt_kbd_fb: c_ushort,
    dflt_led_fb: c_ushort,
    leds: XkbDeviceLedInfoPtr,
};
pub const XkbDeviceInfoRec = struct__XkbDeviceInfo;
pub const XkbDeviceInfoPtr = [*c]struct__XkbDeviceInfo;
pub const struct__XkbDeviceLedChanges = extern struct {
    led_class: c_ushort,
    led_id: c_ushort,
    defined: c_uint,
    next: [*c]struct__XkbDeviceLedChanges,
};
pub const XkbDeviceLedChangesRec = struct__XkbDeviceLedChanges;
pub const XkbDeviceLedChangesPtr = [*c]struct__XkbDeviceLedChanges;
pub const struct__XkbDeviceChanges = extern struct {
    changed: c_uint,
    first_btn: c_ushort,
    num_btns: c_ushort,
    leds: XkbDeviceLedChangesRec,
};
pub const XkbDeviceChangesRec = struct__XkbDeviceChanges;
pub const XkbDeviceChangesPtr = [*c]struct__XkbDeviceChanges;
pub const struct__XkbAnyEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    time: Time,
    xkb_type: c_int,
    device: c_uint,
};
pub const XkbAnyEvent = struct__XkbAnyEvent;
pub const struct__XkbNewKeyboardNotify = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    time: Time,
    xkb_type: c_int,
    device: c_int,
    old_device: c_int,
    min_key_code: c_int,
    max_key_code: c_int,
    old_min_key_code: c_int,
    old_max_key_code: c_int,
    changed: c_uint,
    req_major: u8,
    req_minor: u8,
};
pub const XkbNewKeyboardNotifyEvent = struct__XkbNewKeyboardNotify;
pub const struct__XkbMapNotifyEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    time: Time,
    xkb_type: c_int,
    device: c_int,
    changed: c_uint,
    flags: c_uint,
    first_type: c_int,
    num_types: c_int,
    min_key_code: KeyCode,
    max_key_code: KeyCode,
    first_key_sym: KeyCode,
    first_key_act: KeyCode,
    first_key_behavior: KeyCode,
    first_key_explicit: KeyCode,
    first_modmap_key: KeyCode,
    first_vmodmap_key: KeyCode,
    num_key_syms: c_int,
    num_key_acts: c_int,
    num_key_behaviors: c_int,
    num_key_explicit: c_int,
    num_modmap_keys: c_int,
    num_vmodmap_keys: c_int,
    vmods: c_uint,
};
pub const XkbMapNotifyEvent = struct__XkbMapNotifyEvent;
pub const struct__XkbStateNotifyEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    time: Time,
    xkb_type: c_int,
    device: c_int,
    changed: c_uint,
    group: c_int,
    base_group: c_int,
    latched_group: c_int,
    locked_group: c_int,
    mods: c_uint,
    base_mods: c_uint,
    latched_mods: c_uint,
    locked_mods: c_uint,
    compat_state: c_int,
    grab_mods: u8,
    compat_grab_mods: u8,
    lookup_mods: u8,
    compat_lookup_mods: u8,
    ptr_buttons: c_int,
    keycode: KeyCode,
    event_type: u8,
    req_major: u8,
    req_minor: u8,
};
pub const XkbStateNotifyEvent = struct__XkbStateNotifyEvent;
pub const struct__XkbControlsNotify = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    time: Time,
    xkb_type: c_int,
    device: c_int,
    changed_ctrls: c_uint,
    enabled_ctrls: c_uint,
    enabled_ctrl_changes: c_uint,
    num_groups: c_int,
    keycode: KeyCode,
    event_type: u8,
    req_major: u8,
    req_minor: u8,
};
pub const XkbControlsNotifyEvent = struct__XkbControlsNotify;
pub const struct__XkbIndicatorNotify = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    time: Time,
    xkb_type: c_int,
    device: c_int,
    changed: c_uint,
    state: c_uint,
};
pub const XkbIndicatorNotifyEvent = struct__XkbIndicatorNotify;
pub const struct__XkbNamesNotify = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    time: Time,
    xkb_type: c_int,
    device: c_int,
    changed: c_uint,
    first_type: c_int,
    num_types: c_int,
    first_lvl: c_int,
    num_lvls: c_int,
    num_aliases: c_int,
    num_radio_groups: c_int,
    changed_vmods: c_uint,
    changed_groups: c_uint,
    changed_indicators: c_uint,
    first_key: c_int,
    num_keys: c_int,
};
pub const XkbNamesNotifyEvent = struct__XkbNamesNotify;
pub const struct__XkbCompatMapNotify = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    time: Time,
    xkb_type: c_int,
    device: c_int,
    changed_groups: c_uint,
    first_si: c_int,
    num_si: c_int,
    num_total_si: c_int,
};
pub const XkbCompatMapNotifyEvent = struct__XkbCompatMapNotify;
pub const struct__XkbBellNotify = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    time: Time,
    xkb_type: c_int,
    device: c_int,
    percent: c_int,
    pitch: c_int,
    duration: c_int,
    bell_class: c_int,
    bell_id: c_int,
    name: Atom,
    window: Window,
    event_only: c_int,
};
pub const XkbBellNotifyEvent = struct__XkbBellNotify;
pub const struct__XkbActionMessage = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    time: Time,
    xkb_type: c_int,
    device: c_int,
    keycode: KeyCode,
    press: c_int,
    key_event_follows: c_int,
    group: c_int,
    mods: c_uint,
    message: [7]u8,
};
pub const XkbActionMessageEvent = struct__XkbActionMessage;
pub const struct__XkbAccessXNotify = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    time: Time,
    xkb_type: c_int,
    device: c_int,
    detail: c_int,
    keycode: c_int,
    sk_delay: c_int,
    debounce_delay: c_int,
};
pub const XkbAccessXNotifyEvent = struct__XkbAccessXNotify;
pub const struct__XkbExtensionDeviceNotify = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    time: Time,
    xkb_type: c_int,
    device: c_int,
    reason: c_uint,
    supported: c_uint,
    unsupported: c_uint,
    first_btn: c_int,
    num_btns: c_int,
    leds_defined: c_uint,
    led_state: c_uint,
    led_class: c_int,
    led_id: c_int,
};
pub const XkbExtensionDeviceNotifyEvent = struct__XkbExtensionDeviceNotify;
pub const union__XkbEvent = extern union {
    type: c_int,
    any: XkbAnyEvent,
    new_kbd: XkbNewKeyboardNotifyEvent,
    map: XkbMapNotifyEvent,
    state: XkbStateNotifyEvent,
    ctrls: XkbControlsNotifyEvent,
    indicators: XkbIndicatorNotifyEvent,
    names: XkbNamesNotifyEvent,
    compat: XkbCompatMapNotifyEvent,
    bell: XkbBellNotifyEvent,
    message: XkbActionMessageEvent,
    accessx: XkbAccessXNotifyEvent,
    device: XkbExtensionDeviceNotifyEvent,
    core: XEvent,
};
pub const XkbEvent = union__XkbEvent;
pub const struct__XkbKbdDpyState = opaque {};
pub const XkbKbdDpyStateRec = struct__XkbKbdDpyState;
pub const XkbKbdDpyStatePtr = ?*struct__XkbKbdDpyState;
pub extern fn XkbIgnoreExtension(c_int) c_int;
pub extern fn XkbOpenDisplay([*c]const u8, [*c]c_int, [*c]c_int, [*c]c_int, [*c]c_int, [*c]c_int) ?*Display;
pub extern fn XkbQueryExtension(?*Display, [*c]c_int, [*c]c_int, [*c]c_int, [*c]c_int, [*c]c_int) c_int;
pub extern fn XkbUseExtension(?*Display, [*c]c_int, [*c]c_int) c_int;
pub extern fn XkbLibraryVersion([*c]c_int, [*c]c_int) c_int;
pub extern fn XkbSetXlibControls(?*Display, c_uint, c_uint) c_uint;
pub extern fn XkbGetXlibControls(?*Display) c_uint;
pub extern fn XkbXlibControlsImplemented() c_uint;
pub const XkbInternAtomFunc = ?fn (?*Display, [*c]const u8, c_int) callconv(.C) Atom;
pub const XkbGetAtomNameFunc = ?fn (?*Display, Atom) callconv(.C) [*c]u8;
pub extern fn XkbSetAtomFuncs(XkbInternAtomFunc, XkbGetAtomNameFunc) void;
pub extern fn XkbKeycodeToKeysym(?*Display, KeyCode, c_int, c_int) KeySym;
pub extern fn XkbKeysymToModifiers(?*Display, KeySym) c_uint;
pub extern fn XkbLookupKeySym(?*Display, KeyCode, c_uint, [*c]c_uint, [*c]KeySym) c_int;
pub extern fn XkbLookupKeyBinding(?*Display, KeySym, c_uint, [*c]u8, c_int, [*c]c_int) c_int;
pub extern fn XkbTranslateKeyCode(XkbDescPtr, KeyCode, c_uint, [*c]c_uint, [*c]KeySym) c_int;
pub extern fn XkbTranslateKeySym(?*Display, [*c]KeySym, c_uint, [*c]u8, c_int, [*c]c_int) c_int;
pub extern fn XkbSetAutoRepeatRate(?*Display, c_uint, c_uint, c_uint) c_int;
pub extern fn XkbGetAutoRepeatRate(?*Display, c_uint, [*c]c_uint, [*c]c_uint) c_int;
pub extern fn XkbChangeEnabledControls(?*Display, c_uint, c_uint, c_uint) c_int;
pub extern fn XkbDeviceBell(?*Display, Window, c_int, c_int, c_int, c_int, Atom) c_int;
pub extern fn XkbForceDeviceBell(?*Display, c_int, c_int, c_int, c_int) c_int;
pub extern fn XkbDeviceBellEvent(?*Display, Window, c_int, c_int, c_int, c_int, Atom) c_int;
pub extern fn XkbBell(?*Display, Window, c_int, Atom) c_int;
pub extern fn XkbForceBell(?*Display, c_int) c_int;
pub extern fn XkbBellEvent(?*Display, Window, c_int, Atom) c_int;
pub extern fn XkbSelectEvents(?*Display, c_uint, c_uint, c_uint) c_int;
pub extern fn XkbSelectEventDetails(?*Display, c_uint, c_uint, c_ulong, c_ulong) c_int;
pub extern fn XkbNoteMapChanges(XkbMapChangesPtr, [*c]XkbMapNotifyEvent, c_uint) void;
pub extern fn XkbNoteNameChanges(XkbNameChangesPtr, [*c]XkbNamesNotifyEvent, c_uint) void;
pub extern fn XkbGetIndicatorState(?*Display, c_uint, [*c]c_uint) c_int;
pub extern fn XkbGetDeviceIndicatorState(?*Display, c_uint, c_uint, c_uint, [*c]c_uint) c_int;
pub extern fn XkbGetIndicatorMap(?*Display, c_ulong, XkbDescPtr) c_int;
pub extern fn XkbSetIndicatorMap(?*Display, c_ulong, XkbDescPtr) c_int;
pub extern fn XkbGetNamedIndicator(?*Display, Atom, [*c]c_int, [*c]c_int, XkbIndicatorMapPtr, [*c]c_int) c_int;
pub extern fn XkbGetNamedDeviceIndicator(?*Display, c_uint, c_uint, c_uint, Atom, [*c]c_int, [*c]c_int, XkbIndicatorMapPtr, [*c]c_int) c_int;
pub extern fn XkbSetNamedIndicator(?*Display, Atom, c_int, c_int, c_int, XkbIndicatorMapPtr) c_int;
pub extern fn XkbSetNamedDeviceIndicator(?*Display, c_uint, c_uint, c_uint, Atom, c_int, c_int, c_int, XkbIndicatorMapPtr) c_int;
pub extern fn XkbLockModifiers(?*Display, c_uint, c_uint, c_uint) c_int;
pub extern fn XkbLatchModifiers(?*Display, c_uint, c_uint, c_uint) c_int;
pub extern fn XkbLockGroup(?*Display, c_uint, c_uint) c_int;
pub extern fn XkbLatchGroup(?*Display, c_uint, c_uint) c_int;
pub extern fn XkbSetServerInternalMods(?*Display, c_uint, c_uint, c_uint, c_uint, c_uint) c_int;
pub extern fn XkbSetIgnoreLockMods(?*Display, c_uint, c_uint, c_uint, c_uint, c_uint) c_int;
pub extern fn XkbVirtualModsToReal(XkbDescPtr, c_uint, [*c]c_uint) c_int;
pub extern fn XkbComputeEffectiveMap(XkbDescPtr, XkbKeyTypePtr, [*c]u8) c_int;
pub extern fn XkbInitCanonicalKeyTypes(XkbDescPtr, c_uint, c_int) c_int;
pub extern fn XkbAllocKeyboard() XkbDescPtr;
pub extern fn XkbFreeKeyboard(XkbDescPtr, c_uint, c_int) void;
pub extern fn XkbAllocClientMap(XkbDescPtr, c_uint, c_uint) c_int;
pub extern fn XkbAllocServerMap(XkbDescPtr, c_uint, c_uint) c_int;
pub extern fn XkbFreeClientMap(XkbDescPtr, c_uint, c_int) void;
pub extern fn XkbFreeServerMap(XkbDescPtr, c_uint, c_int) void;
pub extern fn XkbAddKeyType(XkbDescPtr, Atom, c_int, c_int, c_int) XkbKeyTypePtr;
pub extern fn XkbAllocIndicatorMaps(XkbDescPtr) c_int;
pub extern fn XkbFreeIndicatorMaps(XkbDescPtr) void;
pub extern fn XkbGetMap(?*Display, c_uint, c_uint) XkbDescPtr;
pub extern fn XkbGetUpdatedMap(?*Display, c_uint, XkbDescPtr) c_int;
pub extern fn XkbGetMapChanges(?*Display, XkbDescPtr, XkbMapChangesPtr) c_int;
pub extern fn XkbRefreshKeyboardMapping([*c]XkbMapNotifyEvent) c_int;
pub extern fn XkbGetKeyTypes(?*Display, c_uint, c_uint, XkbDescPtr) c_int;
pub extern fn XkbGetKeySyms(?*Display, c_uint, c_uint, XkbDescPtr) c_int;
pub extern fn XkbGetKeyActions(?*Display, c_uint, c_uint, XkbDescPtr) c_int;
pub extern fn XkbGetKeyBehaviors(?*Display, c_uint, c_uint, XkbDescPtr) c_int;
pub extern fn XkbGetVirtualMods(?*Display, c_uint, XkbDescPtr) c_int;
pub extern fn XkbGetKeyExplicitComponents(?*Display, c_uint, c_uint, XkbDescPtr) c_int;
pub extern fn XkbGetKeyModifierMap(?*Display, c_uint, c_uint, XkbDescPtr) c_int;
pub extern fn XkbGetKeyVirtualModMap(?*Display, c_uint, c_uint, XkbDescPtr) c_int;
pub extern fn XkbAllocControls(XkbDescPtr, c_uint) c_int;
pub extern fn XkbFreeControls(XkbDescPtr, c_uint, c_int) void;
pub extern fn XkbGetControls(?*Display, c_ulong, XkbDescPtr) c_int;
pub extern fn XkbSetControls(?*Display, c_ulong, XkbDescPtr) c_int;
pub extern fn XkbNoteControlsChanges(XkbControlsChangesPtr, [*c]XkbControlsNotifyEvent, c_uint) void;
pub extern fn XkbAllocCompatMap(XkbDescPtr, c_uint, c_uint) c_int;
pub extern fn XkbFreeCompatMap(XkbDescPtr, c_uint, c_int) void;
pub extern fn XkbGetCompatMap(?*Display, c_uint, XkbDescPtr) c_int;
pub extern fn XkbSetCompatMap(?*Display, c_uint, XkbDescPtr, c_int) c_int;
pub extern fn XkbAddSymInterpret(XkbDescPtr, XkbSymInterpretPtr, c_int, XkbChangesPtr) XkbSymInterpretPtr;
pub extern fn XkbAllocNames(XkbDescPtr, c_uint, c_int, c_int) c_int;
pub extern fn XkbGetNames(?*Display, c_uint, XkbDescPtr) c_int;
pub extern fn XkbSetNames(?*Display, c_uint, c_uint, c_uint, XkbDescPtr) c_int;
pub extern fn XkbChangeNames(?*Display, XkbDescPtr, XkbNameChangesPtr) c_int;
pub extern fn XkbFreeNames(XkbDescPtr, c_uint, c_int) void;
pub extern fn XkbGetState(?*Display, c_uint, XkbStatePtr) c_int;
pub extern fn XkbSetMap(?*Display, c_uint, XkbDescPtr) c_int;
pub extern fn XkbChangeMap(?*Display, XkbDescPtr, XkbMapChangesPtr) c_int;
pub extern fn XkbSetDetectableAutoRepeat(?*Display, c_int, [*c]c_int) c_int;
pub extern fn XkbGetDetectableAutoRepeat(?*Display, [*c]c_int) c_int;
pub extern fn XkbSetAutoResetControls(?*Display, c_uint, [*c]c_uint, [*c]c_uint) c_int;
pub extern fn XkbGetAutoResetControls(?*Display, [*c]c_uint, [*c]c_uint) c_int;
pub extern fn XkbSetPerClientControls(?*Display, c_uint, [*c]c_uint) c_int;
pub extern fn XkbGetPerClientControls(?*Display, [*c]c_uint) c_int;
pub extern fn XkbCopyKeyType(XkbKeyTypePtr, XkbKeyTypePtr) c_int;
pub extern fn XkbCopyKeyTypes(XkbKeyTypePtr, XkbKeyTypePtr, c_int) c_int;
pub extern fn XkbResizeKeyType(XkbDescPtr, c_int, c_int, c_int, c_int) c_int;
pub extern fn XkbResizeKeySyms(XkbDescPtr, c_int, c_int) [*c]KeySym;
pub extern fn XkbResizeKeyActions(XkbDescPtr, c_int, c_int) [*c]XkbAction;
pub extern fn XkbChangeTypesOfKey(XkbDescPtr, c_int, c_int, c_uint, [*c]c_int, XkbMapChangesPtr) c_int;
pub extern fn XkbChangeKeycodeRange(XkbDescPtr, c_int, c_int, XkbChangesPtr) c_int;
pub extern fn XkbListComponents(?*Display, c_uint, XkbComponentNamesPtr, [*c]c_int) XkbComponentListPtr;
pub extern fn XkbFreeComponentList(XkbComponentListPtr) void;
pub extern fn XkbGetKeyboard(?*Display, c_uint, c_uint) XkbDescPtr;
pub extern fn XkbGetKeyboardByName(?*Display, c_uint, XkbComponentNamesPtr, c_uint, c_uint, c_int) XkbDescPtr;
pub extern fn XkbKeyTypesForCoreSymbols(XkbDescPtr, c_int, [*c]KeySym, c_uint, [*c]c_int, [*c]KeySym) c_int;
pub extern fn XkbApplyCompatMapToKey(XkbDescPtr, KeyCode, XkbChangesPtr) c_int;
pub extern fn XkbUpdateMapFromCore(XkbDescPtr, KeyCode, c_int, c_int, [*c]KeySym, XkbChangesPtr) c_int;
pub extern fn XkbAddDeviceLedInfo(XkbDeviceInfoPtr, c_uint, c_uint) XkbDeviceLedInfoPtr;
pub extern fn XkbResizeDeviceButtonActions(XkbDeviceInfoPtr, c_uint) c_int;
pub extern fn XkbAllocDeviceInfo(c_uint, c_uint, c_uint) XkbDeviceInfoPtr;
pub extern fn XkbFreeDeviceInfo(XkbDeviceInfoPtr, c_uint, c_int) void;
pub extern fn XkbNoteDeviceChanges(XkbDeviceChangesPtr, [*c]XkbExtensionDeviceNotifyEvent, c_uint) void;
pub extern fn XkbGetDeviceInfo(?*Display, c_uint, c_uint, c_uint, c_uint) XkbDeviceInfoPtr;
pub extern fn XkbGetDeviceInfoChanges(?*Display, XkbDeviceInfoPtr, XkbDeviceChangesPtr) c_int;
pub extern fn XkbGetDeviceButtonActions(?*Display, XkbDeviceInfoPtr, c_int, c_uint, c_uint) c_int;
pub extern fn XkbGetDeviceLedInfo(?*Display, XkbDeviceInfoPtr, c_uint, c_uint, c_uint) c_int;
pub extern fn XkbSetDeviceInfo(?*Display, c_uint, XkbDeviceInfoPtr) c_int;
pub extern fn XkbChangeDeviceInfo(?*Display, XkbDeviceInfoPtr, XkbDeviceChangesPtr) c_int;
pub extern fn XkbSetDeviceLedInfo(?*Display, XkbDeviceInfoPtr, c_uint, c_uint, c_uint) c_int;
pub extern fn XkbSetDeviceButtonActions(?*Display, XkbDeviceInfoPtr, c_uint, c_uint) c_int;
pub extern fn XkbToControl(u8) u8;
pub extern fn XkbSetDebuggingFlags(?*Display, c_uint, c_uint, [*c]u8, c_uint, c_uint, [*c]c_uint, [*c]c_uint) c_int;
pub extern fn XkbApplyVirtualModChanges(XkbDescPtr, c_uint, XkbChangesPtr) c_int;
pub extern fn XkbUpdateActionVirtualMods(XkbDescPtr, [*c]XkbAction, c_uint) c_int;
pub extern fn XkbUpdateKeyTypeVirtualMods(XkbDescPtr, XkbKeyTypePtr, c_uint, XkbChangesPtr) void;
pub const __INTMAX_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `L`"); // (no file):67:9
pub const __UINTMAX_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `UL`"); // (no file):73:9
pub const __INT64_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `L`"); // (no file):164:9
pub const __UINT32_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `U`"); // (no file):186:9
pub const __UINT64_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `UL`"); // (no file):194:9
pub const __seg_gs = @compileError("unable to translate macro: undefined identifier `__attribute__`"); // (no file):312:9
pub const __seg_fs = @compileError("unable to translate macro: undefined identifier `__attribute__`"); // (no file):313:9
pub const __restrict = @compileError("unable to translate C expr: unexpected token .Keyword_restrict"); // ./features.h:20:9
pub const __inline = @compileError("unable to translate C expr: unexpected token .Keyword_inline"); // ./features.h:26:9
pub const _Xconst = @compileError("unable to translate C expr: unexpected token .Keyword_const"); // ./Xfuncproto.h:47:9
pub const _X_SENTINEL = @compileError("unable to translate macro: undefined identifier `__attribute__`"); // ./Xfuncproto.h:92:10
pub const _X_EXPORT = @compileError("unable to translate macro: undefined identifier `__attribute__`"); // ./Xfuncproto.h:100:10
pub const _X_HIDDEN = @compileError("unable to translate macro: undefined identifier `__attribute__`"); // ./Xfuncproto.h:101:10
pub const _X_INTERNAL = @compileError("unable to translate macro: undefined identifier `__attribute__`"); // ./Xfuncproto.h:102:10
pub const _X_COLD = @compileError("unable to translate macro: undefined identifier `__attribute__`"); // ./Xfuncproto.h:127:10
pub const _X_DEPRECATED = @compileError("unable to translate macro: undefined identifier `__attribute__`"); // ./Xfuncproto.h:136:10
pub const _X_DEPRECATED_MSG = @compileError("unable to translate macro: undefined identifier `__attribute__`"); // ./Xfuncproto.h:144:10
pub const _X_NORETURN = @compileError("unable to translate macro: undefined identifier `__attribute`"); // ./Xfuncproto.h:153:10
pub const _X_ATTRIBUTE_PRINTF = @compileError("unable to translate macro: undefined identifier `__attribute__`"); // ./Xfuncproto.h:161:10
pub const _X_NONNULL = @compileError("unable to translate C expr: expected ')'"); // ./Xfuncproto.h:171:9
pub const _X_UNUSED = @compileError("unable to translate macro: undefined identifier `__attribute__`"); // ./Xfuncproto.h:182:9
pub const _X_INLINE = @compileError("unable to translate C expr: unexpected token .Keyword_inline"); // ./Xfuncproto.h:193:10
pub const _X_RESTRICT_KYWD = @compileError("unable to translate C expr: unexpected token .Keyword_restrict"); // ./Xfuncproto.h:206:11
pub const _X_NOTSAN = @compileError("unable to translate macro: undefined identifier `__attribute__`"); // ./Xfuncproto.h:216:10
pub const offsetof = @compileError("unable to translate macro: undefined identifier `__builtin_offsetof`"); // /nix/store/ck6769mmixpvxd1anwp3cr9sq3armxzw-zig-0.9.1/lib/zig/include/stddef.h:104:9
pub const XkbLegalXILedClass = @compileError("unable to translate macro: undefined identifier `KbdFeedbackClass`"); // ./XKB.h:325:9
pub const XkbLegalXIBellClass = @compileError("unable to translate macro: undefined identifier `KbdFeedbackClass`"); // ./XKB.h:329:9
pub const XkbIsModAction = @compileError("unable to translate macro: undefined identifier `Xkb_SASetMods`"); // ./XKB.h:517:9
pub const XkbIntTo2Chars = @compileError("unable to translate C expr: expected ')' instead got: Equal"); // ./XKBstr.h:34:9
pub const XkbSetModActionVMods = @compileError("unable to translate C expr: expected ')' instead got: Equal"); // ./XKBstr.h:131:9
pub const XkbSASetGroup = @compileError("unable to translate C expr: expected ')' instead got: Equal"); // ./XKBstr.h:140:9
pub const XkbSASetPtrDfltValue = @compileError("unable to translate C expr: expected ')' instead got: Equal"); // ./XKBstr.h:180:9
pub const XkbSASetScreen = @compileError("unable to translate C expr: expected ')' instead got: Equal"); // ./XKBstr.h:188:9
pub const XkbActionSetCtrls = @compileError("unable to translate C expr: expected ')' instead got: Equal"); // ./XKBstr.h:198:9
pub const XkbSARedirectSetVMods = @compileError("unable to translate C expr: expected ')' instead got: Equal"); // ./XKBstr.h:226:9
pub const XkbSARedirectSetVModsMask = @compileError("unable to translate C expr: expected ')' instead got: Equal"); // ./XKBstr.h:230:9
pub const XkbNoteIndicatorMapChanges = @compileError("unable to translate C expr: expected ')' instead got: PipeEqual"); // ./XKBlib.h:527:9
pub const XkbNoteIndicatorStateChanges = @compileError("unable to translate C expr: expected ')' instead got: PipeEqual"); // ./XKBlib.h:529:9
pub const __llvm__ = @as(c_int, 1);
pub const __clang__ = @as(c_int, 1);
pub const __clang_major__ = @as(c_int, 13);
pub const __clang_minor__ = @as(c_int, 0);
pub const __clang_patchlevel__ = @as(c_int, 1);
pub const __clang_version__ = "13.0.1 ";
pub const __GNUC__ = @as(c_int, 4);
pub const __GNUC_MINOR__ = @as(c_int, 2);
pub const __GNUC_PATCHLEVEL__ = @as(c_int, 1);
pub const __GXX_ABI_VERSION = @as(c_int, 1002);
pub const __ATOMIC_RELAXED = @as(c_int, 0);
pub const __ATOMIC_CONSUME = @as(c_int, 1);
pub const __ATOMIC_ACQUIRE = @as(c_int, 2);
pub const __ATOMIC_RELEASE = @as(c_int, 3);
pub const __ATOMIC_ACQ_REL = @as(c_int, 4);
pub const __ATOMIC_SEQ_CST = @as(c_int, 5);
pub const __OPENCL_MEMORY_SCOPE_WORK_ITEM = @as(c_int, 0);
pub const __OPENCL_MEMORY_SCOPE_WORK_GROUP = @as(c_int, 1);
pub const __OPENCL_MEMORY_SCOPE_DEVICE = @as(c_int, 2);
pub const __OPENCL_MEMORY_SCOPE_ALL_SVM_DEVICES = @as(c_int, 3);
pub const __OPENCL_MEMORY_SCOPE_SUB_GROUP = @as(c_int, 4);
pub const __PRAGMA_REDEFINE_EXTNAME = @as(c_int, 1);
pub const __VERSION__ = "Clang 13.0.1";
pub const __OBJC_BOOL_IS_BOOL = @as(c_int, 0);
pub const __CONSTANT_CFSTRINGS__ = @as(c_int, 1);
pub const __clang_literal_encoding__ = "UTF-8";
pub const __clang_wide_literal_encoding__ = "UTF-32";
pub const __OPTIMIZE__ = @as(c_int, 1);
pub const __ORDER_LITTLE_ENDIAN__ = @as(c_int, 1234);
pub const __ORDER_BIG_ENDIAN__ = @as(c_int, 4321);
pub const __ORDER_PDP_ENDIAN__ = @as(c_int, 3412);
pub const __BYTE_ORDER__ = __ORDER_LITTLE_ENDIAN__;
pub const __LITTLE_ENDIAN__ = @as(c_int, 1);
pub const _LP64 = @as(c_int, 1);
pub const __LP64__ = @as(c_int, 1);
pub const __CHAR_BIT__ = @as(c_int, 8);
pub const __SCHAR_MAX__ = @as(c_int, 127);
pub const __SHRT_MAX__ = @as(c_int, 32767);
pub const __INT_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __LONG_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __LONG_LONG_MAX__ = @as(c_longlong, 9223372036854775807);
pub const __WCHAR_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __WINT_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const __INTMAX_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __SIZE_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const __UINTMAX_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const __PTRDIFF_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __INTPTR_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __UINTPTR_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const __SIZEOF_DOUBLE__ = @as(c_int, 8);
pub const __SIZEOF_FLOAT__ = @as(c_int, 4);
pub const __SIZEOF_INT__ = @as(c_int, 4);
pub const __SIZEOF_LONG__ = @as(c_int, 8);
pub const __SIZEOF_LONG_DOUBLE__ = @as(c_int, 16);
pub const __SIZEOF_LONG_LONG__ = @as(c_int, 8);
pub const __SIZEOF_POINTER__ = @as(c_int, 8);
pub const __SIZEOF_SHORT__ = @as(c_int, 2);
pub const __SIZEOF_PTRDIFF_T__ = @as(c_int, 8);
pub const __SIZEOF_SIZE_T__ = @as(c_int, 8);
pub const __SIZEOF_WCHAR_T__ = @as(c_int, 4);
pub const __SIZEOF_WINT_T__ = @as(c_int, 4);
pub const __SIZEOF_INT128__ = @as(c_int, 16);
pub const __INTMAX_TYPE__ = c_long;
pub const __INTMAX_FMTd__ = "ld";
pub const __INTMAX_FMTi__ = "li";
pub const __UINTMAX_TYPE__ = c_ulong;
pub const __UINTMAX_FMTo__ = "lo";
pub const __UINTMAX_FMTu__ = "lu";
pub const __UINTMAX_FMTx__ = "lx";
pub const __UINTMAX_FMTX__ = "lX";
pub const __INTMAX_WIDTH__ = @as(c_int, 64);
pub const __PTRDIFF_TYPE__ = c_long;
pub const __PTRDIFF_FMTd__ = "ld";
pub const __PTRDIFF_FMTi__ = "li";
pub const __PTRDIFF_WIDTH__ = @as(c_int, 64);
pub const __INTPTR_TYPE__ = c_long;
pub const __INTPTR_FMTd__ = "ld";
pub const __INTPTR_FMTi__ = "li";
pub const __INTPTR_WIDTH__ = @as(c_int, 64);
pub const __SIZE_TYPE__ = c_ulong;
pub const __SIZE_FMTo__ = "lo";
pub const __SIZE_FMTu__ = "lu";
pub const __SIZE_FMTx__ = "lx";
pub const __SIZE_FMTX__ = "lX";
pub const __SIZE_WIDTH__ = @as(c_int, 64);
pub const __WCHAR_TYPE__ = c_int;
pub const __WCHAR_WIDTH__ = @as(c_int, 32);
pub const __WINT_TYPE__ = c_uint;
pub const __WINT_WIDTH__ = @as(c_int, 32);
pub const __SIG_ATOMIC_WIDTH__ = @as(c_int, 32);
pub const __SIG_ATOMIC_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __CHAR16_TYPE__ = c_ushort;
pub const __CHAR32_TYPE__ = c_uint;
pub const __UINTMAX_WIDTH__ = @as(c_int, 64);
pub const __UINTPTR_TYPE__ = c_ulong;
pub const __UINTPTR_FMTo__ = "lo";
pub const __UINTPTR_FMTu__ = "lu";
pub const __UINTPTR_FMTx__ = "lx";
pub const __UINTPTR_FMTX__ = "lX";
pub const __UINTPTR_WIDTH__ = @as(c_int, 64);
pub const __FLT_DENORM_MIN__ = @as(f32, 1.40129846e-45);
pub const __FLT_HAS_DENORM__ = @as(c_int, 1);
pub const __FLT_DIG__ = @as(c_int, 6);
pub const __FLT_DECIMAL_DIG__ = @as(c_int, 9);
pub const __FLT_EPSILON__ = @as(f32, 1.19209290e-7);
pub const __FLT_HAS_INFINITY__ = @as(c_int, 1);
pub const __FLT_HAS_QUIET_NAN__ = @as(c_int, 1);
pub const __FLT_MANT_DIG__ = @as(c_int, 24);
pub const __FLT_MAX_10_EXP__ = @as(c_int, 38);
pub const __FLT_MAX_EXP__ = @as(c_int, 128);
pub const __FLT_MAX__ = @as(f32, 3.40282347e+38);
pub const __FLT_MIN_10_EXP__ = -@as(c_int, 37);
pub const __FLT_MIN_EXP__ = -@as(c_int, 125);
pub const __FLT_MIN__ = @as(f32, 1.17549435e-38);
pub const __DBL_DENORM_MIN__ = 4.9406564584124654e-324;
pub const __DBL_HAS_DENORM__ = @as(c_int, 1);
pub const __DBL_DIG__ = @as(c_int, 15);
pub const __DBL_DECIMAL_DIG__ = @as(c_int, 17);
pub const __DBL_EPSILON__ = 2.2204460492503131e-16;
pub const __DBL_HAS_INFINITY__ = @as(c_int, 1);
pub const __DBL_HAS_QUIET_NAN__ = @as(c_int, 1);
pub const __DBL_MANT_DIG__ = @as(c_int, 53);
pub const __DBL_MAX_10_EXP__ = @as(c_int, 308);
pub const __DBL_MAX_EXP__ = @as(c_int, 1024);
pub const __DBL_MAX__ = 1.7976931348623157e+308;
pub const __DBL_MIN_10_EXP__ = -@as(c_int, 307);
pub const __DBL_MIN_EXP__ = -@as(c_int, 1021);
pub const __DBL_MIN__ = 2.2250738585072014e-308;
pub const __LDBL_DENORM_MIN__ = @as(c_longdouble, 3.64519953188247460253e-4951);
pub const __LDBL_HAS_DENORM__ = @as(c_int, 1);
pub const __LDBL_DIG__ = @as(c_int, 18);
pub const __LDBL_DECIMAL_DIG__ = @as(c_int, 21);
pub const __LDBL_EPSILON__ = @as(c_longdouble, 1.08420217248550443401e-19);
pub const __LDBL_HAS_INFINITY__ = @as(c_int, 1);
pub const __LDBL_HAS_QUIET_NAN__ = @as(c_int, 1);
pub const __LDBL_MANT_DIG__ = @as(c_int, 64);
pub const __LDBL_MAX_10_EXP__ = @as(c_int, 4932);
pub const __LDBL_MAX_EXP__ = @as(c_int, 16384);
pub const __LDBL_MAX__ = @as(c_longdouble, 1.18973149535723176502e+4932);
pub const __LDBL_MIN_10_EXP__ = -@as(c_int, 4931);
pub const __LDBL_MIN_EXP__ = -@as(c_int, 16381);
pub const __LDBL_MIN__ = @as(c_longdouble, 3.36210314311209350626e-4932);
pub const __POINTER_WIDTH__ = @as(c_int, 64);
pub const __BIGGEST_ALIGNMENT__ = @as(c_int, 16);
pub const __WINT_UNSIGNED__ = @as(c_int, 1);
pub const __INT8_TYPE__ = i8;
pub const __INT8_FMTd__ = "hhd";
pub const __INT8_FMTi__ = "hhi";
pub const __INT8_C_SUFFIX__ = "";
pub const __INT16_TYPE__ = c_short;
pub const __INT16_FMTd__ = "hd";
pub const __INT16_FMTi__ = "hi";
pub const __INT16_C_SUFFIX__ = "";
pub const __INT32_TYPE__ = c_int;
pub const __INT32_FMTd__ = "d";
pub const __INT32_FMTi__ = "i";
pub const __INT32_C_SUFFIX__ = "";
pub const __INT64_TYPE__ = c_long;
pub const __INT64_FMTd__ = "ld";
pub const __INT64_FMTi__ = "li";
pub const __UINT8_TYPE__ = u8;
pub const __UINT8_FMTo__ = "hho";
pub const __UINT8_FMTu__ = "hhu";
pub const __UINT8_FMTx__ = "hhx";
pub const __UINT8_FMTX__ = "hhX";
pub const __UINT8_C_SUFFIX__ = "";
pub const __UINT8_MAX__ = @as(c_int, 255);
pub const __INT8_MAX__ = @as(c_int, 127);
pub const __UINT16_TYPE__ = c_ushort;
pub const __UINT16_FMTo__ = "ho";
pub const __UINT16_FMTu__ = "hu";
pub const __UINT16_FMTx__ = "hx";
pub const __UINT16_FMTX__ = "hX";
pub const __UINT16_C_SUFFIX__ = "";
pub const __UINT16_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 65535, .decimal);
pub const __INT16_MAX__ = @as(c_int, 32767);
pub const __UINT32_TYPE__ = c_uint;
pub const __UINT32_FMTo__ = "o";
pub const __UINT32_FMTu__ = "u";
pub const __UINT32_FMTx__ = "x";
pub const __UINT32_FMTX__ = "X";
pub const __UINT32_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const __INT32_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __UINT64_TYPE__ = c_ulong;
pub const __UINT64_FMTo__ = "lo";
pub const __UINT64_FMTu__ = "lu";
pub const __UINT64_FMTx__ = "lx";
pub const __UINT64_FMTX__ = "lX";
pub const __UINT64_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const __INT64_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __INT_LEAST8_TYPE__ = i8;
pub const __INT_LEAST8_MAX__ = @as(c_int, 127);
pub const __INT_LEAST8_FMTd__ = "hhd";
pub const __INT_LEAST8_FMTi__ = "hhi";
pub const __UINT_LEAST8_TYPE__ = u8;
pub const __UINT_LEAST8_MAX__ = @as(c_int, 255);
pub const __UINT_LEAST8_FMTo__ = "hho";
pub const __UINT_LEAST8_FMTu__ = "hhu";
pub const __UINT_LEAST8_FMTx__ = "hhx";
pub const __UINT_LEAST8_FMTX__ = "hhX";
pub const __INT_LEAST16_TYPE__ = c_short;
pub const __INT_LEAST16_MAX__ = @as(c_int, 32767);
pub const __INT_LEAST16_FMTd__ = "hd";
pub const __INT_LEAST16_FMTi__ = "hi";
pub const __UINT_LEAST16_TYPE__ = c_ushort;
pub const __UINT_LEAST16_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 65535, .decimal);
pub const __UINT_LEAST16_FMTo__ = "ho";
pub const __UINT_LEAST16_FMTu__ = "hu";
pub const __UINT_LEAST16_FMTx__ = "hx";
pub const __UINT_LEAST16_FMTX__ = "hX";
pub const __INT_LEAST32_TYPE__ = c_int;
pub const __INT_LEAST32_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __INT_LEAST32_FMTd__ = "d";
pub const __INT_LEAST32_FMTi__ = "i";
pub const __UINT_LEAST32_TYPE__ = c_uint;
pub const __UINT_LEAST32_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const __UINT_LEAST32_FMTo__ = "o";
pub const __UINT_LEAST32_FMTu__ = "u";
pub const __UINT_LEAST32_FMTx__ = "x";
pub const __UINT_LEAST32_FMTX__ = "X";
pub const __INT_LEAST64_TYPE__ = c_long;
pub const __INT_LEAST64_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __INT_LEAST64_FMTd__ = "ld";
pub const __INT_LEAST64_FMTi__ = "li";
pub const __UINT_LEAST64_TYPE__ = c_ulong;
pub const __UINT_LEAST64_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const __UINT_LEAST64_FMTo__ = "lo";
pub const __UINT_LEAST64_FMTu__ = "lu";
pub const __UINT_LEAST64_FMTx__ = "lx";
pub const __UINT_LEAST64_FMTX__ = "lX";
pub const __INT_FAST8_TYPE__ = i8;
pub const __INT_FAST8_MAX__ = @as(c_int, 127);
pub const __INT_FAST8_FMTd__ = "hhd";
pub const __INT_FAST8_FMTi__ = "hhi";
pub const __UINT_FAST8_TYPE__ = u8;
pub const __UINT_FAST8_MAX__ = @as(c_int, 255);
pub const __UINT_FAST8_FMTo__ = "hho";
pub const __UINT_FAST8_FMTu__ = "hhu";
pub const __UINT_FAST8_FMTx__ = "hhx";
pub const __UINT_FAST8_FMTX__ = "hhX";
pub const __INT_FAST16_TYPE__ = c_short;
pub const __INT_FAST16_MAX__ = @as(c_int, 32767);
pub const __INT_FAST16_FMTd__ = "hd";
pub const __INT_FAST16_FMTi__ = "hi";
pub const __UINT_FAST16_TYPE__ = c_ushort;
pub const __UINT_FAST16_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 65535, .decimal);
pub const __UINT_FAST16_FMTo__ = "ho";
pub const __UINT_FAST16_FMTu__ = "hu";
pub const __UINT_FAST16_FMTx__ = "hx";
pub const __UINT_FAST16_FMTX__ = "hX";
pub const __INT_FAST32_TYPE__ = c_int;
pub const __INT_FAST32_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __INT_FAST32_FMTd__ = "d";
pub const __INT_FAST32_FMTi__ = "i";
pub const __UINT_FAST32_TYPE__ = c_uint;
pub const __UINT_FAST32_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const __UINT_FAST32_FMTo__ = "o";
pub const __UINT_FAST32_FMTu__ = "u";
pub const __UINT_FAST32_FMTx__ = "x";
pub const __UINT_FAST32_FMTX__ = "X";
pub const __INT_FAST64_TYPE__ = c_long;
pub const __INT_FAST64_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __INT_FAST64_FMTd__ = "ld";
pub const __INT_FAST64_FMTi__ = "li";
pub const __UINT_FAST64_TYPE__ = c_ulong;
pub const __UINT_FAST64_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const __UINT_FAST64_FMTo__ = "lo";
pub const __UINT_FAST64_FMTu__ = "lu";
pub const __UINT_FAST64_FMTx__ = "lx";
pub const __UINT_FAST64_FMTX__ = "lX";
pub const __USER_LABEL_PREFIX__ = "";
pub const __FINITE_MATH_ONLY__ = @as(c_int, 0);
pub const __GNUC_STDC_INLINE__ = @as(c_int, 1);
pub const __GCC_ATOMIC_TEST_AND_SET_TRUEVAL = @as(c_int, 1);
pub const __CLANG_ATOMIC_BOOL_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_CHAR_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_CHAR16_T_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_CHAR32_T_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_WCHAR_T_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_SHORT_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_INT_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_LONG_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_LLONG_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_POINTER_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_BOOL_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_CHAR_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_CHAR16_T_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_CHAR32_T_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_WCHAR_T_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_SHORT_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_INT_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_LONG_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_LLONG_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_POINTER_LOCK_FREE = @as(c_int, 2);
pub const __FLT_EVAL_METHOD__ = @as(c_int, 0);
pub const __FLT_RADIX__ = @as(c_int, 2);
pub const __DECIMAL_DIG__ = __LDBL_DECIMAL_DIG__;
pub const __GCC_ASM_FLAG_OUTPUTS__ = @as(c_int, 1);
pub const __code_model_small__ = @as(c_int, 1);
pub const __amd64__ = @as(c_int, 1);
pub const __amd64 = @as(c_int, 1);
pub const __x86_64 = @as(c_int, 1);
pub const __x86_64__ = @as(c_int, 1);
pub const __SEG_GS = @as(c_int, 1);
pub const __SEG_FS = @as(c_int, 1);
pub const __znver3 = @as(c_int, 1);
pub const __znver3__ = @as(c_int, 1);
pub const __tune_znver3__ = @as(c_int, 1);
pub const __REGISTER_PREFIX__ = "";
pub const __NO_MATH_INLINES = @as(c_int, 1);
pub const __AES__ = @as(c_int, 1);
pub const __VAES__ = @as(c_int, 1);
pub const __PCLMUL__ = @as(c_int, 1);
pub const __VPCLMULQDQ__ = @as(c_int, 1);
pub const __LAHF_SAHF__ = @as(c_int, 1);
pub const __LZCNT__ = @as(c_int, 1);
pub const __RDRND__ = @as(c_int, 1);
pub const __FSGSBASE__ = @as(c_int, 1);
pub const __BMI__ = @as(c_int, 1);
pub const __BMI2__ = @as(c_int, 1);
pub const __POPCNT__ = @as(c_int, 1);
pub const __PRFCHW__ = @as(c_int, 1);
pub const __RDSEED__ = @as(c_int, 1);
pub const __ADX__ = @as(c_int, 1);
pub const __MWAITX__ = @as(c_int, 1);
pub const __MOVBE__ = @as(c_int, 1);
pub const __SSE4A__ = @as(c_int, 1);
pub const __FMA__ = @as(c_int, 1);
pub const __F16C__ = @as(c_int, 1);
pub const __SHA__ = @as(c_int, 1);
pub const __FXSR__ = @as(c_int, 1);
pub const __XSAVE__ = @as(c_int, 1);
pub const __XSAVEOPT__ = @as(c_int, 1);
pub const __XSAVEC__ = @as(c_int, 1);
pub const __XSAVES__ = @as(c_int, 1);
pub const __PKU__ = @as(c_int, 1);
pub const __CLFLUSHOPT__ = @as(c_int, 1);
pub const __CLWB__ = @as(c_int, 1);
pub const __WBNOINVD__ = @as(c_int, 1);
pub const __SHSTK__ = @as(c_int, 1);
pub const __CLZERO__ = @as(c_int, 1);
pub const __RDPID__ = @as(c_int, 1);
pub const __INVPCID__ = @as(c_int, 1);
pub const __AVX2__ = @as(c_int, 1);
pub const __AVX__ = @as(c_int, 1);
pub const __SSE4_2__ = @as(c_int, 1);
pub const __SSE4_1__ = @as(c_int, 1);
pub const __SSSE3__ = @as(c_int, 1);
pub const __SSE3__ = @as(c_int, 1);
pub const __SSE2__ = @as(c_int, 1);
pub const __SSE2_MATH__ = @as(c_int, 1);
pub const __SSE__ = @as(c_int, 1);
pub const __SSE_MATH__ = @as(c_int, 1);
pub const __MMX__ = @as(c_int, 1);
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_1 = @as(c_int, 1);
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_2 = @as(c_int, 1);
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_4 = @as(c_int, 1);
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_8 = @as(c_int, 1);
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_16 = @as(c_int, 1);
pub const __SIZEOF_FLOAT128__ = @as(c_int, 16);
pub const unix = @as(c_int, 1);
pub const __unix = @as(c_int, 1);
pub const __unix__ = @as(c_int, 1);
pub const linux = @as(c_int, 1);
pub const __linux = @as(c_int, 1);
pub const __linux__ = @as(c_int, 1);
pub const __ELF__ = @as(c_int, 1);
pub const __gnu_linux__ = @as(c_int, 1);
pub const __FLOAT128__ = @as(c_int, 1);
pub const __STDC__ = @as(c_int, 1);
pub const __STDC_HOSTED__ = @as(c_int, 1);
pub const __STDC_VERSION__ = @as(c_long, 201710);
pub const __STDC_UTF_16__ = @as(c_int, 1);
pub const __STDC_UTF_32__ = @as(c_int, 1);
pub const _DEBUG = @as(c_int, 1);
pub const __GCC_HAVE_DWARF2_CFI_ASM = @as(c_int, 1);
pub const _X11_XKBLIB_H_ = "";
pub const _X11_XLIB_H_ = "";
pub const XlibSpecificationRelease = @as(c_int, 6);
pub const _SYS_TYPES_H = "";
pub const _FEATURES_H = "";
pub const _BSD_SOURCE = @as(c_int, 1);
pub const _XOPEN_SOURCE = @as(c_int, 700);
pub const __NEED_ino_t = "";
pub const __NEED_dev_t = "";
pub const __NEED_uid_t = "";
pub const __NEED_gid_t = "";
pub const __NEED_mode_t = "";
pub const __NEED_nlink_t = "";
pub const __NEED_off_t = "";
pub const __NEED_pid_t = "";
pub const __NEED_size_t = "";
pub const __NEED_ssize_t = "";
pub const __NEED_time_t = "";
pub const __NEED_timer_t = "";
pub const __NEED_clockid_t = "";
pub const __NEED_blkcnt_t = "";
pub const __NEED_fsblkcnt_t = "";
pub const __NEED_fsfilcnt_t = "";
pub const __NEED_id_t = "";
pub const __NEED_key_t = "";
pub const __NEED_clock_t = "";
pub const __NEED_suseconds_t = "";
pub const __NEED_blksize_t = "";
pub const __NEED_pthread_t = "";
pub const __NEED_pthread_attr_t = "";
pub const __NEED_pthread_mutexattr_t = "";
pub const __NEED_pthread_condattr_t = "";
pub const __NEED_pthread_rwlockattr_t = "";
pub const __NEED_pthread_barrierattr_t = "";
pub const __NEED_pthread_mutex_t = "";
pub const __NEED_pthread_cond_t = "";
pub const __NEED_pthread_rwlock_t = "";
pub const __NEED_pthread_barrier_t = "";
pub const __NEED_pthread_spinlock_t = "";
pub const __NEED_pthread_key_t = "";
pub const __NEED_pthread_once_t = "";
pub const __NEED_useconds_t = "";
pub const __NEED_int8_t = "";
pub const __NEED_int16_t = "";
pub const __NEED_int32_t = "";
pub const __NEED_int64_t = "";
pub const __NEED_u_int64_t = "";
pub const __NEED_register_t = "";
pub const X_H = "";
pub const X_PROTOCOL = @as(c_int, 11);
pub const X_PROTOCOL_REVISION = @as(c_int, 0);
pub const _XTYPEDEF_XID = "";
pub const _XTYPEDEF_MASK = "";
pub const _XTYPEDEF_ATOM = "";
pub const _XTYPEDEF_FONT = "";
pub const None = @as(c_long, 0);
pub const ParentRelative = @as(c_long, 1);
pub const CopyFromParent = @as(c_long, 0);
pub const PointerWindow = @as(c_long, 0);
pub const InputFocus = @as(c_long, 1);
pub const PointerRoot = @as(c_long, 1);
pub const AnyPropertyType = @as(c_long, 0);
pub const AnyKey = @as(c_long, 0);
pub const AnyButton = @as(c_long, 0);
pub const AllTemporary = @as(c_long, 0);
pub const CurrentTime = @as(c_long, 0);
pub const NoSymbol = @as(c_long, 0);
pub const NoEventMask = @as(c_long, 0);
pub const KeyPressMask = @as(c_long, 1) << @as(c_int, 0);
pub const KeyReleaseMask = @as(c_long, 1) << @as(c_int, 1);
pub const ButtonPressMask = @as(c_long, 1) << @as(c_int, 2);
pub const ButtonReleaseMask = @as(c_long, 1) << @as(c_int, 3);
pub const EnterWindowMask = @as(c_long, 1) << @as(c_int, 4);
pub const LeaveWindowMask = @as(c_long, 1) << @as(c_int, 5);
pub const PointerMotionMask = @as(c_long, 1) << @as(c_int, 6);
pub const PointerMotionHintMask = @as(c_long, 1) << @as(c_int, 7);
pub const Button1MotionMask = @as(c_long, 1) << @as(c_int, 8);
pub const Button2MotionMask = @as(c_long, 1) << @as(c_int, 9);
pub const Button3MotionMask = @as(c_long, 1) << @as(c_int, 10);
pub const Button4MotionMask = @as(c_long, 1) << @as(c_int, 11);
pub const Button5MotionMask = @as(c_long, 1) << @as(c_int, 12);
pub const ButtonMotionMask = @as(c_long, 1) << @as(c_int, 13);
pub const KeymapStateMask = @as(c_long, 1) << @as(c_int, 14);
pub const ExposureMask = @as(c_long, 1) << @as(c_int, 15);
pub const VisibilityChangeMask = @as(c_long, 1) << @as(c_int, 16);
pub const StructureNotifyMask = @as(c_long, 1) << @as(c_int, 17);
pub const ResizeRedirectMask = @as(c_long, 1) << @as(c_int, 18);
pub const SubstructureNotifyMask = @as(c_long, 1) << @as(c_int, 19);
pub const SubstructureRedirectMask = @as(c_long, 1) << @as(c_int, 20);
pub const FocusChangeMask = @as(c_long, 1) << @as(c_int, 21);
pub const PropertyChangeMask = @as(c_long, 1) << @as(c_int, 22);
pub const ColormapChangeMask = @as(c_long, 1) << @as(c_int, 23);
pub const OwnerGrabButtonMask = @as(c_long, 1) << @as(c_int, 24);
pub const KeyPress = @as(c_int, 2);
pub const KeyRelease = @as(c_int, 3);
pub const ButtonPress = @as(c_int, 4);
pub const ButtonRelease = @as(c_int, 5);
pub const MotionNotify = @as(c_int, 6);
pub const EnterNotify = @as(c_int, 7);
pub const LeaveNotify = @as(c_int, 8);
pub const FocusIn = @as(c_int, 9);
pub const FocusOut = @as(c_int, 10);
pub const KeymapNotify = @as(c_int, 11);
pub const Expose = @as(c_int, 12);
pub const GraphicsExpose = @as(c_int, 13);
pub const NoExpose = @as(c_int, 14);
pub const VisibilityNotify = @as(c_int, 15);
pub const CreateNotify = @as(c_int, 16);
pub const DestroyNotify = @as(c_int, 17);
pub const UnmapNotify = @as(c_int, 18);
pub const MapNotify = @as(c_int, 19);
pub const MapRequest = @as(c_int, 20);
pub const ReparentNotify = @as(c_int, 21);
pub const ConfigureNotify = @as(c_int, 22);
pub const ConfigureRequest = @as(c_int, 23);
pub const GravityNotify = @as(c_int, 24);
pub const ResizeRequest = @as(c_int, 25);
pub const CirculateNotify = @as(c_int, 26);
pub const CirculateRequest = @as(c_int, 27);
pub const PropertyNotify = @as(c_int, 28);
pub const SelectionClear = @as(c_int, 29);
pub const SelectionRequest = @as(c_int, 30);
pub const SelectionNotify = @as(c_int, 31);
pub const ColormapNotify = @as(c_int, 32);
pub const ClientMessage = @as(c_int, 33);
pub const MappingNotify = @as(c_int, 34);
pub const GenericEvent = @as(c_int, 35);
pub const LASTEvent = @as(c_int, 36);
pub const ShiftMask = @as(c_int, 1) << @as(c_int, 0);
pub const LockMask = @as(c_int, 1) << @as(c_int, 1);
pub const ControlMask = @as(c_int, 1) << @as(c_int, 2);
pub const Mod1Mask = @as(c_int, 1) << @as(c_int, 3);
pub const Mod2Mask = @as(c_int, 1) << @as(c_int, 4);
pub const Mod3Mask = @as(c_int, 1) << @as(c_int, 5);
pub const Mod4Mask = @as(c_int, 1) << @as(c_int, 6);
pub const Mod5Mask = @as(c_int, 1) << @as(c_int, 7);
pub const ShiftMapIndex = @as(c_int, 0);
pub const LockMapIndex = @as(c_int, 1);
pub const ControlMapIndex = @as(c_int, 2);
pub const Mod1MapIndex = @as(c_int, 3);
pub const Mod2MapIndex = @as(c_int, 4);
pub const Mod3MapIndex = @as(c_int, 5);
pub const Mod4MapIndex = @as(c_int, 6);
pub const Mod5MapIndex = @as(c_int, 7);
pub const Button1Mask = @as(c_int, 1) << @as(c_int, 8);
pub const Button2Mask = @as(c_int, 1) << @as(c_int, 9);
pub const Button3Mask = @as(c_int, 1) << @as(c_int, 10);
pub const Button4Mask = @as(c_int, 1) << @as(c_int, 11);
pub const Button5Mask = @as(c_int, 1) << @as(c_int, 12);
pub const AnyModifier = @as(c_int, 1) << @as(c_int, 15);
pub const Button1 = @as(c_int, 1);
pub const Button2 = @as(c_int, 2);
pub const Button3 = @as(c_int, 3);
pub const Button4 = @as(c_int, 4);
pub const Button5 = @as(c_int, 5);
pub const NotifyNormal = @as(c_int, 0);
pub const NotifyGrab = @as(c_int, 1);
pub const NotifyUngrab = @as(c_int, 2);
pub const NotifyWhileGrabbed = @as(c_int, 3);
pub const NotifyHint = @as(c_int, 1);
pub const NotifyAncestor = @as(c_int, 0);
pub const NotifyVirtual = @as(c_int, 1);
pub const NotifyInferior = @as(c_int, 2);
pub const NotifyNonlinear = @as(c_int, 3);
pub const NotifyNonlinearVirtual = @as(c_int, 4);
pub const NotifyPointer = @as(c_int, 5);
pub const NotifyPointerRoot = @as(c_int, 6);
pub const NotifyDetailNone = @as(c_int, 7);
pub const VisibilityUnobscured = @as(c_int, 0);
pub const VisibilityPartiallyObscured = @as(c_int, 1);
pub const VisibilityFullyObscured = @as(c_int, 2);
pub const PlaceOnTop = @as(c_int, 0);
pub const PlaceOnBottom = @as(c_int, 1);
pub const FamilyInternet = @as(c_int, 0);
pub const FamilyDECnet = @as(c_int, 1);
pub const FamilyChaos = @as(c_int, 2);
pub const FamilyInternet6 = @as(c_int, 6);
pub const FamilyServerInterpreted = @as(c_int, 5);
pub const PropertyNewValue = @as(c_int, 0);
pub const PropertyDelete = @as(c_int, 1);
pub const ColormapUninstalled = @as(c_int, 0);
pub const ColormapInstalled = @as(c_int, 1);
pub const GrabModeSync = @as(c_int, 0);
pub const GrabModeAsync = @as(c_int, 1);
pub const GrabSuccess = @as(c_int, 0);
pub const AlreadyGrabbed = @as(c_int, 1);
pub const GrabInvalidTime = @as(c_int, 2);
pub const GrabNotViewable = @as(c_int, 3);
pub const GrabFrozen = @as(c_int, 4);
pub const AsyncPointer = @as(c_int, 0);
pub const SyncPointer = @as(c_int, 1);
pub const ReplayPointer = @as(c_int, 2);
pub const AsyncKeyboard = @as(c_int, 3);
pub const SyncKeyboard = @as(c_int, 4);
pub const ReplayKeyboard = @as(c_int, 5);
pub const AsyncBoth = @as(c_int, 6);
pub const SyncBoth = @as(c_int, 7);
pub const RevertToNone = @import("std").zig.c_translation.cast(c_int, None);
pub const RevertToPointerRoot = @import("std").zig.c_translation.cast(c_int, PointerRoot);
pub const RevertToParent = @as(c_int, 2);
pub const Success = @as(c_int, 0);
pub const BadRequest = @as(c_int, 1);
pub const BadValue = @as(c_int, 2);
pub const BadWindow = @as(c_int, 3);
pub const BadPixmap = @as(c_int, 4);
pub const BadAtom = @as(c_int, 5);
pub const BadCursor = @as(c_int, 6);
pub const BadFont = @as(c_int, 7);
pub const BadMatch = @as(c_int, 8);
pub const BadDrawable = @as(c_int, 9);
pub const BadAccess = @as(c_int, 10);
pub const BadAlloc = @as(c_int, 11);
pub const BadColor = @as(c_int, 12);
pub const BadGC = @as(c_int, 13);
pub const BadIDChoice = @as(c_int, 14);
pub const BadName = @as(c_int, 15);
pub const BadLength = @as(c_int, 16);
pub const BadImplementation = @as(c_int, 17);
pub const FirstExtensionError = @as(c_int, 128);
pub const LastExtensionError = @as(c_int, 255);
pub const InputOutput = @as(c_int, 1);
pub const InputOnly = @as(c_int, 2);
pub const CWBackPixmap = @as(c_long, 1) << @as(c_int, 0);
pub const CWBackPixel = @as(c_long, 1) << @as(c_int, 1);
pub const CWBorderPixmap = @as(c_long, 1) << @as(c_int, 2);
pub const CWBorderPixel = @as(c_long, 1) << @as(c_int, 3);
pub const CWBitGravity = @as(c_long, 1) << @as(c_int, 4);
pub const CWWinGravity = @as(c_long, 1) << @as(c_int, 5);
pub const CWBackingStore = @as(c_long, 1) << @as(c_int, 6);
pub const CWBackingPlanes = @as(c_long, 1) << @as(c_int, 7);
pub const CWBackingPixel = @as(c_long, 1) << @as(c_int, 8);
pub const CWOverrideRedirect = @as(c_long, 1) << @as(c_int, 9);
pub const CWSaveUnder = @as(c_long, 1) << @as(c_int, 10);
pub const CWEventMask = @as(c_long, 1) << @as(c_int, 11);
pub const CWDontPropagate = @as(c_long, 1) << @as(c_int, 12);
pub const CWColormap = @as(c_long, 1) << @as(c_int, 13);
pub const CWCursor = @as(c_long, 1) << @as(c_int, 14);
pub const CWX = @as(c_int, 1) << @as(c_int, 0);
pub const CWY = @as(c_int, 1) << @as(c_int, 1);
pub const CWWidth = @as(c_int, 1) << @as(c_int, 2);
pub const CWHeight = @as(c_int, 1) << @as(c_int, 3);
pub const CWBorderWidth = @as(c_int, 1) << @as(c_int, 4);
pub const CWSibling = @as(c_int, 1) << @as(c_int, 5);
pub const CWStackMode = @as(c_int, 1) << @as(c_int, 6);
pub const ForgetGravity = @as(c_int, 0);
pub const NorthWestGravity = @as(c_int, 1);
pub const NorthGravity = @as(c_int, 2);
pub const NorthEastGravity = @as(c_int, 3);
pub const WestGravity = @as(c_int, 4);
pub const CenterGravity = @as(c_int, 5);
pub const EastGravity = @as(c_int, 6);
pub const SouthWestGravity = @as(c_int, 7);
pub const SouthGravity = @as(c_int, 8);
pub const SouthEastGravity = @as(c_int, 9);
pub const StaticGravity = @as(c_int, 10);
pub const UnmapGravity = @as(c_int, 0);
pub const NotUseful = @as(c_int, 0);
pub const WhenMapped = @as(c_int, 1);
pub const Always = @as(c_int, 2);
pub const IsUnmapped = @as(c_int, 0);
pub const IsUnviewable = @as(c_int, 1);
pub const IsViewable = @as(c_int, 2);
pub const SetModeInsert = @as(c_int, 0);
pub const SetModeDelete = @as(c_int, 1);
pub const DestroyAll = @as(c_int, 0);
pub const RetainPermanent = @as(c_int, 1);
pub const RetainTemporary = @as(c_int, 2);
pub const Above = @as(c_int, 0);
pub const Below = @as(c_int, 1);
pub const TopIf = @as(c_int, 2);
pub const BottomIf = @as(c_int, 3);
pub const Opposite = @as(c_int, 4);
pub const RaiseLowest = @as(c_int, 0);
pub const LowerHighest = @as(c_int, 1);
pub const PropModeReplace = @as(c_int, 0);
pub const PropModePrepend = @as(c_int, 1);
pub const PropModeAppend = @as(c_int, 2);
pub const GXclear = @as(c_int, 0x0);
pub const GXand = @as(c_int, 0x1);
pub const GXandReverse = @as(c_int, 0x2);
pub const GXcopy = @as(c_int, 0x3);
pub const GXandInverted = @as(c_int, 0x4);
pub const GXnoop = @as(c_int, 0x5);
pub const GXxor = @as(c_int, 0x6);
pub const GXor = @as(c_int, 0x7);
pub const GXnor = @as(c_int, 0x8);
pub const GXequiv = @as(c_int, 0x9);
pub const GXinvert = @as(c_int, 0xa);
pub const GXorReverse = @as(c_int, 0xb);
pub const GXcopyInverted = @as(c_int, 0xc);
pub const GXorInverted = @as(c_int, 0xd);
pub const GXnand = @as(c_int, 0xe);
pub const GXset = @as(c_int, 0xf);
pub const LineSolid = @as(c_int, 0);
pub const LineOnOffDash = @as(c_int, 1);
pub const LineDoubleDash = @as(c_int, 2);
pub const CapNotLast = @as(c_int, 0);
pub const CapButt = @as(c_int, 1);
pub const CapRound = @as(c_int, 2);
pub const CapProjecting = @as(c_int, 3);
pub const JoinMiter = @as(c_int, 0);
pub const JoinRound = @as(c_int, 1);
pub const JoinBevel = @as(c_int, 2);
pub const FillSolid = @as(c_int, 0);
pub const FillTiled = @as(c_int, 1);
pub const FillStippled = @as(c_int, 2);
pub const FillOpaqueStippled = @as(c_int, 3);
pub const EvenOddRule = @as(c_int, 0);
pub const WindingRule = @as(c_int, 1);
pub const ClipByChildren = @as(c_int, 0);
pub const IncludeInferiors = @as(c_int, 1);
pub const Unsorted = @as(c_int, 0);
pub const YSorted = @as(c_int, 1);
pub const YXSorted = @as(c_int, 2);
pub const YXBanded = @as(c_int, 3);
pub const CoordModeOrigin = @as(c_int, 0);
pub const CoordModePrevious = @as(c_int, 1);
pub const Complex = @as(c_int, 0);
pub const Nonconvex = @as(c_int, 1);
pub const Convex = @as(c_int, 2);
pub const ArcChord = @as(c_int, 0);
pub const ArcPieSlice = @as(c_int, 1);
pub const GCFunction = @as(c_long, 1) << @as(c_int, 0);
pub const GCPlaneMask = @as(c_long, 1) << @as(c_int, 1);
pub const GCForeground = @as(c_long, 1) << @as(c_int, 2);
pub const GCBackground = @as(c_long, 1) << @as(c_int, 3);
pub const GCLineWidth = @as(c_long, 1) << @as(c_int, 4);
pub const GCLineStyle = @as(c_long, 1) << @as(c_int, 5);
pub const GCCapStyle = @as(c_long, 1) << @as(c_int, 6);
pub const GCJoinStyle = @as(c_long, 1) << @as(c_int, 7);
pub const GCFillStyle = @as(c_long, 1) << @as(c_int, 8);
pub const GCFillRule = @as(c_long, 1) << @as(c_int, 9);
pub const GCTile = @as(c_long, 1) << @as(c_int, 10);
pub const GCStipple = @as(c_long, 1) << @as(c_int, 11);
pub const GCTileStipXOrigin = @as(c_long, 1) << @as(c_int, 12);
pub const GCTileStipYOrigin = @as(c_long, 1) << @as(c_int, 13);
pub const GCFont = @as(c_long, 1) << @as(c_int, 14);
pub const GCSubwindowMode = @as(c_long, 1) << @as(c_int, 15);
pub const GCGraphicsExposures = @as(c_long, 1) << @as(c_int, 16);
pub const GCClipXOrigin = @as(c_long, 1) << @as(c_int, 17);
pub const GCClipYOrigin = @as(c_long, 1) << @as(c_int, 18);
pub const GCClipMask = @as(c_long, 1) << @as(c_int, 19);
pub const GCDashOffset = @as(c_long, 1) << @as(c_int, 20);
pub const GCDashList = @as(c_long, 1) << @as(c_int, 21);
pub const GCArcMode = @as(c_long, 1) << @as(c_int, 22);
pub const GCLastBit = @as(c_int, 22);
pub const FontLeftToRight = @as(c_int, 0);
pub const FontRightToLeft = @as(c_int, 1);
pub const FontChange = @as(c_int, 255);
pub const XYBitmap = @as(c_int, 0);
pub const XYPixmap = @as(c_int, 1);
pub const ZPixmap = @as(c_int, 2);
pub const AllocNone = @as(c_int, 0);
pub const AllocAll = @as(c_int, 1);
pub const DoRed = @as(c_int, 1) << @as(c_int, 0);
pub const DoGreen = @as(c_int, 1) << @as(c_int, 1);
pub const DoBlue = @as(c_int, 1) << @as(c_int, 2);
pub const CursorShape = @as(c_int, 0);
pub const TileShape = @as(c_int, 1);
pub const StippleShape = @as(c_int, 2);
pub const AutoRepeatModeOff = @as(c_int, 0);
pub const AutoRepeatModeOn = @as(c_int, 1);
pub const AutoRepeatModeDefault = @as(c_int, 2);
pub const LedModeOff = @as(c_int, 0);
pub const LedModeOn = @as(c_int, 1);
pub const KBKeyClickPercent = @as(c_long, 1) << @as(c_int, 0);
pub const KBBellPercent = @as(c_long, 1) << @as(c_int, 1);
pub const KBBellPitch = @as(c_long, 1) << @as(c_int, 2);
pub const KBBellDuration = @as(c_long, 1) << @as(c_int, 3);
pub const KBLed = @as(c_long, 1) << @as(c_int, 4);
pub const KBLedMode = @as(c_long, 1) << @as(c_int, 5);
pub const KBKey = @as(c_long, 1) << @as(c_int, 6);
pub const KBAutoRepeatMode = @as(c_long, 1) << @as(c_int, 7);
pub const MappingSuccess = @as(c_int, 0);
pub const MappingBusy = @as(c_int, 1);
pub const MappingFailed = @as(c_int, 2);
pub const MappingModifier = @as(c_int, 0);
pub const MappingKeyboard = @as(c_int, 1);
pub const MappingPointer = @as(c_int, 2);
pub const DontPreferBlanking = @as(c_int, 0);
pub const PreferBlanking = @as(c_int, 1);
pub const DefaultBlanking = @as(c_int, 2);
pub const DisableScreenSaver = @as(c_int, 0);
pub const DisableScreenInterval = @as(c_int, 0);
pub const DontAllowExposures = @as(c_int, 0);
pub const AllowExposures = @as(c_int, 1);
pub const DefaultExposures = @as(c_int, 2);
pub const ScreenSaverReset = @as(c_int, 0);
pub const ScreenSaverActive = @as(c_int, 1);
pub const HostInsert = @as(c_int, 0);
pub const HostDelete = @as(c_int, 1);
pub const EnableAccess = @as(c_int, 1);
pub const DisableAccess = @as(c_int, 0);
pub const StaticGray = @as(c_int, 0);
pub const GrayScale = @as(c_int, 1);
pub const StaticColor = @as(c_int, 2);
pub const PseudoColor = @as(c_int, 3);
pub const TrueColor = @as(c_int, 4);
pub const DirectColor = @as(c_int, 5);
pub const LSBFirst = @as(c_int, 0);
pub const MSBFirst = @as(c_int, 1);
pub const _XFUNCPROTO_H_ = "";
pub const NeedFunctionPrototypes = @as(c_int, 1);
pub const NeedVarargsPrototypes = @as(c_int, 1);
pub const NeedNestedPrototypes = @as(c_int, 1);
pub const NARROWPROTO = "";
pub const FUNCPROTO = @as(c_int, 15);
pub const NeedWidePrototypes = @as(c_int, 0);
pub const _XFUNCPROTOBEGIN = "";
pub const _XFUNCPROTOEND = "";
pub inline fn _X_LIKELY(x: anytype) @TypeOf(__builtin_expect(!!(x != 0), @as(c_int, 1))) {
    return __builtin_expect(!!(x != 0), @as(c_int, 1));
}
pub inline fn _X_UNLIKELY(x: anytype) @TypeOf(__builtin_expect(!!(x != 0), @as(c_int, 0))) {
    return __builtin_expect(!!(x != 0), @as(c_int, 0));
}
pub const _X_NONSTRING = "";
pub const _XOSDEFS_H_ = "";
pub const __STDDEF_H = "";
pub const __need_ptrdiff_t = "";
pub const __need_size_t = "";
pub const __need_wchar_t = "";
pub const __need_NULL = "";
pub const __need_STDDEF_H_misc = "";
pub const _PTRDIFF_T = "";
pub const _SIZE_T = "";
pub const _WCHAR_T = "";
pub const NULL = @import("std").zig.c_translation.cast(?*anyopaque, @as(c_int, 0));
pub const __CLANG_MAX_ALIGN_T_DEFINED = "";
pub const X_HAVE_UTF8_STRING = @as(c_int, 1);
pub const Bool = c_int;
pub const Status = c_int;
pub const True = @as(c_int, 1);
pub const False = @as(c_int, 0);
pub const QueuedAlready = @as(c_int, 0);
pub const QueuedAfterReading = @as(c_int, 1);
pub const QueuedAfterFlush = @as(c_int, 2);
pub inline fn ConnectionNumber(dpy: anytype) @TypeOf(@import("std").zig.c_translation.cast(_XPrivDisplay, dpy).*.fd) {
    return @import("std").zig.c_translation.cast(_XPrivDisplay, dpy).*.fd;
}
pub inline fn RootWindow(dpy: anytype, scr: anytype) @TypeOf(ScreenOfDisplay(dpy, scr).*.root) {
    return ScreenOfDisplay(dpy, scr).*.root;
}
pub inline fn DefaultScreen(dpy: anytype) @TypeOf(@import("std").zig.c_translation.cast(_XPrivDisplay, dpy).*.default_screen) {
    return @import("std").zig.c_translation.cast(_XPrivDisplay, dpy).*.default_screen;
}
pub inline fn DefaultRootWindow(dpy: anytype) @TypeOf(ScreenOfDisplay(dpy, DefaultScreen(dpy)).*.root) {
    return ScreenOfDisplay(dpy, DefaultScreen(dpy)).*.root;
}
pub inline fn DefaultVisual(dpy: anytype, scr: anytype) @TypeOf(ScreenOfDisplay(dpy, scr).*.root_visual) {
    return ScreenOfDisplay(dpy, scr).*.root_visual;
}
pub inline fn DefaultGC(dpy: anytype, scr: anytype) @TypeOf(ScreenOfDisplay(dpy, scr).*.default_gc) {
    return ScreenOfDisplay(dpy, scr).*.default_gc;
}
pub inline fn BlackPixel(dpy: anytype, scr: anytype) @TypeOf(ScreenOfDisplay(dpy, scr).*.black_pixel) {
    return ScreenOfDisplay(dpy, scr).*.black_pixel;
}
pub inline fn WhitePixel(dpy: anytype, scr: anytype) @TypeOf(ScreenOfDisplay(dpy, scr).*.white_pixel) {
    return ScreenOfDisplay(dpy, scr).*.white_pixel;
}
pub const AllPlanes = @import("std").zig.c_translation.cast(c_ulong, ~@as(c_long, 0));
pub inline fn QLength(dpy: anytype) @TypeOf(@import("std").zig.c_translation.cast(_XPrivDisplay, dpy).*.qlen) {
    return @import("std").zig.c_translation.cast(_XPrivDisplay, dpy).*.qlen;
}
pub inline fn DisplayWidth(dpy: anytype, scr: anytype) @TypeOf(ScreenOfDisplay(dpy, scr).*.width) {
    return ScreenOfDisplay(dpy, scr).*.width;
}
pub inline fn DisplayHeight(dpy: anytype, scr: anytype) @TypeOf(ScreenOfDisplay(dpy, scr).*.height) {
    return ScreenOfDisplay(dpy, scr).*.height;
}
pub inline fn DisplayWidthMM(dpy: anytype, scr: anytype) @TypeOf(ScreenOfDisplay(dpy, scr).*.mwidth) {
    return ScreenOfDisplay(dpy, scr).*.mwidth;
}
pub inline fn DisplayHeightMM(dpy: anytype, scr: anytype) @TypeOf(ScreenOfDisplay(dpy, scr).*.mheight) {
    return ScreenOfDisplay(dpy, scr).*.mheight;
}
pub inline fn DisplayPlanes(dpy: anytype, scr: anytype) @TypeOf(ScreenOfDisplay(dpy, scr).*.root_depth) {
    return ScreenOfDisplay(dpy, scr).*.root_depth;
}
pub inline fn DisplayCells(dpy: anytype, scr: anytype) @TypeOf(DefaultVisual(dpy, scr).*.map_entries) {
    return DefaultVisual(dpy, scr).*.map_entries;
}
pub inline fn ScreenCount(dpy: anytype) @TypeOf(@import("std").zig.c_translation.cast(_XPrivDisplay, dpy).*.nscreens) {
    return @import("std").zig.c_translation.cast(_XPrivDisplay, dpy).*.nscreens;
}
pub inline fn ServerVendor(dpy: anytype) @TypeOf(@import("std").zig.c_translation.cast(_XPrivDisplay, dpy).*.vendor) {
    return @import("std").zig.c_translation.cast(_XPrivDisplay, dpy).*.vendor;
}
pub inline fn ProtocolVersion(dpy: anytype) @TypeOf(@import("std").zig.c_translation.cast(_XPrivDisplay, dpy).*.proto_major_version) {
    return @import("std").zig.c_translation.cast(_XPrivDisplay, dpy).*.proto_major_version;
}
pub inline fn ProtocolRevision(dpy: anytype) @TypeOf(@import("std").zig.c_translation.cast(_XPrivDisplay, dpy).*.proto_minor_version) {
    return @import("std").zig.c_translation.cast(_XPrivDisplay, dpy).*.proto_minor_version;
}
pub inline fn VendorRelease(dpy: anytype) @TypeOf(@import("std").zig.c_translation.cast(_XPrivDisplay, dpy).*.release) {
    return @import("std").zig.c_translation.cast(_XPrivDisplay, dpy).*.release;
}
pub inline fn DisplayString(dpy: anytype) @TypeOf(@import("std").zig.c_translation.cast(_XPrivDisplay, dpy).*.display_name) {
    return @import("std").zig.c_translation.cast(_XPrivDisplay, dpy).*.display_name;
}
pub inline fn DefaultDepth(dpy: anytype, scr: anytype) @TypeOf(ScreenOfDisplay(dpy, scr).*.root_depth) {
    return ScreenOfDisplay(dpy, scr).*.root_depth;
}
pub inline fn DefaultColormap(dpy: anytype, scr: anytype) @TypeOf(ScreenOfDisplay(dpy, scr).*.cmap) {
    return ScreenOfDisplay(dpy, scr).*.cmap;
}
pub inline fn BitmapUnit(dpy: anytype) @TypeOf(@import("std").zig.c_translation.cast(_XPrivDisplay, dpy).*.bitmap_unit) {
    return @import("std").zig.c_translation.cast(_XPrivDisplay, dpy).*.bitmap_unit;
}
pub inline fn BitmapBitOrder(dpy: anytype) @TypeOf(@import("std").zig.c_translation.cast(_XPrivDisplay, dpy).*.bitmap_bit_order) {
    return @import("std").zig.c_translation.cast(_XPrivDisplay, dpy).*.bitmap_bit_order;
}
pub inline fn BitmapPad(dpy: anytype) @TypeOf(@import("std").zig.c_translation.cast(_XPrivDisplay, dpy).*.bitmap_pad) {
    return @import("std").zig.c_translation.cast(_XPrivDisplay, dpy).*.bitmap_pad;
}
pub inline fn ImageByteOrder(dpy: anytype) @TypeOf(@import("std").zig.c_translation.cast(_XPrivDisplay, dpy).*.byte_order) {
    return @import("std").zig.c_translation.cast(_XPrivDisplay, dpy).*.byte_order;
}
pub inline fn NextRequest(dpy: anytype) @TypeOf(@import("std").zig.c_translation.cast(_XPrivDisplay, dpy).*.request + @as(c_int, 1)) {
    return @import("std").zig.c_translation.cast(_XPrivDisplay, dpy).*.request + @as(c_int, 1);
}
pub inline fn LastKnownRequestProcessed(dpy: anytype) @TypeOf(@import("std").zig.c_translation.cast(_XPrivDisplay, dpy).*.last_request_read) {
    return @import("std").zig.c_translation.cast(_XPrivDisplay, dpy).*.last_request_read;
}
pub inline fn ScreenOfDisplay(dpy: anytype, scr: anytype) @TypeOf(&@import("std").zig.c_translation.cast(_XPrivDisplay, dpy).*.screens[scr]) {
    return &@import("std").zig.c_translation.cast(_XPrivDisplay, dpy).*.screens[scr];
}
pub inline fn DefaultScreenOfDisplay(dpy: anytype) @TypeOf(ScreenOfDisplay(dpy, DefaultScreen(dpy))) {
    return ScreenOfDisplay(dpy, DefaultScreen(dpy));
}
pub inline fn DisplayOfScreen(s: anytype) @TypeOf(s.*.display) {
    return s.*.display;
}
pub inline fn RootWindowOfScreen(s: anytype) @TypeOf(s.*.root) {
    return s.*.root;
}
pub inline fn BlackPixelOfScreen(s: anytype) @TypeOf(s.*.black_pixel) {
    return s.*.black_pixel;
}
pub inline fn WhitePixelOfScreen(s: anytype) @TypeOf(s.*.white_pixel) {
    return s.*.white_pixel;
}
pub inline fn DefaultColormapOfScreen(s: anytype) @TypeOf(s.*.cmap) {
    return s.*.cmap;
}
pub inline fn DefaultDepthOfScreen(s: anytype) @TypeOf(s.*.root_depth) {
    return s.*.root_depth;
}
pub inline fn DefaultGCOfScreen(s: anytype) @TypeOf(s.*.default_gc) {
    return s.*.default_gc;
}
pub inline fn DefaultVisualOfScreen(s: anytype) @TypeOf(s.*.root_visual) {
    return s.*.root_visual;
}
pub inline fn WidthOfScreen(s: anytype) @TypeOf(s.*.width) {
    return s.*.width;
}
pub inline fn HeightOfScreen(s: anytype) @TypeOf(s.*.height) {
    return s.*.height;
}
pub inline fn WidthMMOfScreen(s: anytype) @TypeOf(s.*.mwidth) {
    return s.*.mwidth;
}
pub inline fn HeightMMOfScreen(s: anytype) @TypeOf(s.*.mheight) {
    return s.*.mheight;
}
pub inline fn PlanesOfScreen(s: anytype) @TypeOf(s.*.root_depth) {
    return s.*.root_depth;
}
pub inline fn CellsOfScreen(s: anytype) @TypeOf(DefaultVisualOfScreen(s).*.map_entries) {
    return DefaultVisualOfScreen(s).*.map_entries;
}
pub inline fn MinCmapsOfScreen(s: anytype) @TypeOf(s.*.min_maps) {
    return s.*.min_maps;
}
pub inline fn MaxCmapsOfScreen(s: anytype) @TypeOf(s.*.max_maps) {
    return s.*.max_maps;
}
pub inline fn DoesSaveUnders(s: anytype) @TypeOf(s.*.save_unders) {
    return s.*.save_unders;
}
pub inline fn DoesBackingStore(s: anytype) @TypeOf(s.*.backing_store) {
    return s.*.backing_store;
}
pub inline fn EventMaskOfScreen(s: anytype) @TypeOf(s.*.root_input_mask) {
    return s.*.root_input_mask;
}
pub inline fn XAllocID(dpy: anytype) @TypeOf(@import("std").zig.c_translation.cast(_XPrivDisplay, dpy).*.resource_alloc.*(dpy)) {
    return @import("std").zig.c_translation.cast(_XPrivDisplay, dpy).*.resource_alloc.*(dpy);
}
pub const XNRequiredCharSet = "requiredCharSet";
pub const XNQueryOrientation = "queryOrientation";
pub const XNBaseFontName = "baseFontName";
pub const XNOMAutomatic = "omAutomatic";
pub const XNMissingCharSet = "missingCharSet";
pub const XNDefaultString = "defaultString";
pub const XNOrientation = "orientation";
pub const XNDirectionalDependentDrawing = "directionalDependentDrawing";
pub const XNContextualDrawing = "contextualDrawing";
pub const XNFontInfo = "fontInfo";
pub const XIMPreeditArea = @as(c_long, 0x0001);
pub const XIMPreeditCallbacks = @as(c_long, 0x0002);
pub const XIMPreeditPosition = @as(c_long, 0x0004);
pub const XIMPreeditNothing = @as(c_long, 0x0008);
pub const XIMPreeditNone = @as(c_long, 0x0010);
pub const XIMStatusArea = @as(c_long, 0x0100);
pub const XIMStatusCallbacks = @as(c_long, 0x0200);
pub const XIMStatusNothing = @as(c_long, 0x0400);
pub const XIMStatusNone = @as(c_long, 0x0800);
pub const XNVaNestedList = "XNVaNestedList";
pub const XNQueryInputStyle = "queryInputStyle";
pub const XNClientWindow = "clientWindow";
pub const XNInputStyle = "inputStyle";
pub const XNFocusWindow = "focusWindow";
pub const XNResourceName = "resourceName";
pub const XNResourceClass = "resourceClass";
pub const XNGeometryCallback = "geometryCallback";
pub const XNDestroyCallback = "destroyCallback";
pub const XNFilterEvents = "filterEvents";
pub const XNPreeditStartCallback = "preeditStartCallback";
pub const XNPreeditDoneCallback = "preeditDoneCallback";
pub const XNPreeditDrawCallback = "preeditDrawCallback";
pub const XNPreeditCaretCallback = "preeditCaretCallback";
pub const XNPreeditStateNotifyCallback = "preeditStateNotifyCallback";
pub const XNPreeditAttributes = "preeditAttributes";
pub const XNStatusStartCallback = "statusStartCallback";
pub const XNStatusDoneCallback = "statusDoneCallback";
pub const XNStatusDrawCallback = "statusDrawCallback";
pub const XNStatusAttributes = "statusAttributes";
pub const XNArea = "area";
pub const XNAreaNeeded = "areaNeeded";
pub const XNSpotLocation = "spotLocation";
pub const XNColormap = "colorMap";
pub const XNStdColormap = "stdColorMap";
pub const XNForeground = "foreground";
pub const XNBackground = "background";
pub const XNBackgroundPixmap = "backgroundPixmap";
pub const XNFontSet = "fontSet";
pub const XNLineSpace = "lineSpace";
pub const XNCursor = "cursor";
pub const XNQueryIMValuesList = "queryIMValuesList";
pub const XNQueryICValuesList = "queryICValuesList";
pub const XNVisiblePosition = "visiblePosition";
pub const XNR6PreeditCallback = "r6PreeditCallback";
pub const XNStringConversionCallback = "stringConversionCallback";
pub const XNStringConversion = "stringConversion";
pub const XNResetState = "resetState";
pub const XNHotKey = "hotKey";
pub const XNHotKeyState = "hotKeyState";
pub const XNPreeditState = "preeditState";
pub const XNSeparatorofNestedList = "separatorofNestedList";
pub const XBufferOverflow = -@as(c_int, 1);
pub const XLookupNone = @as(c_int, 1);
pub const XLookupChars = @as(c_int, 2);
pub const XLookupKeySym = @as(c_int, 3);
pub const XLookupBoth = @as(c_int, 4);
pub const XIMReverse = @as(c_long, 1);
pub const XIMUnderline = @as(c_long, 1) << @as(c_int, 1);
pub const XIMHighlight = @as(c_long, 1) << @as(c_int, 2);
pub const XIMPrimary = @as(c_long, 1) << @as(c_int, 5);
pub const XIMSecondary = @as(c_long, 1) << @as(c_int, 6);
pub const XIMTertiary = @as(c_long, 1) << @as(c_int, 7);
pub const XIMVisibleToForward = @as(c_long, 1) << @as(c_int, 8);
pub const XIMVisibleToBackword = @as(c_long, 1) << @as(c_int, 9);
pub const XIMVisibleToCenter = @as(c_long, 1) << @as(c_int, 10);
pub const XIMPreeditUnKnown = @as(c_long, 0);
pub const XIMPreeditEnable = @as(c_long, 1);
pub const XIMPreeditDisable = @as(c_long, 1) << @as(c_int, 1);
pub const XIMInitialState = @as(c_long, 1);
pub const XIMPreserveState = @as(c_long, 1) << @as(c_int, 1);
pub const XIMStringConversionLeftEdge = @as(c_int, 0x00000001);
pub const XIMStringConversionRightEdge = @as(c_int, 0x00000002);
pub const XIMStringConversionTopEdge = @as(c_int, 0x00000004);
pub const XIMStringConversionBottomEdge = @as(c_int, 0x00000008);
pub const XIMStringConversionConcealed = @as(c_int, 0x00000010);
pub const XIMStringConversionWrapped = @as(c_int, 0x00000020);
pub const XIMStringConversionBuffer = @as(c_int, 0x0001);
pub const XIMStringConversionLine = @as(c_int, 0x0002);
pub const XIMStringConversionWord = @as(c_int, 0x0003);
pub const XIMStringConversionChar = @as(c_int, 0x0004);
pub const XIMStringConversionSubstitution = @as(c_int, 0x0001);
pub const XIMStringConversionRetrieval = @as(c_int, 0x0002);
pub const XIMHotKeyStateON = @as(c_long, 0x0001);
pub const XIMHotKeyStateOFF = @as(c_long, 0x0002);
pub const _XKBSTR_H_ = "";
pub const _XKB_H_ = "";
pub const X_kbUseExtension = @as(c_int, 0);
pub const X_kbSelectEvents = @as(c_int, 1);
pub const X_kbBell = @as(c_int, 3);
pub const X_kbGetState = @as(c_int, 4);
pub const X_kbLatchLockState = @as(c_int, 5);
pub const X_kbGetControls = @as(c_int, 6);
pub const X_kbSetControls = @as(c_int, 7);
pub const X_kbGetMap = @as(c_int, 8);
pub const X_kbSetMap = @as(c_int, 9);
pub const X_kbGetCompatMap = @as(c_int, 10);
pub const X_kbSetCompatMap = @as(c_int, 11);
pub const X_kbGetIndicatorState = @as(c_int, 12);
pub const X_kbGetIndicatorMap = @as(c_int, 13);
pub const X_kbSetIndicatorMap = @as(c_int, 14);
pub const X_kbGetNamedIndicator = @as(c_int, 15);
pub const X_kbSetNamedIndicator = @as(c_int, 16);
pub const X_kbGetNames = @as(c_int, 17);
pub const X_kbSetNames = @as(c_int, 18);
pub const X_kbGetGeometry = @as(c_int, 19);
pub const X_kbSetGeometry = @as(c_int, 20);
pub const X_kbPerClientFlags = @as(c_int, 21);
pub const X_kbListComponents = @as(c_int, 22);
pub const X_kbGetKbdByName = @as(c_int, 23);
pub const X_kbGetDeviceInfo = @as(c_int, 24);
pub const X_kbSetDeviceInfo = @as(c_int, 25);
pub const X_kbSetDebuggingFlags = @as(c_int, 101);
pub const XkbEventCode = @as(c_int, 0);
pub const XkbNumberEvents = XkbEventCode + @as(c_int, 1);
pub const XkbNewKeyboardNotify = @as(c_int, 0);
pub const XkbMapNotify = @as(c_int, 1);
pub const XkbStateNotify = @as(c_int, 2);
pub const XkbControlsNotify = @as(c_int, 3);
pub const XkbIndicatorStateNotify = @as(c_int, 4);
pub const XkbIndicatorMapNotify = @as(c_int, 5);
pub const XkbNamesNotify = @as(c_int, 6);
pub const XkbCompatMapNotify = @as(c_int, 7);
pub const XkbBellNotify = @as(c_int, 8);
pub const XkbActionMessage = @as(c_int, 9);
pub const XkbAccessXNotify = @as(c_int, 10);
pub const XkbExtensionDeviceNotify = @as(c_int, 11);
pub const XkbNewKeyboardNotifyMask = @as(c_long, 1) << @as(c_int, 0);
pub const XkbMapNotifyMask = @as(c_long, 1) << @as(c_int, 1);
pub const XkbStateNotifyMask = @as(c_long, 1) << @as(c_int, 2);
pub const XkbControlsNotifyMask = @as(c_long, 1) << @as(c_int, 3);
pub const XkbIndicatorStateNotifyMask = @as(c_long, 1) << @as(c_int, 4);
pub const XkbIndicatorMapNotifyMask = @as(c_long, 1) << @as(c_int, 5);
pub const XkbNamesNotifyMask = @as(c_long, 1) << @as(c_int, 6);
pub const XkbCompatMapNotifyMask = @as(c_long, 1) << @as(c_int, 7);
pub const XkbBellNotifyMask = @as(c_long, 1) << @as(c_int, 8);
pub const XkbActionMessageMask = @as(c_long, 1) << @as(c_int, 9);
pub const XkbAccessXNotifyMask = @as(c_long, 1) << @as(c_int, 10);
pub const XkbExtensionDeviceNotifyMask = @as(c_long, 1) << @as(c_int, 11);
pub const XkbAllEventsMask = @as(c_int, 0xFFF);
pub const XkbNKN_KeycodesMask = @as(c_long, 1) << @as(c_int, 0);
pub const XkbNKN_GeometryMask = @as(c_long, 1) << @as(c_int, 1);
pub const XkbNKN_DeviceIDMask = @as(c_long, 1) << @as(c_int, 2);
pub const XkbAllNewKeyboardEventsMask = @as(c_int, 0x7);
pub const XkbAXN_SKPress = @as(c_int, 0);
pub const XkbAXN_SKAccept = @as(c_int, 1);
pub const XkbAXN_SKReject = @as(c_int, 2);
pub const XkbAXN_SKRelease = @as(c_int, 3);
pub const XkbAXN_BKAccept = @as(c_int, 4);
pub const XkbAXN_BKReject = @as(c_int, 5);
pub const XkbAXN_AXKWarning = @as(c_int, 6);
pub const XkbAXN_SKPressMask = @as(c_long, 1) << @as(c_int, 0);
pub const XkbAXN_SKAcceptMask = @as(c_long, 1) << @as(c_int, 1);
pub const XkbAXN_SKRejectMask = @as(c_long, 1) << @as(c_int, 2);
pub const XkbAXN_SKReleaseMask = @as(c_long, 1) << @as(c_int, 3);
pub const XkbAXN_BKAcceptMask = @as(c_long, 1) << @as(c_int, 4);
pub const XkbAXN_BKRejectMask = @as(c_long, 1) << @as(c_int, 5);
pub const XkbAXN_AXKWarningMask = @as(c_long, 1) << @as(c_int, 6);
pub const XkbAllAccessXEventsMask = @as(c_int, 0x7f);
pub const XkbAllStateEventsMask = XkbAllStateComponentsMask;
pub const XkbAllMapEventsMask = XkbAllMapComponentsMask;
pub const XkbAllControlEventsMask = XkbAllControlsMask;
pub const XkbAllIndicatorEventsMask = XkbAllIndicatorsMask;
pub const XkbAllNameEventsMask = XkbAllNamesMask;
pub const XkbAllCompatMapEventsMask = XkbAllCompatMask;
pub const XkbAllBellEventsMask = @as(c_long, 1) << @as(c_int, 0);
pub const XkbAllActionMessagesMask = @as(c_long, 1) << @as(c_int, 0);
pub const XkbKeyboard = @as(c_int, 0);
pub const XkbNumberErrors = @as(c_int, 1);
pub const XkbErr_BadDevice = @as(c_int, 0xff);
pub const XkbErr_BadClass = @as(c_int, 0xfe);
pub const XkbErr_BadId = @as(c_int, 0xfd);
pub const XkbClientMapMask = @as(c_long, 1) << @as(c_int, 0);
pub const XkbServerMapMask = @as(c_long, 1) << @as(c_int, 1);
pub const XkbCompatMapMask = @as(c_long, 1) << @as(c_int, 2);
pub const XkbIndicatorMapMask = @as(c_long, 1) << @as(c_int, 3);
pub const XkbNamesMask = @as(c_long, 1) << @as(c_int, 4);
pub const XkbGeometryMask = @as(c_long, 1) << @as(c_int, 5);
pub const XkbControlsMask = @as(c_long, 1) << @as(c_int, 6);
pub const XkbAllComponentsMask = @as(c_int, 0x7f);
pub const XkbModifierStateMask = @as(c_long, 1) << @as(c_int, 0);
pub const XkbModifierBaseMask = @as(c_long, 1) << @as(c_int, 1);
pub const XkbModifierLatchMask = @as(c_long, 1) << @as(c_int, 2);
pub const XkbModifierLockMask = @as(c_long, 1) << @as(c_int, 3);
pub const XkbGroupStateMask = @as(c_long, 1) << @as(c_int, 4);
pub const XkbGroupBaseMask = @as(c_long, 1) << @as(c_int, 5);
pub const XkbGroupLatchMask = @as(c_long, 1) << @as(c_int, 6);
pub const XkbGroupLockMask = @as(c_long, 1) << @as(c_int, 7);
pub const XkbCompatStateMask = @as(c_long, 1) << @as(c_int, 8);
pub const XkbGrabModsMask = @as(c_long, 1) << @as(c_int, 9);
pub const XkbCompatGrabModsMask = @as(c_long, 1) << @as(c_int, 10);
pub const XkbLookupModsMask = @as(c_long, 1) << @as(c_int, 11);
pub const XkbCompatLookupModsMask = @as(c_long, 1) << @as(c_int, 12);
pub const XkbPointerButtonMask = @as(c_long, 1) << @as(c_int, 13);
pub const XkbAllStateComponentsMask = @as(c_int, 0x3fff);
pub const XkbRepeatKeysMask = @as(c_long, 1) << @as(c_int, 0);
pub const XkbSlowKeysMask = @as(c_long, 1) << @as(c_int, 1);
pub const XkbBounceKeysMask = @as(c_long, 1) << @as(c_int, 2);
pub const XkbStickyKeysMask = @as(c_long, 1) << @as(c_int, 3);
pub const XkbMouseKeysMask = @as(c_long, 1) << @as(c_int, 4);
pub const XkbMouseKeysAccelMask = @as(c_long, 1) << @as(c_int, 5);
pub const XkbAccessXKeysMask = @as(c_long, 1) << @as(c_int, 6);
pub const XkbAccessXTimeoutMask = @as(c_long, 1) << @as(c_int, 7);
pub const XkbAccessXFeedbackMask = @as(c_long, 1) << @as(c_int, 8);
pub const XkbAudibleBellMask = @as(c_long, 1) << @as(c_int, 9);
pub const XkbOverlay1Mask = @as(c_long, 1) << @as(c_int, 10);
pub const XkbOverlay2Mask = @as(c_long, 1) << @as(c_int, 11);
pub const XkbIgnoreGroupLockMask = @as(c_long, 1) << @as(c_int, 12);
pub const XkbGroupsWrapMask = @as(c_long, 1) << @as(c_int, 27);
pub const XkbInternalModsMask = @as(c_long, 1) << @as(c_int, 28);
pub const XkbIgnoreLockModsMask = @as(c_long, 1) << @as(c_int, 29);
pub const XkbPerKeyRepeatMask = @as(c_long, 1) << @as(c_int, 30);
pub const XkbControlsEnabledMask = @as(c_long, 1) << @as(c_int, 31);
pub const XkbAccessXOptionsMask = XkbStickyKeysMask | XkbAccessXFeedbackMask;
pub const XkbAllBooleanCtrlsMask = @as(c_int, 0x00001FFF);
pub const XkbAllControlsMask = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0xF8001FFF, .hexadecimal);
pub const XkbAX_SKPressFBMask = @as(c_long, 1) << @as(c_int, 0);
pub const XkbAX_SKAcceptFBMask = @as(c_long, 1) << @as(c_int, 1);
pub const XkbAX_FeatureFBMask = @as(c_long, 1) << @as(c_int, 2);
pub const XkbAX_SlowWarnFBMask = @as(c_long, 1) << @as(c_int, 3);
pub const XkbAX_IndicatorFBMask = @as(c_long, 1) << @as(c_int, 4);
pub const XkbAX_StickyKeysFBMask = @as(c_long, 1) << @as(c_int, 5);
pub const XkbAX_TwoKeysMask = @as(c_long, 1) << @as(c_int, 6);
pub const XkbAX_LatchToLockMask = @as(c_long, 1) << @as(c_int, 7);
pub const XkbAX_SKReleaseFBMask = @as(c_long, 1) << @as(c_int, 8);
pub const XkbAX_SKRejectFBMask = @as(c_long, 1) << @as(c_int, 9);
pub const XkbAX_BKRejectFBMask = @as(c_long, 1) << @as(c_int, 10);
pub const XkbAX_DumbBellFBMask = @as(c_long, 1) << @as(c_int, 11);
pub const XkbAX_FBOptionsMask = @as(c_int, 0xF3F);
pub const XkbAX_SKOptionsMask = @as(c_int, 0x0C0);
pub const XkbAX_AllOptionsMask = @as(c_int, 0xFFF);
pub const XkbUseCoreKbd = @as(c_int, 0x0100);
pub const XkbUseCorePtr = @as(c_int, 0x0200);
pub const XkbDfltXIClass = @as(c_int, 0x0300);
pub const XkbDfltXIId = @as(c_int, 0x0400);
pub const XkbAllXIClasses = @as(c_int, 0x0500);
pub const XkbAllXIIds = @as(c_int, 0x0600);
pub const XkbXINone = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0xff00, .hexadecimal);
pub inline fn XkbExplicitXIDevice(c: anytype) @TypeOf((c & ~@as(c_int, 0xff)) == @as(c_int, 0)) {
    return (c & ~@as(c_int, 0xff)) == @as(c_int, 0);
}
pub inline fn XkbExplicitXIClass(c: anytype) @TypeOf((c & ~@as(c_int, 0xff)) == @as(c_int, 0)) {
    return (c & ~@as(c_int, 0xff)) == @as(c_int, 0);
}
pub inline fn XkbExplicitXIId(c: anytype) @TypeOf((c & ~@as(c_int, 0xff)) == @as(c_int, 0)) {
    return (c & ~@as(c_int, 0xff)) == @as(c_int, 0);
}
pub inline fn XkbSingleXIClass(c: anytype) @TypeOf(((c & ~@as(c_int, 0xff)) == @as(c_int, 0)) or (c == XkbDfltXIClass)) {
    return ((c & ~@as(c_int, 0xff)) == @as(c_int, 0)) or (c == XkbDfltXIClass);
}
pub inline fn XkbSingleXIId(c: anytype) @TypeOf(((c & ~@as(c_int, 0xff)) == @as(c_int, 0)) or (c == XkbDfltXIId)) {
    return ((c & ~@as(c_int, 0xff)) == @as(c_int, 0)) or (c == XkbDfltXIId);
}
pub const XkbNoModifier = @as(c_int, 0xff);
pub const XkbNoShiftLevel = @as(c_int, 0xff);
pub const XkbNoShape = @as(c_int, 0xff);
pub const XkbNoIndicator = @as(c_int, 0xff);
pub const XkbNoModifierMask = @as(c_int, 0);
pub const XkbAllModifiersMask = @as(c_int, 0xff);
pub const XkbAllVirtualModsMask = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0xffff, .hexadecimal);
pub const XkbNumKbdGroups = @as(c_int, 4);
pub const XkbMaxKbdGroup = XkbNumKbdGroups - @as(c_int, 1);
pub const XkbMaxMouseKeysBtn = @as(c_int, 4);
pub const XkbGroup1Index = @as(c_int, 0);
pub const XkbGroup2Index = @as(c_int, 1);
pub const XkbGroup3Index = @as(c_int, 2);
pub const XkbGroup4Index = @as(c_int, 3);
pub const XkbAnyGroup = @as(c_int, 254);
pub const XkbAllGroups = @as(c_int, 255);
pub const XkbGroup1Mask = @as(c_int, 1) << @as(c_int, 0);
pub const XkbGroup2Mask = @as(c_int, 1) << @as(c_int, 1);
pub const XkbGroup3Mask = @as(c_int, 1) << @as(c_int, 2);
pub const XkbGroup4Mask = @as(c_int, 1) << @as(c_int, 3);
pub const XkbAnyGroupMask = @as(c_int, 1) << @as(c_int, 7);
pub const XkbAllGroupsMask = @as(c_int, 0xf);
pub inline fn XkbBuildCoreState(m: anytype, g: anytype) @TypeOf(((g & @as(c_int, 0x3)) << @as(c_int, 13)) | (m & @as(c_int, 0xff))) {
    return ((g & @as(c_int, 0x3)) << @as(c_int, 13)) | (m & @as(c_int, 0xff));
}
pub inline fn XkbGroupForCoreState(s: anytype) @TypeOf((s >> @as(c_int, 13)) & @as(c_int, 0x3)) {
    return (s >> @as(c_int, 13)) & @as(c_int, 0x3);
}
pub inline fn XkbIsLegalGroup(g: anytype) @TypeOf((g >= @as(c_int, 0)) and (g < XkbNumKbdGroups)) {
    return (g >= @as(c_int, 0)) and (g < XkbNumKbdGroups);
}
pub const XkbWrapIntoRange = @as(c_int, 0x00);
pub const XkbClampIntoRange = @as(c_int, 0x40);
pub const XkbRedirectIntoRange = @as(c_int, 0x80);
pub const XkbSA_ClearLocks = @as(c_long, 1) << @as(c_int, 0);
pub const XkbSA_LatchToLock = @as(c_long, 1) << @as(c_int, 1);
pub const XkbSA_LockNoLock = @as(c_long, 1) << @as(c_int, 0);
pub const XkbSA_LockNoUnlock = @as(c_long, 1) << @as(c_int, 1);
pub const XkbSA_UseModMapMods = @as(c_long, 1) << @as(c_int, 2);
pub const XkbSA_GroupAbsolute = @as(c_long, 1) << @as(c_int, 2);
pub const XkbSA_UseDfltButton = @as(c_int, 0);
pub const XkbSA_NoAcceleration = @as(c_long, 1) << @as(c_int, 0);
pub const XkbSA_MoveAbsoluteX = @as(c_long, 1) << @as(c_int, 1);
pub const XkbSA_MoveAbsoluteY = @as(c_long, 1) << @as(c_int, 2);
pub const XkbSA_ISODfltIsGroup = @as(c_long, 1) << @as(c_int, 7);
pub const XkbSA_ISONoAffectMods = @as(c_long, 1) << @as(c_int, 6);
pub const XkbSA_ISONoAffectGroup = @as(c_long, 1) << @as(c_int, 5);
pub const XkbSA_ISONoAffectPtr = @as(c_long, 1) << @as(c_int, 4);
pub const XkbSA_ISONoAffectCtrls = @as(c_long, 1) << @as(c_int, 3);
pub const XkbSA_ISOAffectMask = @as(c_int, 0x78);
pub const XkbSA_MessageOnPress = @as(c_long, 1) << @as(c_int, 0);
pub const XkbSA_MessageOnRelease = @as(c_long, 1) << @as(c_int, 1);
pub const XkbSA_MessageGenKeyEvent = @as(c_long, 1) << @as(c_int, 2);
pub const XkbSA_AffectDfltBtn = @as(c_int, 1);
pub const XkbSA_DfltBtnAbsolute = @as(c_long, 1) << @as(c_int, 2);
pub const XkbSA_SwitchApplication = @as(c_long, 1) << @as(c_int, 0);
pub const XkbSA_SwitchAbsolute = @as(c_long, 1) << @as(c_int, 2);
pub const XkbSA_IgnoreVal = @as(c_int, 0x00);
pub const XkbSA_SetValMin = @as(c_int, 0x10);
pub const XkbSA_SetValCenter = @as(c_int, 0x20);
pub const XkbSA_SetValMax = @as(c_int, 0x30);
pub const XkbSA_SetValRelative = @as(c_int, 0x40);
pub const XkbSA_SetValAbsolute = @as(c_int, 0x50);
pub const XkbSA_ValOpMask = @as(c_int, 0x70);
pub const XkbSA_ValScaleMask = @as(c_int, 0x07);
pub inline fn XkbSA_ValOp(a: anytype) @TypeOf(a & XkbSA_ValOpMask) {
    return a & XkbSA_ValOpMask;
}
pub inline fn XkbSA_ValScale(a: anytype) @TypeOf(a & XkbSA_ValScaleMask) {
    return a & XkbSA_ValScaleMask;
}
pub const XkbSA_NoAction = @as(c_int, 0x00);
pub const XkbSA_SetMods = @as(c_int, 0x01);
pub const XkbSA_LatchMods = @as(c_int, 0x02);
pub const XkbSA_LockMods = @as(c_int, 0x03);
pub const XkbSA_SetGroup = @as(c_int, 0x04);
pub const XkbSA_LatchGroup = @as(c_int, 0x05);
pub const XkbSA_LockGroup = @as(c_int, 0x06);
pub const XkbSA_MovePtr = @as(c_int, 0x07);
pub const XkbSA_PtrBtn = @as(c_int, 0x08);
pub const XkbSA_LockPtrBtn = @as(c_int, 0x09);
pub const XkbSA_SetPtrDflt = @as(c_int, 0x0a);
pub const XkbSA_ISOLock = @as(c_int, 0x0b);
pub const XkbSA_Terminate = @as(c_int, 0x0c);
pub const XkbSA_SwitchScreen = @as(c_int, 0x0d);
pub const XkbSA_SetControls = @as(c_int, 0x0e);
pub const XkbSA_LockControls = @as(c_int, 0x0f);
pub const XkbSA_ActionMessage = @as(c_int, 0x10);
pub const XkbSA_RedirectKey = @as(c_int, 0x11);
pub const XkbSA_DeviceBtn = @as(c_int, 0x12);
pub const XkbSA_LockDeviceBtn = @as(c_int, 0x13);
pub const XkbSA_DeviceValuator = @as(c_int, 0x14);
pub const XkbSA_LastAction = XkbSA_DeviceValuator;
pub const XkbSA_NumActions = XkbSA_LastAction + @as(c_int, 1);
pub const XkbSA_XFree86Private = @as(c_int, 0x86);
pub const XkbSA_BreakLatch = ((((((((((@as(c_int, 1) << XkbSA_NoAction) | (@as(c_int, 1) << XkbSA_PtrBtn)) | (@as(c_int, 1) << XkbSA_LockPtrBtn)) | (@as(c_int, 1) << XkbSA_Terminate)) | (@as(c_int, 1) << XkbSA_SwitchScreen)) | (@as(c_int, 1) << XkbSA_SetControls)) | (@as(c_int, 1) << XkbSA_LockControls)) | (@as(c_int, 1) << XkbSA_ActionMessage)) | (@as(c_int, 1) << XkbSA_RedirectKey)) | (@as(c_int, 1) << XkbSA_DeviceBtn)) | (@as(c_int, 1) << XkbSA_LockDeviceBtn);
pub inline fn XkbIsGroupAction(a: anytype) @TypeOf((a.*.type >= XkbSA_SetGroup) and (a.*.type <= XkbSA_LockGroup)) {
    return (a.*.type >= XkbSA_SetGroup) and (a.*.type <= XkbSA_LockGroup);
}
pub inline fn XkbIsPtrAction(a: anytype) @TypeOf((a.*.type >= XkbSA_MovePtr) and (a.*.type <= XkbSA_SetPtrDflt)) {
    return (a.*.type >= XkbSA_MovePtr) and (a.*.type <= XkbSA_SetPtrDflt);
}
pub const XkbKB_Permanent = @as(c_int, 0x80);
pub const XkbKB_OpMask = @as(c_int, 0x7f);
pub const XkbKB_Default = @as(c_int, 0x00);
pub const XkbKB_Lock = @as(c_int, 0x01);
pub const XkbKB_RadioGroup = @as(c_int, 0x02);
pub const XkbKB_Overlay1 = @as(c_int, 0x03);
pub const XkbKB_Overlay2 = @as(c_int, 0x04);
pub const XkbKB_RGAllowNone = @as(c_int, 0x80);
pub const XkbMinLegalKeyCode = @as(c_int, 8);
pub const XkbMaxLegalKeyCode = @as(c_int, 255);
pub const XkbMaxKeyCount = (XkbMaxLegalKeyCode - XkbMinLegalKeyCode) + @as(c_int, 1);
pub const XkbPerKeyBitArraySize = (XkbMaxLegalKeyCode + @as(c_int, 1)) / @as(c_int, 8);
pub inline fn XkbIsLegalKeycode(k: anytype) @TypeOf(k >= XkbMinLegalKeyCode) {
    return k >= XkbMinLegalKeyCode;
}
pub const XkbNumModifiers = @as(c_int, 8);
pub const XkbNumVirtualMods = @as(c_int, 16);
pub const XkbNumIndicators = @as(c_int, 32);
pub const XkbAllIndicatorsMask = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0xffffffff, .hexadecimal);
pub const XkbMaxRadioGroups = @as(c_int, 32);
pub const XkbAllRadioGroupsMask = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0xffffffff, .hexadecimal);
pub const XkbMaxShiftLevel = @as(c_int, 63);
pub const XkbMaxSymsPerKey = XkbMaxShiftLevel * XkbNumKbdGroups;
pub const XkbRGMaxMembers = @as(c_int, 12);
pub const XkbActionMessageLength = @as(c_int, 6);
pub const XkbKeyNameLength = @as(c_int, 4);
pub const XkbMaxRedirectCount = @as(c_int, 8);
pub const XkbGeomPtsPerMM = @as(c_int, 10);
pub const XkbGeomMaxColors = @as(c_int, 32);
pub const XkbGeomMaxLabelColors = @as(c_int, 3);
pub const XkbGeomMaxPriority = @as(c_int, 255);
pub const XkbOneLevelIndex = @as(c_int, 0);
pub const XkbTwoLevelIndex = @as(c_int, 1);
pub const XkbAlphabeticIndex = @as(c_int, 2);
pub const XkbKeypadIndex = @as(c_int, 3);
pub const XkbLastRequiredType = XkbKeypadIndex;
pub const XkbNumRequiredTypes = XkbLastRequiredType + @as(c_int, 1);
pub const XkbMaxKeyTypes = @as(c_int, 255);
pub const XkbOneLevelMask = @as(c_int, 1) << @as(c_int, 0);
pub const XkbTwoLevelMask = @as(c_int, 1) << @as(c_int, 1);
pub const XkbAlphabeticMask = @as(c_int, 1) << @as(c_int, 2);
pub const XkbKeypadMask = @as(c_int, 1) << @as(c_int, 3);
pub const XkbAllRequiredTypes = @as(c_int, 0xf);
pub inline fn XkbShiftLevel(n: anytype) @TypeOf(n - @as(c_int, 1)) {
    return n - @as(c_int, 1);
}
pub inline fn XkbShiftLevelMask(n: anytype) @TypeOf(@as(c_int, 1) << (n - @as(c_int, 1))) {
    return @as(c_int, 1) << (n - @as(c_int, 1));
}
pub const XkbName = "XKEYBOARD";
pub const XkbMajorVersion = @as(c_int, 1);
pub const XkbMinorVersion = @as(c_int, 0);
pub const XkbExplicitKeyTypesMask = @as(c_int, 0x0f);
pub const XkbExplicitKeyType1Mask = @as(c_int, 1) << @as(c_int, 0);
pub const XkbExplicitKeyType2Mask = @as(c_int, 1) << @as(c_int, 1);
pub const XkbExplicitKeyType3Mask = @as(c_int, 1) << @as(c_int, 2);
pub const XkbExplicitKeyType4Mask = @as(c_int, 1) << @as(c_int, 3);
pub const XkbExplicitInterpretMask = @as(c_int, 1) << @as(c_int, 4);
pub const XkbExplicitAutoRepeatMask = @as(c_int, 1) << @as(c_int, 5);
pub const XkbExplicitBehaviorMask = @as(c_int, 1) << @as(c_int, 6);
pub const XkbExplicitVModMapMask = @as(c_int, 1) << @as(c_int, 7);
pub const XkbAllExplicitMask = @as(c_int, 0xff);
pub const XkbKeyTypesMask = @as(c_int, 1) << @as(c_int, 0);
pub const XkbKeySymsMask = @as(c_int, 1) << @as(c_int, 1);
pub const XkbModifierMapMask = @as(c_int, 1) << @as(c_int, 2);
pub const XkbExplicitComponentsMask = @as(c_int, 1) << @as(c_int, 3);
pub const XkbKeyActionsMask = @as(c_int, 1) << @as(c_int, 4);
pub const XkbKeyBehaviorsMask = @as(c_int, 1) << @as(c_int, 5);
pub const XkbVirtualModsMask = @as(c_int, 1) << @as(c_int, 6);
pub const XkbVirtualModMapMask = @as(c_int, 1) << @as(c_int, 7);
pub const XkbAllClientInfoMask = (XkbKeyTypesMask | XkbKeySymsMask) | XkbModifierMapMask;
pub const XkbAllServerInfoMask = (((XkbExplicitComponentsMask | XkbKeyActionsMask) | XkbKeyBehaviorsMask) | XkbVirtualModsMask) | XkbVirtualModMapMask;
pub const XkbAllMapComponentsMask = XkbAllClientInfoMask | XkbAllServerInfoMask;
pub const XkbSI_AutoRepeat = @as(c_int, 1) << @as(c_int, 0);
pub const XkbSI_LockingKey = @as(c_int, 1) << @as(c_int, 1);
pub const XkbSI_LevelOneOnly = @as(c_int, 0x80);
pub const XkbSI_OpMask = @as(c_int, 0x7f);
pub const XkbSI_NoneOf = @as(c_int, 0);
pub const XkbSI_AnyOfOrNone = @as(c_int, 1);
pub const XkbSI_AnyOf = @as(c_int, 2);
pub const XkbSI_AllOf = @as(c_int, 3);
pub const XkbSI_Exactly = @as(c_int, 4);
pub const XkbIM_NoExplicit = @as(c_long, 1) << @as(c_int, 7);
pub const XkbIM_NoAutomatic = @as(c_long, 1) << @as(c_int, 6);
pub const XkbIM_LEDDrivesKB = @as(c_long, 1) << @as(c_int, 5);
pub const XkbIM_UseBase = @as(c_long, 1) << @as(c_int, 0);
pub const XkbIM_UseLatched = @as(c_long, 1) << @as(c_int, 1);
pub const XkbIM_UseLocked = @as(c_long, 1) << @as(c_int, 2);
pub const XkbIM_UseEffective = @as(c_long, 1) << @as(c_int, 3);
pub const XkbIM_UseCompat = @as(c_long, 1) << @as(c_int, 4);
pub const XkbIM_UseNone = @as(c_int, 0);
pub const XkbIM_UseAnyGroup = ((XkbIM_UseBase | XkbIM_UseLatched) | XkbIM_UseLocked) | XkbIM_UseEffective;
pub const XkbIM_UseAnyMods = XkbIM_UseAnyGroup | XkbIM_UseCompat;
pub const XkbSymInterpMask = @as(c_int, 1) << @as(c_int, 0);
pub const XkbGroupCompatMask = @as(c_int, 1) << @as(c_int, 1);
pub const XkbAllCompatMask = @as(c_int, 0x3);
pub const XkbKeycodesNameMask = @as(c_int, 1) << @as(c_int, 0);
pub const XkbGeometryNameMask = @as(c_int, 1) << @as(c_int, 1);
pub const XkbSymbolsNameMask = @as(c_int, 1) << @as(c_int, 2);
pub const XkbPhysSymbolsNameMask = @as(c_int, 1) << @as(c_int, 3);
pub const XkbTypesNameMask = @as(c_int, 1) << @as(c_int, 4);
pub const XkbCompatNameMask = @as(c_int, 1) << @as(c_int, 5);
pub const XkbKeyTypeNamesMask = @as(c_int, 1) << @as(c_int, 6);
pub const XkbKTLevelNamesMask = @as(c_int, 1) << @as(c_int, 7);
pub const XkbIndicatorNamesMask = @as(c_int, 1) << @as(c_int, 8);
pub const XkbKeyNamesMask = @as(c_int, 1) << @as(c_int, 9);
pub const XkbKeyAliasesMask = @as(c_int, 1) << @as(c_int, 10);
pub const XkbVirtualModNamesMask = @as(c_int, 1) << @as(c_int, 11);
pub const XkbGroupNamesMask = @as(c_int, 1) << @as(c_int, 12);
pub const XkbRGNamesMask = @as(c_int, 1) << @as(c_int, 13);
pub const XkbComponentNamesMask = @as(c_int, 0x3f);
pub const XkbAllNamesMask = @as(c_int, 0x3fff);
pub const XkbGBN_TypesMask = @as(c_long, 1) << @as(c_int, 0);
pub const XkbGBN_CompatMapMask = @as(c_long, 1) << @as(c_int, 1);
pub const XkbGBN_ClientSymbolsMask = @as(c_long, 1) << @as(c_int, 2);
pub const XkbGBN_ServerSymbolsMask = @as(c_long, 1) << @as(c_int, 3);
pub const XkbGBN_SymbolsMask = XkbGBN_ClientSymbolsMask | XkbGBN_ServerSymbolsMask;
pub const XkbGBN_IndicatorMapMask = @as(c_long, 1) << @as(c_int, 4);
pub const XkbGBN_KeyNamesMask = @as(c_long, 1) << @as(c_int, 5);
pub const XkbGBN_GeometryMask = @as(c_long, 1) << @as(c_int, 6);
pub const XkbGBN_OtherNamesMask = @as(c_long, 1) << @as(c_int, 7);
pub const XkbGBN_AllComponentsMask = @as(c_int, 0xff);
pub const XkbLC_Hidden = @as(c_long, 1) << @as(c_int, 0);
pub const XkbLC_Default = @as(c_long, 1) << @as(c_int, 1);
pub const XkbLC_Partial = @as(c_long, 1) << @as(c_int, 2);
pub const XkbLC_AlphanumericKeys = @as(c_long, 1) << @as(c_int, 8);
pub const XkbLC_ModifierKeys = @as(c_long, 1) << @as(c_int, 9);
pub const XkbLC_KeypadKeys = @as(c_long, 1) << @as(c_int, 10);
pub const XkbLC_FunctionKeys = @as(c_long, 1) << @as(c_int, 11);
pub const XkbLC_AlternateGroup = @as(c_long, 1) << @as(c_int, 12);
pub const XkbXI_KeyboardsMask = @as(c_long, 1) << @as(c_int, 0);
pub const XkbXI_ButtonActionsMask = @as(c_long, 1) << @as(c_int, 1);
pub const XkbXI_IndicatorNamesMask = @as(c_long, 1) << @as(c_int, 2);
pub const XkbXI_IndicatorMapsMask = @as(c_long, 1) << @as(c_int, 3);
pub const XkbXI_IndicatorStateMask = @as(c_long, 1) << @as(c_int, 4);
pub const XkbXI_UnsupportedFeatureMask = @as(c_long, 1) << @as(c_int, 15);
pub const XkbXI_AllFeaturesMask = @as(c_int, 0x001f);
pub const XkbXI_AllDeviceFeaturesMask = @as(c_int, 0x001e);
pub const XkbXI_IndicatorsMask = @as(c_int, 0x001c);
pub const XkbAllExtensionDeviceEventsMask = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x801f, .hexadecimal);
pub const XkbPCF_DetectableAutoRepeatMask = @as(c_long, 1) << @as(c_int, 0);
pub const XkbPCF_GrabsUseXKBStateMask = @as(c_long, 1) << @as(c_int, 1);
pub const XkbPCF_AutoResetControlsMask = @as(c_long, 1) << @as(c_int, 2);
pub const XkbPCF_LookupStateWhenGrabbed = @as(c_long, 1) << @as(c_int, 3);
pub const XkbPCF_SendEventUsesXKBState = @as(c_long, 1) << @as(c_int, 4);
pub const XkbPCF_AllFlagsMask = @as(c_int, 0x1F);
pub const XkbDF_DisableLocks = @as(c_int, 1) << @as(c_int, 0);
pub inline fn XkbCharToInt(v: anytype) @TypeOf(if (v & @as(c_int, 0x80)) @import("std").zig.c_translation.cast(c_int, v | ~@as(c_int, 0xff)) else @import("std").zig.c_translation.cast(c_int, v & @as(c_int, 0x7f))) {
    return if (v & @as(c_int, 0x80)) @import("std").zig.c_translation.cast(c_int, v | ~@as(c_int, 0xff)) else @import("std").zig.c_translation.cast(c_int, v & @as(c_int, 0x7f));
}
pub inline fn Xkb2CharsToInt(h: anytype, l: anytype) c_short {
    return @import("std").zig.c_translation.cast(c_short, (h << @as(c_int, 8)) | l);
}
pub inline fn XkbModLocks(s: anytype) @TypeOf(s.*.locked_mods) {
    return s.*.locked_mods;
}
pub inline fn XkbStateMods(s: anytype) @TypeOf((s.*.base_mods | s.*.latched_mods) | XkbModLocks(s)) {
    return (s.*.base_mods | s.*.latched_mods) | XkbModLocks(s);
}
pub inline fn XkbGroupLock(s: anytype) @TypeOf(s.*.locked_group) {
    return s.*.locked_group;
}
pub inline fn XkbStateGroup(s: anytype) @TypeOf((s.*.base_group + s.*.latched_group) + XkbGroupLock(s)) {
    return (s.*.base_group + s.*.latched_group) + XkbGroupLock(s);
}
pub inline fn XkbStateFieldFromRec(s: anytype) @TypeOf(XkbBuildCoreState(s.*.lookup_mods, s.*.group)) {
    return XkbBuildCoreState(s.*.lookup_mods, s.*.group);
}
pub inline fn XkbGrabStateFromRec(s: anytype) @TypeOf(XkbBuildCoreState(s.*.grab_mods, s.*.group)) {
    return XkbBuildCoreState(s.*.grab_mods, s.*.group);
}
pub inline fn XkbNumGroups(g: anytype) @TypeOf(g & @as(c_int, 0x0f)) {
    return g & @as(c_int, 0x0f);
}
pub inline fn XkbOutOfRangeGroupInfo(g: anytype) @TypeOf(g & @as(c_int, 0xf0)) {
    return g & @as(c_int, 0xf0);
}
pub inline fn XkbOutOfRangeGroupAction(g: anytype) @TypeOf(g & @as(c_int, 0xc0)) {
    return g & @as(c_int, 0xc0);
}
pub inline fn XkbOutOfRangeGroupNumber(g: anytype) @TypeOf((g & @as(c_int, 0x30)) >> @as(c_int, 4)) {
    return (g & @as(c_int, 0x30)) >> @as(c_int, 4);
}
pub inline fn XkbSetGroupInfo(g: anytype, w: anytype, n: anytype) @TypeOf(((w & @as(c_int, 0xc0)) | ((n & @as(c_int, 3)) << @as(c_int, 4))) | (g & @as(c_int, 0x0f))) {
    return ((w & @as(c_int, 0xc0)) | ((n & @as(c_int, 3)) << @as(c_int, 4))) | (g & @as(c_int, 0x0f));
}
pub inline fn XkbSetNumGroups(g: anytype, n: anytype) @TypeOf((g & @as(c_int, 0xf0)) | (n & @as(c_int, 0x0f))) {
    return (g & @as(c_int, 0xf0)) | (n & @as(c_int, 0x0f));
}
pub const XkbAnyActionDataSize = @as(c_int, 7);
pub inline fn XkbModActionVMods(a: anytype) c_short {
    return @import("std").zig.c_translation.cast(c_short, (a.*.vmods1 << @as(c_int, 8)) | a.*.vmods2);
}
pub inline fn XkbSAGroup(a: anytype) @TypeOf(XkbCharToInt(a.*.group_XXX)) {
    return XkbCharToInt(a.*.group_XXX);
}
pub inline fn XkbPtrActionX(a: anytype) @TypeOf(Xkb2CharsToInt(a.*.high_XXX, a.*.low_XXX)) {
    return Xkb2CharsToInt(a.*.high_XXX, a.*.low_XXX);
}
pub inline fn XkbPtrActionY(a: anytype) @TypeOf(Xkb2CharsToInt(a.*.high_YYY, a.*.low_YYY)) {
    return Xkb2CharsToInt(a.*.high_YYY, a.*.low_YYY);
}
pub inline fn XkbSetPtrActionX(a: anytype, x: anytype) @TypeOf(XkbIntTo2Chars(x, a.*.high_XXX, a.*.low_XXX)) {
    return XkbIntTo2Chars(x, a.*.high_XXX, a.*.low_XXX);
}
pub inline fn XkbSetPtrActionY(a: anytype, y: anytype) @TypeOf(XkbIntTo2Chars(y, a.*.high_YYY, a.*.low_YYY)) {
    return XkbIntTo2Chars(y, a.*.high_YYY, a.*.low_YYY);
}
pub inline fn XkbSAPtrDfltValue(a: anytype) @TypeOf(XkbCharToInt(a.*.valueXXX)) {
    return XkbCharToInt(a.*.valueXXX);
}
pub inline fn XkbSAScreen(a: anytype) @TypeOf(XkbCharToInt(a.*.screenXXX)) {
    return XkbCharToInt(a.*.screenXXX);
}
pub inline fn XkbActionCtrls(a: anytype) @TypeOf((((@import("std").zig.c_translation.cast(c_uint, a.*.ctrls3) << @as(c_int, 24)) | (@import("std").zig.c_translation.cast(c_uint, a.*.ctrls2) << @as(c_int, 16))) | (@import("std").zig.c_translation.cast(c_uint, a.*.ctrls1) << @as(c_int, 8))) | @import("std").zig.c_translation.cast(c_uint, a.*.ctrls0)) {
    return (((@import("std").zig.c_translation.cast(c_uint, a.*.ctrls3) << @as(c_int, 24)) | (@import("std").zig.c_translation.cast(c_uint, a.*.ctrls2) << @as(c_int, 16))) | (@import("std").zig.c_translation.cast(c_uint, a.*.ctrls1) << @as(c_int, 8))) | @import("std").zig.c_translation.cast(c_uint, a.*.ctrls0);
}
pub inline fn XkbSARedirectVMods(a: anytype) @TypeOf((@import("std").zig.c_translation.cast(c_uint, a.*.vmods1) << @as(c_int, 8)) | @import("std").zig.c_translation.cast(c_uint, a.*.vmods0)) {
    return (@import("std").zig.c_translation.cast(c_uint, a.*.vmods1) << @as(c_int, 8)) | @import("std").zig.c_translation.cast(c_uint, a.*.vmods0);
}
pub inline fn XkbSARedirectVModsMask(a: anytype) @TypeOf((@import("std").zig.c_translation.cast(c_uint, a.*.vmods_mask1) << @as(c_int, 8)) | @import("std").zig.c_translation.cast(c_uint, a.*.vmods_mask0)) {
    return (@import("std").zig.c_translation.cast(c_uint, a.*.vmods_mask1) << @as(c_int, 8)) | @import("std").zig.c_translation.cast(c_uint, a.*.vmods_mask0);
}
pub inline fn XkbAX_AnyFeedback(c: anytype) @TypeOf(c.*.enabled_ctrls & XkbAccessXFeedbackMask) {
    return c.*.enabled_ctrls & XkbAccessXFeedbackMask;
}
pub inline fn XkbAX_NeedOption(c: anytype, w: anytype) @TypeOf(c.*.ax_options & w) {
    return c.*.ax_options & w;
}
pub inline fn XkbAX_NeedFeedback(c: anytype, w: anytype) @TypeOf((XkbAX_AnyFeedback(c) != 0) and (XkbAX_NeedOption(c, w) != 0)) {
    return (XkbAX_AnyFeedback(c) != 0) and (XkbAX_NeedOption(c, w) != 0);
}
pub inline fn XkbSMKeyActionsPtr(m: anytype, k: anytype) @TypeOf(&m.*.acts[m.*.key_acts[k]]) {
    return &m.*.acts[m.*.key_acts[k]];
}
pub inline fn XkbCMKeyGroupInfo(m: anytype, k: anytype) @TypeOf(m.*.key_sym_map[k].group_info) {
    return m.*.key_sym_map[k].group_info;
}
pub inline fn XkbCMKeyNumGroups(m: anytype, k: anytype) @TypeOf(XkbNumGroups(m.*.key_sym_map[k].group_info)) {
    return XkbNumGroups(m.*.key_sym_map[k].group_info);
}
pub inline fn XkbCMKeyGroupWidth(m: anytype, k: anytype, g: anytype) @TypeOf(XkbCMKeyType(m, k, g).*.num_levels) {
    return XkbCMKeyType(m, k, g).*.num_levels;
}
pub inline fn XkbCMKeyGroupsWidth(m: anytype, k: anytype) @TypeOf(m.*.key_sym_map[k].width) {
    return m.*.key_sym_map[k].width;
}
pub inline fn XkbCMKeyTypeIndex(m: anytype, k: anytype, g: anytype) @TypeOf(m.*.key_sym_map[k].kt_index[g & @as(c_int, 0x3)]) {
    return m.*.key_sym_map[k].kt_index[g & @as(c_int, 0x3)];
}
pub inline fn XkbCMKeyType(m: anytype, k: anytype, g: anytype) @TypeOf(&m.*.types[XkbCMKeyTypeIndex(m, k, g)]) {
    return &m.*.types[XkbCMKeyTypeIndex(m, k, g)];
}
pub inline fn XkbCMKeyNumSyms(m: anytype, k: anytype) @TypeOf(XkbCMKeyGroupsWidth(m, k) * XkbCMKeyNumGroups(m, k)) {
    return XkbCMKeyGroupsWidth(m, k) * XkbCMKeyNumGroups(m, k);
}
pub inline fn XkbCMKeySymsOffset(m: anytype, k: anytype) @TypeOf(m.*.key_sym_map[k].offset) {
    return m.*.key_sym_map[k].offset;
}
pub inline fn XkbCMKeySymsPtr(m: anytype, k: anytype) @TypeOf(&m.*.syms[XkbCMKeySymsOffset(m, k)]) {
    return &m.*.syms[XkbCMKeySymsOffset(m, k)];
}
pub inline fn XkbIM_IsAuto(i: anytype) @TypeOf(((i.*.flags & XkbIM_NoAutomatic) == @as(c_int, 0)) and ((((i.*.which_groups != 0) and (i.*.groups != 0)) or ((i.*.which_mods != 0) and (i.*.mods.mask != 0))) or (i.*.ctrls != 0))) {
    return ((i.*.flags & XkbIM_NoAutomatic) == @as(c_int, 0)) and ((((i.*.which_groups != 0) and (i.*.groups != 0)) or ((i.*.which_mods != 0) and (i.*.mods.mask != 0))) or (i.*.ctrls != 0));
}
pub inline fn XkbIM_InUse(i: anytype) @TypeOf((((i.*.flags != 0) or (i.*.which_groups != 0)) or (i.*.which_mods != 0)) or (i.*.ctrls != 0)) {
    return (((i.*.flags != 0) or (i.*.which_groups != 0)) or (i.*.which_mods != 0)) or (i.*.ctrls != 0);
}
pub inline fn XkbKeyKeyTypeIndex(d: anytype, k: anytype, g: anytype) @TypeOf(XkbCMKeyTypeIndex(d.*.map, k, g)) {
    return XkbCMKeyTypeIndex(d.*.map, k, g);
}
pub inline fn XkbKeyKeyType(d: anytype, k: anytype, g: anytype) @TypeOf(XkbCMKeyType(d.*.map, k, g)) {
    return XkbCMKeyType(d.*.map, k, g);
}
pub inline fn XkbKeyGroupWidth(d: anytype, k: anytype, g: anytype) @TypeOf(XkbCMKeyGroupWidth(d.*.map, k, g)) {
    return XkbCMKeyGroupWidth(d.*.map, k, g);
}
pub inline fn XkbKeyGroupsWidth(d: anytype, k: anytype) @TypeOf(XkbCMKeyGroupsWidth(d.*.map, k)) {
    return XkbCMKeyGroupsWidth(d.*.map, k);
}
pub inline fn XkbKeyGroupInfo(d: anytype, k: anytype) @TypeOf(XkbCMKeyGroupInfo(d.*.map, k)) {
    return XkbCMKeyGroupInfo(d.*.map, k);
}
pub inline fn XkbKeyNumGroups(d: anytype, k: anytype) @TypeOf(XkbCMKeyNumGroups(d.*.map, k)) {
    return XkbCMKeyNumGroups(d.*.map, k);
}
pub inline fn XkbKeyNumSyms(d: anytype, k: anytype) @TypeOf(XkbCMKeyNumSyms(d.*.map, k)) {
    return XkbCMKeyNumSyms(d.*.map, k);
}
pub inline fn XkbKeySymsPtr(d: anytype, k: anytype) @TypeOf(XkbCMKeySymsPtr(d.*.map, k)) {
    return XkbCMKeySymsPtr(d.*.map, k);
}
pub inline fn XkbKeySym(d: anytype, k: anytype, n: anytype) @TypeOf(XkbKeySymsPtr(d, k)[n]) {
    return XkbKeySymsPtr(d, k)[n];
}
pub inline fn XkbKeySymEntry(d: anytype, k: anytype, sl: anytype, g: anytype) @TypeOf(XkbKeySym(d, k, (XkbKeyGroupsWidth(d, k) * g) + sl)) {
    return XkbKeySym(d, k, (XkbKeyGroupsWidth(d, k) * g) + sl);
}
pub inline fn XkbKeyAction(d: anytype, k: anytype, n: anytype) @TypeOf(if (XkbKeyHasActions(d, k)) &XkbKeyActionsPtr(d, k)[n] else NULL) {
    return if (XkbKeyHasActions(d, k)) &XkbKeyActionsPtr(d, k)[n] else NULL;
}
pub inline fn XkbKeyActionEntry(d: anytype, k: anytype, sl: anytype, g: anytype) @TypeOf(if (XkbKeyHasActions(d, k)) XkbKeyAction(d, k, (XkbKeyGroupsWidth(d, k) * g) + sl) else NULL) {
    return if (XkbKeyHasActions(d, k)) XkbKeyAction(d, k, (XkbKeyGroupsWidth(d, k) * g) + sl) else NULL;
}
pub inline fn XkbKeyHasActions(d: anytype, k: anytype) @TypeOf(d.*.server.*.key_acts[k] != @as(c_int, 0)) {
    return d.*.server.*.key_acts[k] != @as(c_int, 0);
}
pub inline fn XkbKeyNumActions(d: anytype, k: anytype) @TypeOf(if (XkbKeyHasActions(d, k)) XkbKeyNumSyms(d, k) else @as(c_int, 1)) {
    return if (XkbKeyHasActions(d, k)) XkbKeyNumSyms(d, k) else @as(c_int, 1);
}
pub inline fn XkbKeyActionsPtr(d: anytype, k: anytype) @TypeOf(XkbSMKeyActionsPtr(d.*.server, k)) {
    return XkbSMKeyActionsPtr(d.*.server, k);
}
pub inline fn XkbKeycodeInRange(d: anytype, k: anytype) @TypeOf((k >= d.*.min_key_code) and (k <= d.*.max_key_code)) {
    return (k >= d.*.min_key_code) and (k <= d.*.max_key_code);
}
pub inline fn XkbNumKeys(d: anytype) @TypeOf((d.*.max_key_code - d.*.min_key_code) + @as(c_int, 1)) {
    return (d.*.max_key_code - d.*.min_key_code) + @as(c_int, 1);
}
pub inline fn XkbXI_DevHasBtnActs(d: anytype) @TypeOf((d.*.num_btns > @as(c_int, 0)) and (d.*.btn_acts != NULL)) {
    return (d.*.num_btns > @as(c_int, 0)) and (d.*.btn_acts != NULL);
}
pub inline fn XkbXI_LegalDevBtn(d: anytype, b: anytype) @TypeOf((XkbXI_DevHasBtnActs(d) != 0) and (b < d.*.num_btns)) {
    return (XkbXI_DevHasBtnActs(d) != 0) and (b < d.*.num_btns);
}
pub inline fn XkbXI_DevHasLeds(d: anytype) @TypeOf((d.*.num_leds > @as(c_int, 0)) and (d.*.leds != NULL)) {
    return (d.*.num_leds > @as(c_int, 0)) and (d.*.leds != NULL);
}
pub const XkbOD_Success = @as(c_int, 0);
pub const XkbOD_BadLibraryVersion = @as(c_int, 1);
pub const XkbOD_ConnectionRefused = @as(c_int, 2);
pub const XkbOD_NonXkbServer = @as(c_int, 3);
pub const XkbOD_BadServerVersion = @as(c_int, 4);
pub const XkbLC_ForceLatin1Lookup = @as(c_int, 1) << @as(c_int, 0);
pub const XkbLC_ConsumeLookupMods = @as(c_int, 1) << @as(c_int, 1);
pub const XkbLC_AlwaysConsumeShiftAndLock = @as(c_int, 1) << @as(c_int, 2);
pub const XkbLC_IgnoreNewKeyboards = @as(c_int, 1) << @as(c_int, 3);
pub const XkbLC_ControlFallback = @as(c_int, 1) << @as(c_int, 4);
pub const XkbLC_ConsumeKeysOnComposeFail = @as(c_int, 1) << @as(c_int, 29);
pub const XkbLC_ComposeLED = @as(c_int, 1) << @as(c_int, 30);
pub const XkbLC_BeepOnComposeFail = @as(c_int, 1) << @as(c_int, 31);
pub const XkbLC_AllComposeControls = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0xc0000000, .hexadecimal);
pub const XkbLC_AllControls = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0xc000001f, .hexadecimal);
pub inline fn XkbGetIndicatorMapChanges(d: anytype, x: anytype, c: anytype) @TypeOf(XkbGetIndicatorMap(d, c.*.map_changes, x)) {
    return XkbGetIndicatorMap(d, c.*.map_changes, x);
}
pub inline fn XkbChangeIndicatorMaps(d: anytype, x: anytype, c: anytype) @TypeOf(XkbSetIndicatorMap(d, c.*.map_changes, x)) {
    return XkbSetIndicatorMap(d, c.*.map_changes, x);
}
pub inline fn XkbGetControlsChanges(d: anytype, x: anytype, c: anytype) @TypeOf(XkbGetControls(d, c.*.changed_ctrls, x)) {
    return XkbGetControls(d, c.*.changed_ctrls, x);
}
pub inline fn XkbChangeControls(d: anytype, x: anytype, c: anytype) @TypeOf(XkbSetControls(d, c.*.changed_ctrls, x)) {
    return XkbSetControls(d, c.*.changed_ctrls, x);
}
pub const _XExtData = struct__XExtData;
pub const _XGC = struct__XGC;
pub const _XDisplay = struct__XDisplay;
pub const funcs = struct_funcs;
pub const _XImage = struct__XImage;
pub const _XPrivate = struct__XPrivate;
pub const _XrmHashBucketRec = struct__XrmHashBucketRec;
pub const _XEvent = union__XEvent;
pub const _XOM = struct__XOM;
pub const _XOC = struct__XOC;
pub const _XIM = struct__XIM;
pub const _XIC = struct__XIC;
pub const _XIMText = struct__XIMText;
pub const _XIMPreeditStateNotifyCallbackStruct = struct__XIMPreeditStateNotifyCallbackStruct;
pub const _XIMStringConversionText = struct__XIMStringConversionText;
pub const _XIMStringConversionCallbackStruct = struct__XIMStringConversionCallbackStruct;
pub const _XIMPreeditDrawCallbackStruct = struct__XIMPreeditDrawCallbackStruct;
pub const _XIMPreeditCaretCallbackStruct = struct__XIMPreeditCaretCallbackStruct;
pub const _XIMStatusDrawCallbackStruct = struct__XIMStatusDrawCallbackStruct;
pub const _XIMHotKeyTrigger = struct__XIMHotKeyTrigger;
pub const _XIMHotKeyTriggers = struct__XIMHotKeyTriggers;
pub const _XkbStateRec = struct__XkbStateRec;
pub const _XkbMods = struct__XkbMods;
pub const _XkbKTMapEntry = struct__XkbKTMapEntry;
pub const _XkbKeyType = struct__XkbKeyType;
pub const _XkbBehavior = struct__XkbBehavior;
pub const _XkbAnyAction = struct__XkbAnyAction;
pub const _XkbModAction = struct__XkbModAction;
pub const _XkbGroupAction = struct__XkbGroupAction;
pub const _XkbISOAction = struct__XkbISOAction;
pub const _XkbPtrAction = struct__XkbPtrAction;
pub const _XkbPtrBtnAction = struct__XkbPtrBtnAction;
pub const _XkbPtrDfltAction = struct__XkbPtrDfltAction;
pub const _XkbSwitchScreenAction = struct__XkbSwitchScreenAction;
pub const _XkbCtrlsAction = struct__XkbCtrlsAction;
pub const _XkbMessageAction = struct__XkbMessageAction;
pub const _XkbRedirectKeyAction = struct__XkbRedirectKeyAction;
pub const _XkbDeviceBtnAction = struct__XkbDeviceBtnAction;
pub const _XkbDeviceValuatorAction = struct__XkbDeviceValuatorAction;
pub const _XkbAction = union__XkbAction;
pub const _XkbControls = struct__XkbControls;
pub const _XkbServerMapRec = struct__XkbServerMapRec;
pub const _XkbSymMapRec = struct__XkbSymMapRec;
pub const _XkbClientMapRec = struct__XkbClientMapRec;
pub const _XkbSymInterpretRec = struct__XkbSymInterpretRec;
pub const _XkbCompatMapRec = struct__XkbCompatMapRec;
pub const _XkbIndicatorMapRec = struct__XkbIndicatorMapRec;
pub const _XkbIndicatorRec = struct__XkbIndicatorRec;
pub const _XkbKeyNameRec = struct__XkbKeyNameRec;
pub const _XkbKeyAliasRec = struct__XkbKeyAliasRec;
pub const _XkbNamesRec = struct__XkbNamesRec;
pub const _XkbGeometry = struct__XkbGeometry;
pub const _XkbDesc = struct__XkbDesc;
pub const _XkbMapChanges = struct__XkbMapChanges;
pub const _XkbControlsChanges = struct__XkbControlsChanges;
pub const _XkbIndicatorChanges = struct__XkbIndicatorChanges;
pub const _XkbNameChanges = struct__XkbNameChanges;
pub const _XkbCompatChanges = struct__XkbCompatChanges;
pub const _XkbChanges = struct__XkbChanges;
pub const _XkbComponentNames = struct__XkbComponentNames;
pub const _XkbComponentName = struct__XkbComponentName;
pub const _XkbComponentList = struct__XkbComponentList;
pub const _XkbDeviceLedInfo = struct__XkbDeviceLedInfo;
pub const _XkbDeviceInfo = struct__XkbDeviceInfo;
pub const _XkbDeviceLedChanges = struct__XkbDeviceLedChanges;
pub const _XkbDeviceChanges = struct__XkbDeviceChanges;
pub const _XkbAnyEvent = struct__XkbAnyEvent;
pub const _XkbNewKeyboardNotify = struct__XkbNewKeyboardNotify;
pub const _XkbMapNotifyEvent = struct__XkbMapNotifyEvent;
pub const _XkbStateNotifyEvent = struct__XkbStateNotifyEvent;
pub const _XkbControlsNotify = struct__XkbControlsNotify;
pub const _XkbIndicatorNotify = struct__XkbIndicatorNotify;
pub const _XkbNamesNotify = struct__XkbNamesNotify;
pub const _XkbCompatMapNotify = struct__XkbCompatMapNotify;
pub const _XkbBellNotify = struct__XkbBellNotify;
pub const _XkbActionMessage = struct__XkbActionMessage;
pub const _XkbAccessXNotify = struct__XkbAccessXNotify;
pub const _XkbExtensionDeviceNotify = struct__XkbExtensionDeviceNotify;
pub const _XkbEvent = union__XkbEvent;
pub const _XkbKbdDpyState = struct__XkbKbdDpyState;
