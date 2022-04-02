const std = @import("std");

const stbi = @import("stb_image");

const common = @import("common.zig");
const TextureFormat = common.TextureFormat;
const TextureHandle = common.TextureHandle;

pub fn withBackend(comptime backend: anytype) type {
    return struct {
        pub const Texture2d = struct {
            handle: TextureHandle,
            format: TextureFormat,
            width: u32,
            height: u32,

            pub fn fromBytes(bytes: []const u8) !Texture2d {
                var width: u32 = undefined;
                var height: u32 = undefined;
                var channels: u32 = undefined;
                
                const texture_bytes = stbi.stbi_load_from_memory(
                    bytes.ptr,
                    @intCast(c_int, bytes.len),
                    @ptrCast(*c_int, &width),
                    @ptrCast(*c_int, &height),
                    @ptrCast(*c_int, &channels),
                    0,
                );
                defer stbi.stbi_image_free(texture_bytes);

                const texture_bytes_size = width * height * channels * @sizeOf(u8);

                const format: TextureFormat = switch (channels) {
                    4 => .rgba_u8,
                    else => unreachable,
                };

                const handle = try backend.createTexture2dWithBytes(
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

            pub fn fromPBM(allocator: std.mem.Allocator, pbm_bytes: []const u8) !Texture2d {
                return try pbm.parse(allocator, pbm_bytes);
            }

            const pbm = struct {
                pub fn parse(allocator: std.mem.Allocator, bytes: []const u8) !Texture2d {
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
                        var texture_bytes = std.ArrayList(u8).init(allocator);
                        defer texture_bytes.deinit();

                        const magic_number = try self.magicNumber();
                        self.whitespace();
                        const width = self.integer();
                        self.whitespace();
                        const height = self.integer();
                        self.whitespace();
                        switch (magic_number) {
                            .p1 => {
                                const format = TextureFormat.uint8;

                                for (self.bytes[self.cur..]) |c| {
                                    if (isWhitespace(c)) continue;
                                    try texture_bytes.append(switch (c) {
                                        '1' => 255,
                                        else => 0,
                                    });
                                }

                                std.debug.assert(texture_bytes.items.len == width * height);

                                const handle = try backend.createTexture2dWithBytes(
                                    texture_bytes.items,
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

                    fn magicNumber(self: *@This()) !enum { p1, p4 } {
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
                        while (isWhitespace(self.bytes[self.cur])) {
                            self.cur += 1;
                        }
                    }

                    inline fn isWhitespace(char: u8) bool {
                        const whitespace_chars = "    \n\r";
                        inline for (whitespace_chars) |wsc| if (wsc == char) return true;
                        return false;
                    }

                    fn integer(self: *@This()) u32 {
                        var res: u32 = 0;
                        for (self.bytes[self.cur..]) |c| {
                            self.cur += 1;
                            if (isWhitespace(c)) break;
                            res = (res << 3) +% (res << 1) +% (c -% '0');
                        }
                        return res;
                    }
                };
            };
        };
    };
}
