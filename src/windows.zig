const std = @import("std");
const gfx = @import("gfx.zig");
const Input = @import("Input.zig");

pub const gfx_api = gfx.API.d3d11;

pub fn run(args: struct {
    title: [:0]const u8 = "",
    pxwidth: u16 = 854,
    pxheight: u16 = 480,
    update_fn: fn (Input) anyerror!bool,
}) !void {
    const hinstance = GetModuleHandleA(null);
    try registerClass(hinstance, args.title);
}

pub const Error = error{
    FailedToRegisterWindowClass,
};

fn registerClass(instance: HINSTANCE, title: []const u8) !void {
    var class_name = [_]u16{0} ** 64;
    _ = try std.unicode.utf8ToUtf16Le(class_name[0..], title);

    var wndclass = WNDCLASSEXW{
        .cbSize = @sizeOf(WNDCLASSEXW),
        .style = 0,
        .lpfnWndProc = wndProc,
        .cbClsExtra = 0,
        .cbWndExtra = 0,
        .hInstance = instance,
        .hIcon = LoadIconA(null, IDI_WINLOGO),
        .hCursor = LoadCursorA(null, IDC_ARROW),
        .hbrBackground = 0,
        .lpszMenuName = 0,
        .lpszClassName = @ptrCast([*:0]const u16, &class_name),
        .hIconSm = 0,
    };

    if (RegisterClassExW(&wndclass) == 0) return Error.FailedToRegisterWindowClass;
}

fn wndProc(_: HWND, _: UINT, _: WPARAM, _: LPARAM) callconv(.C) LRESULT {
    return 0;
}

const WINAPI = std.os.windows.WINAPI;
const HINSTANCE = std.os.windows.HINSTANCE;
const LPCSTR = std.os.windows.LPCSTR;
const LPSTR = std.os.windows.LPSTR;
const LPCWSTR = std.os.windows.LPCWSTR;
const WORD = std.os.windows.WORD;
const DWORD = std.os.windows.DWORD;
const UINT = std.os.windows.UINT;
const HCURSOR = std.os.windows.HCURSOR;
const HICON = std.os.windows.HICON;
const ATOM = std.os.windows.ATOM;
const HWND = std.os.windows.HWND;
const WPARAM = std.os.windows.WPARAM;
const LPARAM = std.os.windows.LPARAM;
const LRESULT = std.os.windows.LRESULT;

const IDI_WINLOGO = MAKEINTRESOURCEA(32517);
const IDC_ARROW = MAKEINTRESOURCEA(32512);

fn MAKEINTRESOURCEA(i: WORD) LPSTR {
    return @intToPtr(LPSTR, @intCast(DWORD, i));
}

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

const WNDPROC = fn (HWND, UINT, WPARAM, LPARAM) callconv(WINAPI) LRESULT;

extern "kernel32" fn GetModuleHandleA(?LPCSTR) callconv(WINAPI) HINSTANCE;

extern "user32" fn RegisterClassExW(*WNDCLASSEXW) callconv(WINAPI) ATOM;
extern "user32" fn LoadIconA(hInstance: ?HINSTANCE, lpIconName: LPCSTR) callconv(WINAPI) HICON;
extern "user32" fn LoadCursorA(hInstance: ?HINSTANCE, lpCursorName: LPCSTR) callconv(WINAPI) HCURSOR;
