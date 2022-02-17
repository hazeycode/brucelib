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
const kernel32 = win32.base.kernel32;
const user32 = win32.base.user32;
const dxgi = win32.dxgi;
const d3d = win32.d3d;
const d3d11 = win32.d3d11;
const d3dcompiler = win32.d3dcompiler;

const L = std.unicode.utf8ToUtf16LeStringLiteral;

pub const default_graphics_api = core.GraphicsAPI.d3d11;

pub const Error = error{
    FailedToGetModuleHandle,
};

var window_width: u16 = undefined;
var window_height: u16 = undefined;
var window_closed = false;

pub fn run(args: struct {
    graphics_api: core.GraphicsAPI = default_graphics_api,
    title: [:0]const u8 = "",
    pxwidth: u16 = 854,
    pxheight: u16 = 480,
    init_fn: fn (std.mem.Allocator) anyerror!void,
    deinit_fn: fn () void,
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

    try args.init_fn(allocator);
    defer args.deinit_fn();

    var quit = false;
    while (quit == false) main_loop: {
        var frame_mem_arena = std.heap.ArenaAllocator.init(allocator);
        defer frame_mem_arena.deinit();

        const arena_allocator = frame_mem_arena.allocator();

        var key_events = std.ArrayList(Input.KeyEvent).init(arena_allocator);
        var mouse_button_events = std.ArrayList(Input.MouseButtonEvent).init(arena_allocator);

        var msg: user32.MSG = undefined;
        while (try user32.peekMessageW(&msg, null, 0, 0, user32.PM_REMOVE)) {
            _ = user32.translateMessage(&msg);
            _ = user32.dispatchMessageW(&msg);
            if (msg.message == user32.WM_QUIT) {
                quit = true;
                break :main_loop;
            }
        }

        quit = !(try args.update_fn(.{
            .frame_arena_allocator = arena_allocator,
            .key_events = key_events.items,
            .mouse_button_events = mouse_button_events.items,
            .canvas_size = .{
                .width = window_width,
                .height = window_height,
            },
            .quit_requested = window_closed,
        }));

        try win32.hrErrorOnFail(dxgi_swap_chain.?.Present(1, 0));
    }
}

fn wndProc(hwnd: HWND, msg: UINT, wparam: WPARAM, lparam: LPARAM) callconv(.C) LRESULT {
    switch (msg) {
        user32.WM_CLOSE => {
            window_closed = true;
            return 0;
        },
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
    const offset_x = 60;
    const offset_y = 60;
    var rect = RECT{
        .left = offset_x,
        .top = offset_y,
        .right = offset_x + window_width,
        .bottom = offset_y + window_height,
    };
    const style: DWORD = user32.WS_OVERLAPPEDWINDOW;
    try user32.adjustWindowRectEx(&rect, style, false, 0);
    const hwnd = try user32.createWindowExW(
        0,
        class_name,
        window_name,
        style,
        rect.left,
        rect.top,
        rect.right - rect.left,
        rect.bottom - rect.top,
        null,
        null,
        hinstance,
        null,
    );
    _ = user32.showWindow(hwnd, user32.SW_SHOWNORMAL);
    try user32.updateWindow(hwnd);
    return hwnd;
}

var dxgi_swap_chain: ?*dxgi.ISwapChain = null;
var d3d11_device: ?*d3d11.IDevice = null;
var d3d11_device_context: ?*d3d11.IDeviceContext = null;
var d3d11_render_target_view: ?*d3d11.IRenderTargetView = null;

fn createDeviceAndSwapchain(hwnd: HWND) win32.HResultError!void {
    // TODO(chris): check that hardware supports the multisampling values we want
    // and downgrade if nessesary
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
            .Count = 4,
            .Quality = @enumToInt(d3d11.STANDARD_MULTISAMPLE_QUALITY_LEVELS.STANDARD_MULTISAMPLE_PATTERN),
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

    var feature_level: d3d.FEATURE_LEVEL = .FL_11_1;

    try win32.hrErrorOnFail(d3d11.D3D11CreateDeviceAndSwapChain(
        null,
        d3d.DRIVER_TYPE.HARDWARE,
        null,
        flags,
        null,
        0,
        d3d11.SDK_VERSION,
        &swapchain_desc,
        &dxgi_swap_chain,
        &d3d11_device,
        &feature_level,
        &d3d11_device_context,
    ));
}

fn createRenderTargetView() win32.HResultError!void {
    var framebuffer: *d3d11.IResource = undefined;
    try win32.hrErrorOnFail(dxgi_swap_chain.?.GetBuffer(
        0,
        &d3d11.IID_IResource,
        @ptrCast(*?*anyopaque, &framebuffer),
    ));
    try win32.hrErrorOnFail(d3d11_device.?.CreateRenderTargetView(
        framebuffer,
        null,
        &d3d11_render_target_view,
    ));
    _ = framebuffer.Release();
}

export fn getD3D11Device() *d3d11.IDevice {
    return d3d11_device.?;
}

export fn getD3D11DeviceContext() *d3d11.IDeviceContext {
    return d3d11_device_context.?;
}

export fn getD3D11RenderTargetView() *d3d11.IRenderTargetView {
    return d3d11_render_target_view.?;
}
