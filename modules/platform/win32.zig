const std = @import("std");
const builtin = @import("builtin");
const core = @import("core");
const Input = @import("Input.zig");

const win32 = @import("win32/windows.zig");
const kernel32 = win32.kernel32;
const user32 = win32.user32;

const dxgi = @import("win32/dxgi.zig");

pub const default_graphics_api = core.GraphicsAPI.d3d11;

pub const Error = error{
    FailedToGetModuleHandle,
};

pub fn run(args: struct {
    graphics_api: core.GraphicsAPI = default_graphics_api,
    title: [:0]const u8 = "",
    pxwidth: u16 = 854,
    pxheight: u16 = 480,
    update_fn: fn (Input) anyerror!bool,
}) !void {
    const hinstance = @ptrCast(win32.HINSTANCE, kernel32.GetModuleHandleW(null) orelse {
        std.log.err("GetModuleHandleW failed with error: {}", .{kernel32.GetLastError()});
        return Error.FailedToGetModuleHandle;
    });

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

    var quit = false;
    while (quit == false) {
        var msg: user32.MSG = undefined;
        while (try user32.peekMessageW(&msg, null, 0, 0, user32.PM_REMOVE)) {
            _ = user32.translateMessage(&msg);
            _ = user32.dispatchMessageW(&msg);
            if (msg.message == user32.WM_QUIT) {
                quit = true;
                break;
            }
        }
    }
}

fn wndProc(hwnd: win32.HWND, msg: win32.UINT, wparam: win32.WPARAM, lparam: win32.LPARAM) callconv(.C) win32.LRESULT {
    switch (msg) {
        user32.WM_DESTROY => user32.postQuitMessage(0),
        else => {},
    }
    return user32.defWindowProcW(hwnd, msg, wparam, lparam);
}

fn registerClass(hinstance: win32.HINSTANCE, name: win32.LPCWSTR) !void {
    var wndclass = user32.WNDCLASSEXW{
        .cbSize = @sizeOf(user32.WNDCLASSEXW),
        .style = 0,
        .lpfnWndProc = wndProc,
        .cbClsExtra = 0,
        .cbWndExtra = 0,
        .hInstance = hinstance,
        .hIcon = null,
        .hCursor = null,
        .hbrBackground = null,
        .lpszMenuName = null,
        .lpszClassName = name,
        .hIconSm = null,
    };

    _ = try user32.registerClassExW(&wndclass);
}

fn createWindow(
    hinstance: win32.HINSTANCE,
    class_name: win32.LPCWSTR,
    window_name: win32.LPCWSTR,
    window_width: u16,
    window_height: u16,
) !win32.HWND {
    var rect = win32.RECT{
        .left = 60,
        .top = 60,
        .right = window_width,
        .bottom = window_height,
    };
    const style: win32.DWORD = user32.WS_OVERLAPPEDWINDOW;
    try user32.adjustWindowRectEx(&rect, style, false, 0);
    const actual_window_width = rect.right - rect.left;
    const actual_window_height = rect.bottom - rect.top;
    const hwnd = try user32.createWindowExW(
        0,
        class_name,
        window_name,
        style,
        rect.left,
        rect.top,
        actual_window_width,
        actual_window_height,
        null,
        null,
        hinstance,
        null,
    );
    _ = user32.showWindow(hwnd, user32.SW_SHOWNORMAL);
    try user32.updateWindow(hwnd);
    return hwnd;
}
