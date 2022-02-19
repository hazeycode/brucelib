pub usingnamespace @import("local.zig");
pub usingnamespace @import("pcm.zig");

const snderr = @import("error.zig");
pub usingnamespace snderr;

pub fn checkError(return_code: c_int) !void {
    const std = @import("std");
    if (return_code < 0) {
        std.log.err("{s}", .{snderr.snd_strerror(return_code)});
        return error.AlsaError;
    }
}
