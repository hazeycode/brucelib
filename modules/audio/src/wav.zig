const std = @import("std");

const log = std.log.scoped(.@"brucelib.audio.wav");

pub const Format = enum {
    unsigned8,
    signed16,
    signed24,
    signed32,
};

pub const Desc = struct {
    format: Format,
    channels: u16,
    sample_rate: u32,
    sample_bytes: []u8,
};

/// Caller is responsible for freeing memory allocated for returned .sample_bytes
pub fn readFromBytes(allocator: std.mem.Allocator, bytes: []const u8) !Desc {
    var reader = std.io.fixedBufferStream(bytes).reader();
    return read(allocator, reader);
}

/// Caller is responsible for freeing memory allocated for returned .sample_bytes
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
    var data: []u8 = undefined;

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

            data = try allocator.alloc(u8, block_size);
            errdefer allocator.free(data);

            try reader.readNoEof(data);

            read_data = true;
        } else {
            // skip unrecognised block
            try reader.skipBytes(block_size, .{});
            log.debug("block \"{s}\" skipped", .{block_id});
        }
    }

    return Desc{
        .format = format,
        .channels = channels,
        .sample_rate = sample_rate,
        .sample_bytes = data,
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
