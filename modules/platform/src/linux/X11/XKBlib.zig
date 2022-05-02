const NULL = @import("std").zig.c_translation.cast(?*anyopaque, @as(c_int, 0));
pub const wchar_t = c_int;

const xlib = @import("Xlib.zig");

const keys = @import("keysym.zig");
pub usingnamespace keys;

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
    name: xlib.Atom,
    level_names: [*c]xlib.Atom,
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
    syms: [*c]xlib.KeySym,
    key_sym_map: XkbSymMapPtr,
    modmap: [*c]u8,
};
pub const XkbClientMapRec = struct__XkbClientMapRec;
pub const XkbClientMapPtr = [*c]struct__XkbClientMapRec;
pub const struct__XkbSymInterpretRec = extern struct {
    sym: xlib.KeySym,
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
    keycodes: xlib.Atom,
    geometry: xlib.Atom,
    symbols: xlib.Atom,
    types: xlib.Atom,
    compat: xlib.Atom,
    vmods: [16]xlib.Atom,
    indicators: [32]xlib.Atom,
    groups: [4]xlib.Atom,
    keys: XkbKeyNamePtr,
    key_aliases: XkbKeyAliasPtr,
    radio_groups: [*c]xlib.Atom,
    phys_symbols: xlib.Atom,
    num_keys: u8,
    num_key_aliases: u8,
    num_rg: c_ushort,
};
pub const XkbNamesRec = struct__XkbNamesRec;
pub const XkbNamesPtr = [*c]struct__XkbNamesRec;
pub const struct__XkbGeometry = opaque {};
pub const XkbGeometryPtr = ?*struct__XkbGeometry;
pub const struct__XkbDesc = extern struct {
    dpy: ?*xlib.Display,
    flags: c_ushort,
    device_spec: c_ushort,
    min_key_code: xlib.KeyCode,
    max_key_code: xlib.KeyCode,
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
    min_key_code: xlib.KeyCode,
    max_key_code: xlib.KeyCode,
    first_type: u8,
    num_types: u8,
    first_key_sym: xlib.KeyCode,
    num_key_syms: u8,
    first_key_act: xlib.KeyCode,
    num_key_acts: u8,
    first_key_behavior: xlib.KeyCode,
    num_key_behaviors: u8,
    first_key_explicit: xlib.KeyCode,
    num_key_explicit: u8,
    first_modmap_key: xlib.KeyCode,
    num_modmap_keys: u8,
    first_vmodmap_key: xlib.KeyCode,
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
    names: [32]xlib.Atom,
    maps: [32]XkbIndicatorMapRec,
};
pub const XkbDeviceLedInfoRec = struct__XkbDeviceLedInfo;
pub const XkbDeviceLedInfoPtr = [*c]struct__XkbDeviceLedInfo;
pub const struct__XkbDeviceInfo = extern struct {
    name: [*c]u8,
    type: xlib.Atom,
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
    display: ?*xlib.Display,
    time: xlib.Time,
    xkb_type: c_int,
    device: c_uint,
};
pub const XkbAnyEvent = struct__XkbAnyEvent;
pub const struct__XkbNewKeyboardNotify = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*xlib.Display,
    time: xlib.Time,
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
    display: ?*xlib.Display,
    time: xlib.Time,
    xkb_type: c_int,
    device: c_int,
    changed: c_uint,
    flags: c_uint,
    first_type: c_int,
    num_types: c_int,
    min_key_code: xlib.KeyCode,
    max_key_code: xlib.KeyCode,
    first_key_sym: xlib.KeyCode,
    first_key_act: xlib.KeyCode,
    first_key_behavior: xlib.KeyCode,
    first_key_explicit: xlib.KeyCode,
    first_modmap_key: xlib.KeyCode,
    first_vmodmap_key: xlib.KeyCode,
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
    display: ?*xlib.Display,
    time: xlib.Time,
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
    keycode: xlib.KeyCode,
    event_type: u8,
    req_major: u8,
    req_minor: u8,
};
pub const XkbStateNotifyEvent = struct__XkbStateNotifyEvent;
pub const struct__XkbControlsNotify = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*xlib.Display,
    time: xlib.Time,
    xkb_type: c_int,
    device: c_int,
    changed_ctrls: c_uint,
    enabled_ctrls: c_uint,
    enabled_ctrl_changes: c_uint,
    num_groups: c_int,
    keycode: xlib.KeyCode,
    event_type: u8,
    req_major: u8,
    req_minor: u8,
};
pub const XkbControlsNotifyEvent = struct__XkbControlsNotify;
pub const struct__XkbIndicatorNotify = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*xlib.Display,
    time: xlib.Time,
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
    display: ?*xlib.Display,
    time: xlib.Time,
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
    display: ?*xlib.Display,
    time: xlib.Time,
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
    display: ?*xlib.Display,
    time: xlib.Time,
    xkb_type: c_int,
    device: c_int,
    percent: c_int,
    pitch: c_int,
    duration: c_int,
    bell_class: c_int,
    bell_id: c_int,
    name: xlib.Atom,
    window: xlib.Window,
    event_only: c_int,
};
pub const XkbBellNotifyEvent = struct__XkbBellNotify;
pub const struct__XkbActionMessage = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*xlib.Display,
    time: xlib.Time,
    xkb_type: c_int,
    device: c_int,
    keycode: xlib.KeyCode,
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
    display: ?*xlib.Display,
    time: xlib.Time,
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
    display: ?*xlib.Display,
    time: xlib.Time,
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
    core: xlib.XEvent,
};
pub const XkbEvent = union__XkbEvent;
pub const struct__XkbKbdDpyState = opaque {};
pub const XkbKbdDpyStateRec = struct__XkbKbdDpyState;
pub const XkbKbdDpyStatePtr = ?*struct__XkbKbdDpyState;
pub extern fn XkbIgnoreExtension(c_int) c_int;
pub extern fn XkbOpenDisplay([*c]const u8, [*c]c_int, [*c]c_int, [*c]c_int, [*c]c_int, [*c]c_int) ?*xlib.Display;
pub extern fn XkbQueryExtension(?*xlib.Display, [*c]c_int, [*c]c_int, [*c]c_int, [*c]c_int, [*c]c_int) c_int;
pub extern fn XkbUseExtension(?*xlib.Display, [*c]c_int, [*c]c_int) c_int;
pub extern fn XkbLibraryVersion([*c]c_int, [*c]c_int) c_int;
pub extern fn XkbSetXlibControls(?*xlib.Display, c_uint, c_uint) c_uint;
pub extern fn XkbGetXlibControls(?*xlib.Display) c_uint;
pub extern fn XkbXlibControlsImplemented() c_uint;
pub const XkbInternAtomFunc = ?fn (?*xlib.Display, [*c]const u8, c_int) callconv(.C) xlib.Atom;
pub const XkbGetAtomNameFunc = ?fn (?*xlib.Display, xlib.Atom) callconv(.C) [*c]u8;
pub extern fn XkbSetAtomFuncs(XkbInternAtomFunc, XkbGetAtomNameFunc) void;
pub extern fn XkbKeycodeToKeysym(?*xlib.Display, xlib.KeyCode, c_int, c_int) xlib.KeySym;
pub extern fn XkbKeysymToModifiers(?*xlib.Display, xlib.KeySym) c_uint;
pub extern fn XkbLookupKeySym(?*xlib.Display, xlib.KeyCode, c_uint, [*c]c_uint, [*c]xlib.KeySym) c_int;
pub extern fn XkbLookupKeyBinding(?*xlib.Display, xlib.KeySym, c_uint, [*c]u8, c_int, [*c]c_int) c_int;
pub extern fn XkbTranslateKeyCode(XkbDescPtr, xlib.KeyCode, c_uint, [*c]c_uint, [*c]xlib.KeySym) c_int;
pub extern fn XkbTranslateKeySym(?*xlib.Display, [*c]xlib.KeySym, c_uint, [*c]u8, c_int, [*c]c_int) c_int;
pub extern fn XkbSetAutoRepeatRate(?*xlib.Display, c_uint, c_uint, c_uint) c_int;
pub extern fn XkbGetAutoRepeatRate(?*xlib.Display, c_uint, [*c]c_uint, [*c]c_uint) c_int;
pub extern fn XkbChangeEnabledControls(?*xlib.Display, c_uint, c_uint, c_uint) c_int;
pub extern fn XkbDeviceBell(?*xlib.Display, xlib.Window, c_int, c_int, c_int, c_int, xlib.Atom) c_int;
pub extern fn XkbForceDeviceBell(?*xlib.Display, c_int, c_int, c_int, c_int) c_int;
pub extern fn XkbDeviceBellEvent(?*xlib.Display, xlib.Window, c_int, c_int, c_int, c_int, xlib.Atom) c_int;
pub extern fn XkbBell(?*xlib.Display, xlib.Window, c_int, xlib.Atom) c_int;
pub extern fn XkbForceBell(?*xlib.Display, c_int) c_int;
pub extern fn XkbBellEvent(?*xlib.Display, xlib.Window, c_int, xlib.Atom) c_int;
pub extern fn XkbSelectEvents(?*xlib.Display, c_uint, c_uint, c_uint) c_int;
pub extern fn XkbSelectEventDetails(?*xlib.Display, c_uint, c_uint, c_ulong, c_ulong) c_int;
pub extern fn XkbNoteMapChanges(XkbMapChangesPtr, [*c]XkbMapNotifyEvent, c_uint) void;
pub extern fn XkbNoteNameChanges(XkbNameChangesPtr, [*c]XkbNamesNotifyEvent, c_uint) void;
pub extern fn XkbGetIndicatorState(?*xlib.Display, c_uint, [*c]c_uint) c_int;
pub extern fn XkbGetDeviceIndicatorState(?*xlib.Display, c_uint, c_uint, c_uint, [*c]c_uint) c_int;
pub extern fn XkbGetIndicatorMap(?*xlib.Display, c_ulong, XkbDescPtr) c_int;
pub extern fn XkbSetIndicatorMap(?*xlib.Display, c_ulong, XkbDescPtr) c_int;
pub extern fn XkbGetNamedIndicator(?*xlib.Display, xlib.Atom, [*c]c_int, [*c]c_int, XkbIndicatorMapPtr, [*c]c_int) c_int;
pub extern fn XkbGetNamedDeviceIndicator(?*xlib.Display, c_uint, c_uint, c_uint, xlib.Atom, [*c]c_int, [*c]c_int, XkbIndicatorMapPtr, [*c]c_int) c_int;
pub extern fn XkbSetNamedIndicator(?*xlib.Display, xlib.Atom, c_int, c_int, c_int, XkbIndicatorMapPtr) c_int;
pub extern fn XkbSetNamedDeviceIndicator(?*xlib.Display, c_uint, c_uint, c_uint, xlib.Atom, c_int, c_int, c_int, XkbIndicatorMapPtr) c_int;
pub extern fn XkbLockModifiers(?*xlib.Display, c_uint, c_uint, c_uint) c_int;
pub extern fn XkbLatchModifiers(?*xlib.Display, c_uint, c_uint, c_uint) c_int;
pub extern fn XkbLockGroup(?*xlib.Display, c_uint, c_uint) c_int;
pub extern fn XkbLatchGroup(?*xlib.Display, c_uint, c_uint) c_int;
pub extern fn XkbSetServerInternalMods(?*xlib.Display, c_uint, c_uint, c_uint, c_uint, c_uint) c_int;
pub extern fn XkbSetIgnoreLockMods(?*xlib.Display, c_uint, c_uint, c_uint, c_uint, c_uint) c_int;
pub extern fn XkbVirtualModsToReal(XkbDescPtr, c_uint, [*c]c_uint) c_int;
pub extern fn XkbComputeEffectiveMap(XkbDescPtr, XkbKeyTypePtr, [*c]u8) c_int;
pub extern fn XkbInitCanonicalKeyTypes(XkbDescPtr, c_uint, c_int) c_int;
pub extern fn XkbAllocKeyboard() XkbDescPtr;
pub extern fn XkbFreeKeyboard(XkbDescPtr, c_uint, c_int) void;
pub extern fn XkbAllocClientMap(XkbDescPtr, c_uint, c_uint) c_int;
pub extern fn XkbAllocServerMap(XkbDescPtr, c_uint, c_uint) c_int;
pub extern fn XkbFreeClientMap(XkbDescPtr, c_uint, c_int) void;
pub extern fn XkbFreeServerMap(XkbDescPtr, c_uint, c_int) void;
pub extern fn XkbAddKeyType(XkbDescPtr, xlib.Atom, c_int, c_int, c_int) XkbKeyTypePtr;
pub extern fn XkbAllocIndicatorMaps(XkbDescPtr) c_int;
pub extern fn XkbFreeIndicatorMaps(XkbDescPtr) void;
pub extern fn XkbGetMap(?*xlib.Display, c_uint, c_uint) XkbDescPtr;
pub extern fn XkbGetUpdatedMap(?*xlib.Display, c_uint, XkbDescPtr) c_int;
pub extern fn XkbGetMapChanges(?*xlib.Display, XkbDescPtr, XkbMapChangesPtr) c_int;
pub extern fn XkbRefreshKeyboardMapping([*c]XkbMapNotifyEvent) c_int;
pub extern fn XkbGetKeyTypes(?*xlib.Display, c_uint, c_uint, XkbDescPtr) c_int;
pub extern fn XkbGetKeySyms(?*xlib.Display, c_uint, c_uint, XkbDescPtr) c_int;
pub extern fn XkbGetKeyActions(?*xlib.Display, c_uint, c_uint, XkbDescPtr) c_int;
pub extern fn XkbGetKeyBehaviors(?*xlib.Display, c_uint, c_uint, XkbDescPtr) c_int;
pub extern fn XkbGetVirtualMods(?*xlib.Display, c_uint, XkbDescPtr) c_int;
pub extern fn XkbGetKeyExplicitComponents(?*xlib.Display, c_uint, c_uint, XkbDescPtr) c_int;
pub extern fn XkbGetKeyModifierMap(?*xlib.Display, c_uint, c_uint, XkbDescPtr) c_int;
pub extern fn XkbGetKeyVirtualModMap(?*xlib.Display, c_uint, c_uint, XkbDescPtr) c_int;
pub extern fn XkbAllocControls(XkbDescPtr, c_uint) c_int;
pub extern fn XkbFreeControls(XkbDescPtr, c_uint, c_int) void;
pub extern fn XkbGetControls(?*xlib.Display, c_ulong, XkbDescPtr) c_int;
pub extern fn XkbSetControls(?*xlib.Display, c_ulong, XkbDescPtr) c_int;
pub extern fn XkbNoteControlsChanges(XkbControlsChangesPtr, [*c]XkbControlsNotifyEvent, c_uint) void;
pub extern fn XkbAllocCompatMap(XkbDescPtr, c_uint, c_uint) c_int;
pub extern fn XkbFreeCompatMap(XkbDescPtr, c_uint, c_int) void;
pub extern fn XkbGetCompatMap(?*xlib.Display, c_uint, XkbDescPtr) c_int;
pub extern fn XkbSetCompatMap(?*xlib.Display, c_uint, XkbDescPtr, c_int) c_int;
pub extern fn XkbAddSymInterpret(XkbDescPtr, XkbSymInterpretPtr, c_int, XkbChangesPtr) XkbSymInterpretPtr;
pub extern fn XkbAllocNames(XkbDescPtr, c_uint, c_int, c_int) c_int;
pub extern fn XkbGetNames(?*xlib.Display, c_uint, XkbDescPtr) c_int;
pub extern fn XkbSetNames(?*xlib.Display, c_uint, c_uint, c_uint, XkbDescPtr) c_int;
pub extern fn XkbChangeNames(?*xlib.Display, XkbDescPtr, XkbNameChangesPtr) c_int;
pub extern fn XkbFreeNames(XkbDescPtr, c_uint, c_int) void;
pub extern fn XkbGetState(?*xlib.Display, c_uint, XkbStatePtr) c_int;
pub extern fn XkbSetMap(?*xlib.Display, c_uint, XkbDescPtr) c_int;
pub extern fn XkbChangeMap(?*xlib.Display, XkbDescPtr, XkbMapChangesPtr) c_int;
pub extern fn XkbSetDetectableAutoRepeat(?*xlib.Display, c_int, [*c]c_int) c_int;
pub extern fn XkbGetDetectableAutoRepeat(?*xlib.Display, [*c]c_int) c_int;
pub extern fn XkbSetAutoResetControls(?*xlib.Display, c_uint, [*c]c_uint, [*c]c_uint) c_int;
pub extern fn XkbGetAutoResetControls(?*xlib.Display, [*c]c_uint, [*c]c_uint) c_int;
pub extern fn XkbSetPerClientControls(?*xlib.Display, c_uint, [*c]c_uint) c_int;
pub extern fn XkbGetPerClientControls(?*xlib.Display, [*c]c_uint) c_int;
pub extern fn XkbCopyKeyType(XkbKeyTypePtr, XkbKeyTypePtr) c_int;
pub extern fn XkbCopyKeyTypes(XkbKeyTypePtr, XkbKeyTypePtr, c_int) c_int;
pub extern fn XkbResizeKeyType(XkbDescPtr, c_int, c_int, c_int, c_int) c_int;
pub extern fn XkbResizeKeySyms(XkbDescPtr, c_int, c_int) [*c]xlib.KeySym;
pub extern fn XkbResizeKeyActions(XkbDescPtr, c_int, c_int) [*c]XkbAction;
pub extern fn XkbChangeTypesOfKey(XkbDescPtr, c_int, c_int, c_uint, [*c]c_int, XkbMapChangesPtr) c_int;
pub extern fn XkbChangeKeycodeRange(XkbDescPtr, c_int, c_int, XkbChangesPtr) c_int;
pub extern fn XkbListComponents(?*xlib.Display, c_uint, XkbComponentNamesPtr, [*c]c_int) XkbComponentListPtr;
pub extern fn XkbFreeComponentList(XkbComponentListPtr) void;
pub extern fn XkbGetKeyboard(?*xlib.Display, c_uint, c_uint) XkbDescPtr;
pub extern fn XkbGetKeyboardByName(?*xlib.Display, c_uint, XkbComponentNamesPtr, c_uint, c_uint, c_int) XkbDescPtr;
pub extern fn XkbKeyTypesForCoreSymbols(XkbDescPtr, c_int, [*c]xlib.KeySym, c_uint, [*c]c_int, [*c]xlib.KeySym) c_int;
pub extern fn XkbApplyCompatMapToKey(XkbDescPtr, xlib.KeyCode, XkbChangesPtr) c_int;
pub extern fn XkbUpdateMapFromCore(XkbDescPtr, xlib.KeyCode, c_int, c_int, [*c]xlib.KeySym, XkbChangesPtr) c_int;
pub extern fn XkbAddDeviceLedInfo(XkbDeviceInfoPtr, c_uint, c_uint) XkbDeviceLedInfoPtr;
pub extern fn XkbResizeDeviceButtonActions(XkbDeviceInfoPtr, c_uint) c_int;
pub extern fn XkbAllocDeviceInfo(c_uint, c_uint, c_uint) XkbDeviceInfoPtr;
pub extern fn XkbFreeDeviceInfo(XkbDeviceInfoPtr, c_uint, c_int) void;
pub extern fn XkbNoteDeviceChanges(XkbDeviceChangesPtr, [*c]XkbExtensionDeviceNotifyEvent, c_uint) void;
pub extern fn XkbGetDeviceInfo(?*xlib.Display, c_uint, c_uint, c_uint, c_uint) XkbDeviceInfoPtr;
pub extern fn XkbGetDeviceInfoChanges(?*xlib.Display, XkbDeviceInfoPtr, XkbDeviceChangesPtr) c_int;
pub extern fn XkbGetDeviceButtonActions(?*xlib.Display, XkbDeviceInfoPtr, c_int, c_uint, c_uint) c_int;
pub extern fn XkbGetDeviceLedInfo(?*xlib.Display, XkbDeviceInfoPtr, c_uint, c_uint, c_uint) c_int;
pub extern fn XkbSetDeviceInfo(?*xlib.Display, c_uint, XkbDeviceInfoPtr) c_int;
pub extern fn XkbChangeDeviceInfo(?*xlib.Display, XkbDeviceInfoPtr, XkbDeviceChangesPtr) c_int;
pub extern fn XkbSetDeviceLedInfo(?*xlib.Display, XkbDeviceInfoPtr, c_uint, c_uint, c_uint) c_int;
pub extern fn XkbSetDeviceButtonActions(?*xlib.Display, XkbDeviceInfoPtr, c_uint, c_uint) c_int;
pub extern fn XkbToControl(u8) u8;
pub extern fn XkbSetDebuggingFlags(?*xlib.Display, c_uint, c_uint, [*c]u8, c_uint, c_uint, [*c]c_uint, [*c]c_uint) c_int;
pub extern fn XkbApplyVirtualModChanges(XkbDescPtr, c_uint, XkbChangesPtr) c_int;
pub extern fn XkbUpdateActionVirtualMods(XkbDescPtr, [*c]XkbAction, c_uint) c_int;
pub extern fn XkbUpdateKeyTypeVirtualMods(XkbDescPtr, XkbKeyTypePtr, c_uint, XkbChangesPtr) void;

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
pub const EnteWindowMask = @as(c_long, 1) << @as(c_int, 4);
pub const LeavWindowMask = @as(c_long, 1) << @as(c_int, 5);
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
pub inline fn XkbIntTo2Chars(i: anytype, h: anytype, l: anytype) c_short {
    h.* = ((i >> 8) & @as(c_int, 0xff));
    l.* = ((i) & @as(c_int, 0xff));
    return h | l;
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
