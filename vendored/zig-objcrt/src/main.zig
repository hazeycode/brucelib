//! This is the top level module that exposes type-safe Objective-C runtime bindings and convenient wrappers

const std = @import("std");
const testing = std.testing;

pub const nil: ?id = null;

const objc = @import("objc.zig");
pub const object = objc.object;
pub const Class = objc.Class;
pub const id = objc.id;
pub const SEL = objc.SEL;
pub const IMP = objc.IMP;
pub const sel_registerName = objc.sel_registerName;
pub const sel_getUid = objc.sel_getUid;

const runtime = @import("runtime.zig");
pub const Method = runtime.Method;
pub const Ivar = runtime.Ivar;
pub const Category = runtime.Category;
pub const Property = runtime.Property;
pub const Protocol = runtime.Protocol;
pub const object_getClass = runtime.object_getClass;
pub const object_getInstanceVariable = runtime.object_getInstanceVariable;
pub const getClass = runtime.getClass;
pub const getMetaClass = runtime.getMetaClass;
pub const lookUpClass = runtime.lookUpClass;
pub const class_getClassVariable = runtime.class_getClassVariable;
pub const class_getInstanceMethod = runtime.class_getInstanceMethod;
pub const class_getClassMethod = runtime.class_getClassMethod;
pub const class_respondsToSelector = runtime.class_respondsToSelector;
pub const class_conformsToProtocol = runtime.class_conformsToProtocol;
pub const allocateClassPair = runtime.allocateClassPair;
pub const registerClassPair = runtime.registerClassPair;
pub const disposeClassPair = runtime.disposeClassPair;
pub const class_addMethod = runtime.class_addMethod;
pub const class_replaceMethod = runtime.class_replaceMethod;
pub const class_addIvar = runtime.class_addIvar;
pub const method_setImplementation = runtime.method_setImplementation;
pub const getProtocol = runtime.getProtocol;

const message = @import("message.zig");
pub const msgSend = message.msgSend;

const type_encoding = @import("type-encoding.zig");
const writeEncodingForType = type_encoding.writeEncodingForType;

pub const Error = error{
    ClassDoesNotRespondToSelector,
    InstanceDoesNotRespondToSelector,
    FailedToAddIvarToClass,
    FailedToAddMethodToClass,
};

/// Checks whether the target implements the method described by selector and then sends a message
/// Returns the return value of the called method or an error if the target does not implement the corresponding method
pub fn msgSendChecked(comptime ReturnType: type, target: anytype, selector: SEL, args: anytype) !ReturnType {
    switch (@TypeOf(target)) {
        Class => {
            if (class_getClassMethod(target, selector) == null) return Error.ClassDoesNotRespondToSelector;
        },
        id => {
            const class = try object_getClass(target);
            if (class_getInstanceMethod(class, selector) == null) return Error.InstanceDoesNotRespondToSelector;
        },
        else => @compileError("Invalid msgSend target type. Must be a Class or id"),
    }
    return msgSend(ReturnType, target, selector, args);
}

/// The same as calling msgSendChecked except takes a selector name instead of a selector
pub fn msgSendByName(comptime ReturnType: type, target: anytype, sel_name: [:0]const u8, args: anytype) !ReturnType {
    const selector = try sel_getUid(sel_name);
    return msgSendChecked(ReturnType, target, selector, args);
}

/// The same as calling msgSend except takes a selector name instead of a selector
pub fn msgSendByNameUnchecked(comptime ReturnType: type, target: anytype, sel_name: [:0]const u8, args: anytype) !ReturnType {
    const selector = try sel_getUid(sel_name);
    return msgSend(ReturnType, target, selector, args);
}

/// Convenience fn for sending an new message to a Class object
/// Which is equivilent to sending an alloc message to a Class object followed by an init message to the returned Class instance
pub fn new(class: Class) !id {
    const new_sel = try sel_getUid("new");
    return msgSend(id, class, new_sel, .{});
}

/// Convenience fn for sending a dealloc message to object
pub fn dealloc(instance: id) !void {
    const dealloc_sel = try sel_getUid("dealloc");
    msgSend(void, instance, dealloc_sel, .{});
}

/// Convenience fn for defining and registering a new Class
/// dispose of the resultng class using `disposeClassPair`
pub fn defineAndRegisterClass(name: [:0]const u8, superclass: Class, ivars: anytype, methods: anytype) !Class {
    const class = try allocateClassPair(superclass, name, 0);
    errdefer disposeClassPair(class);

    // reuseable buffer for type encoding strings
    var type_encoding_buf = [_]u8{0} ** 256;

    // add ivars to class
    inline for (ivars) |ivar| {
        const ivar_name = ivar.@"0";
        const ivar_type = ivar.@"1";
        const type_enc_str = encode: {
            var fbs = std.io.fixedBufferStream(&type_encoding_buf);
            try writeEncodingForType(ivar_type, fbs.writer());
            const len = fbs.getWritten().len + 1;
            break :encode type_encoding_buf[0..len :0];
        };
        var ivar_name_terminated = [_]u8{0} ** (ivar_name.len + 1);
        std.mem.copy(u8, &ivar_name_terminated, ivar_name);
        if (class_addIvar(class, ivar_name_terminated[0..ivar_name.len :0], @sizeOf(ivar_type), @alignOf(ivar_type), type_enc_str) == false) {
            return Error.FailedToAddIvarToClass;
        }
        std.mem.set(u8, &type_encoding_buf, 0);
    }

    // add methods to class
    inline for (methods) |m| {
        const fn_name = m.@"0";
        const func = m.@"1";
        const FnType = @TypeOf(func);
        const type_enc_str = encode: {
            var fbs = std.io.fixedBufferStream(&type_encoding_buf);
            try writeEncodingForType(FnType, fbs.writer());
            const len = fbs.getWritten().len + 1;
            break :encode type_encoding_buf[0..len :0];
        };
        const selector = try sel_registerName(fn_name);
        const result = class_addMethod(
            class,
            selector,
            func,
            type_enc_str,
        );
        if (result == false) {
            return Error.FailedToAddMethodToClass;
        }
        std.mem.set(u8, &type_encoding_buf, 0);
    }

    registerClassPair(class);

    return class;
}

test {
    testing.refAllDecls(@This());
}

test "new/dealloc NSObject" {
    const NSObject = try getClass("NSObject");
    const new_obj = try new(NSObject);
    try dealloc(new_obj);
}

test "register/call/deregister Objective-C Class" {
    try struct {
        pub fn runTest() !void {
            const NSObject = try getClass("NSObject");

            const TestClass = try defineAndRegisterClass(
                "TestClass",
                NSObject,
                .{
                    .{ "foo", c_int },
                },
                .{
                    .{ "add", add },
                },
            );

            const instance = try new(TestClass);

            try testing.expectEqual(
                @as(c_int, 3),
                try msgSendByName(c_int, instance, "add", .{ @as(c_int, 1), @as(c_int, 2) }),
            );

            try dealloc(instance);
        }

        pub fn add(_: id, _: SEL, a: c_int, b: c_int) callconv(.C) c_int {
            return a + b;
        }
    }.runTest();
}
