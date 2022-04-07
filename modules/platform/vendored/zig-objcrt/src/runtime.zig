//! This module provides type-safe bindings to the API defined in objc/runtime.h
// TODO(hazeycode): add missing definitions

const std = @import("std");

const objc = @import("objc.zig");
const Class = objc.Class;
const object = objc.object;
const id = objc.id;
const SEL = objc.SEL;
const IMP = objc.IMP;

const c = @import("c.zig");

pub const Error = error{
    FailedToGetClassForObject,
    FailedToGetInstanceVariable,
    ClassNotRegisteredWithRuntime,
    FailedToGetClassVariable,
    FailedToAllocateClassPair,
    NoSuchProtocol,
};

// ----- Types -----

/// An opaque type that represents a method in a class definition.
pub const Method = *c.objc_method;

/// An opaque type that represents an instance variable.
pub const Ivar = *c.objc_ivar;

/// An opaque type that represents a category.
pub const Category = *c.objc_category;

/// An opaque type that represents an Objective-C declared property.
pub const Property = *c.objc_property;

pub const Protocol = c.objc_object;

// ----- Working with Instances -----

/// Returns the class of an object.
/// 
/// @param obj An id of the object you want to inspect.
/// 
/// @return The class object of which object is an instance
pub fn object_getClass(obj: id) Error!Class {
    return c.object_getClass(obj) orelse Error.FailedToGetClassForObject;
}

/// Obtains the value of an instance variable and the assosciated `Ivar` of a class instance.
/// 
/// @param obj An instance of the class containing the instance variable whose value you wish to obtain.
/// @param name The name of the instance variable whose value you wish to obtain.
/// @param outValue On return, contains a pointer to the value of the instance variable.
/// 
/// Returns a struct containing an `Ivar` that defines the type and name of the instance
/// variable specified by `name` and the 
pub fn object_getInstanceVariable(comptime ValueType: type, obj: id, name: [:0]const u8) Error!struct { ivar: Ivar, value: ValueType } {
    var value_ptr: *ValueType = undefined;
    const maybe_ivar = c.object_getInstanceVariable(obj, name, @ptrCast([*c]?*anyopaque, &value_ptr));
    return if (maybe_ivar) |ivar| .{ .ivar = ivar, .value = value_ptr.* } else Error.FailedToGetInstanceVariable;
}

// ----- Obtaining Class Definitions ----

/// Returns the class definition of a specified class, or an error if the class is not registered
/// with the Objective-C runtime.
/// 
/// @param name The name of the class to look up.
/// 
/// @note getClass is different from lookUpClass in that if the class
///  is not registered, getClass calls the class handler callback and then checks
///  a second time to see whether the class is registered. lookUpClass does 
///  not call the class handler callback.
/// 
/// @warning Earlier implementations of this function (prior to OS X v10.0)
///  terminate the program if the class does not exist.
pub fn getClass(class_name: [:0]const u8) Error!Class {
    return c.objc_getClass(class_name) orelse Error.ClassNotRegisteredWithRuntime;
}

/// Returns the metaclass definition of a specified class, or an error if the class is not registered
/// with the Objective-C runtime.
/// 
/// @param name The name of the class to look up.
/// 
/// @note If the definition for the named class is not registered, this function calls the class handler
///  callback and then checks a second time to see if the class is registered. However, every class
///  definition must have a valid metaclass definition, and so the metaclass definition is always returned,
///  whether it’s valid or not.
pub fn getMetaClass(class_name: [:0]const u8) Error!Class {
    return c.objc_getMetaClass(class_name) orelse Error.ClassNotRegisteredWithRuntime;
}

/// Returns the class definition of a specified class, or null if the class is not registered
/// with the Objective-C runtime
/// 
/// @param name The name of the class to look up.
/// 
/// @note getClass is different from this function in that if the class is not
///  registered, getClass calls the class handler callback and then checks a second
///  time to see whether the class is registered. This function does not call the class handler callback.
pub fn lookUpClass(class_name: [:0]const u8) ?Class {
    return c.objc_lookUpClass(class_name);
}

/// Returns the Ivar for a specified class variable of a given class.
/// 
/// @param cls The class definition whose class variable you wish to obtain.
/// @param name The name of the class variable definition to obtain.
pub fn class_getClassVariable(class: Class, name: [:0]const u8) Error!Ivar {
    return c.class_getClassVariable(class, name) orelse Error.FailedToGetClassVariable;
}

/// Returns an instance method corresponding to the implementation of a given selector for  given class
/// null if the specified class or its superclasses do not contain an instance method with the specified selector.
/// NOTE: This function searches superclasses for implementations, whereas `class_copyMethodList` does not.
pub fn class_getInstanceMethod(class: Class, selector: SEL) ?Method {
    return c.class_getInstanceMethod(class, selector);
}

/// Returns an class method corresponding to the implementation of a given selector for  given class
/// null if the specified class or its superclasses do not contain an class method with the specified selector.
/// NOTE: This function searches superclasses for implementations, whereas `class_copyMethodList` does not.
pub fn class_getClassMethod(class: Class, selector: SEL) ?Method {
    return c.class_getClassMethod(class, selector);
}

/// Returns a Boolean value that indicates whether instances of a class respond to a particular selector.
pub fn class_respondsToSelector(class: Class, selector: SEL) bool {
    return (c.class_respondsToSelector(class, selector) != 0);
}

