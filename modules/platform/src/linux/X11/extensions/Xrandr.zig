const xlib = @import("../Xlib.zig");
const Display = xlib.Display;
const XTransform = xlib.XTransform;
const XFixed = xlib.XFixed;
const XEvent = xlib.XEvent;
const Atom = xlib.Atom;
const XID = xlib.XID;
const Time = xlib.Time;
const Window = xlib.Window;
const Connection = xlib.Connection;
const Drawable = xlib.Drawable;
const SizeID = xlib.SizeID;
const SubpixelOrder = xlib.SubpixelOrder;

pub const Rotation = c_ushort;
pub const RROutput = XID;
pub const RRCrtc = XID;
pub const RRMode = XID;
pub const RRProvider = XID;
pub const XRRScreenSize = extern struct {
    width: c_int,
    height: c_int,
    mwidth: c_int,
    mheight: c_int,
};
pub const XRRScreenChangeNotifyEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    window: Window,
    root: Window,
    timestamp: Time,
    config_timestamp: Time,
    size_index: SizeID,
    subpixel_order: SubpixelOrder,
    rotation: Rotation,
    width: c_int,
    height: c_int,
    mwidth: c_int,
    mheight: c_int,
};
pub const XRRNotifyEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    window: Window,
    subtype: c_int,
};
pub const XRROutputChangeNotifyEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    window: Window,
    subtype: c_int,
    output: RROutput,
    crtc: RRCrtc,
    mode: RRMode,
    rotation: Rotation,
    connection: Connection,
    subpixel_order: SubpixelOrder,
};
pub const XRRCrtcChangeNotifyEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    window: Window,
    subtype: c_int,
    crtc: RRCrtc,
    mode: RRMode,
    rotation: Rotation,
    x: c_int,
    y: c_int,
    width: c_uint,
    height: c_uint,
};
pub const XRROutputPropertyNotifyEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    window: Window,
    subtype: c_int,
    output: RROutput,
    property: Atom,
    timestamp: Time,
    state: c_int,
};
pub const XRRProviderChangeNotifyEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    window: Window,
    subtype: c_int,
    provider: RRProvider,
    timestamp: Time,
    current_role: c_uint,
};
pub const XRRProviderPropertyNotifyEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    window: Window,
    subtype: c_int,
    provider: RRProvider,
    property: Atom,
    timestamp: Time,
    state: c_int,
};
pub const XRRResourceChangeNotifyEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    window: Window,
    subtype: c_int,
    timestamp: Time,
};
pub const struct__XRRScreenConfiguration = opaque {};
pub const XRRScreenConfiguration = struct__XRRScreenConfiguration;
pub extern fn XRRQueryExtension(dpy: ?*Display, event_base_return: [*c]c_int, error_base_return: [*c]c_int) c_int;
pub extern fn XRRQueryVersion(dpy: ?*Display, major_version_return: [*c]c_int, minor_version_return: [*c]c_int) c_int;
pub extern fn XRRGetScreenInfo(dpy: ?*Display, window: Window) ?*XRRScreenConfiguration;
pub extern fn XRRFreeScreenConfigInfo(config: ?*XRRScreenConfiguration) void;
pub extern fn XRRSetScreenConfig(dpy: ?*Display, config: ?*XRRScreenConfiguration, draw: Drawable, size_index: c_int, rotation: Rotation, timestamp: Time) c_int;
pub extern fn XRRSetScreenConfigAndRate(dpy: ?*Display, config: ?*XRRScreenConfiguration, draw: Drawable, size_index: c_int, rotation: Rotation, rate: c_short, timestamp: Time) c_int;
pub extern fn XRRConfigRotations(config: ?*XRRScreenConfiguration, current_rotation: [*c]Rotation) Rotation;
pub extern fn XRRConfigTimes(config: ?*XRRScreenConfiguration, config_timestamp: [*c]Time) Time;
pub extern fn XRRConfigSizes(config: ?*XRRScreenConfiguration, nsizes: [*c]c_int) [*c]XRRScreenSize;
pub extern fn XRRConfigRates(config: ?*XRRScreenConfiguration, sizeID: c_int, nrates: [*c]c_int) [*c]c_short;
pub extern fn XRRConfigCurrentConfiguration(config: ?*XRRScreenConfiguration, rotation: [*c]Rotation) SizeID;
pub extern fn XRRConfigCurrentRate(config: ?*XRRScreenConfiguration) c_short;
pub extern fn XRRRootToScreen(dpy: ?*Display, root: Window) c_int;
pub extern fn XRRSelectInput(dpy: ?*Display, window: Window, mask: c_int) void;
pub extern fn XRRRotations(dpy: ?*Display, screen: c_int, current_rotation: [*c]Rotation) Rotation;
pub extern fn XRRSizes(dpy: ?*Display, screen: c_int, nsizes: [*c]c_int) [*c]XRRScreenSize;
pub extern fn XRRRates(dpy: ?*Display, screen: c_int, sizeID: c_int, nrates: [*c]c_int) [*c]c_short;
pub extern fn XRRTimes(dpy: ?*Display, screen: c_int, config_timestamp: [*c]Time) Time;
pub extern fn XRRGetScreenSizeRange(dpy: ?*Display, window: Window, minWidth: [*c]c_int, minHeight: [*c]c_int, maxWidth: [*c]c_int, maxHeight: [*c]c_int) c_int;
pub extern fn XRRSetScreenSize(dpy: ?*Display, window: Window, width: c_int, height: c_int, mmWidth: c_int, mmHeight: c_int) void;
pub const XRRModeFlags = c_ulong;
pub const struct__XRRModeInfo = extern struct {
    id: RRMode,
    width: c_uint,
    height: c_uint,
    dotClock: c_ulong,
    hSyncStart: c_uint,
    hSyncEnd: c_uint,
    hTotal: c_uint,
    hSkew: c_uint,
    vSyncStart: c_uint,
    vSyncEnd: c_uint,
    vTotal: c_uint,
    name: [*c]u8,
    nameLength: c_uint,
    modeFlags: XRRModeFlags,
};
pub const XRRModeInfo = struct__XRRModeInfo;
pub const struct__XRRScreenResources = extern struct {
    timestamp: Time,
    configTimestamp: Time,
    ncrtc: c_int,
    crtcs: [*c]RRCrtc,
    noutput: c_int,
    outputs: [*c]RROutput,
    nmode: c_int,
    modes: [*c]XRRModeInfo,
};
pub const XRRScreenResources = struct__XRRScreenResources;
pub extern fn XRRGetScreenResources(dpy: ?*Display, window: Window) [*c]XRRScreenResources;
pub extern fn XRRFreeScreenResources(resources: [*c]XRRScreenResources) void;
pub const struct__XRROutputInfo = extern struct {
    timestamp: Time,
    crtc: RRCrtc,
    name: [*c]u8,
    nameLen: c_int,
    mm_width: c_ulong,
    mm_height: c_ulong,
    connection: Connection,
    subpixel_order: SubpixelOrder,
    ncrtc: c_int,
    crtcs: [*c]RRCrtc,
    nclone: c_int,
    clones: [*c]RROutput,
    nmode: c_int,
    npreferred: c_int,
    modes: [*c]RRMode,
};
pub const XRROutputInfo = struct__XRROutputInfo;
pub extern fn XRRGetOutputInfo(dpy: ?*Display, resources: [*c]XRRScreenResources, output: RROutput) [*c]XRROutputInfo;
pub extern fn XRRFreeOutputInfo(outputInfo: [*c]XRROutputInfo) void;
pub extern fn XRRListOutputProperties(dpy: ?*Display, output: RROutput, nprop: [*c]c_int) [*c]Atom;
pub const XRRPropertyInfo = extern struct {
    pending: c_int,
    range: c_int,
    immutable: c_int,
    num_values: c_int,
    values: [*c]c_long,
};
pub extern fn XRRQueryOutputProperty(dpy: ?*Display, output: RROutput, property: Atom) [*c]XRRPropertyInfo;
pub extern fn XRRConfigureOutputProperty(dpy: ?*Display, output: RROutput, property: Atom, pending: c_int, range: c_int, num_values: c_int, values: [*c]c_long) void;
pub extern fn XRRChangeOutputProperty(dpy: ?*Display, output: RROutput, property: Atom, @"type": Atom, format: c_int, mode: c_int, data: [*c]const u8, nelements: c_int) void;
pub extern fn XRRDeleteOutputProperty(dpy: ?*Display, output: RROutput, property: Atom) void;
pub extern fn XRRGetOutputProperty(dpy: ?*Display, output: RROutput, property: Atom, offset: c_long, length: c_long, _delete: c_int, pending: c_int, req_type: Atom, actual_type: [*c]Atom, actual_format: [*c]c_int, nitems: [*c]c_ulong, bytes_after: [*c]c_ulong, prop: [*c][*c]u8) c_int;
pub extern fn XRRAllocModeInfo(name: [*c]const u8, nameLength: c_int) [*c]XRRModeInfo;
pub extern fn XRRCreateMode(dpy: ?*Display, window: Window, modeInfo: [*c]XRRModeInfo) RRMode;
pub extern fn XRRDestroyMode(dpy: ?*Display, mode: RRMode) void;
pub extern fn XRRAddOutputMode(dpy: ?*Display, output: RROutput, mode: RRMode) void;
pub extern fn XRRDeleteOutputMode(dpy: ?*Display, output: RROutput, mode: RRMode) void;
pub extern fn XRRFreeModeInfo(modeInfo: [*c]XRRModeInfo) void;
pub const struct__XRRCrtcInfo = extern struct {
    timestamp: Time,
    x: c_int,
    y: c_int,
    width: c_uint,
    height: c_uint,
    mode: RRMode,
    rotation: Rotation,
    noutput: c_int,
    outputs: [*c]RROutput,
    rotations: Rotation,
    npossible: c_int,
    possible: [*c]RROutput,
};
pub const XRRCrtcInfo = struct__XRRCrtcInfo;
pub extern fn XRRGetCrtcInfo(dpy: ?*Display, resources: [*c]XRRScreenResources, crtc: RRCrtc) [*c]XRRCrtcInfo;
pub extern fn XRRFreeCrtcInfo(crtcInfo: [*c]XRRCrtcInfo) void;
pub extern fn XRRSetCrtcConfig(dpy: ?*Display, resources: [*c]XRRScreenResources, crtc: RRCrtc, timestamp: Time, x: c_int, y: c_int, mode: RRMode, rotation: Rotation, outputs: [*c]RROutput, noutputs: c_int) c_int;
pub extern fn XRRGetCrtcGammaSize(dpy: ?*Display, crtc: RRCrtc) c_int;
pub const struct__XRRCrtcGamma = extern struct {
    size: c_int,
    red: [*c]c_ushort,
    green: [*c]c_ushort,
    blue: [*c]c_ushort,
};
pub const XRRCrtcGamma = struct__XRRCrtcGamma;
pub extern fn XRRGetCrtcGamma(dpy: ?*Display, crtc: RRCrtc) [*c]XRRCrtcGamma;
pub extern fn XRRAllocGamma(size: c_int) [*c]XRRCrtcGamma;
pub extern fn XRRSetCrtcGamma(dpy: ?*Display, crtc: RRCrtc, gamma: [*c]XRRCrtcGamma) void;
pub extern fn XRRFreeGamma(gamma: [*c]XRRCrtcGamma) void;
pub extern fn XRRGetScreenResourcesCurrent(dpy: ?*Display, window: Window) [*c]XRRScreenResources;
pub extern fn XRRSetCrtcTransform(dpy: ?*Display, crtc: RRCrtc, transform: [*c]XTransform, filter: [*c]const u8, params: [*c]XFixed, nparams: c_int) void;
pub const struct__XRRCrtcTransformAttributes = extern struct {
    pendingTransform: XTransform,
    pendingFilter: [*c]u8,
    pendingNparams: c_int,
    pendingParams: [*c]XFixed,
    currentTransform: XTransform,
    currentFilter: [*c]u8,
    currentNparams: c_int,
    currentParams: [*c]XFixed,
};
pub const XRRCrtcTransformAttributes = struct__XRRCrtcTransformAttributes;
pub extern fn XRRGetCrtcTransform(dpy: ?*Display, crtc: RRCrtc, attributes: [*c][*c]XRRCrtcTransformAttributes) c_int;
pub extern fn XRRUpdateConfiguration(event: [*c]XEvent) c_int;
pub const struct__XRRPanning = extern struct {
    timestamp: Time,
    left: c_uint,
    top: c_uint,
    width: c_uint,
    height: c_uint,
    track_left: c_uint,
    track_top: c_uint,
    track_width: c_uint,
    track_height: c_uint,
    border_left: c_int,
    border_top: c_int,
    border_right: c_int,
    border_bottom: c_int,
};
pub const XRRPanning = struct__XRRPanning;
pub extern fn XRRGetPanning(dpy: ?*Display, resources: [*c]XRRScreenResources, crtc: RRCrtc) [*c]XRRPanning;
pub extern fn XRRFreePanning(panning: [*c]XRRPanning) void;
pub extern fn XRRSetPanning(dpy: ?*Display, resources: [*c]XRRScreenResources, crtc: RRCrtc, panning: [*c]XRRPanning) c_int;
pub extern fn XRRSetOutputPrimary(dpy: ?*Display, window: Window, output: RROutput) void;
pub extern fn XRRGetOutputPrimary(dpy: ?*Display, window: Window) RROutput;
pub const struct__XRRProviderResources = extern struct {
    timestamp: Time,
    nproviders: c_int,
    providers: [*c]RRProvider,
};
pub const XRRProviderResources = struct__XRRProviderResources;
pub extern fn XRRGetProviderResources(dpy: ?*Display, window: Window) [*c]XRRProviderResources;
pub extern fn XRRFreeProviderResources(resources: [*c]XRRProviderResources) void;
pub const struct__XRRProviderInfo = extern struct {
    capabilities: c_uint,
    ncrtcs: c_int,
    crtcs: [*c]RRCrtc,
    noutputs: c_int,
    outputs: [*c]RROutput,
    name: [*c]u8,
    nassociatedproviders: c_int,
    associated_providers: [*c]RRProvider,
    associated_capability: [*c]c_uint,
    nameLen: c_int,
};
pub const XRRProviderInfo = struct__XRRProviderInfo;
pub extern fn XRRGetProviderInfo(dpy: ?*Display, resources: [*c]XRRScreenResources, provider: RRProvider) [*c]XRRProviderInfo;
pub extern fn XRRFreeProviderInfo(provider: [*c]XRRProviderInfo) void;
pub extern fn XRRSetProviderOutputSource(dpy: ?*Display, provider: XID, source_provider: XID) c_int;
pub extern fn XRRSetProviderOffloadSink(dpy: ?*Display, provider: XID, sink_provider: XID) c_int;
pub extern fn XRRListProviderProperties(dpy: ?*Display, provider: RRProvider, nprop: [*c]c_int) [*c]Atom;
pub extern fn XRRQueryProviderProperty(dpy: ?*Display, provider: RRProvider, property: Atom) [*c]XRRPropertyInfo;
pub extern fn XRRConfigureProviderProperty(dpy: ?*Display, provider: RRProvider, property: Atom, pending: c_int, range: c_int, num_values: c_int, values: [*c]c_long) void;
pub extern fn XRRChangeProviderProperty(dpy: ?*Display, provider: RRProvider, property: Atom, @"type": Atom, format: c_int, mode: c_int, data: [*c]const u8, nelements: c_int) void;
pub extern fn XRRDeleteProviderProperty(dpy: ?*Display, provider: RRProvider, property: Atom) void;
pub extern fn XRRGetProviderProperty(dpy: ?*Display, provider: RRProvider, property: Atom, offset: c_long, length: c_long, _delete: c_int, pending: c_int, req_type: Atom, actual_type: [*c]Atom, actual_format: [*c]c_int, nitems: [*c]c_ulong, bytes_after: [*c]c_ulong, prop: [*c][*c]u8) c_int;
pub const RANDR_NAME = "RANDR";
pub const RANDR_MAJOR = @as(c_int, 1);
pub const RANDR_MINOR = @as(c_int, 5);
pub const RRNumberErrors = @as(c_int, 4);
pub const RRNumberEvents = @as(c_int, 2);
pub const RRNumberRequests = @as(c_int, 45);
pub const X_RRQueryVersion = @as(c_int, 0);
pub const X_RROldGetScreenInfo = @as(c_int, 1);
pub const X_RR1_0SetScreenConfig = @as(c_int, 2);
pub const X_RRSetScreenConfig = @as(c_int, 2);
pub const X_RROldScreenChangeSelectInput = @as(c_int, 3);
pub const X_RRSelectInput = @as(c_int, 4);
pub const X_RRGetScreenInfo = @as(c_int, 5);
pub const X_RRGetScreenSizeRange = @as(c_int, 6);
pub const X_RRSetScreenSize = @as(c_int, 7);
pub const X_RRGetScreenResources = @as(c_int, 8);
pub const X_RRGetOutputInfo = @as(c_int, 9);
pub const X_RRListOutputProperties = @as(c_int, 10);
pub const X_RRQueryOutputProperty = @as(c_int, 11);
pub const X_RRConfigureOutputProperty = @as(c_int, 12);
pub const X_RRChangeOutputProperty = @as(c_int, 13);
pub const X_RRDeleteOutputProperty = @as(c_int, 14);
pub const X_RRGetOutputProperty = @as(c_int, 15);
pub const X_RRCreateMode = @as(c_int, 16);
pub const X_RRDestroyMode = @as(c_int, 17);
pub const X_RRAddOutputMode = @as(c_int, 18);
pub const X_RRDeleteOutputMode = @as(c_int, 19);
pub const X_RRGetCrtcInfo = @as(c_int, 20);
pub const X_RRSetCrtcConfig = @as(c_int, 21);
pub const X_RRGetCrtcGammaSize = @as(c_int, 22);
pub const X_RRGetCrtcGamma = @as(c_int, 23);
pub const X_RRSetCrtcGamma = @as(c_int, 24);
pub const X_RRGetScreenResourcesCurrent = @as(c_int, 25);
pub const X_RRSetCrtcTransform = @as(c_int, 26);
pub const X_RRGetCrtcTransform = @as(c_int, 27);
pub const X_RRGetPanning = @as(c_int, 28);
pub const X_RRSetPanning = @as(c_int, 29);
pub const X_RRSetOutputPrimary = @as(c_int, 30);
pub const X_RRGetOutputPrimary = @as(c_int, 31);
pub const RRTransformUnit = @as(c_long, 1) << @as(c_int, 0);
pub const RRTransformScaleUp = @as(c_long, 1) << @as(c_int, 1);
pub const RRTransformScaleDown = @as(c_long, 1) << @as(c_int, 2);
pub const RRTransformProjective = @as(c_long, 1) << @as(c_int, 3);
pub const X_RRGetProviders = @as(c_int, 32);
pub const X_RRGetProviderInfo = @as(c_int, 33);
pub const X_RRSetProviderOffloadSink = @as(c_int, 34);
pub const X_RRSetProviderOutputSource = @as(c_int, 35);
pub const X_RRListProviderProperties = @as(c_int, 36);
pub const X_RRQueryProviderProperty = @as(c_int, 37);
pub const X_RRConfigureProviderProperty = @as(c_int, 38);
pub const X_RRChangeProviderProperty = @as(c_int, 39);
pub const X_RRDeleteProviderProperty = @as(c_int, 40);
pub const X_RRGetProviderProperty = @as(c_int, 41);
pub const X_RRGetMonitors = @as(c_int, 42);
pub const X_RRSetMonitor = @as(c_int, 43);
pub const X_RRDeleteMonitor = @as(c_int, 44);
pub const RRScreenChangeNotifyMask = @as(c_long, 1) << @as(c_int, 0);
pub const RRCrtcChangeNotifyMask = @as(c_long, 1) << @as(c_int, 1);
pub const RROutputChangeNotifyMask = @as(c_long, 1) << @as(c_int, 2);
pub const RROutputPropertyNotifyMask = @as(c_long, 1) << @as(c_int, 3);
pub const RRProviderChangeNotifyMask = @as(c_long, 1) << @as(c_int, 4);
pub const RRProviderPropertyNotifyMask = @as(c_long, 1) << @as(c_int, 5);
pub const RRResourceChangeNotifyMask = @as(c_long, 1) << @as(c_int, 6);
pub const RRScreenChangeNotify = @as(c_int, 0);
pub const RRNotify = @as(c_int, 1);
pub const RRNotify_CrtcChange = @as(c_int, 0);
pub const RRNotify_OutputChange = @as(c_int, 1);
pub const RRNotify_OutputProperty = @as(c_int, 2);
pub const RRNotify_ProviderChange = @as(c_int, 3);
pub const RRNotify_ProviderProperty = @as(c_int, 4);
pub const RRNotify_ResourceChange = @as(c_int, 5);
pub const RR_Rotate_0 = @as(c_int, 1);
pub const RR_Rotate_90 = @as(c_int, 2);
pub const RR_Rotate_180 = @as(c_int, 4);
pub const RR_Rotate_270 = @as(c_int, 8);
pub const RR_Reflect_X = @as(c_int, 16);
pub const RR_Reflect_Y = @as(c_int, 32);
pub const RRSetConfigSuccess = @as(c_int, 0);
pub const RRSetConfigInvalidConfigTime = @as(c_int, 1);
pub const RRSetConfigInvalidTime = @as(c_int, 2);
pub const RRSetConfigFailed = @as(c_int, 3);
pub const RR_HSyncPositive = @as(c_int, 0x00000001);
pub const RR_HSyncNegative = @as(c_int, 0x00000002);
pub const RR_VSyncPositive = @as(c_int, 0x00000004);
pub const RR_VSyncNegative = @as(c_int, 0x00000008);
pub const RR_Interlace = @as(c_int, 0x00000010);
pub const RR_DoubleScan = @as(c_int, 0x00000020);
pub const RR_CSync = @as(c_int, 0x00000040);
pub const RR_CSyncPositive = @as(c_int, 0x00000080);
pub const RR_CSyncNegative = @as(c_int, 0x00000100);
pub const RR_HSkewPresent = @as(c_int, 0x00000200);
pub const RR_BCast = @as(c_int, 0x00000400);
pub const RR_PixelMultiplex = @as(c_int, 0x00000800);
pub const RR_DoubleClock = @as(c_int, 0x00001000);
pub const RR_ClockDivideBy2 = @as(c_int, 0x00002000);
pub const RR_Connected = @as(c_int, 0);
pub const RR_Disconnected = @as(c_int, 1);
pub const RR_UnknownConnection = @as(c_int, 2);
pub const BadRROutput = @as(c_int, 0);
pub const BadRRCrtc = @as(c_int, 1);
pub const BadRRMode = @as(c_int, 2);
pub const BadRRProvider = @as(c_int, 3);
pub const RR_PROPERTY_BACKLIGHT = "Backlight";
pub const RR_PROPERTY_RANDR_EDID = "EDID";
pub const RR_PROPERTY_SIGNAL_FORMAT = "SignalFormat";
pub const RR_PROPERTY_SIGNAL_PROPERTIES = "SignalProperties";
pub const RR_PROPERTY_CONNECTOR_TYPE = "ConnectorType";
pub const RR_PROPERTY_CONNECTOR_NUMBER = "ConnectorNumber";
pub const RR_PROPERTY_COMPATIBILITY_LIST = "CompatibilityList";
pub const RR_PROPERTY_CLONE_LIST = "CloneList";
pub const RR_PROPERTY_BORDER = "Border";
pub const RR_PROPERTY_BORDER_DIMENSIONS = "BorderDimensions";
pub const RR_PROPERTY_GUID = "GUID";
pub const RR_PROPERTY_RANDR_TILE = "TILE";
pub const RR_Capability_None = @as(c_int, 0);
pub const RR_Capability_SourceOutput = @as(c_int, 1);
pub const RR_Capability_SinkOutput = @as(c_int, 2);
pub const RR_Capability_SourceOffload = @as(c_int, 4);
pub const RR_Capability_SinkOffload = @as(c_int, 8);
pub const _XRRScreenConfiguration = struct__XRRScreenConfiguration;
pub const _XRRModeInfo = struct__XRRModeInfo;
pub const _XRRScreenResources = struct__XRRScreenResources;
pub const _XRROutputInfo = struct__XRROutputInfo;
pub const _XRRCrtcInfo = struct__XRRCrtcInfo;
pub const _XRRCrtcGamma = struct__XRRCrtcGamma;
pub const _XRRCrtcTransformAttributes = struct__XRRCrtcTransformAttributes;
pub const _XRRPanning = struct__XRRPanning;
pub const _XRRProviderResources = struct__XRRProviderResources;
pub const _XRRProviderInfo = struct__XRRProviderInfo;
