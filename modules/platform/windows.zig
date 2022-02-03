const std = @import("std");
const core = @import("core");
const Input = @import("Input.zig");

pub const default_graphics_api = core.GraphicsAPI.d3d11;

pub const Error = error{
    FailedToRegisterWin32Class,
    FailedToCreateWindow,
    FailedToUpdateWindow,
};

pub fn run(args: struct {
    graphics_api: core.GraphicsAPI = default_graphics_api,
    title: [:0]const u8 = "",
    pxwidth: u16 = 854,
    pxheight: u16 = 480,
    update_fn: fn (Input) anyerror!bool,
}) !void {
    const hinstance = GetModuleHandleA(null);

    var utf16_title = [_]u16{0} ** 64;
    _ = try std.unicode.utf8ToUtf16Le(utf16_title[0..], args.title);
    const utf16_title_ptr = @ptrCast([*:0]const u16, &utf16_title);

    try registerClass(hinstance, utf16_title_ptr);

    _ = try createWindow(
        hinstance,
        utf16_title_ptr,
        utf16_title_ptr,
        args.pxwidth,
        args.pxheight,
    );

    while (true) {}
}

fn wndProc(hwnd: HWND, msg: UINT, wparam: WPARAM, lparam: LPARAM) callconv(.C) LRESULT {
    return DefWindowProcW(hwnd, msg, wparam, lparam);
}

fn registerClass(hinstance: HINSTANCE, name: LPCWSTR) Error!void {
    var wndclass = WNDCLASSEXW{
        .cbSize = @sizeOf(WNDCLASSEXW),
        .style = 0,
        .lpfnWndProc = wndProc,
        .cbClsExtra = 0,
        .cbWndExtra = 0,
        .hInstance = hinstance,
        .hIcon = LoadIconA(null, IDI_WINLOGO),
        .hCursor = LoadCursorA(null, IDC_ARROW),
        .hbrBackground = 0,
        .lpszMenuName = 0,
        .lpszClassName = name,
        .hIconSm = 0,
    };

    if (RegisterClassExW(&wndclass) == 0) return Error.FailedToRegisterWin32Class;
}

fn createWindow(
    hinstance: HINSTANCE,
    class_name: LPCWSTR,
    window_name: LPCWSTR,
    window_width: u16,
    window_height: u16,
) Error!HWND {
    var rect = RECT{
        .left = 0,
        .top = 0,
        .right = window_width,
        .bottom = window_height,
    };
    const style: DWORD = WS_OVERLAPPEDWINDOW;
    if (AdjustWindowRect(&rect, style, TRUE) == FALSE) {
        std.log.warn("AdjustWindowRect failed", .{});
    }
    const actual_window_width = rect.right - rect.left;
    const actual_window_height = rect.bottom - rect.top;
    const res = CreateWindowExW(
        0,
        class_name,
        window_name,
        style,
        rect.left,
        rect.top,
        actual_window_width,
        actual_window_height,
        0,
        0,
        hinstance,
        0,
    );
    if (@ptrToInt(res) == 0) {
        logWin32Error(GetLastError(), "CreateWindowExW");
        return Error.FailedToCreateWindow;
    }
    _ = ShowWindow(res, SW_SHOWNORMAL);
    if (UpdateWindow(res) == FALSE) {
        logWin32Error(GetLastError(), "UpdateWindow");
        return Error.FailedToUpdateWindow;
    }
    return res;
}

fn logWin32Error(err_code: DWORD, fn_name: []const u8) void {
    std.log.err("{s} failed with error code: 0x{x:0>8}", .{ fn_name, err_code });
}

const TRUE = std.os.windows.TRUE;
const FALSE = std.os.windows.FALSE;
const BOOL = std.os.windows.BOOL;
const WORD = std.os.windows.WORD;
const DWORD = std.os.windows.DWORD;
const UINT = std.os.windows.UINT;
const LPVOID = std.os.windows.LPVOID;
const LPCSTR = std.os.windows.LPCSTR;
const LPSTR = std.os.windows.LPSTR;
const LPCWSTR = std.os.windows.LPCWSTR;
const ATOM = std.os.windows.ATOM;
const WINAPI = std.os.windows.WINAPI;
const HINSTANCE = std.os.windows.HINSTANCE;
const HWND = std.os.windows.HWND;
const HCURSOR = std.os.windows.HCURSOR;
const HICON = std.os.windows.HICON;
const HMENU = std.os.windows.HMENU;
const WPARAM = std.os.windows.WPARAM;
const LPARAM = std.os.windows.LPARAM;
const LRESULT = std.os.windows.LRESULT;
const RECT = std.os.windows.RECT;
const LPRECT = *RECT;