/// Returns a bool that indicates whether a class conforms to a given protocol.
pub fn class_conformsToProtocol(class: Class, protocol: *Protocol) bool {
    return (c.class_conformsToProtocol(class, protocol) != 0);
}

// ----- Working with Classes -----

/// Adds a new method to a class with a given name and implementation.
/// 
/// @param class The class to which to add a method.
/// @param selector A selector that specifies the name of the method being added.
/// @param imp A function which is the implementation of the new method. The function must take at least two arguments—self and _cmd.
/// @param types An array of characters that describe the types of the arguments to the method. 
/// 
/// @return `true` if the method was added successfully, otherwise `false` 
///  (for example, the class already contains a method implementation with that name).
/// @note `class_addMethod` will add an override of a superclass's implementation, 
///  but will not replace an existing implementation in this class. 
///  To change an existing implementation, use `method_setImplementation`.
pub fn class_addMethod(class: Class, selector: SEL, imp: IMP, types: [:0]const u8) bool {
    return (c.class_addMethod(class, selector, @ptrCast(fn () callconv(.C) void, imp), types) != 0);
}

/// Replaces the implementation of a method for a given class.
/// 
/// @param class The class you want to modify.
/// @param selector A selector that identifies the method whose implementation you want to replace.
/// @param imp The new implementation for the method identified by name for the class identified by cls.
/// @param types An array of characters that describe the types of the arguments to the method. 
///  Since the function must take at least two arguments—self and _cmd, the second and third characters
///  must be “@:” (the first character is the return type).
/// 
/// @return The previous implementation of the method identified by `name` for the class identified by `class`.
/// 
/// @note This function behaves in two different ways:
///  - If the method identified by `name` does not yet exist, it is added as if `class_addMethod` were called. 
///    The type encoding specified by `types` is used as given.
///  - If the method identified by `name` does exist, its `IMP` is replaced as if `method_setImplementation` were called.
///    The type encoding specified by `types` is ignored.
pub fn class_replaceMethod(class: Class, selector: SEL, imp: IMP, types: [:0]const u8) ?IMP {
    return c.class_replaceMethod(class, selector, @ptrCast(fn () callconv(.C) void, imp), types);
}

/// Adds a new instance variable to a class.
/// 
/// @return `true` if the instance variable was added successfully, otherwise `false`
///         (for example, the class already contains an instance variable with that name).
/// 
/// @note This function may only be called after `objc_allocateClassPair` and before `objc_registerClassPair`. 
///       Adding an instance variable to an existing class is not supported.
/// @note The class must not be a metaclass. Adding an instance variable to a metaclass is not supported.
/// @note The instance variable's minimum alignment in bytes is 1<<align. The minimum alignment of an instance 
///       variable depends on the ivar's type and the machine architecture. 
///       For variables of any pointer type, pass log2(sizeof(pointer_type)).
pub fn class_addIvar(class: Class, name: [:0]const u8, size: usize, alignment: u8, types: [:0]const u8) bool {
    return (c.class_addIvar(class, name, size, alignment, types) != 0);
}

// ----- Adding Classes -----

/// Creates a new class and metaclass.
/// 
/// @param superclass The class to use as the new class's superclass, or nulll to create a new root class.
/// @param name The string to use as the new class's name. The string will be copied.
/// @param extraBytes The number of bytes to allocate for indexed ivars at the end of 
///  the class and metaclass objects. This should usually be 0.
/// 
/// @return The new class, or an error if the class could not be created (for example, the desired name is already in use).
/// 
/// @note You can get a pointer to the new metaclass by calling object_getClass(newClass).
/// @note To create a new class, start by calling allocateClassPair. 
///  Then set the class's attributes with functions like class_addMethod and class_addIvar.
///  When you are done building the class, call registerClassPair. The new class is now ready for use.
/// @note Instance methods and instance variables should be added to the class itself. 
///  Class methods should be added to the metaclass.
pub fn allocateClassPair(superclass: ?Class, class_name: [:0]const u8, extra_bytes: usize) Error!Class {
    return c.objc_allocateClassPair(superclass, class_name, extra_bytes) orelse Error.FailedToAllocateClassPair;
}

/// Registers a class that was allocated using allocateClassPair.
/// 
/// @param cls The class you want to register.
pub fn registerClassPair(class: Class) void {
    c.objc_registerClassPair(class);
}

/// Destroy a class and its associated metaclass. 
/// 
/// @param cls The class to be destroyed. It must have been allocated with objc_allocateClassPair
/// 
/// @warning Do not call if instances of this class or a subclass exist.
pub fn disposeClassPair(class: Class) void {
    c.objc_disposeClassPair(class);
}

// ----- Working with Methods -----

/// Sets the implementation of a method.
/// 
/// @param m The method for which to set an implementation.
/// @param imp The implemention to set to this method.
/// 
/// @return The previous implementation of the method.
pub fn method_setImplementation(m: Method, imp: IMP) ?IMP {
    return c.method_setImplementation(m, @ptrCast(fn () callconv(.C) void, imp));
}

// ----- Working with Protocols -----

/// Returns a protocol specified by name
pub fn getProtocol(name: [:0]const u8) Error!*Protocol {
    return c.objc_getProtocol(name) orelse Error.NoSuchProtocol;
}
