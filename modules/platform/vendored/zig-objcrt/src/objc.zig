//! This module provides type-safe bindings to the API defined in objc/obj.h
// TODO(hazeycode): add missing definitions

pub const Error = error{
    FailedToRegisterMethodName,
};

const c = @import("c.zig");

/// An opaque type that represents an Objective-C class.
pub const Class = *c.objc_class;

/// Represents an instance of a class.
pub const object = c.objc_object;

/// A pointer to an instance of a class.
pub const id = *object;

/// An opaque type that represents a method selector.
pub const SEL = *c.objc_selector;

/// A pointer to the function of a method implementation.
pub const IMP = *const anyopaque;

/// Registers a method with the Objective-C runtime system, maps the method
/// name to a selector, and returns the selector value.
///
/// @param str The name of the method you wish to register.
///
/// Returns A pointer of type SEL specifying the selector for the named method.
///
/// NOTE: You must register a method name with the Objective-C runtime system to obtain the
/// method’s selector before you can add the method to a class definition. If the method name
/// has already been registered, this function simply returns the selector.
pub fn sel_registerName(str: [:0]const u8) Error!SEL {
    return c.sel_registerName(str) orelse Error.FailedToRegisterMethodName;
}

/// Registers a method name with the Objective-C runtime system.
/// The implementation of this method is identical to the implementation of sel_registerName.
///
/// @param str The name of the method you wish to register.
///
/// Returns A pointer of type SEL specifying the selector for the named method.
///
/// NOTE: Prior to OS X version 10.0, this method tried to find the selector mapped to the given name
///  and returned NULL if the selector was not found. This was changed for safety, because it was
///  observed that many of the callers of this function did not check the return value for NULL.
pub fn sel_getUid(str: [:0]const u8) Error!SEL {
    return c.sel_getUid(str) orelse Error.FailedToRegisterMethodName;
}
