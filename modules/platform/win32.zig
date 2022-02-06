const std = @import("std");
const builtin = @import("builtin");
const core = @import("core");
const Input = @import("Input.zig");

const win32 = @import("zig-gamedev-win32");
const UINT = win32.base.UINT;
const DWORD = win32.base.DWORD;
const BOOL = win32.base.BOOL;
const TRUE = win32.base.TRUE;
const FALSE = win32.base.FALSE;
const LPCWSTR = win32.base.LPCWSTR;
const WPARAM = win32.base.WPARAM;
const LPARAM = win32.base.LPARAM;
const LRESULT = win32.base.LRESULT;
const HRESULT = win32.base.HRESULT;
const HINSTANCE = win32.base.HINSTANCE;
const HWND = win32.base.HWND;
const RECT = win32.base.RECT;
const E_FAIL = win32.base.E_FAIL;
const E_INVALIDARG = win32.base.E_INVALIDARG;
const E_OUTOFMEMORY = win32.base.E_OUTOFMEMORY;
const E_NOTIMPL = win32.base.E_NOTIMPL;
const S_FALSE = win32.base.S_FALSE;
const S_OK = win32.base.S_OK;
const kernel32 = win32.base.kernel32;
const user32 = win32.base.user32;
const dxgi = win32.dxgi;
const d3d = win32.d3d;
const d3d11 = win32.d3d11;

pub const default_graphics_api = core.GraphicsAPI.d3d11;

pub const Error = error{
    FailedToGetModuleHandle,
};

var window_width: u16 = undefined;
var window_height: u16 = undefined;
var window_resized: bool = false;

pub fn run(args: struct {
    graphics_api: core.GraphicsAPI = default_graphics_api,
    title: [:0]const u8 = "",
    pxwidth: u16 = 854,
    pxheight: u16 = 480,
    update_fn: fn (Input) anyerror!bool,
}) !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    window_width = args.pxwidth;
    window_height = args.pxheight;

    const hinstance = @ptrCast(HINSTANCE, kernel32.GetModuleHandleW(null) orelse {
        std.log.err("GetModuleHandleW failed with error: {}", .{kernel32.GetLastError()});
        return Error.FailedToGetModuleHandle;
    });

    var utf16_title = [_]u16{0} ** 64;
    _ = try std.unicode.utf8ToUtf16Le(utf16_title[0..], args.title);
    const utf16_title_ptr = @ptrCast([*:0]const u16, &utf16_title);

    try registerClass(hinstance, utf16_title_ptr);

    const hwnd = try createWindow(
        hinstance,
        utf16_title_ptr,
        utf16_title_ptr,
    );

    try createDeviceAndSwapchain(hwnd);
    try createRenderTargetView();

    while (true) {
        var frame_mem_arena = std.heap.ArenaAllocator.init(allocator);
        defer frame_mem_arena.deinit();

        const arena_allocator = frame_mem_arena.allocator();

        var key_presses = std.ArrayList(Input.KeyPressEvent).init(arena_allocator);
        var key_releases = std.ArrayList(Input.KeyReleaseEvent).init(arena_allocator);
        var mouse_button_presses = std.ArrayList(Input.MouseButtonEvent).init(arena_allocator);
        var mouse_button_releases = std.ArrayList(Input.MouseButtonEvent).init(arena_allocator);
        var window_closed = false;

        var msg: user32.MSG = undefined;
        while (try user32.peekMessageW(&msg, null, 0, 0, user32.PM_REMOVE)) {
            _ = user32.translateMessage(&msg);
            _ = user32.dispatchMessageW(&msg);
            if (msg.message == user32.WM_DESTROY) {
                std.log.debug("CLOSE!", .{});
                window_closed = true;
            }
        }

        const quit = !(try args.update_fn(.{
            .frame_arena_allocator = arena_allocator,
            .key_presses = key_presses.items,
            .key_releases = key_releases.items,
            .mouse_button_presses = mouse_button_presses.items,
            .mouse_button_releases = mouse_button_releases.items,
            .canvas_width = window_width,
            .canvas_height = window_height,
            .quit_requested = window_closed,
        }));

        if (quit) break;
    }
}

fn wndProc(hwnd: HWND, msg: UINT, wparam: WPARAM, lparam: LPARAM) callconv(.C) LRESULT {
    switch (msg) {
        user32.WM_DESTROY => user32.postQuitMessage(0),
        else => {},
    }
    return user32.defWindowProcW(hwnd, msg, wparam, lparam);
}

