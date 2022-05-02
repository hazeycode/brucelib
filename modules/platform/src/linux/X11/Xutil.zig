const wchar_t = c_short;

const xlib = @import("Xlib.zig");
usingnamespace xlib;

const struct_unnamed_1 = extern struct {
    x: c_int,
    y: c_int,
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
    icon_pixmap: xlib.Pixmap,
    icon_window: xlib.Window,
    icon_x: c_int,
    icon_y: c_int,
    icon_mask: xlib.Pixmap,
    window_group: xlib.XID,
};
pub const XTextProperty = extern struct {
    value: [*c]u8,
    encoding: xlib.Atom,
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
    compose_ptr: xlib.XPointer,
    chars_matched: c_int,
};
pub const XComposeStatus = struct__XComposeStatus;
pub const struct__XRegion = opaque {};
pub const Region = ?*struct__XRegion;
pub const XVisualInfo = extern struct {
    visual: [*c]xlib.Visual,
    visualid: xlib.VisualID,
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
    colormap: xlib.Colormap,
    red_max: c_ulong,
    red_mult: c_ulong,
    green_max: c_ulong,
    green_mult: c_ulong,
    blue_max: c_ulong,
    blue_mult: c_ulong,
    base_pixel: c_ulong,
    visualid: xlib.VisualID,
    killid: xlib.XID,
};
pub const XContext = c_int;
pub extern fn XAllocClassHint() [*c]XClassHint;
pub extern fn XAllocIconSize() [*c]XIconSize;
pub extern fn XAllocSizeHints() [*c]XSizeHints;
pub extern fn XAllocStandardColormap() [*c]XStandardColormap;
pub extern fn XAllocWMHints() [*c]XWMHints;
pub extern fn XClipBox(Region, [*c]xlib.XRectangle) c_int;
pub extern fn XCreateRegion() Region;
pub extern fn XDefaultString() [*c]const u8;
pub extern fn XDeleteContext(?*xlib.Display, xlib.XID, XContext) c_int;
pub extern fn XDestroyRegion(Region) c_int;
pub extern fn XEmptyRegion(Region) c_int;
pub extern fn XEqualRegion(Region, Region) c_int;
pub extern fn XFindContext(?*xlib.Display, xlib.XID, XContext, [*c]xlib.XPointer) c_int;
pub extern fn XGetClassHint(?*xlib.Display, xlib.Window, [*c]XClassHint) c_int;
pub extern fn XGetIconSizes(?*xlib.Display, xlib.Window, [*c][*c]XIconSize, [*c]c_int) c_int;
pub extern fn XGetNormalHints(?*xlib.Display, xlib.Window, [*c]XSizeHints) c_int;
pub extern fn XGetRGBColormaps(?*xlib.Display, xlib.Window, [*c][*c]XStandardColormap, [*c]c_int, xlib.Atom) c_int;
pub extern fn XGetSizeHints(?*xlib.Display, xlib.Window, [*c]XSizeHints, xlib.Atom) c_int;
pub extern fn XGetStandardColormap(?*xlib.Display, xlib.Window, [*c]XStandardColormap, xlib.Atom) c_int;
pub extern fn XGetTextProperty(?*xlib.Display, xlib.Window, [*c]XTextProperty, xlib.Atom) c_int;
pub extern fn XGetVisualInfo(?*xlib.Display, c_long, [*c]XVisualInfo, [*c]c_int) [*c]XVisualInfo;
pub extern fn XGetWMClientMachine(?*xlib.Display, xlib.Window, [*c]XTextProperty) c_int;
pub extern fn XGetWMHints(?*xlib.Display, xlib.Window) [*c]XWMHints;
pub extern fn XGetWMIconName(?*xlib.Display, xlib.Window, [*c]XTextProperty) c_int;
pub extern fn XGetWMName(?*xlib.Display, xlib.Window, [*c]XTextProperty) c_int;
pub extern fn XGetWMNormalHints(?*xlib.Display, xlib.Window, [*c]XSizeHints, [*c]c_long) c_int;
pub extern fn XGetWMSizeHints(?*xlib.Display, xlib.Window, [*c]XSizeHints, [*c]c_long, xlib.Atom) c_int;
pub extern fn XGetZoomHints(?*xlib.Display, xlib.Window, [*c]XSizeHints) c_int;
pub extern fn XIntersectRegion(Region, Region, Region) c_int;
pub extern fn XConvertCase(xlib.KeySym, [*c]xlib.KeySym, [*c]xlib.KeySym) void;
pub extern fn XLookupString([*c]xlib.XKeyEvent, [*c]u8, c_int, [*c]xlib.KeySym, [*c]XComposeStatus) c_int;
pub extern fn XMatchVisualInfo(?*xlib.Display, c_int, c_int, c_int, [*c]XVisualInfo) c_int;
pub extern fn XOffsetRegion(Region, c_int, c_int) c_int;
pub extern fn XPointInRegion(Region, c_int, c_int) c_int;
pub extern fn XPolygonRegion([*c]xlib.XPoint, c_int, c_int) Region;
pub extern fn XRectInRegion(Region, c_int, c_int, c_uint, c_uint) c_int;
pub extern fn XSaveContext(?*xlib.Display, xlib.XID, XContext, [*c]const u8) c_int;
pub extern fn XSetClassHint(?*xlib.Display, xlib.Window, [*c]XClassHint) c_int;
pub extern fn XSetIconSizes(?*xlib.Display, xlib.Window, [*c]XIconSize, c_int) c_int;
pub extern fn XSetNormalHints(?*xlib.Display, xlib.Window, [*c]XSizeHints) c_int;
pub extern fn XSetRGBColormaps(?*xlib.Display, xlib.Window, [*c]XStandardColormap, c_int, xlib.Atom) void;
pub extern fn XSetSizeHints(?*xlib.Display, xlib.Window, [*c]XSizeHints, xlib.Atom) c_int;
pub extern fn XSetStandardProperties(?*xlib.Display, xlib.Window, [*c]const u8, [*c]const u8, xlib.Pixmap, [*c][*c]u8, c_int, [*c]XSizeHints) c_int;
pub extern fn XSetTextProperty(?*xlib.Display, xlib.Window, [*c]XTextProperty, xlib.Atom) void;
pub extern fn XSetWMClientMachine(?*xlib.Display, xlib.Window, [*c]XTextProperty) void;
pub extern fn XSetWMHints(?*xlib.Display, xlib.Window, [*c]XWMHints) c_int;
pub extern fn XSetWMIconName(?*xlib.Display, xlib.Window, [*c]XTextProperty) void;
pub extern fn XSetWMName(?*xlib.Display, xlib.Window, [*c]XTextProperty) void;
pub extern fn XSetWMNormalHints(?*xlib.Display, xlib.Window, [*c]XSizeHints) void;
pub extern fn XSetWMProperties(?*xlib.Display, xlib.Window, [*c]XTextProperty, [*c]XTextProperty, [*c][*c]u8, c_int, [*c]XSizeHints, [*c]XWMHints, [*c]XClassHint) void;
pub extern fn XmbSetWMProperties(?*xlib.Display, xlib.Window, [*c]const u8, [*c]const u8, [*c][*c]u8, c_int, [*c]XSizeHints, [*c]XWMHints, [*c]XClassHint) void;
pub extern fn Xutf8SetWMProperties(?*xlib.Display, xlib.Window, [*c]const u8, [*c]const u8, [*c][*c]u8, c_int, [*c]XSizeHints, [*c]XWMHints, [*c]XClassHint) void;
pub extern fn XSetWMSizeHints(?*xlib.Display, xlib.Window, [*c]XSizeHints, xlib.Atom) void;
pub extern fn XSetRegion(?*xlib.Display, GC: c_int, Region) c_int;
pub extern fn XSetStandardColormap(?*xlib.Display, xlib.Window, [*c]XStandardColormap, xlib.Atom) void;
pub extern fn XSetZoomHints(?*xlib.Display, xlib.Window, [*c]XSizeHints) c_int;
pub extern fn XShrinkRegion(Region, c_int, c_int) c_int;
pub extern fn XStringListToTextProperty([*c][*c]u8, c_int, [*c]XTextProperty) c_int;
pub extern fn XSubtractRegion(Region, Region, Region) c_int;
pub extern fn XmbTextListToTextProperty(display: ?*xlib.Display, list: [*c][*c]u8, count: c_int, style: XICCEncodingStyle, text_prop_return: [*c]XTextProperty) c_int;
pub extern fn XwcTextListToTextProperty(display: ?*xlib.Display, list: [*c][*c]wchar_t, count: c_int, style: XICCEncodingStyle, text_prop_return: [*c]XTextProperty) c_int;
pub extern fn Xutf8TextListToTextProperty(display: ?*xlib.Display, list: [*c][*c]u8, count: c_int, style: XICCEncodingStyle, text_prop_return: [*c]XTextProperty) c_int;
pub extern fn XwcFreeStringList(list: [*c][*c]wchar_t) void;
pub extern fn XTextPropertyToStringList([*c]XTextProperty, [*c][*c][*c]u8, [*c]c_int) c_int;
pub extern fn XmbTextPropertyToTextList(display: ?*xlib.Display, text_prop: [*c]const XTextProperty, list_return: [*c][*c][*c]u8, count_return: [*c]c_int) c_int;
pub extern fn XwcTextPropertyToTextList(display: ?*xlib.Display, text_prop: [*c]const XTextProperty, list_return: [*c][*c][*c]wchar_t, count_return: [*c]c_int) c_int;
pub extern fn Xutf8TextPropertyToTextList(display: ?*xlib.Display, text_prop: [*c]const XTextProperty, list_return: [*c][*c][*c]u8, count_return: [*c]c_int) c_int;
pub extern fn XUnionRectWithRegion([*c]xlib.XRectangle, Region, Region) c_int;
pub extern fn XUnionRegion(Region, Region, Region) c_int;
pub extern fn XWMGeometry(?*xlib.Display, c_int, [*c]const u8, [*c]const u8, c_uint, [*c]XSizeHints, [*c]c_int, [*c]c_int, [*c]c_int, [*c]c_int, [*c]c_int) c_int;
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
pub inline fn IsPrivateKeypadKey(keysym: anytype) @TypeOf((@import("std").zig.c_translation.cast(xlib.KeySym, keysym) >= @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x11000000, .hexadecimal)) and (@import("std").zig.c_translation.cast(xlib.KeySym, keysym) <= @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x1100FFFF, .hexadecimal))) {
    return (@import("std").zig.c_translation.cast(xlib.KeySym, keysym) >= @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x11000000, .hexadecimal)) and (@import("std").zig.c_translation.cast(xlib.KeySym, keysym) <= @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x1100FFFF, .hexadecimal));
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
pub const ReleaseByFreeingColormap = @import("std").zig.c_translation.cast(xlib.XID, @as(c_long, 1));
pub const BitmapSuccess = @as(c_int, 0);
pub const BitmapOpenFailed = @as(c_int, 1);
pub const BitmapFileInvalid = @as(c_int, 2);
pub const BitmapNoMemory = @as(c_int, 3);
pub const XCSUCCESS = @as(c_int, 0);
pub const XCNOMEM = @as(c_int, 1);
pub const XCNOENT = @as(c_int, 2);