const IDI_WINLOGO = MAKEINTRESOURCEA(32517);
const IDC_ARROW = MAKEINTRESOURCEA(32512);

fn MAKEINTRESOURCEA(i: WORD) LPSTR {
    return @intToPtr(LPSTR, @intCast(DWORD, i));
}

const WS_BORDER: DWORD = 0x00800000;
const WS_CAPTION: DWORD = 0x00C00000;
const WS_CHILD: DWORD = 0x40000000;
const WS_CHILDWINDOW = WS_CHILD;
const WS_CLIPCHILDREN: DWORD = 0x02000000;
const WS_CLIPSBLINGS: DWORD = 0x04000000;
const WS_DISABLED: DWORD = 0x08000000;
const WS_DLGFRAME: DWORD = 0x0040000;
const WS_GROUP: DWORD = 0x00020000;
const WS_HSCROLL: DWORD = 0x00100000;
const WS_ICONIC: DWORD = 0x20000000;
const WS_MAXIMIZE: DWORD = 0x01000000;
const WS_MAXIMIZEBOX: DWORD = 0x00010000;
const WS_MINIMIZE = WS_ICONIC;
const WS_MINIMIZEBOX: DWORD = 0x00020000;
const WS_OVERLAPPED: DWORD = 0x00000000;
const WS_OVERLAPPEDWINDOW = WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU | WS_THICKFRAME | WS_MINIMIZEBOX | WS_MAXIMIZEBOX;
const WS_POPUP: DWORD = 0x80000000;
const WS_POPUPWINDOW = WS_POPUP | WS_BORDER | WS_SYSMENU;
const WS_SIZEBOX: DWORD = 0x00040000;
const WS_SYSMENU: DWORD = 0x00080000;
const WS_TABSTOP: DWORD = 0x00010000;
const WS_THICKFRAME = WS_SIZEBOX;
const WS_TILED = WS_OVERLAPPED;
const WS_TILEDWINDOW = WS_OVERLAPPEDWINDOW;
const WS_VISIBLE: DWORD = 0x10000000;
const WS_VSCROLL: DWORD = 0x00200000;

const WNDCLASSEXW = struct {
    cbSize: UINT,
    style: UINT,
    lpfnWndProc: WNDPROC,
    cbClsExtra: c_int,
    cbWndExtra: c_int,
    hInstance: HINSTANCE,
    hIcon: HICON,
    hCursor: HCURSOR,
    hbrBackground: usize, // HBRUSH
    lpszMenuName: usize, // LPCWSTR
    lpszClassName: LPCWSTR,
    hIconSm: usize, // HICON
};

const SW_SHOWNORMAL = 1;
const SW_NORMAL = SW_SHOWNORMAL;
const SW_SHOW = 5;

const WNDPROC = fn (HWND, UINT, WPARAM, LPARAM) callconv(WINAPI) LRESULT;

extern "kernel32" fn GetLastError() callconv(WINAPI) DWORD;
extern "kernel32" fn GetModuleHandleA(?LPCSTR) callconv(WINAPI) HINSTANCE;

extern "user32" fn RegisterClassExW(*WNDCLASSEXW) callconv(WINAPI) ATOM;
extern "user32" fn DefWindowProcW(HWND, UINT, WPARAM, LPARAM) callconv(WINAPI) LRESULT;
extern "user32" fn LoadIconA(?HINSTANCE, LPCSTR) callconv(WINAPI) HICON;
extern "user32" fn LoadCursorA(?HINSTANCE, LPCSTR) callconv(WINAPI) HCURSOR;
extern "user32" fn AdjustWindowRect(LPRECT, DWORD, BOOL) callconv(WINAPI) BOOL;
extern "user32" fn CreateWindowExW(
    DWORD,
    LPCWSTR,
    LPCWSTR,
    DWORD,
    c_int,
    c_int,
    c_int,
    c_int,
    usize, // HWND
    usize, // MENU
    HINSTANCE,
    usize, // LPVOID
) callconv(WINAPI) HWND;
extern "user32" fn ShowWindow(HWND, c_int) callconv(WINAPI) BOOL;
extern "user32" fn UpdateWindow(HWND) callconv(WINAPI) BOOL;
