//! This module provides type-safe-ish bindings to the API defined in objc/message.h
// TODO(hazeycode): add missing definitions

const std = @import("std");

const c = @import("c.zig");

const objc = @import("objc.zig");
const object = objc.object;
const Class = objc.Class;
const id = objc.id;
const SEL = objc.SEL;
const sel_getUid = objc.sel_getUid;

/// Sends a message to an id or Class and returns the return value of the called method
pub fn msgSend(comptime ReturnType: type, target: anytype, selector: SEL, args: anytype) ReturnType {
    const target_type = @TypeOf(target);
    if ((target_type == id or target_type == Class) == false) @compileError("msgSend target should be of type id or Class");

    const args_meta = @typeInfo(@TypeOf(args)).Struct.fields;
    const FnType = blk: {
        {
            // NOTE(hazeycode): The following commented out code crashes the compiler :( last tested with Zig 0.9.0
            // https://github.com/ziglang/zig/issues/9526
            // comptime var fn_args: [2 + args_meta.len]std.builtin.TypeInfo.FnArg = undefined;
            // fn_args[0] = .{
            //     .is_generic = false,
            //     .is_noalias = false,
            //     .arg_type = @TypeOf(target),
            // };
            // fn_args[1] = .{
            //     .is_generic = false,
            //     .is_noalias = false,
            //     .arg_type = SEL,
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
                0 => fn (@TypeOf(target), SEL) callconv(.C) ReturnType,
                1 => fn (@TypeOf(target), SEL, args_meta[0].field_type) callconv(.C) ReturnType,
                2 => fn (@TypeOf(target), SEL, args_meta[0].field_type, args_meta[1].field_type) callconv(.C) ReturnType,
                3 => fn (@TypeOf(target), SEL, args_meta[0].field_type, args_meta[1].field_type, args_meta[2].field_type) callconv(.C) ReturnType,
                4 => fn (@TypeOf(target), SEL, args_meta[0].field_type, args_meta[1].field_type, args_meta[2].field_type, args_meta[3].field_type) callconv(.C) ReturnType,
                else => @compileError("Unsupported number of args: add more variants in zig-objcrt/src/message.zig"),
            };
        }
    };

    // NOTE: func is a var because making it const causes a compile error which I believe is a compiler bug
    var func = @ptrCast(FnType, c.objc_msgSend);

    return @call(.{}, func, .{ target, selector } ++ args);
}
