const std = @import("std");

const stbi = @cImport("vendored/stb_image/main.zig");

const common = @import("common.zig");
const TextureFormat = common.TextureFormat;
const TextureHandle = common.TextureHandle;

pub fn using_backend(comptime Backend: anytype) type {
    return struct {
        pub const Texture2d = struct {
            handle: TextureHandle,
            format: TextureFormat,
            width: u32,
            height: u32,

            pub fn from_raw_bytes(
                format: TextureFormat,
                width: u32,
                height: u32,
                bytes: []const u8,
            ) !Texture2d {
                const handle = try Backend.create_texture2d_with_bytes(
                    bytes,
                    width,
                    height,
                    format,
                );
                return Texture2d{
                    .handle = handle,
                    .format = format,
                    .width = width,
                    .height = height,
                };
            }

            pub fn from_bytes(bytes: []const u8) !Texture2d {
                var width: u32 = undefined;
                var height: u32 = undefined;
                var channels: u32 = 1;

                const texture_bytes = stbi.stbi_load_from_memory(
                    bytes.ptr,
                    @intCast(c_int, bytes.len),
                    @ptrCast(*c_int, &width),
                    @ptrCast(*c_int, &height),
                    @ptrCast(*c_int, &channels),
                    0,
                );
                defer stbi.stbi_image_free(texture_bytes);

                if (texture_bytes == null) return error.FailedToLoadImage;

                const texture_bytes_size = width * height * channels * @sizeOf(u8);

                const format: TextureFormat = switch (channels) {
                    4 => .rgba_u8,
                    else => unreachable,
                };

                const handle = try Backend.create_texture2d_with_bytes(
                    texture_bytes[0..texture_bytes_size],
                    width,
                    height,
                    format,
                );

                return Texture2d{
                    .handle = handle,
                    .format = format,
                    .width = width,
                    .height = height,
                };
            }

            pub fn from_pbm(
                allocator: std.mem.Allocator,
                pbm_bytes: []const u8,
            ) !Texture2d {
                return try pbm.parse(allocator, pbm_bytes);
            }

            const pbm = struct {
                pub fn parse(
                    allocator: std.mem.Allocator,
                    bytes: []const u8,
                ) !Texture2d {
                    var parser = Parser{
                        .bytes = bytes,
                        .cur = 0,
                    };
                    return parser.parse(allocator);
                }

                pub const Parser = struct {
                    bytes: []const u8,
                    cur: usize,

                    fn parse(self: *@This(), allocator: std.mem.Allocator) !Texture2d {
                        const magic = try self.magic_number();
                        self.whitespace();

                        const width = self.integer();
                        self.whitespace();

                        const height = self.integer();
                        self.whitespace();

                        var texture_rows = try allocator.alloc([]u8, height);
                        defer allocator.free(texture_rows);

                        for (texture_rows) |*row| {
                            row.* = try allocator.alloc(u8, width);
                        }
                        defer {
                            for (texture_rows) |*row| {
                                allocator.free(row.*);
                            }
                        }

                        var texture_bytes = try allocator.alloc(u8, width * height);
                        defer allocator.free(texture_bytes);

                        switch (magic) {
                            .p1 => {
                                const format = TextureFormat.uint8;

                                var i: usize = 0;
                                for (self.bytes[self.cur..]) |c| {
                                    if (is_whitespace(c)) continue;
                                    texture_bytes[i] = switch (c) {
                                        '1' => 255,
                                        else => 0,
                                    };
                                    i += 1;
                                }

                                const handle = try Backend.create_texture2d_with_bytes(
                                    texture_bytes,
                                    width,
                                    height,
                                    format,
                                );

                                return Texture2d{
                                    .handle = handle,
                                    .format = format,
                                    .width = width,
                                    .height = height,
                                };
                            },
                            .p4 => return error.Unimplemented,
                        }
                    }

                    fn magic_number(self: *@This()) !enum { p1, p4 } {
                        if (self.bytes[self.cur] != 'P') return error.BadFormat;
                        self.cur += 1;
                        defer self.cur += 1;
                        switch (self.bytes[self.cur]) {
                            '1' => return .p1,
                            '4' => return .p4,
                            else => return error.BadFormat,
                        }
                    }

                    fn whitespace(self: *@This()) void {
                        while (is_whitespace(self.bytes[self.cur])) {
                            self.cur += 1;
                        }
                    }

                    inline fn is_whitespace(char: u8) bool {
                        const whitespace_chars = " \t\n\r";
                        inline for (whitespace_chars) |wsc| if (wsc == char) return true;
                        return false;
                    }

                    fn integer(self: *@This()) u32 {
                        var res: u32 = 0;
                        for (self.bytes[self.cur..]) |c| {
                            self.cur += 1;
                            if (is_whitespace(c)) break;
                            res = (res << 3) +% (res << 1) +% (c -% '0');
                        }
                        return res;
                    }
                };
            };
        };
    };
}
