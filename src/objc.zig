pub usingnamespace @cImport({
    @cInclude("objc/message.h");
});

pub fn class(s: [*c]const u8) id {
    return @ptrCast(id, objc_lookUpClass(s));
}

pub fn call(obj: id, sel_name: [*c]const u8, args: anytype) id {
    const type_info = @typeInfo(@TypeOf(args));
    const fields = type_info.Struct.fields;
    var func = @ptrCast(
        switch (fields.len) {
            0 => fn (id, SEL) callconv(.C) id,
            1 => fn (id, SEL, fields[0].field_type) callconv(.C) id,
            2 => fn (id, SEL, fields[0].field_type, fields[1].field_type) callconv(.C) id,
            3 => fn (id, SEL, fields[0].field_type, fields[1].field_type, fields[2].field_type) callconv(.C) id,
            4 => fn (id, SEL, fields[0].field_type, fields[1].field_type, fields[2].field_type, fields[3].field_type) callconv(.C) id,
            else => @compileError("Unsupported number of args"),
        },
        objc_msgSend,
    );
    return switch (fields.len) {
        0 => func(obj, sel_getUid(sel_name)),
        1 => func(obj, sel_getUid(sel_name), @field(args, fields[0].name)),
        2 => func(obj, sel_getUid(sel_name), @field(args, fields[0].name), @field(args, fields[1].name)),
        3 => func(obj, sel_getUid(sel_name), @field(args, fields[0].name), @field(args, fields[1].name), @field(args, fields[2].name)),
        4 => func(obj, sel_getUid(sel_name), @field(args, fields[0].name), @field(args, fields[1].name), @field(args, fields[2].name), @field(args, fields[3].name)),
        else => @compileError("Unsupported number of args"),
    };
}
