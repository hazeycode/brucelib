const X = @import("X.zig");
pub usingnamespace X;

const wchar_t = c_int;

pub const FreeFuncType = ?fn ([*c]Display) callconv(.C) void;
pub const FreeModmapType = ?fn ([*c]XModifierKeymap) callconv(.C) c_int;

pub const struct__XSQEvent = extern struct {
    next: [*c]struct__XSQEvent,
    event: XEvent,
    qserial_num: c_ulong,
};

pub const struct__XFreeFuncs = extern struct {
    atoms: FreeFuncType,
    modifiermap: FreeModmapType,
    key_bindings: FreeFuncType,
    context_db: FreeFuncType,
    defaultCCCs: FreeFuncType,
    clientCmaps: FreeFuncType,
    intensityMaps: FreeFuncType,
    im_filters: FreeFuncType,
    xkb: FreeFuncType,
};

pub const struct__XPrivate = opaque {};

pub const CreateGCType = ?fn ([*c]Display, GC, [*c]XExtCodes) callconv(.C) c_int;
pub const CopyGCType = ?fn ([*c]Display, GC, [*c]XExtCodes) callconv(.C) c_int;
pub const FlushGCType = ?fn ([*c]Display, GC, [*c]XExtCodes) callconv(.C) c_int;
pub const FreeGCType = ?fn ([*c]Display, GC, [*c]XExtCodes) callconv(.C) c_int;
pub const CreateFontType = ?fn ([*c]Display, [*c]XFontStruct, [*c]XExtCodes) callconv(.C) c_int;
pub const FreeFontType = ?fn ([*c]Display, [*c]XFontStruct, [*c]XExtCodes) callconv(.C) c_int;
pub const CloseDisplayType = ?fn ([*c]Display, [*c]XExtCodes) callconv(.C) c_int;
pub const ErrorType = ?fn ([*c]Display, [*c]xError, [*c]XExtCodes, [*c]c_int) callconv(.C) c_int;
pub const ErrorStringType = ?fn ([*c]Display, c_int, [*c]XExtCodes, [*c]u8, c_int) callconv(.C) [*c]u8;
pub const PrintErrorType = ?fn ([*c]Display, [*c]XErrorEvent, ?*anyopaque) callconv(.C) void;
pub const BeforeFlushType = ?fn ([*c]Display, [*c]XExtCodes, [*c]const u8, c_long) callconv(.C) void;
pub const struct__XExten = extern struct {
    next: [*c]struct__XExten,
    codes: XExtCodes,
    create_GC: CreateGCType,
    copy_GC: CopyGCType,
    flush_GC: FlushGCType,
    free_GC: FreeGCType,
    create_Font: CreateFontType,
    free_Font: FreeFontType,
    close_display: CloseDisplayType,
    @"error": ErrorType,
    error_string: ErrorStringType,
    name: [*c]u8,
    error_values: PrintErrorType,
    before_flush: BeforeFlushType,
    next_flush: [*c]struct__XExten,
};

pub const XSizeHints = extern struct {
    flags: c_long,
    x: c_int,
    y: c_int,
    width: c_int,
    height: c_int,
    min_width: c_int,
    min_height: c_int,
    max_width: c_int,
    max_height: c_int,
    width_inc: c_int,
    height_inc: c_int,
    min_aspect: struct_unnamed_1,
    max_aspect: struct_unnamed_1,
    base_width: c_int,
    base_height: c_int,
    win_gravity: c_int,
};
pub const XWMHints = extern struct {
    flags: c_long,
    input: c_int,
    initial_state: c_int,
    icon_pixmap: X.Pixmap,
    icon_window: X.Window,
    icon_x: c_int,
    icon_y: c_int,
    icon_mask: X.Pixmap,
    window_group: X.XID,
};
pub const XTextProperty = extern struct {
    value: [*c]u8,
    encoding: X.Atom,
    format: c_int,
    nitems: c_ulong,
};
pub const XStringStyle: c_int = 0;
pub const XCompoundTextStyle: c_int = 1;
pub const XTextStyle: c_int = 2;
pub const XStdICCTextStyle: c_int = 3;
pub const XUTF8StringStyle: c_int = 4;
pub const XICCEncodingStyle = c_uint;
pub const XIconSize = extern struct {
    min_width: c_int,
    min_height: c_int,
    max_width: c_int,
    max_height: c_int,
    width_inc: c_int,
    height_inc: c_int,
};
pub const XClassHint = extern struct {
    res_name: [*c]u8,
    res_class: [*c]u8,
};
pub const struct__XComposeStatus = extern struct {
    compose_ptr: X.XPointer,
    chars_matched: c_int,
};
pub const XComposeStatus = struct__XComposeStatus;
pub const struct__XRegion = opaque {};
pub const Region = ?*struct__XRegion;
pub const XVisualInfo = extern struct {
    visual: [*c]Visual,
    visualid: X.VisualID,
    screen: c_int,
    depth: c_int,
    class: c_int,
    red_mask: c_ulong,
    green_mask: c_ulong,
    blue_mask: c_ulong,
    colormap_size: c_int,
    bits_per_rgb: c_int,
};
pub const XStandardColormap = extern struct {
    colormap: X.Colormap,
    red_max: c_ulong,
    red_mult: c_ulong,
    green_max: c_ulong,
    green_mult: c_ulong,
    blue_max: c_ulong,
    blue_mult: c_ulong,
    base_pixel: c_ulong,
    visualid: X.VisualID,
    killid: X.XID,
};
pub const XContext = c_int;
pub extern fn XAllocClassHint() [*c]XClassHint;
pub extern fn XAllocIconSize() [*c]XIconSize;
pub extern fn XAllocSizeHints() [*c]XSizeHints;
pub extern fn XAllocStandardColormap() [*c]XStandardColormap;
pub extern fn XAllocWMHints() [*c]XWMHints;
pub extern fn XClipBox(Region, [*c]X.XRectangle) c_int;
pub extern fn XCreateRegion() Region;
pub extern fn XDefaultString() [*c]const u8;
pub extern fn XDeleteContext(?*X.Display, X.XID, XContext) c_int;
pub extern fn XDestroyRegion(Region) c_int;
pub extern fn XEmptyRegion(Region) c_int;
pub extern fn XEqualRegion(Region, Region) c_int;
pub extern fn XFindContext(?*X.Display, X.XID, XContext, [*c]X.XPointer) c_int;
pub extern fn XGetClassHint(?*X.Display, X.Window, [*c]XClassHint) c_int;
pub extern fn XGetIconSizes(?*X.Display, X.Window, [*c][*c]XIconSize, [*c]c_int) c_int;
pub extern fn XGetNormalHints(?*X.Display, X.Window, [*c]XSizeHints) c_int;
pub extern fn XGetRGBColormaps(?*X.Display, X.Window, [*c][*c]XStandardColormap, [*c]c_int, X.Atom) c_int;
pub extern fn XGetSizeHints(?*X.Display, X.Window, [*c]XSizeHints, X.Atom) c_int;
pub extern fn XGetStandardColormap(?*X.Display, X.Window, [*c]XStandardColormap, X.Atom) c_int;
pub extern fn XGetTextProperty(?*X.Display, X.Window, [*c]XTextProperty, X.Atom) c_int;
pub extern fn XGetVisualInfo(?*X.Display, c_long, [*c]XVisualInfo, [*c]c_int) [*c]XVisualInfo;
pub extern fn XGetWMClientMachine(?*X.Display, X.Window, [*c]XTextProperty) c_int;
pub extern fn XGetWMHints(?*X.Display, X.Window) [*c]XWMHints;
pub extern fn XGetWMIconName(?*X.Display, X.Window, [*c]XTextProperty) c_int;
pub extern fn XGetWMName(?*X.Display, X.Window, [*c]XTextProperty) c_int;
pub extern fn XGetWMNormalHints(?*X.Display, X.Window, [*c]XSizeHints, [*c]c_long) c_int;
pub extern fn XGetWMSizeHints(?*X.Display, X.Window, [*c]XSizeHints, [*c]c_long, X.Atom) c_int;
pub extern fn XGetZoomHints(?*X.Display, X.Window, [*c]XSizeHints) c_int;
pub extern fn XIntersectRegion(Region, Region, Region) c_int;
pub extern fn XConvertCase(X.KeySym, [*c]X.KeySym, [*c]X.KeySym) void;
pub extern fn XLookupString([*c]X.XKeyEvent, [*c]u8, c_int, [*c]X.KeySym, [*c]XComposeStatus) c_int;
pub extern fn XMatchVisualInfo(?*X.Display, c_int, c_int, c_int, [*c]XVisualInfo) c_int;
pub extern fn XOffsetRegion(Region, c_int, c_int) c_int;
pub extern fn XPointInRegion(Region, c_int, c_int) c_int;
pub extern fn XPolygonRegion([*c]X.XPoint, c_int, c_int) Region;
pub extern fn XRectInRegion(Region, c_int, c_int, c_uint, c_uint) c_int;
pub extern fn XSaveContext(?*X.Display, X.XID, XContext, [*c]const u8) c_int;
pub extern fn XSetClassHint(?*X.Display, X.Window, [*c]XClassHint) c_int;
pub extern fn XSetIconSizes(?*X.Display, X.Window, [*c]XIconSize, c_int) c_int;
pub extern fn XSetNormalHints(?*X.Display, X.Window, [*c]XSizeHints) c_int;
pub extern fn XSetRGBColormaps(?*X.Display, X.Window, [*c]XStandardColormap, c_int, X.Atom) void;
pub extern fn XSetSizeHints(?*X.Display, X.Window, [*c]XSizeHints, X.Atom) c_int;
pub extern fn XSetStandardProperties(?*X.Display, X.Window, [*c]const u8, [*c]const u8, X.Pixmap, [*c][*c]u8, c_int, [*c]XSizeHints) c_int;
pub extern fn XSetTextProperty(?*X.Display, X.Window, [*c]XTextProperty, X.Atom) void;
pub extern fn XSetWMClientMachine(?*X.Display, X.Window, [*c]XTextProperty) void;
pub extern fn XSetWMHints(?*X.Display, X.Window, [*c]XWMHints) c_int;
pub extern fn XSetWMIconName(?*X.Display, X.Window, [*c]XTextProperty) void;
pub extern fn XSetWMName(?*X.Display, X.Window, [*c]XTextProperty) void;
pub extern fn XSetWMNormalHints(?*X.Display, X.Window, [*c]XSizeHints) void;
pub extern fn XSetWMProperties(?*X.Display, X.Window, [*c]XTextProperty, [*c]XTextProperty, [*c][*c]u8, c_int, [*c]XSizeHints, [*c]XWMHints, [*c]XClassHint) void;
pub extern fn XmbSetWMProperties(?*X.Display, X.Window, [*c]const u8, [*c]const u8, [*c][*c]u8, c_int, [*c]XSizeHints, [*c]XWMHints, [*c]XClassHint) void;
pub extern fn Xutf8SetWMProperties(?*X.Display, X.Window, [*c]const u8, [*c]const u8, [*c][*c]u8, c_int, [*c]XSizeHints, [*c]XWMHints, [*c]XClassHint) void;
pub extern fn XSetWMSizeHints(?*X.Display, X.Window, [*c]XSizeHints, X.Atom) void;
pub extern fn XSetRegion(?*X.Display, GC: c_int, Region) c_int;
pub extern fn XSetStandardColormap(?*X.Display, X.Window, [*c]XStandardColormap, X.Atom) void;
pub extern fn XSetZoomHints(?*X.Display, X.Window, [*c]XSizeHints) c_int;
pub extern fn XShrinkRegion(Region, c_int, c_int) c_int;
pub extern fn XStringListToTextProperty([*c][*c]u8, c_int, [*c]XTextProperty) c_int;
pub extern fn XSubtractRegion(Region, Region, Region) c_int;
pub extern fn XmbTextListToTextProperty(display: ?*X.Display, list: [*c][*c]u8, count: c_int, style: XICCEncodingStyle, text_prop_return: [*c]XTextProperty) c_int;
pub extern fn XwcTextListToTextProperty(display: ?*X.Display, list: [*c][*c]wchar_t, count: c_int, style: XICCEncodingStyle, text_prop_return: [*c]XTextProperty) c_int;
pub extern fn Xutf8TextListToTextProperty(display: ?*X.Display, list: [*c][*c]u8, count: c_int, style: XICCEncodingStyle, text_prop_return: [*c]XTextProperty) c_int;
pub extern fn XwcFreeStringList(list: [*c][*c]wchar_t) void;
pub extern fn XTextPropertyToStringList([*c]XTextProperty, [*c][*c][*c]u8, [*c]c_int) c_int;
pub extern fn XmbTextPropertyToTextList(display: ?*X.Display, text_prop: [*c]const XTextProperty, list_return: [*c][*c][*c]u8, count_return: [*c]c_int) c_int;
pub extern fn XwcTextPropertyToTextList(display: ?*X.Display, text_prop: [*c]const XTextProperty, list_return: [*c][*c][*c]wchar_t, count_return: [*c]c_int) c_int;
pub extern fn Xutf8TextPropertyToTextList(display: ?*X.Display, text_prop: [*c]const XTextProperty, list_return: [*c][*c][*c]u8, count_return: [*c]c_int) c_int;
pub extern fn XUnionRectWithRegion([*c]X.XRectangle, Region, Region) c_int;
pub extern fn XUnionRegion(Region, Region, Region) c_int;
pub extern fn XWMGeometry(?*X.Display, c_int, [*c]const u8, [*c]const u8, c_uint, [*c]XSizeHints, [*c]c_int, [*c]c_int, [*c]c_int, [*c]c_int, [*c]c_int) c_int;
pub extern fn XXorRegion(Region, Region, Region) c_int;
pub inline fn XDestroyImage(ximage: anytype) @TypeOf(ximage.*.f.destroy_image.*(ximage)) {
    return ximage.*.f.destroy_image.*(ximage);
}
pub inline fn XGetPixel(ximage: anytype, x: anytype, y: anytype) @TypeOf(ximage.*.f.get_pixel.*(ximage, x, y)) {
    return ximage.*.f.get_pixel.*(ximage, x, y);
}
pub inline fn XPutPixel(ximage: anytype, x: anytype, y: anytype, pixel: anytype) @TypeOf(ximage.*.f.put_pixel.*(ximage, x, y, pixel)) {
    return ximage.*.f.put_pixel.*(ximage, x, y, pixel);
}
pub inline fn XSubImage(ximage: anytype, x: anytype, y: anytype, width: anytype, height: anytype) @TypeOf(ximage.*.f.sub_image.*(ximage, x, y, width, height)) {
    return ximage.*.f.sub_image.*(ximage, x, y, width, height);
}
pub inline fn XAddPixel(ximage: anytype, value: anytype) @TypeOf(ximage.*.f.add_pixel.*(ximage, value)) {
    return ximage.*.f.add_pixel.*(ximage, value);
}
pub inline fn IsPrivateKeypadKey(keysym: anytype) @TypeOf((@import("std").zig.c_translation.cast(X.KeySym, keysym) >= @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x11000000, .hexadecimal)) and (@import("std").zig.c_translation.cast(X.KeySym, keysym) <= @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x1100FFFF, .hexadecimal))) {
    return (@import("std").zig.c_translation.cast(X.KeySym, keysym) >= @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x11000000, .hexadecimal)) and (@import("std").zig.c_translation.cast(X.KeySym, keysym) <= @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x1100FFFF, .hexadecimal));
}
pub const RectangleOut = @as(c_int, 0);
pub const RectangleIn = @as(c_int, 1);
pub const RectanglePart = @as(c_int, 2);
pub const VisualNoMask = @as(c_int, 0x0);
pub const VisualIDMask = @as(c_int, 0x1);
pub const VisualScreenMask = @as(c_int, 0x2);
pub const VisualDepthMask = @as(c_int, 0x4);
pub const VisualClassMask = @as(c_int, 0x8);
pub const VisualRedMaskMask = @as(c_int, 0x10);
pub const VisualGreenMaskMask = @as(c_int, 0x20);
pub const VisualBlueMaskMask = @as(c_int, 0x40);
pub const VisualColormapSizeMask = @as(c_int, 0x80);
pub const VisualBitsPerRGBMask = @as(c_int, 0x100);
pub const VisualAllMask = @as(c_int, 0x1FF);
pub const ReleaseByFreeingColormap = @import("std").zig.c_translation.cast(X.XID, @as(c_long, 1));
pub const BitmapSuccess = @as(c_int, 0);
pub const BitmapOpenFailed = @as(c_int, 1);
pub const BitmapFileInvalid = @as(c_int, 2);
pub const BitmapNoMemory = @as(c_int, 3);
pub const XCSUCCESS = @as(c_int, 0);
pub const XCNOMEM = @as(c_int, 1);
pub const XCNOENT = @as(c_int, 2);


