const std = @import("std");

const log = std.log.scoped(.@"brucelib.audio.wav");

pub const Desc = struct {
    channels: u16,
    sample_rate: u32,
    samples: []f32,
};

const Format = enum {
    unsigned8,
    signed16,
    signed24,
    signed32,
};

/// Caller is responsible for freeing memory allocated for returned samples buffer
pub fn readFromBytes(allocator: std.mem.Allocator, bytes: []const u8) !Desc {
    var reader = std.io.fixedBufferStream(bytes).reader();
    return read(allocator, reader);
}

/// Caller is responsible for freeing memory allocated for returned samples buffer
pub fn read(allocator: std.mem.Allocator, reader: anytype) !Desc {
    try readExpectedQuad(reader, .{ 'R', 'I', 'F', 'F' });

    try reader.skipBytes(4, .{});

    try readExpectedQuad(reader, .{ 'W', 'A', 'V', 'E' });

    var format: Format = undefined;
    var channels: u16 = undefined;
    var sample_rate: u32 = undefined;
    var byte_rate: u32 = undefined;
    var block_align: u16 = undefined;
    var bits_per_sample: u16 = undefined;
    var bytes_per_sample: u16 = undefined;
    var samples: []f32 = undefined;

    var read_fmt = false;
    var read_data = false;
    while (read_fmt == false or read_data == false) {
        const block_id = try readQuad(reader);
        const block_size = try reader.readIntLittle(u32);

        if (std.mem.eql(u8, block_id[0..], "fmt ")) {
            if (read_fmt) return error.UnexpectedFormat;

            format = @intToEnum(Format, try reader.readIntLittle(u16));

            channels = try reader.readIntLittle(u16);
            if (channels == 0) return error.UnexpectedFormat;

            sample_rate = try reader.readIntLittle(u32);
            if (sample_rate == 0) return error.UnexpectedFormat;

            byte_rate = try reader.readIntLittle(u32);
            if (byte_rate == 0) return error.UnexpectedFormat;

            block_align = try reader.readIntLittle(u16);
            if (block_align == 0) return error.UnexpectedFormat;

            bits_per_sample = try reader.readIntLittle(u16);
            if (bits_per_sample == 0) return error.UnexpectedFormat;

            // skip any trailing fmt block bytes
            if (block_size > 16) {
                try reader.skipBytes(block_size - 16, .{});
            }

            bytes_per_sample = switch (format) {
                .unsigned8 => 1,
                .signed16 => 2,
                .signed24 => 3,
                .signed32 => 4,
            };

            if (byte_rate != @intCast(u32, sample_rate) * channels * bytes_per_sample) {
                return error.InvalidByteRate;
            }

            if (block_align != channels * bytes_per_sample) {
                return error.InvalidBlockAlign;
            }

            // skip any trailing fmt block bytes
            if (block_size > 16) {
                try reader.skipBytes(block_size - 16, .{});
            }

            read_fmt = true;
        } else if (std.mem.eql(u8, block_id[0..], "data")) {
            if (read_data) return error.UnexpectedFormat;

            if (block_size % (channels * bytes_per_sample) != 0) {
                return error.InvalidDataSize;
            }

            const num_samples = block_size / bytes_per_sample;

            samples = try allocator.alloc(f32, num_samples);
            errdefer allocator.free(samples);

            const recip_conv_factor = @intToFloat(f32, std.math.pow(u32, 2, bits_per_sample - 1) - 1);

            switch (format) {
                .unsigned8 => for (samples) |*sample| {
                    const max = std.math.pow(i16, 2, @intCast(i16, bits_per_sample - 1));
                    const int = @intCast(i16, try reader.readIntLittle(u8)) - max;
                    sample.* = @intToFloat(f32, int) / recip_conv_factor;
                },
                .signed16 => for (samples) |*sample| {
                    const int = try reader.readIntLittle(i16);
                    sample.* = @intToFloat(f32, int) / recip_conv_factor;
                },
                .signed24 => for (samples) |*sample| {
                    const int = try reader.readIntLittle(i24);
                    sample.* = @intToFloat(f32, int) / recip_conv_factor;
                },
                .signed32 => for (samples) |*sample| {
                    const int = try reader.readIntLittle(i32);
                    sample.* = @intToFloat(f32, int) / recip_conv_factor;
                },
            }

            read_data = true;
        } else {
            // skip unrecognised block
            try reader.skipBytes(block_size, .{});
            // log.debug("block \"{s}\" skipped", .{block_id});
        }
    }

    log.debug(
        "read wav: {} channels, {} Hz, {} bit, {} samples",
        .{ channels, sample_rate, bits_per_sample, samples.len },
    );

    return Desc{
        .channels = channels,
        .sample_rate = sample_rate,
        .samples = samples,
    };
}

fn readQuad(reader: anytype) ![4]u8 {
    var quad: [4]u8 = undefined;
    try reader.readNoEof(&quad);
    return quad;
}

fn readExpectedQuad(reader: anytype, expected: [4]u8) !void {
    const quad = try readQuad(reader);
    if (std.mem.eql(u8, &quad, &expected) == false) {
        log.warn("Expected \"{s}\", read \"{s}\"", .{ &expected, &quad });
        return error.UnexpectedFormat;
    }
}