fn registerClass(hinstance: HINSTANCE, name: LPCWSTR) !void {
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
    hinstance: HINSTANCE,
    class_name: LPCWSTR,
    window_name: LPCWSTR,
) !HWND {
    var rect = RECT{
        .left = 60,
        .top = 60,
        .right = window_width,
        .bottom = window_height,
    };
    const style: DWORD = user32.WS_OVERLAPPEDWINDOW;
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

var swap_chain: ?*dxgi.ISwapChain = null;

var d3d11_device: ?*d3d11.IDevice = null;
var d3d11_device_context: ?*d3d11.IDeviceContext = null;
var d3d11_render_target_view: ?*d3d11.IRenderTargetView = null;

fn createDeviceAndSwapchain(hwnd: HWND) HResultError!void {
    var swapchain_desc: dxgi.SWAP_CHAIN_DESC = .{
        .BufferDesc = .{
            .Width = 0,
            .Height = 0,
            .RefreshRate = .{
                .Numerator = 0,
                .Denominator = 1,
            },
            .Format = dxgi.FORMAT.B8G8R8A8_UNORM,
            .ScanlineOrdering = dxgi.MODE_SCANLINE_ORDER.UNSPECIFIED,
            .Scaling = dxgi.MODE_SCALING.UNSPECIFIED,
        },
        .SampleDesc = .{
            .Count = 1,
            .Quality = 0,
        },
        .BufferUsage = dxgi.USAGE_RENDER_TARGET_OUTPUT,
        .BufferCount = 1,
        .OutputWindow = hwnd,
        .Windowed = TRUE,
        .SwapEffect = dxgi.SWAP_EFFECT.DISCARD,
        .Flags = 0,
    };

    var flags: UINT = d3d11.CREATE_DEVICE_SINGLETHREADED;
    if (builtin.mode == .Debug) {
        flags |= d3d11.CREATE_DEVICE_DEBUG;
    }

    var feature_level: d3d.FEATURE_LEVEL = .FL_11_0;

    try checkResult(d3d11.D3D11CreateDeviceAndSwapChain(
        null,
        d3d.DRIVER_TYPE.HARDWARE,
        null,
        flags,
        null,
        0,
        d3d11.SDK_VERSION,
        &swapchain_desc,
        &swap_chain,
        &d3d11_device,
        &feature_level,
        &d3d11_device_context,
    ));
}

fn createRenderTargetView() HResultError!void {
    var framebuffer: *d3d11.IResource = undefined;
    try checkResult(swap_chain.?.GetBuffer(
        0,
        &d3d11.IID_IResource,
        @ptrCast(*?*anyopaque, &framebuffer),
    ));
    try checkResult(d3d11_device.?.CreateRenderTargetView(
        framebuffer,
        null,
        &d3d11_render_target_view,
    ));
    _ = framebuffer.Release();
}

const HResultError = DXGIError || D3D11Error || error{
    UNKNOWN_ERROR,
    E_FAIL,
    E_INVALIDARG,
    E_OUTOFMEMORY,
    E_NOTIMPL,
    S_FALSE,
};

const DXGIError = error{
    ACCESS_DENIED,
    ACCESS_LOST,
    ALREADY_EXISTS,
    CANNOT_PROTECT_CONTENT,
    DEVICE_HUNG,
    DEVICE_REMOVED,
    DEVICE_RESET,
    DRIVER_INTERNAL_ERROR,
    FRAME_STATISTICS_DISJOINT,
    GRAPHICS_VIDPN_SOURCE_IN_USE,
    INVALID_CALL,
    MORE_DATA,
    NAME_ALREADY_EXISTS,
    NONEXCLUSIVE,
    NOT_CURRENTLY_AVAILABLE,
    NOT_FOUND,
    REMOTE_CLIENT_DISCONNECTED,
    REMOTE_OUTOFMEMORY,
    RESTRICT_TO_OUTPUT_STALE,
    SDK_COMPONENT_MISSING,
    SESSION_DISCONNECTED,
    UNSUPPORTED,
    WAIT_TIMEOUT,
    WAS_STILL_DRAWING,
};

const D3D11Error = error{
    FILE_NOT_FOUND,
    TOO_MANY_UNIQUE_STATE_OBJECTS,
    TOO_MANY_UNIQUE_VIEW_OBJECTS,
    DEFERRED_CONTEXT_MAP_WITHOUT_INITIAL_DISCARD,
};

fn hresultToError(hresult: HRESULT) HResultError {
    return switch (hresult) {
        dxgi.ERROR_ACCESS_DENIED => DXGIError.ACCESS_DENIED,
        dxgi.ERROR_ACCESS_LOST => DXGIError.ACCESS_LOST,
        dxgi.ERROR_ALREADY_EXISTS => DXGIError.ALREADY_EXISTS,
        dxgi.ERROR_CANNOT_PROTECT_CONTENT => DXGIError.CANNOT_PROTECT_CONTENT,
        dxgi.ERROR_DEVICE_HUNG => DXGIError.DEVICE_HUNG,
        dxgi.ERROR_DEVICE_REMOVED => DXGIError.DEVICE_REMOVED,
        dxgi.ERROR_DEVICE_RESET => DXGIError.DEVICE_RESET,
        dxgi.ERROR_DRIVER_INTERNAL_ERROR => DXGIError.DRIVER_INTERNAL_ERROR,
        dxgi.ERROR_FRAME_STATISTICS_DISJOINT => DXGIError.FRAME_STATISTICS_DISJOINT,
        dxgi.ERROR_GRAPHICS_VIDPN_SOURCE_IN_USE => DXGIError.GRAPHICS_VIDPN_SOURCE_IN_USE,
        dxgi.ERROR_INVALID_CALL => DXGIError.INVALID_CALL,
        dxgi.ERROR_MORE_DATA => DXGIError.MORE_DATA,
        dxgi.ERROR_NAME_ALREADY_EXISTS => DXGIError.NAME_ALREADY_EXISTS,
        dxgi.ERROR_NONEXCLUSIVE => DXGIError.NONEXCLUSIVE,
        dxgi.ERROR_NOT_CURRENTLY_AVAILABLE => DXGIError.NOT_CURRENTLY_AVAILABLE,
        dxgi.ERROR_NOT_FOUND => DXGIError.NOT_FOUND,
        dxgi.ERROR_REMOTE_CLIENT_DISCONNECTED => DXGIError.REMOTE_CLIENT_DISCONNECTED,
        dxgi.ERROR_REMOTE_OUTOFMEMORY => DXGIError.REMOTE_OUTOFMEMORY,
        dxgi.ERROR_RESTRICT_TO_OUTPUT_STALE => DXGIError.RESTRICT_TO_OUTPUT_STALE,
        dxgi.ERROR_SDK_COMPONENT_MISSING => DXGIError.SDK_COMPONENT_MISSING,
        dxgi.ERROR_SESSION_DISCONNECTED => DXGIError.SESSION_DISCONNECTED,
        dxgi.ERROR_UNSUPPORTED => DXGIError.UNSUPPORTED,
        dxgi.ERROR_WAIT_TIMEOUT => DXGIError.WAIT_TIMEOUT,
        dxgi.ERROR_WAS_STILL_DRAWING => DXGIError.WAS_STILL_DRAWING,
        d3d11.ERROR_FILE_NOT_FOUND => D3D11Error.FILE_NOT_FOUND,
        d3d11.ERROR_TOO_MANY_UNIQUE_STATE_OBJECTS => D3D11Error.TOO_MANY_UNIQUE_STATE_OBJECTS,
        d3d11.ERROR_TOO_MANY_UNIQUE_VIEW_OBJECTS => D3D11Error.TOO_MANY_UNIQUE_VIEW_OBJECTS,
        d3d11.ERROR_DEFERRED_CONTEXT_MAP_WITHOUT_INITIAL_DISCARD => D3D11Error.DEFERRED_CONTEXT_MAP_WITHOUT_INITIAL_DISCARD,
        E_FAIL => HResultError.E_FAIL,
        E_INVALIDARG => HResultError.E_INVALIDARG,
        E_OUTOFMEMORY => HResultError.E_OUTOFMEMORY,
        E_NOTIMPL => HResultError.E_NOTIMPL,
        S_FALSE => HResultError.S_FALSE,
        else => HResultError.UNKNOWN_ERROR,
    };
}

fn checkResult(hresult: HRESULT) HResultError!void {
    if (hresult == S_OK) return;
    return hresultToError(hresult);
}