pub extern fn XLoadQueryFont(?*Display, [*c]const u8) [*c]XFontStruct;
pub extern fn XQueryFont(?*Display, X.XID) [*c]XFontStruct;
pub extern fn XGetMotionEvents(?*Display, X.Window, X.Time, X.Time, [*c]c_int) [*c]XTimeCoord;
pub extern fn XDeleteModifiermapEntry([*c]XModifierKeymap, X.KeyCode, c_int) [*c]XModifierKeymap;
pub extern fn XGetModifierMapping(?*Display) [*c]XModifierKeymap;
pub extern fn XInsertModifiermapEntry([*c]XModifierKeymap, X.KeyCode, c_int) [*c]XModifierKeymap;
pub extern fn XNewModifiermap(c_int) [*c]XModifierKeymap;
pub extern fn XCreateImage(?*Display, [*c]Visual, c_uint, c_int, c_int, [*c]u8, c_uint, c_uint, c_int, c_int) [*c]XImage;
pub extern fn XInitImage([*c]XImage) c_int;
pub extern fn XGetImage(?*Display, X.Drawable, c_int, c_int, c_uint, c_uint, c_ulong, c_int) [*c]XImage;
pub extern fn XGetSubImage(?*Display, X.Drawable, c_int, c_int, c_uint, c_uint, c_ulong, c_int, [*c]XImage, c_int, c_int) [*c]XImage;
pub extern fn XOpenDisplay([*c]const u8) ?*Display;
pub extern fn XrmInitialize() void;
pub extern fn XFetchBytes(?*Display, [*c]c_int) [*c]u8;
pub extern fn XFetchBuffer(?*Display, [*c]c_int, c_int) [*c]u8;
pub extern fn XGetAtomName(?*Display, X.Atom) [*c]u8;
pub extern fn XGetAtomNames(?*Display, [*c]X.Atom, c_int, [*c][*c]u8) c_int;
pub extern fn XGetDefault(?*Display, [*c]const u8, [*c]const u8) [*c]u8;
pub extern fn XDisplayName([*c]const u8) [*c]u8;
pub extern fn XKeysymToString(X.KeySym) [*c]u8;
pub extern fn XSynchronize(?*Display, c_int) ?fn (?*Display) callconv(.C) c_int;
pub extern fn XSetAfterFunction(?*Display, ?fn (?*Display) callconv(.C) c_int) ?fn (?*Display) callconv(.C) c_int;
pub extern fn XInternAtom(?*Display, [*c]const u8, c_int) X.Atom;
pub extern fn XInternAtoms(?*Display, [*c][*c]u8, c_int, c_int, [*c]X.Atom) c_int;
pub extern fn XCopyColormapAndFree(?*Display, X.Colormap) X.Colormap;
pub extern fn XCreateColormap(?*Display, X.Window, [*c]Visual, c_int) X.Colormap;
pub extern fn XCreatePixmapCursor(?*Display, X.Pixmap, X.Pixmap, [*c]XColor, [*c]XColor, c_uint, c_uint) X.Cursor;
pub extern fn XCreateGlyphCursor(?*Display, X.Font, X.Font, c_uint, c_uint, [*c]const XColor, [*c]const XColor) X.Cursor;
pub extern fn XCreateFontCursor(?*Display, c_uint) X.Cursor;
pub extern fn XLoadFont(?*Display, [*c]const u8) X.Font;
pub extern fn XCreateGC(?*Display, X.Drawable, c_ulong, [*c]XGCValues) GC;
pub extern fn XGContextFromGC(GC) X.GContext;
pub extern fn XFlushGC(?*Display, GC) void;
pub extern fn XCreatePixmap(?*Display, X.Drawable, c_uint, c_uint, c_uint) X.Pixmap;
pub extern fn XCreateBitmapFromData(?*Display, X.Drawable, [*c]const u8, c_uint, c_uint) X.Pixmap;
pub extern fn XCreatePixmapFromBitmapData(?*Display, X.Drawable, [*c]u8, c_uint, c_uint, c_ulong, c_ulong, c_uint) X.Pixmap;
pub extern fn XCreateSimpleWindow(?*Display, X.Window, c_int, c_int, c_uint, c_uint, c_uint, c_ulong, c_ulong) X.Window;
pub extern fn XGetSelectionOwner(?*Display, X.Atom) X.Window;
pub extern fn XCreateWindow(?*Display, X.Window, c_int, c_int, c_uint, c_uint, c_uint, c_int, c_uint, [*c]Visual, c_ulong, [*c]XSetWindowAttributes) X.Window;
pub extern fn XListInstalledColormaps(?*Display, X.Window, [*c]c_int) [*c]X.Colormap;
pub extern fn XListFonts(?*Display, [*c]const u8, c_int, [*c]c_int) [*c][*c]u8;
pub extern fn XListFontsWithInfo(?*Display, [*c]const u8, c_int, [*c]c_int, [*c][*c]XFontStruct) [*c][*c]u8;
pub extern fn XGetFontPath(?*Display, [*c]c_int) [*c][*c]u8;
pub extern fn XListExtensions(?*Display, [*c]c_int) [*c][*c]u8;
pub extern fn XListProperties(?*Display, X.Window, [*c]c_int) [*c]X.Atom;
pub extern fn XListHosts(?*Display, [*c]c_int, [*c]c_int) [*c]XHostAddress;
pub extern fn XKeycodeToKeysym(?*Display, X.KeyCode, c_int) X.KeySym;
pub extern fn XLookupKeysym([*c]XKeyEvent, c_int) X.KeySym;
pub extern fn XGetKeyboardMapping(?*Display, X.KeyCode, c_int, [*c]c_int) [*c]X.KeySym;
pub extern fn XStringToKeysym([*c]const u8) X.KeySym;
pub extern fn XMaxRequestSize(?*Display) c_long;
pub extern fn XExtendedMaxRequestSize(?*Display) c_long;
pub extern fn XResourceManagerString(?*Display) [*c]u8;
pub extern fn XScreenResourceString([*c]Screen) [*c]u8;
pub extern fn XDisplayMotionBufferSize(?*Display) c_ulong;
pub extern fn XVisualIDFromVisual([*c]Visual) X.VisualID;
pub extern fn XInitThreads() c_int;
pub extern fn XLockDisplay(?*Display) void;
pub extern fn XUnlockDisplay(?*Display) void;
pub extern fn XInitExtension(?*Display, [*c]const u8) [*c]XExtCodes;
pub extern fn XAddExtension(?*Display) [*c]XExtCodes;
pub extern fn XFindOnExtensionList([*c][*c]XExtData, c_int) [*c]XExtData;
pub extern fn XEHeadOfExtensionList(XEDataObject) [*c][*c]XExtData;
pub extern fn XRootWindow(?*Display, c_int) X.Window;
pub extern fn XDefaultRootWindow(?*Display) X.Window;
pub extern fn XRootWindowOfScreen([*c]Screen) X.Window;
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
pub extern fn XDefaultColormap(?*Display, c_int) X.Colormap;
pub extern fn XDefaultColormapOfScreen([*c]Screen) X.Colormap;
pub extern fn XDisplayOfScreen([*c]Screen) ?*Display;
pub extern fn XScreenOfDisplay(?*Display, c_int) [*c]Screen;
pub extern fn XDefaultScreenOfDisplay(?*Display) [*c]Screen;
pub extern fn XEventMaskOfScreen([*c]Screen) c_long;
pub extern fn XScreenNumberOfScreen([*c]Screen) c_int;
pub const XErrorHandler = ?fn (?*Display, [*c]XErrorEvent) callconv(.C) c_int;
pub extern fn XSetErrorHandler(XErrorHandler) XErrorHandler;
pub const XIOErrorHandler = ?fn (?*Display) callconv(.C) c_int;
pub extern fn XSetIOErrorHandler(XIOErrorHandler) XIOErrorHandler;
pub extern fn XSetIOErrorExitHandler(?*Display, XIOErrorExitHandler, ?*anyopaque) void;
pub extern fn XListPixmapFormats(?*Display, [*c]c_int) [*c]XPixmapFormatValues;
pub extern fn XListDepths(?*Display, c_int, [*c]c_int) [*c]c_int;
pub extern fn XReconfigureWMWindow(?*Display, X.Window, c_int, c_uint, [*c]XWindowChanges) c_int;
pub extern fn XGetWMProtocols(?*Display, X.Window, [*c][*c]X.Atom, [*c]c_int) c_int;
pub extern fn XSetWMProtocols(?*Display, X.Window, [*c]X.Atom, c_int) c_int;
pub extern fn XIconifyWindow(?*Display, X.Window, c_int) c_int;
pub extern fn XWithdrawWindow(?*Display, X.Window, c_int) c_int;
pub extern fn XGetCommand(?*Display, X.Window, [*c][*c][*c]u8, [*c]c_int) c_int;
pub extern fn XGetWMColormapWindows(?*Display, X.Window, [*c][*c]X.Window, [*c]c_int) c_int;
pub extern fn XSetWMColormapWindows(?*Display, X.Window, [*c]X.Window, c_int) c_int;
pub extern fn XFreeStringList([*c][*c]u8) void;
pub extern fn XSetTransientForHint(?*Display, X.Window, X.Window) c_int;
pub extern fn XActivateScreenSaver(?*Display) c_int;
pub extern fn XAddHost(?*Display, [*c]XHostAddress) c_int;
pub extern fn XAddHosts(?*Display, [*c]XHostAddress, c_int) c_int;
pub extern fn XAddToExtensionList([*c][*c]struct__XExtData, [*c]XExtData) c_int;
pub extern fn XAddToSaveSet(?*Display, X.Window) c_int;
pub extern fn XAllocColor(?*Display, X.Colormap, [*c]XColor) c_int;
pub extern fn XAllocColorCells(?*Display, X.Colormap, c_int, [*c]c_ulong, c_uint, [*c]c_ulong, c_uint) c_int;
pub extern fn XAllocColorPlanes(?*Display, X.Colormap, c_int, [*c]c_ulong, c_int, c_int, c_int, c_int, [*c]c_ulong, [*c]c_ulong, [*c]c_ulong) c_int;
pub extern fn XAllocNamedColor(?*Display, X.Colormap, [*c]const u8, [*c]XColor, [*c]XColor) c_int;
pub extern fn XAllowEvents(?*Display, c_int, X.Time) c_int;
pub extern fn XAutoRepeatOff(?*Display) c_int;
pub extern fn XAutoRepeatOn(?*Display) c_int;
pub extern fn XBell(?*Display, c_int) c_int;
pub extern fn XBitmapBitOrder(?*Display) c_int;
pub extern fn XBitmapPad(?*Display) c_int;
pub extern fn XBitmapUnit(?*Display) c_int;
pub extern fn XCellsOfScreen([*c]Screen) c_int;
pub extern fn XChangeActivePointerGrab(?*Display, c_uint, X.Cursor, X.Time) c_int;
pub extern fn XChangeGC(?*Display, GC, c_ulong, [*c]XGCValues) c_int;
pub extern fn XChangeKeyboardControl(?*Display, c_ulong, [*c]XKeyboardControl) c_int;
pub extern fn XChangeKeyboardMapping(?*Display, c_int, c_int, [*c]X.KeySym, c_int) c_int;
pub extern fn XChangePointerControl(?*Display, c_int, c_int, c_int, c_int, c_int) c_int;
pub extern fn XChangeProperty(?*Display, X.Window, X.Atom, X.Atom, c_int, c_int, [*c]const u8, c_int) c_int;
pub extern fn XChangeSaveSet(?*Display, X.Window, c_int) c_int;
pub extern fn XChangeWindowAttributes(?*Display, X.Window, c_ulong, [*c]XSetWindowAttributes) c_int;
pub extern fn XCheckIfEvent(?*Display, [*c]XEvent, ?fn (?*Display, [*c]XEvent, XPointer) callconv(.C) c_int, XPointer) c_int;
pub extern fn XCheckMaskEvent(?*Display, c_long, [*c]XEvent) c_int;
pub extern fn XCheckTypedEvent(?*Display, c_int, [*c]XEvent) c_int;
pub extern fn XCheckTypedWindowEvent(?*Display, X.Window, c_int, [*c]XEvent) c_int;
pub extern fn XCheckWindowEvent(?*Display, X.Window, c_long, [*c]XEvent) c_int;
pub extern fn XCirculateSubwindows(?*Display, X.Window, c_int) c_int;
pub extern fn XCirculateSubwindowsDown(?*Display, X.Window) c_int;
pub extern fn XCirculateSubwindowsUp(?*Display, X.Window) c_int;
pub extern fn XClearArea(?*Display, X.Window, c_int, c_int, c_uint, c_uint, c_int) c_int;
pub extern fn XClearWindow(?*Display, X.Window) c_int;
pub extern fn XCloseDisplay(?*Display) c_int;
pub extern fn XConfigureWindow(?*Display, X.Window, c_uint, [*c]XWindowChanges) c_int;
pub extern fn XConnectionNumber(?*Display) c_int;
pub extern fn XConvertSelection(?*Display, X.Atom, X.Atom, X.Atom, X.Window, X.Time) c_int;
pub extern fn XCopyArea(?*Display, X.Drawable, X.Drawable, GC, c_int, c_int, c_uint, c_uint, c_int, c_int) c_int;
pub extern fn XCopyGC(?*Display, GC, c_ulong, GC) c_int;
pub extern fn XCopyPlane(?*Display, X.Drawable, X.Drawable, GC, c_int, c_int, c_uint, c_uint, c_int, c_int, c_ulong) c_int;
pub extern fn XDefaultDepth(?*Display, c_int) c_int;
pub extern fn XDefaultDepthOfScreen([*c]Screen) c_int;
pub extern fn XDefaultScreen(?*Display) c_int;
pub extern fn XDefineCursor(?*Display, X.Window, X.Cursor) c_int;
pub extern fn XDeleteProperty(?*Display, X.Window, X.Atom) c_int;
pub extern fn XDestroyWindow(?*Display, X.Window) c_int;
pub extern fn XDestroySubwindows(?*Display, X.Window) c_int;
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
pub extern fn XDrawArc(?*Display, X.Drawable, GC, c_int, c_int, c_uint, c_uint, c_int, c_int) c_int;
pub extern fn XDrawArcs(?*Display, X.Drawable, GC, [*c]XArc, c_int) c_int;
pub extern fn XDrawImageString(?*Display, X.Drawable, GC, c_int, c_int, [*c]const u8, c_int) c_int;
pub extern fn XDrawImageString16(?*Display, X.Drawable, GC, c_int, c_int, [*c]const XChar2b, c_int) c_int;
pub extern fn XDrawLine(?*Display, X.Drawable, GC, c_int, c_int, c_int, c_int) c_int;
pub extern fn XDrawLines(?*Display, X.Drawable, GC, [*c]XPoint, c_int, c_int) c_int;
pub extern fn XDrawPoint(?*Display, X.Drawable, GC, c_int, c_int) c_int;
pub extern fn XDrawPoints(?*Display, X.Drawable, GC, [*c]XPoint, c_int, c_int) c_int;
pub extern fn XDrawRectangle(?*Display, X.Drawable, GC, c_int, c_int, c_uint, c_uint) c_int;
pub extern fn XDrawRectangles(?*Display, X.Drawable, GC, [*c]XRectangle, c_int) c_int;
pub extern fn XDrawSegments(?*Display, X.Drawable, GC, [*c]XSegment, c_int) c_int;
pub extern fn XDrawString(?*Display, X.Drawable, GC, c_int, c_int, [*c]const u8, c_int) c_int;
pub extern fn XDrawString16(?*Display, X.Drawable, GC, c_int, c_int, [*c]const XChar2b, c_int) c_int;
pub extern fn XDrawText(?*Display, X.Drawable, GC, c_int, c_int, [*c]XTextItem, c_int) c_int;
pub extern fn XDrawText16(?*Display, X.Drawable, GC, c_int, c_int, [*c]XTextItem16, c_int) c_int;
pub extern fn XEnableAccessControl(?*Display) c_int;
pub extern fn XEventsQueued(?*Display, c_int) c_int;
pub extern fn XFetchName(?*Display, X.Window, [*c][*c]u8) c_int;
pub extern fn XFillArc(?*Display, X.Drawable, GC, c_int, c_int, c_uint, c_uint, c_int, c_int) c_int;
pub extern fn XFillArcs(?*Display, X.Drawable, GC, [*c]XArc, c_int) c_int;
pub extern fn XFillPolygon(?*Display, X.Drawable, GC, [*c]XPoint, c_int, c_int, c_int) c_int;
pub extern fn XFillRectangle(?*Display, X.Drawable, GC, c_int, c_int, c_uint, c_uint) c_int;
pub extern fn XFillRectangles(?*Display, X.Drawable, GC, [*c]XRectangle, c_int) c_int;
pub extern fn XFlush(?*Display) c_int;
pub extern fn XForceScreenSaver(?*Display, c_int) c_int;
pub extern fn XFree(?*anyopaque) c_int;
pub extern fn XFreeColormap(?*Display, X.Colormap) c_int;
pub extern fn XFreeColors(?*Display, X.Colormap, [*c]c_ulong, c_int, c_ulong) c_int;
pub extern fn XFreeCursor(?*Display, X.Cursor) c_int;
pub extern fn XFreeExtensionList([*c][*c]u8) c_int;
pub extern fn XFreeFont(?*Display, [*c]XFontStruct) c_int;
pub extern fn XFreeFontInfo([*c][*c]u8, [*c]XFontStruct, c_int) c_int;
pub extern fn XFreeFontNames([*c][*c]u8) c_int;
pub extern fn XFreeFontPath([*c][*c]u8) c_int;
pub extern fn XFreeGC(?*Display, GC) c_int;
pub extern fn XFreeModifiermap([*c]XModifierKeymap) c_int;
pub extern fn XFreePixmap(?*Display, X.Pixmap) c_int;
pub extern fn XGeometry(?*Display, c_int, [*c]const u8, [*c]const u8, c_uint, c_uint, c_uint, c_int, c_int, [*c]c_int, [*c]c_int, [*c]c_int, [*c]c_int) c_int;
pub extern fn XGetErrorDatabaseText(?*Display, [*c]const u8, [*c]const u8, [*c]const u8, [*c]u8, c_int) c_int;
pub extern fn XGetErrorText(?*Display, c_int, [*c]u8, c_int) c_int;
pub extern fn XGetFontProperty([*c]XFontStruct, X.Atom, [*c]c_ulong) c_int;
pub extern fn XGetGCValues(?*Display, GC, c_ulong, [*c]XGCValues) c_int;
pub extern fn XGetGeometry(?*Display, X.Drawable, [*c]X.Window, [*c]c_int, [*c]c_int, [*c]c_uint, [*c]c_uint, [*c]c_uint, [*c]c_uint) c_int;
pub extern fn XGetIconName(?*Display, X.Window, [*c][*c]u8) c_int;
pub extern fn XGetInputFocus(?*Display, [*c]X.Window, [*c]c_int) c_int;
pub extern fn XGetKeyboardControl(?*Display, [*c]XKeyboardState) c_int;
pub extern fn XGetPointerControl(?*Display, [*c]c_int, [*c]c_int, [*c]c_int) c_int;
pub extern fn XGetPointerMapping(?*Display, [*c]u8, c_int) c_int;
pub extern fn XGetScreenSaver(?*Display, [*c]c_int, [*c]c_int, [*c]c_int, [*c]c_int) c_int;
pub extern fn XGetTransientForHint(?*Display, X.Window, [*c]X.Window) c_int;
pub extern fn XGetWindowProperty(?*Display, X.Window, X.Atom, c_long, c_long, c_int, X.Atom, [*c]X.Atom, [*c]c_int, [*c]c_ulong, [*c]c_ulong, [*c][*c]u8) c_int;
pub extern fn XGetWindowAttributes(?*Display, X.Window, [*c]XWindowAttributes) c_int;
pub extern fn XGrabButton(?*Display, c_uint, c_uint, X.Window, c_int, c_uint, c_int, c_int, X.Window, X.Cursor) c_int;
pub extern fn XGrabKey(?*Display, c_int, c_uint, X.Window, c_int, c_int, c_int) c_int;
pub extern fn XGrabKeyboard(?*Display, X.Window, c_int, c_int, c_int, X.Time) c_int;
pub extern fn XGrabPointer(?*Display, X.Window, c_int, c_uint, c_int, c_int, .XWindow, X.Cursor, X.Time) c_int;
pub extern fn XGrabServer(?*Display) c_int;
pub extern fn XHeightMMOfScreen([*c]Screen) c_int;
pub extern fn XHeightOfScreen([*c]Screen) c_int;
pub extern fn XIfEvent(?*Display, [*c]XEvent, ?fn (?*Display, [*c]XEvent, XPointer) callconv(.C) c_int, XPointer) c_int;
pub extern fn XImageByteOrder(?*Display) c_int;
pub extern fn XInstallColormap(?*Display, X.Colormap) c_int;
pub extern fn XKeysymToKeycode(?*Display, X.KeySym) X.KeyCode;
pub extern fn XKillClient(?*Display, X.XID) c_int;
pub extern fn XLookupColor(?*Display, X.Colormap, [*c]const u8, [*c]XColor, [*c]XColor) c_int;
pub extern fn XLowerWindow(?*Display, X.Window) c_int;
pub extern fn XMapRaised(?*Display, X.Window) c_int;
pub extern fn XMapSubwindows(?*Display, X.Window) c_int;
pub extern fn XMapWindow(?*Display, X.Window) c_int;
pub extern fn XMaskEvent(?*Display, c_long, [*c]XEvent) c_int;
pub extern fn XMaxCmapsOfScreen([*c]Screen) c_int;
pub extern fn XMinCmapsOfScreen([*c]Screen) c_int;
pub extern fn XMoveResizeWindow(?*Display, X.Window, c_int, c_int, c_uint, c_uint) c_int;
pub extern fn XMoveWindow(?*Display, X.Window, c_int, c_int) c_int;
pub extern fn XNextEvent(?*Display, [*c]XEvent) c_int;
pub extern fn XNoOp(?*Display) c_int;
pub extern fn XParseColor(?*Display, X.Colormap, [*c]const u8, [*c]XColor) c_int;
pub extern fn XParseGeometry([*c]const u8, [*c]c_int, [*c]c_int, [*c]c_uint, [*c]c_uint) c_int;
pub extern fn XPeekEvent(?*Display, [*c]XEvent) c_int;
pub extern fn XPeekIfEvent(?*Display, [*c]XEvent, ?fn (?*Display, [*c]XEvent, XPointer) callconv(.C) c_int, XPointer) c_int;
pub extern fn XPending(?*Display) c_int;
pub extern fn XPlanesOfScreen([*c]Screen) c_int;
pub extern fn XProtocolRevision(?*Display) c_int;
pub extern fn XProtocolVersion(?*Display) c_int;
pub extern fn XPutBackEvent(?*Display, [*c]XEvent) c_int;
pub extern fn XPutImage(?*Display, X.Drawable, GC, [*c]XImage, c_int, c_int, c_int, c_int, c_uint, c_uint) c_int;
pub extern fn XQLength(?*Display) c_int;
pub extern fn XQueryBestCursor(?*Display, X.Drawable, c_uint, c_uint, [*c]c_uint, [*c]c_uint) c_int;
pub extern fn XQueryBestSize(?*Display, c_int, X.Drawable, c_uint, c_uint, [*c]c_uint, [*c]c_uint) c_int;
pub extern fn XQueryBestStipple(?*Display, X.Drawable, c_uint, c_uint, [*c]c_uint, [*c]c_uint) c_int;
pub extern fn XQueryBestTile(?*Display, X.Drawable, c_uint, c_uint, [*c]c_uint, [*c]c_uint) c_int;
pub extern fn XQueryColor(?*Display, X.Colormap, [*c]XColor) c_int;
pub extern fn XQueryColors(?*Display, X.Colormap, [*c]XColor, c_int) c_int;
pub extern fn XQueryExtension(?*Display, [*c]const u8, [*c]c_int, [*c]c_int, [*c]c_int) c_int;
pub extern fn XQueryKeymap(?*Display, [*c]u8) c_int;
pub extern fn XQueryPointer(?*Display, X.Window, [*c]X.Window, [*c]X.Window, [*c]c_int, [*c]c_int, [*c]c_int, [*c]c_int, [*c]c_uint) c_int;
pub extern fn XQueryTextExtents(?*Display, X.XID, [*c]const u8, c_int, [*c]c_int, [*c]c_int, [*c]c_int, [*c]XCharStruct) c_int;
pub extern fn XQueryTextExtents16(?*Display, X.XID, [*c]const XChar2b, c_int, [*c]c_int, [*c]c_int, [*c]c_int, [*c]XCharStruct) c_int;
pub extern fn XQueryTree(?*Display, X.Window, [*c]X.Window, [*c]X.Window, [*c][*c]X.Window, [*c]c_uint) c_int;
pub extern fn XRaiseWindow(?*Display, X.Window) c_int;
pub extern fn XReadBitmapFile(?*Display, X.Drawable, [*c]const u8, [*c]c_uint, [*c]c_uint, [*c]X.Pixmap, [*c]c_int, [*c]c_int) c_int;
pub extern fn XReadBitmapFileData([*c]const u8, [*c]c_uint, [*c]c_uint, [*c][*c]u8, [*c]c_int, [*c]c_int) c_int;
pub extern fn XRebindKeysym(?*Display, X.KeySym, [*c]X.KeySym, c_int, [*c]const u8, c_int) c_int;
pub extern fn XRecolorCursor(?*Display, X.Cursor, [*c]XColor, [*c]XColor) c_int;
pub extern fn XRefreshKeyboardMapping([*c]XMappingEvent) c_int;
pub extern fn XRemoveFromSaveSet(?*Display, X.Window) c_int;
pub extern fn XRemoveHost(?*Display, [*c]XHostAddress) c_int;
pub extern fn XRemoveHosts(?*Display, [*c]XHostAddress, c_int) c_int;
pub extern fn XReparentWindow(?*Display, X.Window, X.Window, c_int, c_int) c_int;
pub extern fn XResetScreenSaver(?*Display) c_int;
pub extern fn XResizeWindow(?*Display, X.Window, c_uint, c_uint) c_int;
pub extern fn XRestackWindows(?*Display, [*c]X.Window, c_int) c_int;
pub extern fn XRotateBuffers(?*Display, c_int) c_int;
pub extern fn XRotateWindowProperties(?*Display, X.Window, [*c]X.Atom, c_int, c_int) c_int;
pub extern fn XScreenCount(?*Display) c_int;
pub extern fn XSelectInput(?*Display, X.Window, c_long) c_int;
pub extern fn XSendEvent(?*Display, X.Window, c_int, c_long, [*c]XEvent) c_int;
pub extern fn XSetAccessControl(?*Display, c_int) c_int;
pub extern fn XSetArcMode(?*Display, GC, c_int) c_int;
pub extern fn XSetBackground(?*Display, GC, c_ulong) c_int;
pub extern fn XSetClipMask(?*Display, GC, X.Pixmap) c_int;
pub extern fn XSetClipOrigin(?*Display, GC, c_int, c_int) c_int;
pub extern fn XSetClipRectangles(?*Display, GC, c_int, c_int, [*c]XRectangle, c_int, c_int) c_int;
pub extern fn XSetCloseDownMode(?*Display, c_int) c_int;
pub extern fn XSetCommand(?*Display, X.Window, [*c][*c]u8, c_int) c_int;
pub extern fn XSetDashes(?*Display, GC, c_int, [*c]const u8, c_int) c_int;
pub extern fn XSetFillRule(?*Display, GC, c_int) c_int;
pub extern fn XSetFillStyle(?*Display, GC, c_int) c_int;
pub extern fn XSetFont(?*Display, GC, X.Font) c_int;
pub extern fn XSetFontPath(?*Display, [*c][*c]u8, c_int) c_int;
pub extern fn XSetForeground(?*Display, GC, c_ulong) c_int;
pub extern fn XSetFunction(?*Display, GC, c_int) c_int;
pub extern fn XSetGraphicsExposures(?*Display, GC, c_int) c_int;
pub extern fn XSetIconName(?*Display, X.Window, [*c]const u8) c_int;
pub extern fn XSetInputFocus(?*Display, X.Window, c_int, X.Time) c_int;
pub extern fn XSetLineAttributes(?*Display, GC, c_uint, c_int, c_int, c_int) c_int;
pub extern fn XSetModifierMapping(?*Display, [*c]XModifierKeymap) c_int;
pub extern fn XSetPlaneMask(?*Display, GC, c_ulong) c_int;
pub extern fn XSetPointerMapping(?*Display, [*c]const u8, c_int) c_int;
pub extern fn XSetScreenSaver(?*Display, c_int, c_int, c_int, c_int) c_int;
pub extern fn XSetSelectionOwner(?*Display, X.Atom, X.Window, X.Time) c_int;
pub extern fn XSetState(?*Display, GC, c_ulong, c_ulong, c_int, c_ulong) c_int;
pub extern fn XSetStipple(?*Display, GC, X.Pixmap) c_int;
pub extern fn XSetSubwindowMode(?*Display, GC, c_int) c_int;
pub extern fn XSetTSOrigin(?*Display, GC, c_int, c_int) c_int;
pub extern fn XSetTile(?*Display, GC, X.Pixmap) c_int;
pub extern fn XSetWindowBackground(?*Display, X.Window, c_ulong) c_int;
pub extern fn XSetWindowBackgroundPixmap(?*Display, X.Window, X.Pixmap) c_int;
pub extern fn XSetWindowBorder(?*Display, X.Window, c_ulong) c_int;
pub extern fn XSetWindowBorderPixmap(?*Display, X.Window, X.Pixmap) c_int;
pub extern fn XSetWindowBorderWidth(?*Display, X.Window, c_uint) c_int;
pub extern fn XSetWindowColormap(?*Display, X.Window, X.Colormap) c_int;
pub extern fn XStoreBuffer(?*Display, [*c]const u8, c_int, c_int) c_int;
pub extern fn XStoreBytes(?*Display, [*c]const u8, c_int) c_int;
pub extern fn XStoreColor(?*Display, X.Colormap, [*c]XColor) c_int;
pub extern fn XStoreColors(?*Display, X.Colormap, [*c]XColor, c_int) c_int;
pub extern fn XStoreName(?*Display, X.Window, [*c]const u8) c_int;
pub extern fn XStoreNamedColor(?*Display, X.Colormap, [*c]const u8, c_ulong, c_int) c_int;
pub extern fn XSync(?*Display, c_int) c_int;
pub extern fn XTextExtents([*c]XFontStruct, [*c]const u8, c_int, [*c]c_int, [*c]c_int, [*c]c_int, [*c]XCharStruct) c_int;
pub extern fn XTextExtents16([*c]XFontStruct, [*c]const XChar2b, c_int, [*c]c_int, [*c]c_int, [*c]c_int, [*c]XCharStruct) c_int;
pub extern fn XTextWidth([*c]XFontStruct, [*c]const u8, c_int) c_int;
pub extern fn XTextWidth16([*c]XFontStruct, [*c]const XChar2b, c_int) c_int;
pub extern fn XTranslateCoordinates(?*Display, X.Window, X.Window, c_int, c_int, [*c]c_int, [*c]c_int, [*c]X.Window) c_int;
pub extern fn XUndefineCursor(?*Display, X.Window) c_int;
pub extern fn XUngrabButton(?*Display, c_uint, c_uint, X.Window) c_int;
pub extern fn XUngrabKey(?*Display, c_int, c_uint, X.Window) c_int;
pub extern fn XUngrabKeyboard(?*Display, X.Time) c_int;
pub extern fn XUngrabPointer(?*Display, X.Time) c_int;
pub extern fn XUngrabServer(?*Display) c_int;
pub extern fn XUninstallColormap(?*Display, X.Colormap) c_int;
pub extern fn XUnloadFont(?*Display, X.Font) c_int;
pub extern fn XUnmapSubwindows(?*Display, X.Window) c_int;
pub extern fn XUnmapWindow(?*Display, X.Window) c_int;
pub extern fn XVendorRelease(?*Display) c_int;
pub extern fn XWarpPointer(?*Display, X.Window, X.Window, c_int, c_int, c_uint, c_uint, c_int, c_int) c_int;
pub extern fn XWidthMMOfScreen([*c]Screen) c_int;
pub extern fn XWidthOfScreen([*c]Screen) c_int;
pub extern fn XWindowEvent(?*Display, X.Window, c_long, [*c]XEvent) c_int;
pub extern fn XWriteBitmapFile(?*Display, [*c]const u8, X.Pixmap, c_uint, c_uint, c_int, c_int) c_int;
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
pub extern fn XmbDrawText(?*Display, X.Drawable, GC, c_int, c_int, [*c]XmbTextItem, c_int) void;
pub extern fn XwcDrawText(?*Display, X.Drawable, GC, c_int, c_int, [*c]XwcTextItem, c_int) void;
pub extern fn Xutf8DrawText(?*Display, X.Drawable, GC, c_int, c_int, [*c]XmbTextItem, c_int) void;
pub extern fn XmbDrawString(?*Display, X.Drawable, XFontSet, GC, c_int, c_int, [*c]const u8, c_int) void;
pub extern fn XwcDrawString(?*Display, X.Drawable, XFontSet, GC, c_int, c_int, [*c]const wchar_t, c_int) void;
pub extern fn Xutf8DrawString(?*Display, X.Drawable, XFontSet, GC, c_int, c_int, [*c]const u8, c_int) void;
pub extern fn XmbDrawImageString(?*Display, X.Drawable, XFontSet, GC, c_int, c_int, [*c]const u8, c_int) void;
pub extern fn XwcDrawImageString(?*Display, X.Drawable, XFontSet, GC, c_int, c_int, [*c]const wchar_t, c_int) void;
pub extern fn Xutf8DrawImageString(?*Display, X.Drawable, XFontSet, GC, c_int, c_int, [*c]const u8, c_int) void;
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
pub extern fn XFilterEvent([*c]XEvent, X.Window) c_int;
pub extern fn XmbLookupString(XIC, [*c]XKeyPressedEvent, [*c]u8, c_int, [*c]X.KeySym, [*c]c_int) c_int;
pub extern fn XwcLookupString(XIC, [*c]XKeyPressedEvent, [*c]wchar_t, c_int, [*c]X.KeySym, [*c]c_int) c_int;
pub extern fn Xutf8LookupString(XIC, [*c]XKeyPressedEvent, [*c]u8, c_int, [*c]X.KeySym, [*c]c_int) c_int;
pub extern fn XVaCreateNestedList(c_int, ...) XVaNestedList;
pub extern fn XRegisterIMInstantiateCallback(?*Display, ?*struct__XrmHashBucketRec, [*c]u8, [*c]u8, X.XIDProc, XPointer) c_int;
pub extern fn XUnregisterIMInstantiateCallback(?*Display, ?*struct__XrmHashBucketRec, [*c]u8, [*c]u8, X.XIDProc, XPointer) c_int;
pub extern fn XInternalConnectionNumbers(?*Display, [*c][*c]c_int, [*c]c_int) c_int;
pub extern fn XProcessInternalConnection(?*Display, c_int) void;
pub extern fn XAddConnectionWatch(?*Display, XConnectionWatchProc, XPointer) c_int;
pub extern fn XRemoveConnectionWatch(?*Display, XConnectionWatchProc, XPointer) void;
pub extern fn XSetAuthorization([*c]u8, c_int, [*c]u8, c_int) void;
pub extern fn _Xmbtowc([*c]wchar_t, [*c]u8, c_int) c_int;
pub extern fn _Xwctomb([*c]u8, wchar_t) c_int;
pub extern fn XGetEventData(?*Display, [*c]XGenericEventCookie) c_int;
pub extern fn XFreeEventData(?*Display, [*c]XGenericEventCookie) void;

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
    tile: X.Pixmap,
    stipple: X.Pixmap,
    ts_x_origin: c_int,
    ts_y_origin: c_int,
    font: X.Font,
    subwindow_mode: c_int,
    graphics_exposures: c_int,
    clip_x_origin: c_int,
    clip_y_origin: c_int,
    clip_mask: X.Pixmap,
    dash_offset: c_int,
    dashes: u8,
};
pub const struct__XGC = opaque {};
pub const GC = ?*struct__XGC;
pub const Visual = extern struct {
    ext_data: [*c]XExtData,
    visualid: X.VisualID,
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
pub const Screen = extern struct {
    ext_data: [*c]XExtData,
    display: ?*struct__XDisplay,
    root: X.Window,
    width: c_int,
    height: c_int,
    mwidth: c_int,
    mheight: c_int,
    ndepths: c_int,
    depths: [*c]Depth,
    root_depth: c_int,
    root_visual: [*c]Visual,
    default_gc: GC,
    cmap: X.Colormap,
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
    background_pixmap: X.Pixmap,
    background_pixel: c_ulong,
    border_pixmap: X.Pixmap,
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
    colormap: X.Colormap,
    cursor: X.Cursor,
};
pub const XWindowAttributes = extern struct {
    x: c_int,
    y: c_int,
    width: c_int,
    height: c_int,
    border_width: c_int,
    depth: c_int,
    visual: [*c]Visual,
    root: X.Window,
    class: c_int,
    bit_gravity: c_int,
    win_gravity: c_int,
    backing_store: c_int,
    backing_planes: c_ulong,
    backing_pixel: c_ulong,
    save_under: c_int,
    colormap: X.Colormap,
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
    sibling: X.Window,
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
    time: X.Time,
    x: c_short,
    y: c_short,
};
pub const XModifierKeymap = extern struct {
    max_keypermod: c_int,
    modifiermap: [*c]X.KeyCode,
};
pub const Display = struct__XDisplay;
pub const struct__XrmHashBucketRec = opaque {};
const struct_unnamed_1 = extern struct {
    ext_data: [*c]XExtData,
    private1: ?*struct__XPrivate,
    fd: c_int,
    private2: c_int,
    proto_major_version: c_int,
    proto_minor_version: c_int,
    vendor: [*c]u8,
    private3: X.XID,
    private4: X.XID,
    private5: X.XID,
    private6: c_int,
    resource_alloc: ?fn (?*struct__XDisplay) callconv(.C) X.XID,
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
    window: X.Window,
    root: X.Window,
    subwindow: X.Window,
    time: X.Time,
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
    window: X.Window,
    root: X.Window,
    subwindow: X.Window,
    time: X.Time,
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
    window: X.Window,
    root: X.Window,
    subwindow: X.Window,
    time: X.Time,
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
    window: X.Window,
    root: X.Window,
    subwindow: X.Window,
    time: X.Time,
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
    window: X.Window,
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
    window: X.Window,
    key_vector: [32]u8,
};
pub const XExposeEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    window: X.Window,
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
    drawable: X.Drawable,
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
    drawable: X.Drawable,
    major_code: c_int,
    minor_code: c_int,
};
pub const XVisibilityEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    window: X.Window,
    state: c_int,
};
pub const XCreateWindowEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    parent: X.Window,
    window: X.Window,
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
    event: X.Window,
    window: X.Window,
};
pub const XUnmapEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    event: X.Window,
    window: X.Window,
    from_configure: c_int,
};
pub const XMapEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    event: X.Window,
    window: X.Window,
    override_redirect: c_int,
};
pub const XMapRequestEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    parent: X.Window,
    window: X.Window,
};
pub const XReparentEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    event: X.Window,
    window: X.Window,
    parent: X.Window,
    x: c_int,
    y: c_int,
    override_redirect: c_int,
};
pub const XConfigureEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    event: X.Window,
    window: X.Window,
    x: c_int,
    y: c_int,
    width: c_int,
    height: c_int,
    border_width: c_int,
    above: X.Window,
    override_redirect: c_int,
};
pub const XGravityEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    event: X.Window,
    window: X.Window,
    x: c_int,
    y: c_int,
};
pub const XResizeRequestEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    window: X.Window,
    width: c_int,
    height: c_int,
};
pub const XConfigureRequestEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    parent: X.Window,
    window: X.Window,
    x: c_int,
    y: c_int,
    width: c_int,
    height: c_int,
    border_width: c_int,
    above: X.Window,
    detail: c_int,
    value_mask: c_ulong,
};
pub const XCirculateEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    event: X.Window,
    window: X.Window,
    place: c_int,
};
pub const XCirculateRequestEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    parent: X.Window,
    window: X.Window,
    place: c_int,
};
pub const XPropertyEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    window: X.Window,
    atom: X.Atom,
    time: X.Time,
    state: c_int,
};
pub const XSelectionClearEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    window: X.Window,
    selection: X.Atom,
    time: X.Time,
};
pub const XSelectionRequestEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    owner: X.Window,
    requestor: X.Window,
    selection: X.Atom,
    target: X.Atom,
    property: X.Atom,
    time: X.Time,
};
pub const XSelectionEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    requestor: X.Window,
    selection: X.Atom,
    target: X.Atom,
    property: X.Atom,
    time: X.Time,
};
pub const XColormapEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    window: X.Window,
    colormap: X.Colormap,
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
    window: X.Window,
    message_type: X.Atom,
    format: c_int,
    data: union_unnamed_2,
};
pub const XMappingEvent = extern struct {
    type: c_int,
    serial: c_ulong,
    send_event: c_int,
    display: ?*Display,
    window: X.Window,
    request: c_int,
    first_keycode: c_int,
    count: c_int,
};
pub const XErrorEvent = extern struct {
    type: c_int,
    display: ?*Display,
    resourceid: X.XID,
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
    window: X.Window,
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
    name: X.Atom,
    card32: c_ulong,
};
pub const XFontStruct = extern struct {
    ext_data: [*c]XExtData,
    fid: X.Font,
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
    font: X.Font,
};
pub const XChar2b = extern struct {
    byte1: u8,
    byte2: u8,
};
pub const XTextItem16 = extern struct {
    chars: [*c]XChar2b,
    nchars: c_int,
    delta: c_int,
    font: X.Font,
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
    bitmap: X.Pixmap,
};
pub const struct__XIMStatusDrawCallbackStruct = extern struct {
    type: XIMStatusDataType,
    data: union_unnamed_5,
};
pub const XIMStatusDrawCallbackStruct = struct__XIMStatusDrawCallbackStruct;
pub const struct__XIMHotKeyTrigger = extern struct {
    keysym: X.KeySym,
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
pub const Bool = c_int;
pub const Status = c_int;
pub const True = @as(c_int, 1);
pub const False = @as(c_int, 0);
pub const QueuedAlready = @as(c_int, 0);
pub const QueuedAfterReading = @as(c_int, 1);
pub const QueuedAfterFlush = @as(c_int, 2);
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
pub const _XExtData = struct__XExtData;
pub const _XGC = struct__XGC;
pub const _XDisplay = struct__XDisplay;
pub const funcs = struct_funcs;
pub const _XImage = struct__XImage;
pub const _XPrivate = struct__XPrivate;
pub const _XrmHashBucketRec = struct__XrmHashBucketRec;
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

pub const INT64 = c_long;
pub const CARD64 = c_ulong;
pub const BITS32 = CARD32;
pub const BITS16 = CARD16;
pub const struct__xSegment = extern struct {
    x1: INT16,
    y1: INT16,
    x2: INT16,
    y2: INT16,
};
pub const xSegment = struct__xSegment;
pub const struct__xPoint = extern struct {
    x: INT16,
    y: INT16,
};
pub const xPoint = struct__xPoint;
pub const struct__xRectangle = extern struct {
    x: INT16,
    y: INT16,
    width: CARD16,
    height: CARD16,
};
pub const xRectangle = struct__xRectangle;
pub const struct__xArc = extern struct {
    x: INT16,
    y: INT16,
    width: CARD16,
    height: CARD16,
    angle1: INT16,
    angle2: INT16,
};
pub const xArc = struct__xArc;
pub const xConnClientPrefix = extern struct {
    byteOrder: CARD8,
    pad: BYTE,
    majorVersion: CARD16,
    minorVersion: CARD16,
    nbytesAuthProto: CARD16,
    nbytesAuthString: CARD16,
    pad2: CARD16,
};
pub const xConnSetupPrefix = extern struct {
    success: CARD8,
    lengthReason: BYTE,
    majorVersion: CARD16,
    minorVersion: CARD16,
    length: CARD16,
};
pub const xConnSetup = extern struct {
    release: CARD32,
    ridBase: CARD32,
    ridMask: CARD32,
    motionBufferSize: CARD32,
    nbytesVendor: CARD16,
    maxRequestSize: CARD16,
    numRoots: CARD8,
    numFormats: CARD8,
    imageByteOrder: CARD8,
    bitmapBitOrder: CARD8,
    bitmapScanlineUnit: CARD8,
    bitmapScanlinePad: CARD8,
    minKeyCode: CARD8,
    maxKeyCode: CARD8,
    pad2: CARD32,
};
pub const xPixmapFormat = extern struct {
    depth: CARD8,
    bitsPerPixel: CARD8,
    scanLinePad: CARD8,
    pad1: CARD8,
    pad2: CARD32,
};
pub const xDepth = extern struct {
    depth: CARD8,
    pad1: CARD8,
    nVisuals: CARD16,
    pad2: CARD32,
};
pub const xVisualType = extern struct {
    visualID: CARD32,
    class: CARD8,
    bitsPerRGB: CARD8,
    colormapEntries: CARD16,
    redMask: CARD32,
    greenMask: CARD32,
    blueMask: CARD32,
    pad: CARD32,
};
pub const xWindowRoot = extern struct {
    windowId: CARD32,
    defaultColormap: CARD32,
    whitePixel: CARD32,
    blackPixel: CARD32,
    currentInputMask: CARD32,
    pixWidth: CARD16,
    pixHeight: CARD16,
    mmWidth: CARD16,
    mmHeight: CARD16,
    minInstalledMaps: CARD16,
    maxInstalledMaps: CARD16,
    rootVisualID: CARD32,
    backingStore: CARD8,
    saveUnders: BOOL,
    rootDepth: CARD8,
    nDepths: CARD8,
};
pub const xTimecoord = extern struct {
    time: CARD32,
    x: INT16,
    y: INT16,
};
pub const xHostEntry = extern struct {
    family: CARD8,
    pad: BYTE,
    length: CARD16,
};
pub const xCharInfo = extern struct {
    leftSideBearing: INT16,
    rightSideBearing: INT16,
    characterWidth: INT16,
    ascent: INT16,
    descent: INT16,
    attributes: CARD16,
};
pub const xFontProp = extern struct {
    name: CARD32,
    value: CARD32,
};
pub const xTextElt = extern struct {
    len: CARD8,
    delta: INT8,
};
pub const xColorItem = extern struct {
    pixel: CARD32,
    red: CARD16,
    green: CARD16,
    blue: CARD16,
    flags: CARD8,
    pad: CARD8,
};
pub const xrgb = extern struct {
    red: CARD16,
    green: CARD16,
    blue: CARD16,
    pad: CARD16,
};
pub const KEYCODE = CARD8;
pub const xGenericReply = extern struct {
    type: BYTE,
    data1: BYTE,
    sequenceNumber: CARD16,
    length: CARD32,
    data00: CARD32,
    data01: CARD32,
    data02: CARD32,
    data03: CARD32,
    data04: CARD32,
    data05: CARD32,
};
pub const xGetWindowAttributesReply = extern struct {
    type: BYTE,
    backingStore: CARD8,
    sequenceNumber: CARD16,
    length: CARD32,
    visualID: CARD32,
    class: CARD16,
    bitGravity: CARD8,
    winGravity: CARD8,
    backingBitPlanes: CARD32,
    backingPixel: CARD32,
    saveUnder: BOOL,
    mapInstalled: BOOL,
    mapState: CARD8,
    override: BOOL,
    colormap: CARD32,
    allEventMasks: CARD32,
    yourEventMask: CARD32,
    doNotPropagateMask: CARD16,
    pad: CARD16,
};
pub const xGetGeometryReply = extern struct {
    type: BYTE,
    depth: CARD8,
    sequenceNumber: CARD16,
    length: CARD32,
    root: CARD32,
    x: INT16,
    y: INT16,
    width: CARD16,
    height: CARD16,
    borderWidth: CARD16,
    pad1: CARD16,
    pad2: CARD32,
    pad3: CARD32,
};
pub const xQueryTreeReply = extern struct {
    type: BYTE,
    pad1: BYTE,
    sequenceNumber: CARD16,
    length: CARD32,
    root: CARD32,
    parent: CARD32,
    nChildren: CARD16,
    pad2: CARD16,
    pad3: CARD32,
    pad4: CARD32,
    pad5: CARD32,
};
pub const xInternAtomReply = extern struct {
    type: BYTE,
    pad1: BYTE,
    sequenceNumber: CARD16,
    length: CARD32,
    atom: CARD32,
    pad2: CARD32,
    pad3: CARD32,
    pad4: CARD32,
    pad5: CARD32,
    pad6: CARD32,
};
pub const xGetAtomNameReply = extern struct {
    type: BYTE,
    pad1: BYTE,
    sequenceNumber: CARD16,
    length: CARD32,
    nameLength: CARD16,
    pad2: CARD16,
    pad3: CARD32,
    pad4: CARD32,
    pad5: CARD32,
    pad6: CARD32,
    pad7: CARD32,
};
pub const xGetPropertyReply = extern struct {
    type: BYTE,
    format: CARD8,
    sequenceNumber: CARD16,
    length: CARD32,
    propertyType: CARD32,
    bytesAfter: CARD32,
    nItems: CARD32,
    pad1: CARD32,
    pad2: CARD32,
    pad3: CARD32,
};
pub const xListPropertiesReply = extern struct {
    type: BYTE,
    pad1: BYTE,
    sequenceNumber: CARD16,
    length: CARD32,
    nProperties: CARD16,
    pad2: CARD16,
    pad3: CARD32,
    pad4: CARD32,
    pad5: CARD32,
    pad6: CARD32,
    pad7: CARD32,
};
pub const xGetSelectionOwnerReply = extern struct {
    type: BYTE,
    pad1: BYTE,
    sequenceNumber: CARD16,
    length: CARD32,
    owner: CARD32,
    pad2: CARD32,
    pad3: CARD32,
    pad4: CARD32,
    pad5: CARD32,
    pad6: CARD32,
};
pub const xGrabPointerReply = extern struct {
    type: BYTE,
    status: BYTE,
    sequenceNumber: CARD16,
    length: CARD32,
    pad1: CARD32,
    pad2: CARD32,
    pad3: CARD32,
    pad4: CARD32,
    pad5: CARD32,
    pad6: CARD32,
};
pub const xGrabKeyboardReply = xGrabPointerReply;
pub const xQueryPointerReply = extern struct {
    type: BYTE,
    sameScreen: BOOL,
    sequenceNumber: CARD16,
    length: CARD32,
    root: CARD32,
    child: CARD32,
    rootX: INT16,
    rootY: INT16,
    winX: INT16,
    winY: INT16,
    mask: CARD16,
    pad1: CARD16,
    pad: CARD32,
};
pub const xGetMotionEventsReply = extern struct {
    type: BYTE,
    pad1: BYTE,
    sequenceNumber: CARD16,
    length: CARD32,
    nEvents: CARD32,
    pad2: CARD32,
    pad3: CARD32,
    pad4: CARD32,
    pad5: CARD32,
    pad6: CARD32,
};
pub const xTranslateCoordsReply = extern struct {
    type: BYTE,
    sameScreen: BOOL,
    sequenceNumber: CARD16,
    length: CARD32,
    child: CARD32,
    dstX: INT16,
    dstY: INT16,
    pad2: CARD32,
    pad3: CARD32,
    pad4: CARD32,
    pad5: CARD32,
};
pub const xGetInputFocusReply = extern struct {
    type: BYTE,
    revertTo: CARD8,
    sequenceNumber: CARD16,
    length: CARD32,
    focus: CARD32,
    pad1: CARD32,
    pad2: CARD32,
    pad3: CARD32,
    pad4: CARD32,
    pad5: CARD32,
};
pub const xQueryKeymapReply = extern struct {
    type: BYTE,
    pad1: BYTE,
    sequenceNumber: CARD16,
    length: CARD32,
    map: [32]BYTE,
};
pub const struct__xQueryFontReply = extern struct {
    type: BYTE,
    pad1: BYTE,
    sequenceNumber: CARD16,
    length: CARD32,
    minBounds: xCharInfo,
    walign1: CARD32,
    maxBounds: xCharInfo,
    walign2: CARD32,
    minCharOrByte2: CARD16,
    maxCharOrByte2: CARD16,
    defaultChar: CARD16,
    nFontProps: CARD16,
    drawDirection: CARD8,
    minByte1: CARD8,
    maxByte1: CARD8,
    allCharsExist: BOOL,
    fontAscent: INT16,
    fontDescent: INT16,
    nCharInfos: CARD32,
};
pub const xQueryFontReply = struct__xQueryFontReply;
pub const xQueryTextExtentsReply = extern struct {
    type: BYTE,
    drawDirection: CARD8,
    sequenceNumber: CARD16,
    length: CARD32,
    fontAscent: INT16,
    fontDescent: INT16,
    overallAscent: INT16,
    overallDescent: INT16,
    overallWidth: INT32,
    overallLeft: INT32,
    overallRight: INT32,
    pad: CARD32,
};
pub const xListFontsReply = extern struct {
    type: BYTE,
    pad1: BYTE,
    sequenceNumber: CARD16,
    length: CARD32,
    nFonts: CARD16,
    pad2: CARD16,
    pad3: CARD32,
    pad4: CARD32,
    pad5: CARD32,
    pad6: CARD32,
    pad7: CARD32,
};
pub const xListFontsWithInfoReply = extern struct {
    type: BYTE,
    nameLength: CARD8,
    sequenceNumber: CARD16,
    length: CARD32,
    minBounds: xCharInfo,
    walign1: CARD32,
    maxBounds: xCharInfo,
    walign2: CARD32,
    minCharOrByte2: CARD16,
    maxCharOrByte2: CARD16,
    defaultChar: CARD16,
    nFontProps: CARD16,
    drawDirection: CARD8,
    minByte1: CARD8,
    maxByte1: CARD8,
    allCharsExist: BOOL,
    fontAscent: INT16,
    fontDescent: INT16,
    nReplies: CARD32,
};
pub const xGetFontPathReply = extern struct {
    type: BYTE,
    pad1: BYTE,
    sequenceNumber: CARD16,
    length: CARD32,
    nPaths: CARD16,
    pad2: CARD16,
    pad3: CARD32,
    pad4: CARD32,
    pad5: CARD32,
    pad6: CARD32,
    pad7: CARD32,
};
pub const xGetImageReply = extern struct {
    type: BYTE,
    depth: CARD8,
    sequenceNumber: CARD16,
    length: CARD32,
    visual: CARD32,
    pad3: CARD32,
    pad4: CARD32,
    pad5: CARD32,
    pad6: CARD32,
    pad7: CARD32,
};
pub const xListInstalledColormapsReply = extern struct {
    type: BYTE,
    pad1: BYTE,
    sequenceNumber: CARD16,
    length: CARD32,
    nColormaps: CARD16,
    pad2: CARD16,
    pad3: CARD32,
    pad4: CARD32,
    pad5: CARD32,
    pad6: CARD32,
    pad7: CARD32,
};
pub const xAllocColorReply = extern struct {
    type: BYTE,
    pad1: BYTE,
    sequenceNumber: CARD16,
    length: CARD32,
    red: CARD16,
    green: CARD16,
    blue: CARD16,
    pad2: CARD16,
    pixel: CARD32,
    pad3: CARD32,
    pad4: CARD32,
    pad5: CARD32,
};
pub const xAllocNamedColorReply = extern struct {
    type: BYTE,
    pad1: BYTE,
    sequenceNumber: CARD16,
    length: CARD32,
    pixel: CARD32,
    exactRed: CARD16,
    exactGreen: CARD16,
    exactBlue: CARD16,
    screenRed: CARD16,
    screenGreen: CARD16,
    screenBlue: CARD16,
    pad2: CARD32,
    pad3: CARD32,
};
pub const xAllocColorCellsReply = extern struct {
    type: BYTE,
    pad1: BYTE,
    sequenceNumber: CARD16,
    length: CARD32,
    nPixels: CARD16,
    nMasks: CARD16,
    pad3: CARD32,
    pad4: CARD32,
    pad5: CARD32,
    pad6: CARD32,
    pad7: CARD32,
};
pub const xAllocColorPlanesReply = extern struct {
    type: BYTE,
    pad1: BYTE,
    sequenceNumber: CARD16,
    length: CARD32,
    nPixels: CARD16,
    pad2: CARD16,
    redMask: CARD32,
    greenMask: CARD32,
    blueMask: CARD32,
    pad3: CARD32,
    pad4: CARD32,
};
pub const xQueryColorsReply = extern struct {
    type: BYTE,
    pad1: BYTE,
    sequenceNumber: CARD16,
    length: CARD32,
    nColors: CARD16,
    pad2: CARD16,
    pad3: CARD32,
    pad4: CARD32,
    pad5: CARD32,
    pad6: CARD32,
    pad7: CARD32,
};
pub const xLookupColorReply = extern struct {
    type: BYTE,
    pad1: BYTE,
    sequenceNumber: CARD16,
    length: CARD32,
    exactRed: CARD16,
    exactGreen: CARD16,
    exactBlue: CARD16,
    screenRed: CARD16,
    screenGreen: CARD16,
    screenBlue: CARD16,
    pad3: CARD32,
    pad4: CARD32,
    pad5: CARD32,
};
pub const xQueryBestSizeReply = extern struct {
    type: BYTE,
    pad1: BYTE,
    sequenceNumber: CARD16,
    length: CARD32,
    width: CARD16,
    height: CARD16,
    pad3: CARD32,
    pad4: CARD32,
    pad5: CARD32,
    pad6: CARD32,
    pad7: CARD32,
};
pub const xQueryExtensionReply = extern struct {
    type: BYTE,
    pad1: BYTE,
    sequenceNumber: CARD16,
    length: CARD32,
    present: BOOL,
    major_opcode: CARD8,
    first_event: CARD8,
    first_error: CARD8,
    pad3: CARD32,
    pad4: CARD32,
    pad5: CARD32,
    pad6: CARD32,
    pad7: CARD32,
};
pub const xListExtensionsReply = extern struct {
    type: BYTE,
    nExtensions: CARD8,
    sequenceNumber: CARD16,
    length: CARD32,
    pad2: CARD32,
    pad3: CARD32,
    pad4: CARD32,
    pad5: CARD32,
    pad6: CARD32,
    pad7: CARD32,
};
pub const xSetMappingReply = extern struct {
    type: BYTE,
    success: CARD8,
    sequenceNumber: CARD16,
    length: CARD32,
    pad2: CARD32,
    pad3: CARD32,
    pad4: CARD32,
    pad5: CARD32,
    pad6: CARD32,
    pad7: CARD32,
};
pub const xSetPointerMappingReply = xSetMappingReply;
pub const xSetModifierMappingReply = xSetMappingReply;
pub const xGetPointerMappingReply = extern struct {
    type: BYTE,
    nElts: CARD8,
    sequenceNumber: CARD16,
    length: CARD32,
    pad2: CARD32,
    pad3: CARD32,
    pad4: CARD32,
    pad5: CARD32,
    pad6: CARD32,
    pad7: CARD32,
};
pub const xGetKeyboardMappingReply = extern struct {
    type: BYTE,
    keySymsPerKeyCode: CARD8,
    sequenceNumber: CARD16,
    length: CARD32,
    pad2: CARD32,
    pad3: CARD32,
    pad4: CARD32,
    pad5: CARD32,
    pad6: CARD32,
    pad7: CARD32,
};
pub const xGetModifierMappingReply = extern struct {
    type: BYTE,
    numKeyPerModifier: CARD8,
    sequenceNumber: CARD16,
    length: CARD32,
    pad1: CARD32,
    pad2: CARD32,
    pad3: CARD32,
    pad4: CARD32,
    pad5: CARD32,
    pad6: CARD32,
};
pub const xGetKeyboardControlReply = extern struct {
    type: BYTE,
    globalAutoRepeat: BOOL,
    sequenceNumber: CARD16,
    length: CARD32,
    ledMask: CARD32,
    keyClickPercent: CARD8,
    bellPercent: CARD8,
    bellPitch: CARD16,
    bellDuration: CARD16,
    pad: CARD16,
    map: [32]BYTE,
};
pub const xGetPointerControlReply = extern struct {
    type: BYTE,
    pad1: BYTE,
    sequenceNumber: CARD16,
    length: CARD32,
    accelNumerator: CARD16,
    accelDenominator: CARD16,
    threshold: CARD16,
    pad2: CARD16,
    pad3: CARD32,
    pad4: CARD32,
    pad5: CARD32,
    pad6: CARD32,
};
pub const xGetScreenSaverReply = extern struct {
    type: BYTE,
    pad1: BYTE,
    sequenceNumber: CARD16,
    length: CARD32,
    timeout: CARD16,
    interval: CARD16,
    preferBlanking: BOOL,
    allowExposures: BOOL,
    pad2: CARD16,
    pad3: CARD32,
    pad4: CARD32,
    pad5: CARD32,
    pad6: CARD32,
};
pub const xListHostsReply = extern struct {
    type: BYTE,
    enabled: BOOL,
    sequenceNumber: CARD16,
    length: CARD32,
    nHosts: CARD16,
    pad1: CARD16,
    pad3: CARD32,
    pad4: CARD32,
    pad5: CARD32,
    pad6: CARD32,
    pad7: CARD32,
};
pub const xError = extern struct {
    type: BYTE,
    errorCode: BYTE,
    sequenceNumber: CARD16,
    resourceID: CARD32,
    minorCode: CARD16,
    majorCode: CARD8,
    pad1: BYTE,
    pad3: CARD32,
    pad4: CARD32,
    pad5: CARD32,
    pad6: CARD32,
    pad7: CARD32,
};
pub const xGenericEvent = extern struct {
    type: BYTE,
    extension: CARD8,
    sequenceNumber: CARD16,
    length: CARD32,
    evtype: CARD16,
    pad2: CARD16,
    pad3: CARD32,
    pad4: CARD32,
    pad5: CARD32,
    pad6: CARD32,
    pad7: CARD32,
};
pub const xKeymapEvent = extern struct {
    type: BYTE,
    map: [31]BYTE,
};
pub const xReply = extern union {
    generic: xGenericReply,
    geom: xGetGeometryReply,
    tree: xQueryTreeReply,
    atom: xInternAtomReply,
    atomName: xGetAtomNameReply,
    property: xGetPropertyReply,
    listProperties: xListPropertiesReply,
    selection: xGetSelectionOwnerReply,
    grabPointer: xGrabPointerReply,
    grabKeyboard: xGrabKeyboardReply,
    pointer: xQueryPointerReply,
    motionEvents: xGetMotionEventsReply,
    coords: xTranslateCoordsReply,
    inputFocus: xGetInputFocusReply,
    textExtents: xQueryTextExtentsReply,
    fonts: xListFontsReply,
    fontPath: xGetFontPathReply,
    image: xGetImageReply,
    colormaps: xListInstalledColormapsReply,
    allocColor: xAllocColorReply,
    allocNamedColor: xAllocNamedColorReply,
    colorCells: xAllocColorCellsReply,
    colorPlanes: xAllocColorPlanesReply,
    colors: xQueryColorsReply,
    lookupColor: xLookupColorReply,
    bestSize: xQueryBestSizeReply,
    extension: xQueryExtensionReply,
    extensions: xListExtensionsReply,
    setModifierMapping: xSetModifierMappingReply,
    getModifierMapping: xGetModifierMappingReply,
    setPointerMapping: xSetPointerMappingReply,
    getKeyboardMapping: xGetKeyboardMappingReply,
    getPointerMapping: xGetPointerMappingReply,
    pointerControl: xGetPointerControlReply,
    screenSaver: xGetScreenSaverReply,
    hosts: xListHostsReply,
    @"error": xError,
    event: xEvent,
};
pub const struct__xReq = extern struct {
    reqType: CARD8,
    data: CARD8,
    length: CARD16,
};
pub const xReq = struct__xReq;
pub const xResourceReq = extern struct {
    reqType: CARD8,
    pad: BYTE,
    length: CARD16,
    id: CARD32,
};
pub const xCreateWindowReq = extern struct {
    reqType: CARD8,
    depth: CARD8,
    length: CARD16,
    wid: CARD32,
    parent: CARD32,
    x: INT16,
    y: INT16,
    width: CARD16,
    height: CARD16,
    borderWidth: CARD16,
    class: CARD16,
    visual: CARD32,
    mask: CARD32,
};
pub const xChangeWindowAttributesReq = extern struct {
    reqType: CARD8,
    pad: BYTE,
    length: CARD16,
    window: CARD32,
    valueMask: CARD32,
};
pub const xChangeSaveSetReq = extern struct {
    reqType: CARD8,
    mode: BYTE,
    length: CARD16,
    window: CARD32,
};
pub const xReparentWindowReq = extern struct {
    reqType: CARD8,
    pad: BYTE,
    length: CARD16,
    window: CARD32,
    parent: CARD32,
    x: INT16,
    y: INT16,
};
pub const xConfigureWindowReq = extern struct {
    reqType: CARD8,
    pad: CARD8,
    length: CARD16,
    window: CARD32,
    mask: CARD16,
    pad2: CARD16,
};
pub const xCirculateWindowReq = extern struct {
    reqType: CARD8,
    direction: CARD8,
    length: CARD16,
    window: CARD32,
};
pub const xInternAtomReq = extern struct {
    reqType: CARD8,
    onlyIfExists: BOOL,
    length: CARD16,
    nbytes: CARD16,
    pad: CARD16,
};
pub const xChangePropertyReq = extern struct {
    reqType: CARD8,
    mode: CARD8,
    length: CARD16,
    window: CARD32,
    property: CARD32,
    type: CARD32,
    format: CARD8,
    pad: [3]BYTE,
    nUnits: CARD32,
};
pub const xDeletePropertyReq = extern struct {
    reqType: CARD8,
    pad: BYTE,
    length: CARD16,
    window: CARD32,
    property: CARD32,
};
pub const xGetPropertyReq = extern struct {
    reqType: CARD8,
    delete: BOOL,
    length: CARD16,
    window: CARD32,
    property: CARD32,
    type: CARD32,
    longOffset: CARD32,
    longLength: CARD32,
};
pub const xSetSelectionOwnerReq = extern struct {
    reqType: CARD8,
    pad: BYTE,
    length: CARD16,
    window: CARD32,
    selection: CARD32,
    time: CARD32,
};
pub const xConvertSelectionReq = extern struct {
    reqType: CARD8,
    pad: BYTE,
    length: CARD16,
    requestor: CARD32,
    selection: CARD32,
    target: CARD32,
    property: CARD32,
    time: CARD32,
};
pub const xSendEventReq = extern struct {
    reqType: CARD8,
    propagate: BOOL,
    length: CARD16,
    destination: CARD32,
    eventMask: CARD32,
    event: xEvent,
};
pub const xGrabPointerReq = extern struct {
    reqType: CARD8,
    ownerEvents: BOOL,
    length: CARD16,
    grabWindow: CARD32,
    eventMask: CARD16,
    pointerMode: BYTE,
    keyboardMode: BYTE,
    confineTo: CARD32,
    cursor: CARD32,
    time: CARD32,
};
pub const xGrabButtonReq = extern struct {
    reqType: CARD8,
    ownerEvents: BOOL,
    length: CARD16,
    grabWindow: CARD32,
    eventMask: CARD16,
    pointerMode: BYTE,
    keyboardMode: BYTE,
    confineTo: CARD32,
    cursor: CARD32,
    button: CARD8,
    pad: BYTE,
    modifiers: CARD16,
};
pub const xUngrabButtonReq = extern struct {
    reqType: CARD8,
    button: CARD8,
    length: CARD16,
    grabWindow: CARD32,
    modifiers: CARD16,
    pad: CARD16,
};
pub const xChangeActivePointerGrabReq = extern struct {
    reqType: CARD8,
    pad: BYTE,
    length: CARD16,
    cursor: CARD32,
    time: CARD32,
    eventMask: CARD16,
    pad2: CARD16,
};
pub const xGrabKeyboardReq = extern struct {
    reqType: CARD8,
    ownerEvents: BOOL,
    length: CARD16,
    grabWindow: CARD32,
    time: CARD32,
    pointerMode: BYTE,
    keyboardMode: BYTE,
    pad: CARD16,
};
pub const xGrabKeyReq = extern struct {
    reqType: CARD8,
    ownerEvents: BOOL,
    length: CARD16,
    grabWindow: CARD32,
    modifiers: CARD16,
    key: CARD8,
    pointerMode: BYTE,
    keyboardMode: BYTE,
    pad1: BYTE,
    pad2: BYTE,
    pad3: BYTE,
};
pub const xUngrabKeyReq = extern struct {
    reqType: CARD8,
    key: CARD8,
    length: CARD16,
    grabWindow: CARD32,
    modifiers: CARD16,
    pad: CARD16,
};
pub const xAllowEventsReq = extern struct {
    reqType: CARD8,
    mode: CARD8,
    length: CARD16,
    time: CARD32,
};
pub const xGetMotionEventsReq = extern struct {
    reqType: CARD8,
    pad: BYTE,
    length: CARD16,
    window: CARD32,
    start: CARD32,
    stop: CARD32,
};
pub const xTranslateCoordsReq = extern struct {
    reqType: CARD8,
    pad: BYTE,
    length: CARD16,
    srcWid: CARD32,
    dstWid: CARD32,
    srcX: INT16,
    srcY: INT16,
};
pub const xWarpPointerReq = extern struct {
    reqType: CARD8,
    pad: BYTE,
    length: CARD16,
    srcWid: CARD32,
    dstWid: CARD32,
    srcX: INT16,
    srcY: INT16,
    srcWidth: CARD16,
    srcHeight: CARD16,
    dstX: INT16,
    dstY: INT16,
};
pub const xSetInputFocusReq = extern struct {
    reqType: CARD8,
    revertTo: CARD8,
    length: CARD16,
    focus: CARD32,
    time: CARD32,
};
pub const xOpenFontReq = extern struct {
    reqType: CARD8,
    pad: BYTE,
    length: CARD16,
    fid: CARD32,
    nbytes: CARD16,
    pad1: BYTE,
    pad2: BYTE,
};
pub const xQueryTextExtentsReq = extern struct {
    reqType: CARD8,
    oddLength: BOOL,
    length: CARD16,
    fid: CARD32,
};
pub const xListFontsReq = extern struct {
    reqType: CARD8,
    pad: BYTE,
    length: CARD16,
    maxNames: CARD16,
    nbytes: CARD16,
};
pub const xListFontsWithInfoReq = xListFontsReq;
pub const xSetFontPathReq = extern struct {
    reqType: CARD8,
    pad: BYTE,
    length: CARD16,
    nFonts: CARD16,
    pad1: BYTE,
    pad2: BYTE,
};
pub const xCreatePixmapReq = extern struct {
    reqType: CARD8,
    depth: CARD8,
    length: CARD16,
    pid: CARD32,
    drawable: CARD32,
    width: CARD16,
    height: CARD16,
};
pub const xCreateGCReq = extern struct {
    reqType: CARD8,
    pad: BYTE,
    length: CARD16,
    gc: CARD32,
    drawable: CARD32,
    mask: CARD32,
};
pub const xChangeGCReq = extern struct {
    reqType: CARD8,
    pad: BYTE,
    length: CARD16,
    gc: CARD32,
    mask: CARD32,
};
pub const xCopyGCReq = extern struct {
    reqType: CARD8,
    pad: BYTE,
    length: CARD16,
    srcGC: CARD32,
    dstGC: CARD32,
    mask: CARD32,
};
pub const xSetDashesReq = extern struct {
    reqType: CARD8,
    pad: BYTE,
    length: CARD16,
    gc: CARD32,
    dashOffset: CARD16,
    nDashes: CARD16,
};
pub const xSetClipRectanglesReq = extern struct {
    reqType: CARD8,
    ordering: BYTE,
    length: CARD16,
    gc: CARD32,
    xOrigin: INT16,
    yOrigin: INT16,
};
pub const xClearAreaReq = extern struct {
    reqType: CARD8,
    exposures: BOOL,
    length: CARD16,
    window: CARD32,
    x: INT16,
    y: INT16,
    width: CARD16,
    height: CARD16,
};
pub const xCopyAreaReq = extern struct {
    reqType: CARD8,
    pad: BYTE,
    length: CARD16,
    srcDrawable: CARD32,
    dstDrawable: CARD32,
    gc: CARD32,
    srcX: INT16,
    srcY: INT16,
    dstX: INT16,
    dstY: INT16,
    width: CARD16,
    height: CARD16,
};
pub const xCopyPlaneReq = extern struct {
    reqType: CARD8,
    pad: BYTE,
    length: CARD16,
    srcDrawable: CARD32,
    dstDrawable: CARD32,
    gc: CARD32,
    srcX: INT16,
    srcY: INT16,
    dstX: INT16,
    dstY: INT16,
    width: CARD16,
    height: CARD16,
    bitPlane: CARD32,
};
pub const xPolyPointReq = extern struct {
    reqType: CARD8,
    coordMode: BYTE,
    length: CARD16,
    drawable: CARD32,
    gc: CARD32,
};
pub const xPolyLineReq = xPolyPointReq;
pub const xPolySegmentReq = extern struct {
    reqType: CARD8,
    pad: BYTE,
    length: CARD16,
    drawable: CARD32,
    gc: CARD32,
};
pub const xPolyArcReq = xPolySegmentReq;
pub const xPolyRectangleReq = xPolySegmentReq;
pub const xPolyFillRectangleReq = xPolySegmentReq;
pub const xPolyFillArcReq = xPolySegmentReq;
pub const struct__FillPolyReq = extern struct {
    reqType: CARD8,
    pad: BYTE,
    length: CARD16,
    drawable: CARD32,
    gc: CARD32,
    shape: BYTE,
    coordMode: BYTE,
    pad1: CARD16,
};
pub const xFillPolyReq = struct__FillPolyReq;
pub const struct__PutImageReq = extern struct {
    reqType: CARD8,
    format: CARD8,
    length: CARD16,
    drawable: CARD32,
    gc: CARD32,
    width: CARD16,
    height: CARD16,
    dstX: INT16,
    dstY: INT16,
    leftPad: CARD8,
    depth: CARD8,
    pad: CARD16,
};
pub const xPutImageReq = struct__PutImageReq;
pub const xGetImageReq = extern struct {
    reqType: CARD8,
    format: CARD8,
    length: CARD16,
    drawable: CARD32,
    x: INT16,
    y: INT16,
    width: CARD16,
    height: CARD16,
    planeMask: CARD32,
};
pub const xPolyTextReq = extern struct {
    reqType: CARD8,
    pad: CARD8,
    length: CARD16,
    drawable: CARD32,
    gc: CARD32,
    x: INT16,
    y: INT16,
};
pub const xPolyText8Req = xPolyTextReq;
pub const xPolyText16Req = xPolyTextReq;
pub const xImageTextReq = extern struct {
    reqType: CARD8,
    nChars: BYTE,
    length: CARD16,
    drawable: CARD32,
    gc: CARD32,
    x: INT16,
    y: INT16,
};
pub const xImageText8Req = xImageTextReq;
pub const xImageText16Req = xImageTextReq;
pub const xCreateColormapReq = extern struct {
    reqType: CARD8,
    alloc: BYTE,
    length: CARD16,
    mid: CARD32,
    window: CARD32,
    visual: CARD32,
};
pub const xCopyColormapAndFreeReq = extern struct {
    reqType: CARD8,
    pad: BYTE,
    length: CARD16,
    mid: CARD32,
    srcCmap: CARD32,
};
pub const xAllocColorReq = extern struct {
    reqType: CARD8,
    pad: BYTE,
    length: CARD16,
    cmap: CARD32,
    red: CARD16,
    green: CARD16,
    blue: CARD16,
    pad2: CARD16,
};
pub const xAllocNamedColorReq = extern struct {
    reqType: CARD8,
    pad: BYTE,
    length: CARD16,
    cmap: CARD32,
    nbytes: CARD16,
    pad1: BYTE,
    pad2: BYTE,
};
pub const xAllocColorCellsReq = extern struct {
    reqType: CARD8,
    contiguous: BOOL,
    length: CARD16,
    cmap: CARD32,
    colors: CARD16,
    planes: CARD16,
};
pub const xAllocColorPlanesReq = extern struct {
    reqType: CARD8,
    contiguous: BOOL,
    length: CARD16,
    cmap: CARD32,
    colors: CARD16,
    red: CARD16,
    green: CARD16,
    blue: CARD16,
};
pub const xFreeColorsReq = extern struct {
    reqType: CARD8,
    pad: BYTE,
    length: CARD16,
    cmap: CARD32,
    planeMask: CARD32,
};
pub const xStoreColorsReq = extern struct {
    reqType: CARD8,
    pad: BYTE,
    length: CARD16,
    cmap: CARD32,
};
pub const xStoreNamedColorReq = extern struct {
    reqType: CARD8,
    flags: CARD8,
    length: CARD16,
    cmap: CARD32,
    pixel: CARD32,
    nbytes: CARD16,
    pad1: BYTE,
    pad2: BYTE,
};
pub const xQueryColorsReq = extern struct {
    reqType: CARD8,
    pad: BYTE,
    length: CARD16,
    cmap: CARD32,
};
pub const xLookupColorReq = extern struct {
    reqType: CARD8,
    pad: BYTE,
    length: CARD16,
    cmap: CARD32,
    nbytes: CARD16,
    pad1: BYTE,
    pad2: BYTE,
};
pub const xCreateCursorReq = extern struct {
    reqType: CARD8,
    pad: BYTE,
    length: CARD16,
    cid: CARD32,
    source: CARD32,
    mask: CARD32,
    foreRed: CARD16,
    foreGreen: CARD16,
    foreBlue: CARD16,
    backRed: CARD16,
    backGreen: CARD16,
    backBlue: CARD16,
    x: CARD16,
    y: CARD16,
};
pub const xCreateGlyphCursorReq = extern struct {
    reqType: CARD8,
    pad: BYTE,
    length: CARD16,
    cid: CARD32,
    source: CARD32,
    mask: CARD32,
    sourceChar: CARD16,
    maskChar: CARD16,
    foreRed: CARD16,
    foreGreen: CARD16,
    foreBlue: CARD16,
    backRed: CARD16,
    backGreen: CARD16,
    backBlue: CARD16,
};
pub const xRecolorCursorReq = extern struct {
    reqType: CARD8,
    pad: BYTE,
    length: CARD16,
    cursor: CARD32,
    foreRed: CARD16,
    foreGreen: CARD16,
    foreBlue: CARD16,
    backRed: CARD16,
    backGreen: CARD16,
    backBlue: CARD16,
};
pub const xQueryBestSizeReq = extern struct {
    reqType: CARD8,
    class: CARD8,
    length: CARD16,
    drawable: CARD32,
    width: CARD16,
    height: CARD16,
};
pub const xQueryExtensionReq = extern struct {
    reqType: CARD8,
    pad: BYTE,
    length: CARD16,
    nbytes: CARD16,
    pad1: BYTE,
    pad2: BYTE,
};
pub const xSetModifierMappingReq = extern struct {
    reqType: CARD8,
    numKeyPerModifier: CARD8,
    length: CARD16,
};
pub const xSetPointerMappingReq = extern struct {
    reqType: CARD8,
    nElts: CARD8,
    length: CARD16,
};
pub const xGetKeyboardMappingReq = extern struct {
    reqType: CARD8,
    pad: BYTE,
    length: CARD16,
    firstKeyCode: CARD8,
    count: CARD8,
    pad1: CARD16,
};
pub const xChangeKeyboardMappingReq = extern struct {
    reqType: CARD8,
    keyCodes: CARD8,
    length: CARD16,
    firstKeyCode: CARD8,
    keySymsPerKeyCode: CARD8,
    pad1: CARD16,
};
pub const xChangeKeyboardControlReq = extern struct {
    reqType: CARD8,
    pad: BYTE,
    length: CARD16,
    mask: CARD32,
};
pub const xBellReq = extern struct {
    reqType: CARD8,
    percent: INT8,
    length: CARD16,
};
pub const xChangePointerControlReq = extern struct {
    reqType: CARD8,
    pad: BYTE,
    length: CARD16,
    accelNum: INT16,
    accelDenum: INT16,
    threshold: INT16,
    doAccel: BOOL,
    doThresh: BOOL,
};
pub const xSetScreenSaverReq = extern struct {
    reqType: CARD8,
    pad: BYTE,
    length: CARD16,
    timeout: INT16,
    interval: INT16,
    preferBlank: BYTE,
    allowExpose: BYTE,
    pad2: CARD16,
};
pub const xChangeHostsReq = extern struct {
    reqType: CARD8,
    mode: BYTE,
    length: CARD16,
    hostFamily: CARD8,
    pad: BYTE,
    hostLength: CARD16,
};
pub const xListHostsReq = extern struct {
    reqType: CARD8,
    pad: BYTE,
    length: CARD16,
};
pub const xChangeModeReq = extern struct {
    reqType: CARD8,
    mode: BYTE,
    length: CARD16,
};
pub const xSetAccessControlReq = xChangeModeReq;
pub const xSetCloseDownModeReq = xChangeModeReq;
pub const xForceScreenSaverReq = xChangeModeReq;
pub const xRotatePropertiesReq = extern struct {
    reqType: CARD8,
    pad: BYTE,
    length: CARD16,
    window: CARD32,
    nAtoms: CARD16,
    nPositions: INT16,
};

pub const CARD8 = u8;
pub const BYTE = CARD8;
pub const CARD16 = c_ushort;
const struct_unnamed_2 = extern struct {
    type: BYTE,
    detail: BYTE,
    sequenceNumber: CARD16,
};
pub const CARD32 = c_uint;
pub const INT16 = c_short;
pub const KeyButMask = CARD16;
pub const BOOL = CARD8;
const struct_unnamed_3 = extern struct {
    pad00: CARD32,
    time: CARD32,
    root: CARD32,
    event: CARD32,
    child: CARD32,
    rootX: INT16,
    rootY: INT16,
    eventX: INT16,
    eventY: INT16,
    state: KeyButMask,
    sameScreen: BOOL,
    pad1: BYTE,
};
const struct_unnamed_4 = extern struct {
    pad00: CARD32,
    time: CARD32,
    root: CARD32,
    event: CARD32,
    child: CARD32,
    rootX: INT16,
    rootY: INT16,
    eventX: INT16,
    eventY: INT16,
    state: KeyButMask,
    mode: BYTE,
    flags: BYTE,
};
const struct_unnamed_5 = extern struct {
    pad00: CARD32,
    window: CARD32,
    mode: BYTE,
    pad1: BYTE,
    pad2: BYTE,
    pad3: BYTE,
};
const struct_unnamed_6 = extern struct {
    pad00: CARD32,
    window: CARD32,
    x: CARD16,
    y: CARD16,
    width: CARD16,
    height: CARD16,
    count: CARD16,
    pad2: CARD16,
};
const struct_unnamed_7 = extern struct {
    pad00: CARD32,
    drawable: CARD32,
    x: CARD16,
    y: CARD16,
    width: CARD16,
    height: CARD16,
    minorEvent: CARD16,
    count: CARD16,
    majorEvent: BYTE,
    pad1: BYTE,
    pad2: BYTE,
    pad3: BYTE,
};
const struct_unnamed_8 = extern struct {
    pad00: CARD32,
    drawable: CARD32,
    minorEvent: CARD16,
    majorEvent: BYTE,
    bpad: BYTE,
};
const struct_unnamed_9 = extern struct {
    pad00: CARD32,
    window: CARD32,
    state: CARD8,
    pad1: BYTE,
    pad2: BYTE,
    pad3: BYTE,
};
const struct_unnamed_10 = extern struct {
    pad00: CARD32,
    parent: CARD32,
    window: CARD32,
    x: INT16,
    y: INT16,
    width: CARD16,
    height: CARD16,
    borderWidth: CARD16,
    override: BOOL,
    bpad: BYTE,
};
const struct_unnamed_11 = extern struct {
    pad00: CARD32,
    event: CARD32,
    window: CARD32,
};
const struct_unnamed_12 = extern struct {
    pad00: CARD32,
    event: CARD32,
    window: CARD32,
    fromConfigure: BOOL,
    pad1: BYTE,
    pad2: BYTE,
    pad3: BYTE,
};
const struct_unnamed_13 = extern struct {
    pad00: CARD32,
    event: CARD32,
    window: CARD32,
    override: BOOL,
    pad1: BYTE,
    pad2: BYTE,
    pad3: BYTE,
};
const struct_unnamed_14 = extern struct {
    pad00: CARD32,
    parent: CARD32,
    window: CARD32,
};
const struct_unnamed_15 = extern struct {
    pad00: CARD32,
    event: CARD32,
    window: CARD32,
    parent: CARD32,
    x: INT16,
    y: INT16,
    override: BOOL,
    pad1: BYTE,
    pad2: BYTE,
    pad3: BYTE,
};
const struct_unnamed_16 = extern struct {
    pad00: CARD32,
    event: CARD32,
    window: CARD32,
    aboveSibling: CARD32,
    x: INT16,
    y: INT16,
    width: CARD16,
    height: CARD16,
    borderWidth: CARD16,
    override: BOOL,
    bpad: BYTE,
};
const struct_unnamed_17 = extern struct {
    pad00: CARD32,
    parent: CARD32,
    window: CARD32,
    sibling: CARD32,
    x: INT16,
    y: INT16,
    width: CARD16,
    height: CARD16,
    borderWidth: CARD16,
    valueMask: CARD16,
    pad1: CARD32,
};
const struct_unnamed_18 = extern struct {
    pad00: CARD32,
    event: CARD32,
    window: CARD32,
    x: INT16,
    y: INT16,
    pad1: CARD32,
    pad2: CARD32,
    pad3: CARD32,
    pad4: CARD32,
};
const struct_unnamed_19 = extern struct {
    pad00: CARD32,
    window: CARD32,
    width: CARD16,
    height: CARD16,
};
const struct_unnamed_20 = extern struct {
    pad00: CARD32,
    event: CARD32,
    window: CARD32,
    parent: CARD32,
    place: BYTE,
    pad1: BYTE,
    pad2: BYTE,
    pad3: BYTE,
};
const struct_unnamed_21 = extern struct {
    pad00: CARD32,
    window: CARD32,
    atom: CARD32,
    time: CARD32,
    state: BYTE,
    pad1: BYTE,
    pad2: CARD16,
};
const struct_unnamed_22 = extern struct {
    pad00: CARD32,
    time: CARD32,
    window: CARD32,
    atom: CARD32,
};
const struct_unnamed_23 = extern struct {
    pad00: CARD32,
    time: CARD32,
    owner: CARD32,
    requestor: CARD32,
    selection: CARD32,
    target: CARD32,
    property: CARD32,
};
const struct_unnamed_24 = extern struct {
    pad00: CARD32,
    time: CARD32,
    requestor: CARD32,
    selection: CARD32,
    target: CARD32,
    property: CARD32,
};
const struct_unnamed_25 = extern struct {
    pad00: CARD32,
    window: CARD32,
    colormap: CARD32,
    new: BOOL,
    state: BYTE,
    pad1: BYTE,
    pad2: BYTE,
};
const struct_unnamed_26 = extern struct {
    pad00: CARD32,
    request: CARD8,
    firstKeyCode: CARD8,
    count: CARD8,
    pad1: BYTE,
};
pub const INT32 = c_int;
const struct_unnamed_29 = extern struct {
    type: CARD32,
    longs0: INT32,
    longs1: INT32,
    longs2: INT32,
    longs3: INT32,
    longs4: INT32,
};
const struct_unnamed_30 = extern struct {
    type: CARD32,
    shorts0: INT16,
    shorts1: INT16,
    shorts2: INT16,
    shorts3: INT16,
    shorts4: INT16,
    shorts5: INT16,
    shorts6: INT16,
    shorts7: INT16,
    shorts8: INT16,
    shorts9: INT16,
};
pub const INT8 = i8;
const struct_unnamed_31 = extern struct {
    type: CARD32,
    bytes: [20]INT8,
};
const union_unnamed_28 = extern union {
    l: struct_unnamed_29,
    s: struct_unnamed_30,
    b: struct_unnamed_31,
};
const struct_unnamed_27 = extern struct {
    pad00: CARD32,
    window: CARD32,
    u: union_unnamed_28,
};
const union_unnamed_1 = extern union {
    u: struct_unnamed_2,
    keyButtonPointer: struct_unnamed_3,
    enterLeave: struct_unnamed_4,
    focus: struct_unnamed_5,
    expose: struct_unnamed_6,
    graphicsExposure: struct_unnamed_7,
    noExposure: struct_unnamed_8,
    visibility: struct_unnamed_9,
    createNotify: struct_unnamed_10,
    destroyNotify: struct_unnamed_11,
    unmapNotify: struct_unnamed_12,
    mapNotify: struct_unnamed_13,
    mapRequest: struct_unnamed_14,
    reparent: struct_unnamed_15,
    configureNotify: struct_unnamed_16,
    configureRequest: struct_unnamed_17,
    gravity: struct_unnamed_18,
    resizeRequest: struct_unnamed_19,
    circulate: struct_unnamed_20,
    property: struct_unnamed_21,
    selectionClear: struct_unnamed_22,
    selectionRequest: struct_unnamed_23,
    selectionNotify: struct_unnamed_24,
    colormap: struct_unnamed_25,
    mappingNotify: struct_unnamed_26,
    clientMessage: struct_unnamed_27,
};
pub const struct__xEvent = extern struct {
    u: union_unnamed_1,
};
pub const xEvent = struct__xEvent;
pub const struct__XLockInfo = opaque {};
pub const struct__XInternalAsync = extern struct {
    next: [*c]struct__XInternalAsync,
    handler: ?fn ([*c]Display, [*c]xReply, [*c]u8, c_int, XPointer) callconv(.C) c_int,
    data: XPointer,
};
pub const struct__XLockPtrs = opaque {};
pub const struct__XKeytrans = opaque {};
pub const struct__XDisplayAtoms = opaque {};
pub const struct__XContextDB = opaque {};
const struct_unnamed_32 = extern struct {
    defaultCCCs: XPointer,
    clientCmaps: XPointer,
    perVisualIntensityMaps: XPointer,
};
pub const struct__XIMFilter = opaque {};
pub const _XInternalConnectionProc = ?fn ([*c]Display, c_int, XPointer) callconv(.C) void;
pub const struct__XConnectionInfo = extern struct {
    fd: c_int,
    read_callback: _XInternalConnectionProc,
    call_data: XPointer,
    watch_data: [*c]XPointer,
    next: [*c]struct__XConnectionInfo,
};
pub const XConnectionWatchProc = ?fn ([*c]Display, XPointer, c_int, c_int, [*c]XPointer) callconv(.C) void;
pub const struct__XConnWatchInfo = extern struct {
    @"fn": XConnectionWatchProc,
    client_data: XPointer,
    next: [*c]struct__XConnWatchInfo,
};
pub const struct__XkbInfoRec = opaque {};
pub const struct__XtransConnInfo = opaque {};
pub const struct__X11XCBPrivate = opaque {};
pub const struct__XErrorThreadInfo = opaque {};
pub const XIOErrorExitHandler = ?fn ([*c]Display, ?*anyopaque) callconv(.C) void;
pub const struct__XDisplay = extern struct {
    ext_data: [*c]XExtData,
    free_funcs: [*c]struct__XFreeFuncs,
    fd: c_int,
    conn_checker: c_int,
    proto_major_version: c_int,
    proto_minor_version: c_int,
    vendor: [*c]u8,
    resource_base: X.XID,
    resource_mask: X.XID,
    resource_id: X.XID,
    resource_shift: c_int,
    resource_alloc: ?fn ([*c]struct__XDisplay) callconv(.C) X.XID,
    byte_order: c_int,
    bitmap_unit: c_int,
    bitmap_pad: c_int,
    bitmap_bit_order: c_int,
    nformats: c_int,
    pixmap_format: [*c]ScreenFormat,
    vnumber: c_int,
    release: c_int,
    head: [*c]struct__XSQEvent,
    tail: [*c]struct__XSQEvent,
    qlen: c_int,
    last_request_read: c_ulong,
    request: c_ulong,
    last_req: [*c]u8,
    buffer: [*c]u8,
    bufptr: [*c]u8,
    bufmax: [*c]u8,
    max_request_size: c_uint,
    db: ?*struct__XrmHashBucketRec,
    synchandler: ?fn ([*c]struct__XDisplay) callconv(.C) c_int,
    display_name: [*c]u8,
    default_screen: c_int,
    nscreens: c_int,
    screens: [*c]Screen,
    motion_buffer: c_ulong,
    flags: c_ulong,
    min_keycode: c_int,
    max_keycode: c_int,
    keysyms: [*c]X.KeySym,
    modifiermap: [*c]XModifierKeymap,
    keysyms_per_keycode: c_int,
    xdefaults: [*c]u8,
    scratch_buffer: [*c]u8,
    scratch_length: c_ulong,
    ext_number: c_int,
    ext_procs: [*c]struct__XExten,
    event_vec: [128]?fn ([*c]Display, [*c]XEvent, [*c]xEvent) callconv(.C) c_int,
    wire_vec: [128]?fn ([*c]Display, [*c]XEvent, [*c]xEvent) callconv(.C) c_int,
    lock_meaning: X.KeySym,
    lock: ?*struct__XLockInfo,
    async_handlers: [*c]struct__XInternalAsync,
    bigreq_size: c_ulong,
    lock_fns: ?*struct__XLockPtrs,
    idlist_alloc: ?fn ([*c]Display, [*c]X.XID, c_int) callconv(.C) void,
    key_bindings: ?*struct__XKeytrans,
    cursor_font: X.Font,
    atoms: ?*struct__XDisplayAtoms,
    mode_switch: c_uint,
    num_lock: c_uint,
    context_db: ?*struct__XContextDB,
    error_vec: [*c]?fn ([*c]Display, [*c]XErrorEvent, [*c]xError) callconv(.C) c_int,
    cms: struct_unnamed_32,
    im_filters: ?*struct__XIMFilter,
    qfree: [*c]struct__XSQEvent,
    next_event_serial_num: c_ulong,
    flushes: [*c]struct__XExten,
    im_fd_info: [*c]struct__XConnectionInfo,
    im_fd_length: c_int,
    conn_watchers: [*c]struct__XConnWatchInfo,
    watcher_count: c_int,
    filedes: XPointer,
    savedsynchandler: ?fn ([*c]Display) callconv(.C) c_int,
    resource_max: X.XID,
    xcmisc_opcode: c_int,
    xkb_info: ?*struct__XkbInfoRec,
    trans_conn: ?*struct__XtransConnInfo,
    xcb: ?*struct__X11XCBPrivate,
    next_cookie: c_uint,
    generic_event_vec: [128]?fn ([*c]Display, [*c]XGenericEventCookie, [*c]xEvent) callconv(.C) c_int,
    generic_event_copy_vec: [128]?fn ([*c]Display, [*c]XGenericEventCookie, [*c]XGenericEventCookie) callconv(.C) c_int,
    cookiejar: ?*anyopaque,
    error_threads: ?*struct__XErrorThreadInfo,
    exit_handler: XIOErrorExitHandler,
    exit_handler_data: ?*anyopaque,
};

