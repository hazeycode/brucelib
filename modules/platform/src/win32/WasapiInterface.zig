const std = @import("std");

const zwin32 = @import("../vendored/zwin32/src/zwin32.zig");
const w = zwin32.base;
const wasapi = zwin32.wasapi;
const hrErrorOnFail = zwin32.hrErrorOnFail;

pub const WasapiInterface = @This();

client: *wasapi.IAudioClient3,
render_client: *wasapi.IAudioRenderClient,
buffer_ready_event: w.HANDLE,
num_channels: u32,
sample_rate: u32,
bits_per_sample: u32,
frame_size: u32,

pub fn init(requested_sample_rate: u32) !WasapiInterface {
    var audio_device_enumerator: *wasapi.IMMDeviceEnumerator = undefined;
    try hrErrorOnFail(w.CoCreateInstance(
        &wasapi.CLSID_MMDeviceEnumerator,
        null,
        w.CLSCTX_INPROC_SERVER,
        &wasapi.IID_IMMDeviceEnumerator,
        @ptrCast(*?*anyopaque, &audio_device_enumerator),
    ));
    defer _ = audio_device_enumerator.Release();

    var audio_device: *wasapi.IMMDevice = undefined;
    try hrErrorOnFail(audio_device_enumerator.GetDefaultAudioEndpoint(
        .eRender,
        .eConsole,
        @ptrCast(*?*wasapi.IMMDevice, &audio_device),
    ));
    defer _ = audio_device.Release();

    var client: *wasapi.IAudioClient3 = undefined;
    try hrErrorOnFail(audio_device.Activate(
        &wasapi.IID_IAudioClient3,
        w.CLSCTX_INPROC_SERVER,
        null,
        @ptrCast(*?*anyopaque, &client),
    ));

    const channels = 2;
    const sample_rate = requested_sample_rate;
    const bits_per_sample = 32;
    const block_align = channels * bits_per_sample / 8;
    const wanted_format = wasapi.WAVEFORMATEX{
        .wFormatTag = wasapi.WAVE_FORMAT_IEEE_FLOAT,
        .nChannels = channels,
        .nSamplesPerSec = sample_rate,
        .nAvgBytesPerSec = sample_rate * block_align,
        .nBlockAlign = block_align,
        .wBitsPerSample = bits_per_sample,
        .cbSize = 0,
    };

    var closest_format: ?*wasapi.WAVEFORMATEX = null;
    try hrErrorOnFail(client.IsFormatSupported(.SHARED, &wanted_format, &closest_format));

    const format = if (closest_format) |fmt| fmt.* else wanted_format;

    try hrErrorOnFail(client.Initialize(
        .SHARED,
        wasapi.AUDCLNT_STREAMFLAGS_EVENTCALLBACK,
        0,
        0,
        &format,
        null,
    ));

    var render_client: *wasapi.IAudioRenderClient = undefined;
    try hrErrorOnFail(client.GetService(
        &wasapi.IID_IAudioRenderClient,
        @ptrCast(*?*anyopaque, &render_client),
    ));

    const buffer_ready_event = try zwin32.base.CreateEventEx(
        null,
        "audio_buffer_ready_event",
        0,
        zwin32.base.EVENT_ALL_ACCESS,
    );

    try hrErrorOnFail(client.SetEventHandle(buffer_ready_event));

    return WasapiInterface{
        .client = client,
        .render_client = render_client,
        .buffer_ready_event = buffer_ready_event,
        .num_channels = format.nChannels,
        .sample_rate = format.nSamplesPerSec,
        .bits_per_sample = format.wBitsPerSample,
        .frame_size = format.nBlockAlign,
    };
}

pub fn deinit(self: *WasapiInterface) void {
    w.CloseHandle(self.buffer_ready_event);
    _ = self.client.Stop();
    _ = self.render_client.Release();
    _ = self.client.Release();
}
