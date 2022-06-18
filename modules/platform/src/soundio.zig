const std = @import("std");

const c = @cImport(
    @cInclude("soundio/soundio.h"),
);
pub usingnamespace c;

pub const Error = SoundioError || error {
    SoundioCreateFailed,
    NoOutputDeviceFound,
    FailedToAcquireOutputDevice,
    FailedToCreateOutstream,
};

pub const SoundioError = error {
    NoMem,
    InitAudioBackend,
    SystemResources,
    OpeningDevice,
    NoSuchDevice,
    Invalid,
    BackendUnavailable,
    Streaming,
    IncompatibleDevice,
    NoSuchClient,
    IncompatibleBackend,
    BackendDisconnected,
    Interrupted,
    Underflow,
    EncodingString,
};

pub fn err(code: c_int) SoundioError!void  {
    switch (code) {
        c.SoundIoErrorNone => {},
        c.SoundIoErrorNoMem => return SoundioError.NoMem,
        c.SoundIoErrorInitAudioBackend => return SoundioError.InitAudioBackend,
        c.SoundIoErrorSystemResources => return SoundioError.SystemResources,
        c.SoundIoErrorOpeningDevice => return SoundioError.OpeningDevice,
        c.SoundIoErrorNoSuchDevice => return SoundioError.NoSuchDevice,
        c.SoundIoErrorInvalid => return SoundioError.Invalid,
        c.SoundIoErrorBackendUnavailable => return SoundioError.BackendUnavailable,
        c.SoundIoErrorStreaming => return SoundioError.Streaming,
        c.SoundIoErrorIncompatibleDevice => return SoundioError.IncompatibleDevice,
        c.SoundIoErrorNoSuchClient => return SoundioError.NoSuchClient,
        c.SoundIoErrorIncompatibleBackend => return SoundioError.IncompatibleBackend,
        c.SoundIoErrorBackendDisconnected => return SoundioError.BackendDisconnected,
        c.SoundIoErrorInterrupted => return SoundioError.Interrupted,
        c.SoundIoErrorUnderflow => return SoundioError.Underflow,
        c.SoundIoErrorEncodingString => return SoundioError.EncodingString,
        else => {
            std.log.warn("unrecognised soundio status code: {}", .{code});
        },
    }
}

pub fn Interface(comptime log: anytype, comptime write_cb: anytype) type {
    return struct {
        context: *c.SoundIo,
        device: *c.SoundIoDevice,
        outstream: *c.SoundIoOutStream,
    
        pub fn init() Error!@This() {
            if (c.soundio_create()) |context| {
                errdefer c.soundio_destroy(context);
                
                try err(c.soundio_connect(context));
                c.soundio_flush_events(context);
                
                const default_output_dev_idx = c.soundio_default_output_device_index(context);
                if (default_output_dev_idx < 0) {
                    return Error.NoOutputDeviceFound;
                }
                
                if (c.soundio_get_output_device(context, default_output_dev_idx)) |device| {
                    errdefer c.soundio_device_unref(device);
                    
                    log.info("Audio output device: {s}", .{device.*.name});
                    
                    if (c.soundio_outstream_create(device)) |outstream| {
                        errdefer c.soundio_outstream_destroy(outstream);
                    
                        outstream.*.format = c.SoundIoFormatFloat32NE;
                        outstream.*.write_callback = write_cb;
                        try err(c.soundio_outstream_open(outstream));
                        
                        return @This() {
                            .context = context,
                            .device = device,
                            .outstream = outstream,
                        };
                    }
                    else {
                        return Error.FailedToCreateOutstream;
                    }
                }
                else {
                    return Error.FailedToAcquireOutputDevice;
                }
                
            }
            else {
                return Error.SoundioCreateFailed;
            }
        }
        
        pub fn deinit(self: *@This()) void {
            while (true) c.soundio_wait_events(self.context);
            c.soundio_outstream_destroy(self.outstream);
            c.soundio_device_unref(self.device);
            c.soundio_destroy(self.context);
        }
        
        pub fn start(self: *@This()) !void {
            try err(c.soundio_outstream_start(self.outstream));
        }
    };
}
