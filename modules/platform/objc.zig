// Zig wrapper for objc runtime. Rather unsafe, use will caution

const std = @import("std");

const c = @cImport({
    @cInclude("objc/message.h");
});

pub const id = c.id;

pub fn allocAndInit(class: c.Class) id {
    return msgSend(msgSend(class, "alloc", .{}, c.Class), "init", .{}, id);
}

pub fn lookupClass(s: [*c]const u8) !c.Class {
    return @ptrCast(c.Class, @alignCast(@alignOf(c.Class), c.objc_lookUpClass(s))) orelse error.NotFound;
}

pub fn msgSend(obj: anytype, sel_name: [:0]const u8, args: anytype, comptime ReturnType: type) ReturnType {
    const args_meta = @typeInfo(@TypeOf(args)).Struct.fields;

    const FnType = blk: {
        {
            // NOTE(hazeycode): The following commented out code crashes the compiler :( last tested with Zig 0.9.0
            // https://github.com/ziglang/zig/issues/9526
            // comptime var fn_args: [2 + args_meta.len]std.builtin.TypeInfo.FnArg = undefined;
            // fn_args[0] = .{
            //     .is_generic = false,
            //     .is_noalias = false,
            //     .arg_type = @TypeOf(obj),
            // };
            // fn_args[1] = .{
            //     .is_generic = false,
            //     .is_noalias = false,
            //     .arg_type = c.SEL,
            // };
            // inline for (args_meta) |a, i| {
            //     fn_args[2 + i] = .{
            //         .is_generic = false,
            //         .is_noalias = false,
            //         .arg_type = a.field_type,
            //     };
            // }
            // break :blk @Type(.{ .Fn = .{
            //     .calling_convention = .C,
            //     .alignment = 0,
            //     .is_generic = false,
            //     .is_var_args = false,
            //     .return_type = ReturnType,
            //     .args = &fn_args,
            // } });
        }
        {
            // TODO(hazeycode): replace this hack with the more generalised code above once it doens't crash the compiler
            break :blk switch (args_meta.len) {
                0 => fn (@TypeOf(obj), c.SEL) callconv(.C) ReturnType,
                1 => fn (@TypeOf(obj), c.SEL, args_meta[0].field_type) callconv(.C) ReturnType,
                2 => fn (@TypeOf(obj), c.SEL, args_meta[0].field_type, args_meta[1].field_type) callconv(.C) ReturnType,
                3 => fn (@TypeOf(obj), c.SEL, args_meta[0].field_type, args_meta[1].field_type, args_meta[2].field_type) callconv(.C) ReturnType,
                4 => fn (@TypeOf(obj), c.SEL, args_meta[0].field_type, args_meta[1].field_type, args_meta[2].field_type, args_meta[3].field_type) callconv(.C) ReturnType,
                else => @compileError("Unsupported number of args"),
            };
        }
    };

    // NOTE: func is a var because making it const causes a compile error which I believe is a compiler bug
    var func = @ptrCast(FnType, c.objc_msgSend);
    const sel = c.sel_getUid(sel_name);

    return @call(.{}, func, .{ obj, sel } ++ args);
}
