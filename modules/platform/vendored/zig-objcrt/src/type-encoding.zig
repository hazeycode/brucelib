//! This module provides functions to convert supported Zig types to Objective-C type encodings
// TODO(hazeycode): more tests

const std = @import("std");
const testing = std.testing;

const objc = @import("objc.zig");
const object = objc.object;
const Class = objc.Class;
const id = objc.id;
const SEL = objc.SEL;

/// Enum representing typecodes as defined by Apple's docs https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
const TypeEncodingToken = enum(u8) {
    char = 'c',
    int = 'i',
    short = 's',
    long = 'l', // treated as a 32-bit quantity on 64-bit programs
    long_long = 'q',
    unsigned_char = 'C',
    unsigned_int = 'I',
    unsigned_short = 'S',
    unsigned_long = 'L',
    unsigned_long_long = 'Q',
    float = 'f',
    double = 'd',
    bool = 'B', // A C++ bool or a C99 _Bool
    void = 'v',
    char_string = '*', // A character string (char *)
    object = '@', // An object (whether statically typed or typed id)
    class = '#', // A class object (Class)
    selector = ':', // A method selector (SEL)
    array_begin = '[',
    array_end = ']',
    struct_begin = '{',
    struct_end = '}',
    union_begin = '(',
    union_end = ')',
    pair_separator = '=', // Used to separate name-types pairs in structures and unions
    bitfield = 'b', // Precedes a number representing the size of the bitfield
    pointer = '^', // Precedes a typecode to represent a pointer to type
    unknown = '?', // An unknown type (among other things, this code is used for function pointers)
};

pub fn writeEncodingForType(comptime MaybeT: ?type, writer: anytype) !void {
    var levels_of_indirection: u32 = 0;
    return writeEncodingForTypeInternal(MaybeT, &levels_of_indirection, writer);
}

fn writeEncodingForTypeInternal(comptime MaybeT: ?type, levels_of_indirection: *u32, writer: anytype) !void {
    const T = MaybeT orelse {
        try writeTypeEncodingToken(.void, writer);
        return;
    };
    switch (T) {
        i8 => try writeTypeEncodingToken(.char, writer),
        c_int => try writeTypeEncodingToken(.int, writer),
        c_short => try writeTypeEncodingToken(.short, writer),
        c_long => try writeTypeEncodingToken(.long, writer),
        c_longlong => try writeTypeEncodingToken(.long_long, writer),
        u8 => try writeTypeEncodingToken(.unsigned_char, writer),
        c_uint => try writeTypeEncodingToken(.unsigned_int, writer),
        c_ushort => try writeTypeEncodingToken(.unsigned_short, writer),
        c_ulong => try writeTypeEncodingToken(.unsigned_long, writer),
        c_ulonglong => try writeTypeEncodingToken(.unsigned_long_long, writer),
        f32 => try writeTypeEncodingToken(.float, writer),
        f64 => try writeTypeEncodingToken(.double, writer),
        bool => try writeTypeEncodingToken(.bool, writer),
        void => try writeTypeEncodingToken(.void, writer),
        [*c]u8, [*c]const u8 => try writeTypeEncodingToken(.char_string, writer),
        id => try writeTypeEncodingToken(.object, writer),
        Class => try writeTypeEncodingToken(.class, writer),
        SEL => try writeTypeEncodingToken(.selector, writer),
        object => {
            try writeTypeEncodingToken(.struct_begin, writer);
            try writer.writeAll(@typeName(T));
            try writeTypeEncodingToken(.pair_separator, writer);
            try writeTypeEncodingToken(.class, writer);
            try writeTypeEncodingToken(.struct_end, writer);
        },
        else => switch (@typeInfo(T)) {
            .Fn => |fn_info| {
                try writeEncodingForTypeInternal(fn_info.return_type, levels_of_indirection, writer);
                inline for (fn_info.args) |arg| {
                    try writeEncodingForTypeInternal(arg.arg_type, levels_of_indirection, writer);
                }
            },
            .Array => |arr_info| {
                try writeTypeEncodingToken(.array_begin, writer);
                try writer.print("{d}", .{arr_info.len});
                try writeEncodingForTypeInternal(arr_info.child, levels_of_indirection, writer);
                try writeTypeEncodingToken(.array_end, writer);
            },
            .Struct => |struct_info| {
                try writeTypeEncodingToken(.struct_begin, writer);
                try writer.writeAll(@typeName(T));
                if (levels_of_indirection.* < 2) {
                    try writeTypeEncodingToken(.pair_separator, writer);
                    inline for (struct_info.fields) |field| try writeEncodingForTypeInternal(field.field_type, levels_of_indirection, writer);
                }
                try writeTypeEncodingToken(.struct_end, writer);
            },
            .Union => |union_info| {
                try writeTypeEncodingToken(.union_begin, writer);
                try writer.writeAll(@typeName(T));
                if (levels_of_indirection.* < 2) {
                    try writeTypeEncodingToken(.pair_separator, writer);
                    inline for (union_info.fields) |field| try writeEncodingForTypeInternal(field.field_type, levels_of_indirection, writer);
                }
                try writeTypeEncodingToken(.union_end, writer);
            },
            .Pointer => |ptr_info| switch (ptr_info.size) {
                .One => {
                    levels_of_indirection.* += 1;
                    try writeTypeEncodingToken(.pointer, writer);
                    try writeEncodingForTypeInternal(ptr_info.child, levels_of_indirection, writer);
                },
                else => @compileError("Unsupported type"),
            },
            else => @compileError("Unsupported type"),
        },
    }
}

fn writeTypeEncodingToken(token: TypeEncodingToken, writer: anytype) !void {
    try writer.writeByte(@enumToInt(token));
}

test "write encoding for array" {
    var buffer: [0x100]u8 = undefined;
    var fbs = std.io.fixedBufferStream(&buffer);

    try writeEncodingForType([12]*f32, fbs.writer());
    try testing.expectEqualSlices(u8, "[12^f]", fbs.getWritten());
}

test "write encoding for struct, pointer to struct and pointer to pointer to struct" {
    const Example = struct {
        anObject: id,
        aString: [*c]u8,
        anInt: c_int,
    };

    var buffer: [0x100]u8 = undefined;

    {
        var fbs = std.io.fixedBufferStream(&buffer);
        try writeEncodingForType(Example, fbs.writer());
        try testing.expectEqualSlices(u8, "{Example=@*i}", fbs.getWritten());
    }

    {
        var fbs = std.io.fixedBufferStream(&buffer);
        try writeEncodingForType(*Example, fbs.writer());
        try testing.expectEqualSlices(u8, "^{Example=@*i}", fbs.getWritten());
    }

    {
        var fbs = std.io.fixedBufferStream(&buffer);
        try writeEncodingForType(**Example, fbs.writer());
        try testing.expectEqualSlices(u8, "^^{Example}", fbs.getWritten());
    }
}

test "write encoding for fn" {
    try struct {
        pub fn runTest() !void {
            var buffer: [0x100]u8 = undefined;
            var fbs = std.io.fixedBufferStream(&buffer);
            try writeEncodingForType(@TypeOf(add), fbs.writer());
            try testing.expectEqualSlices(u8, "i@:ii", fbs.getWritten());
        }

        fn add(_: id, _: SEL, a: c_int, b: c_int) callconv(.C) c_int {
            return a + b;
        }
    }.runTest();
}
