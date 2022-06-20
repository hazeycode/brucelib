//! builtin immediate mode gui for quick and dirty debugging. TODO(hazeycode): this code is messy and bad, give it some love 

const std = @import("std");

const common = @import("common.zig");
const orthographic = common.orthographic;
const translation = common.translation;
const scaling = common.scaling;
const mul = common.mul;
const Vertex = common.Vertex;
const TexturedVertex = common.TexturedVertex;
const Rect = common.Rect;
const Colour = common.Colour;

pub const Config = struct {
    Backend: type,
    Profiler: type = @import("NullProfiler.zig"),
    profile_marker_colour: u32 = 0x00_00_AA_AA,
};

pub fn using(comptime config: Config) type {
    const Backend = config.Backend;
    const Profiler = config.Profiler;

    const textures = @import("textures.zig").using_backend(Backend);
    const Texture2d = textures.Texture2d;

    const RenderList = @import("render_list.zig").using(.{
        .Backend = Backend,
        .Profiler = Profiler,
        .profile_marker_colour = config.profile_marker_colour,
    });

    const renderers = @import("renderers.zig").using(.{
        .Backend = Backend,
        .Profiler = Profiler,
        .profile_marker_colour = config.profile_marker_colour,
    });
    const UniformColourVertsRenderer = renderers.UniformColourVertsRenderer;
    const TexturedVertsRenderer = renderers.TexturedVertsRenderer;

    return struct {
        allocator: std.mem.Allocator,
        text_verts: std.ArrayList(TexturedVertex),
        uniform_colour_verts: std.ArrayList(Vertex),
        colour_verts_renderer: UniformColourVertsRenderer,
        textured_verts_renderer: TexturedVertsRenderer,
        font_texture: Texture2d,
        render_list: *RenderList = undefined,
        canvas_width: f32 = undefined,
        canvas_height: f32 = undefined,
        cur_x: f32 = 0,
        cur_y: f32 = 0,
        prev_x_end: f32 = 0,
        same_line_set: bool = false,
        prev_cur_x: f32 = 0,
        state: *State = undefined,

        // values for builtin debugfont
        const glyph_width = 7;
        const glyph_height = 12;

        const margin = glyph_width / 2;
        const line_height = glyph_height + glyph_height / 5;
        const text_y_inset = glyph_height / 10;

        pub const ElemId = u32;

        pub const State = struct {
            input: Input = .{},
            hover_id: ElemId = 0,
            active_id: ElemId = 0,
            keyboard_focus: ElemId = 0,
            text_cur_x: f32 = 0,
            text_cur_y: f32 = 0,
        };

        pub const Input = struct {
            mouse_btn_down: bool = false,
            mouse_btn_was_pressed: bool = false,
            mouse_btn_was_released: bool = false,
            mouse_x: f32 = undefined,
            mouse_y: f32 = undefined,

            // TODO(hazeycode): pass mapping function and provide default
            /// Optional helper fn for mapping brucelib.platform.FrameInput to graphics.DebugGUI.Input
            /// `user_input` can be any weakly conforming type
            pub fn map_platform_input(self: *Input, user_input: anytype) void {
                self.mouse_x = @intToFloat(f32, user_input.mouse_position.x);
                self.mouse_y = @intToFloat(f32, user_input.mouse_position.y);

                self.mouse_btn_was_pressed = false;
                self.mouse_btn_was_released = false;

                for (user_input.mouse_button_events) |mouse_ev| {
                    if (mouse_ev.button != .left) continue;

                    switch (mouse_ev.action) {
                        .press => {
                            self.mouse_btn_was_pressed = true;
                            self.mouse_btn_down = true;
                        },
                        .release => {
                            self.mouse_btn_was_released = true;
                            self.mouse_btn_down = false;
                        },
                    }
                }
            }
        };

        pub fn init(allocator: std.mem.Allocator) !@This() {
            const debugfont_texture = try Texture2d.fromPBM(
                allocator,
                @embedFile("../data/debugfont.pbm"),
            );
            return @This(){
                .allocator = allocator,
                .text_verts = std.ArrayList(TexturedVertex).init(allocator),
                .uniform_colour_verts = std.ArrayList(Vertex).init(allocator),
                .colour_verts_renderer = try UniformColourVertsRenderer.init(1e3),
                .textured_verts_renderer = try TexturedVertsRenderer.init(1e3),
                .font_texture = debugfont_texture,
            };
        }
        
        pub fn deinit(self: *@This()) void {
            self.text_verts.deinit();
            self.uniform_colour_verts.deinit();
        }

        pub fn begin(
            self: *@This(),
            render_list: *RenderList,
            canvas_width: f32,
            canvas_height: f32,
            state: *State,
        ) !void {
            const projection = orthographic(canvas_width, canvas_height, 0, 1);
            try render_list.set_projection_transform(projection);

            const view = mul(
                translation(-canvas_width / 2, -canvas_height / 2, 0),
                scaling(1, -1, 1),
            );
            try render_list.set_view_transform(view);

            self.render_list = render_list;
            self.canvas_width = canvas_width;
            self.canvas_height = canvas_height;
            self.cur_x = @intToFloat(f32, margin);
            self.cur_y = @intToFloat(f32, margin);
            self.state = state;

            self.text_verts.shrinkRetainingCapacity(0);
            self.uniform_colour_verts.shrinkRetainingCapacity(0);
        }

        pub fn end(self: *@This()) !void {
            // calculate bounding rect
            var rect = Rect{ .min_x = 0, .min_y = 0, .max_x = 0, .max_y = 0 };
            for (self.text_verts.items) |v| {
                if (v.pos[0] > rect.max_x) rect.max_x = v.pos[0];
                if (v.pos[1] > rect.max_y) rect.max_y = v.pos[1];
            }
            for (self.uniform_colour_verts.items) |v| {
                if (v.pos[0] > rect.max_x) rect.max_x = v.pos[0];
                if (v.pos[1] > rect.max_y) rect.max_y = v.pos[0];
            }
            rect.max_x += @intToFloat(f32, margin);
            rect.max_y += @intToFloat(f32, margin);

            // draw background
            try self.draw_colour_rect(Colour.from_rgba(0.13, 0.13, 0.13, 0.13), rect);

            // draw all text
            try self.textured_verts_renderer.render(
                self.render_list,
                self.font_texture,
                self.text_verts.items,
            );

            // draw text cursor if there is an element with keyboard focus
            if (self.state.keyboard_focus > 0) {
                try self.draw_colour_rect(
                    Colour.white,
                    .{
                        .min_x = self.state.text_cur_x - 1,
                        .min_y = self.state.text_cur_y,
                        .max_x = self.state.text_cur_x + 1,
                        .max_y = self.state.text_cur_y + line_height,
                    },
                );
            }
        }
        
        pub fn same_line(self: *@This()) void {
            self.cur_y -= line_height;
            self.prev_cur_x = self.cur_x;
            self.cur_x = self.prev_x_end + glyph_width;
            self.same_line_set = true;
        }
        
        pub fn separator(self: *@This()) void {
            self.cur_y += line_height / 2;
        }

        pub fn label(
            self: *@This(),
            comptime fmt: []const u8,
            args: anytype,
        ) !void {
            var temp_arena = std.heap.ArenaAllocator.init(self.allocator);
            defer temp_arena.deinit();
            const temp_allocator = temp_arena.allocator();

            const string = try std.fmt.allocPrint(temp_allocator, fmt, args);

            const text_rect = try self.draw_text(string, &self.text_verts);

            self.cur_y += (text_rect.max_y - text_rect.min_y) + text_y_inset;
            self.prev_x_end = text_rect.max_x;
            
            if (self.same_line_set) {
                self.cur_x = self.prev_cur_x;
                self.same_line_set = false;
            }
        }
        
        pub fn toggle_button(self: *@This(), comptime fmt: []const u8, args: anytype, value_ptr: *bool) !void {
            const id = 1; // TODO(hazeycode): obtain some sort of unique identifier

            var temp_arena = std.heap.ArenaAllocator.init(self.allocator);
            defer temp_arena.deinit();
            const temp_allocator = temp_arena.allocator();

            const string = try std.fmt.allocPrint(temp_allocator, fmt, args);
            
            const text_rect = try self.draw_text(string, &self.text_verts);
            
            const bounding_rect = text_rect.inset(
                -@divFloor(glyph_width, 2),
                -@divFloor(glyph_width, 2),
                -text_y_inset,
                -text_y_inset,
            );
            
            const input = self.state.input;
            const mouse_over = text_rect.contains_point(input.mouse_x, input.mouse_y);

            if (id == self.state.active_id) {
                if (input.mouse_btn_was_released) {
                    self.state.active_id = 0;
                    value_ptr.* = !value_ptr.*;
                }
            } else if (id == self.state.hover_id) {
                if (input.mouse_btn_was_pressed) {
                    if (mouse_over) {
                        self.state.active_id = id;
                        self.state.keyboard_focus = id;
                    } else {
                        self.state.keyboard_focus = 0;
                    }
                }
            } else {
                if (mouse_over) {
                    self.state.hover_id = id;
                }
            }
            
            try self.draw_colour_rect(
                colour: {
                    if (id == self.state.active_id) {
                        if (self.state.input.mouse_btn_down) break :colour Colour.white;
                    }
                    break :colour if (value_ptr.*) Colour.orange else Colour.black;
                },
                bounding_rect,
            );
            try self.draw_colour_rect_outline(Colour.white, bounding_rect, 1);

            self.cur_y += (text_rect.max_y - text_rect.min_y) + text_y_inset;
            self.prev_x_end = text_rect.max_x;
            
            if (self.same_line_set) {
                self.cur_x = self.prev_cur_x;
                self.same_line_set = false;
            }
        }

        pub fn text_field(
            self: *@This(),
            comptime T: type,
            comptime fmt: []const u8,
            value_ptr: *T,
        ) !void {
            const id = 2; // TODO(hazeycode): obtain some sort of unique identifier

            var temp_arena = std.heap.ArenaAllocator.init(self.allocator);
            defer temp_arena.deinit();
            const temp_allocator = temp_arena.allocator();

            const string = try std.fmt.allocPrint(temp_allocator, fmt, .{value_ptr.*});

            const text_rect = try self.draw_text(string, &self.text_verts);

            const bounding_rect = text_rect.inset(
                -@divFloor(glyph_width, 2),
                -@divFloor(glyph_width, 2),
                -text_y_inset,
                -text_y_inset,
            );
            try self.draw_colour_rect_outline(Colour.white, bounding_rect, 1);

            const input = self.state.input;
            const mouse_over = text_rect.contains_point(input.mouse_x, input.mouse_y);

            if (id == self.state.active_id) {
                if (input.mouse_btn_down and id == self.state.keyboard_focus) {
                    const column = @divFloor(
                        @floatToInt(
                            i32,
                            input.mouse_x - text_rect.min_x + @as(f32, glyph_width) / 2,
                        ),
                        glyph_width,
                    );
                    const capped_column = @intCast(
                        u32,
                        std.math.max(
                            0,
                            std.math.min(@intCast(i32, string.len), column),
                        ),
                    );

                    const line = 0;

                    const x_offset = capped_column * glyph_width;
                    const y_offset = line * line_height;

                    self.state.text_cur_x = text_rect.min_x + @intToFloat(f32, x_offset);
                    self.state.text_cur_y = text_rect.min_y + @intToFloat(f32, y_offset);
                }

                if (input.mouse_btn_was_released) {
                    self.state.active_id = 0;
                }
            } else if (id == self.state.hover_id) {
                if (input.mouse_btn_was_pressed) {
                    if (mouse_over) {
                        self.state.active_id = id;
                        self.state.keyboard_focus = id;
                    } else {
                        self.state.keyboard_focus = 0;
                    }
                }
            } else {
                if (mouse_over) {
                    self.state.hover_id = id;
                }
            }

            self.cur_y += (text_rect.max_y - text_rect.min_y) + text_y_inset;
            self.prev_x_end = text_rect.max_x;
            
            if (self.same_line_set) {
                self.cur_x = self.prev_cur_x;
                self.same_line_set = false;
            }
        }

        fn draw_colour_rect(self: *@This(), colour: Colour, rect: Rect) !void {
            var verts = try self.allocator.alloc(Vertex, 6);
            errdefer self.allocator.free(verts);

            std.mem.copy(Vertex, verts, &rect.vertices());

            try self.colour_verts_renderer.render(
                self.render_list,
                colour,
                verts,
            );
        }

        fn draw_colour_rect_outline(self: *@This(), colour: Colour, rect: Rect, weight: f32) !void {
            const num_verts = 6;
            const num_sides = 4;

            var verts = try self.allocator.alloc(Vertex, num_verts * num_sides);
            errdefer self.allocator.free(verts);

            { // left side
                const side_rect = Rect{
                    .min_x = rect.min_x,
                    .max_x = rect.min_x + weight,
                    .min_y = rect.min_y,
                    .max_y = rect.max_y,
                };
                const offset = 0 * num_verts;
                std.mem.copy(
                    Vertex,
                    verts[offset..(offset + num_verts)],
                    &side_rect.vertices(),
                );
            }

            { // right side
                const side_rect = Rect{
                    .min_x = rect.max_x - weight,
                    .max_x = rect.max_x,
                    .min_y = rect.min_y,
                    .max_y = rect.max_y,
                };
                const offset = 1 * num_verts;
                std.mem.copy(
                    Vertex,
                    verts[offset..(offset + num_verts)],
                    &side_rect.vertices(),
                );
            }

            { // top side
                const side_rect = Rect{
                    .min_x = rect.min_x,
                    .max_x = rect.max_x,
                    .min_y = rect.min_y,
                    .max_y = rect.min_y + weight,
                };
                const offset = 2 * num_verts;
                std.mem.copy(
                    Vertex,
                    verts[offset..(offset + num_verts)],
                    &side_rect.vertices(),
                );
            }

            { // bottom side
                const side_rect = Rect{
                    .min_x = rect.min_x,
                    .max_x = rect.max_x,
                    .min_y = rect.max_y - weight,
                    .max_y = rect.max_y,
                };
                const offset = 3 * num_verts;
                std.mem.copy(
                    Vertex,
                    verts[offset..(offset + num_verts)],
                    &side_rect.vertices(),
                );
            }

            try self.colour_verts_renderer.render(
                self.render_list,
                colour,
                verts,
            );
        }

        fn draw_text(
            self: *@This(),
            string: []const u8,
            verts: *std.ArrayList(TexturedVertex),
        ) !Rect {
            var cur_line: u32 = 0;
            var column: u32 = 0;
            var max_column: u32 = 0;

            for (string) |c| {
                // TODO(hazeycode): yank the mapping out of here
                const maybe_glyph_idx: ?u32 = switch (c) {
                    '0'...'9' => 0 + c - 48,
                    'a'...'z' => 10 + c - 97,
                    'A'...'Z' => 36 + c - 65,
                    ':' => 62,
                    ';' => 63,
                    '\'' => 64,
                    '"' => 65,
                    '\\' => 66,
                    ',' => 67,
                    '.' => 68,
                    '?' => 69,
                    '/' => 70,
                    '>' => 71,
                    '<' => 72,
                    '-' => 73,
                    '+' => 74,
                    '%' => 75,
                    '&' => 76,
                    '*' => 77,
                    '(' => 78,
                    ')' => 79,
                    '_' => 80,
                    '=' => 81,
                    else => null,
                };
                if (maybe_glyph_idx) |glyph_idx| {
                    const x = self.cur_x + @intToFloat(f32, column * glyph_width);
                    const y = self.cur_y + @intToFloat(f32, cur_line * line_height);
                    const rect = Rect{
                        .min_x = x,
                        .min_y = y + text_y_inset,
                        .max_x = x + glyph_width,
                        .max_y = y + text_y_inset + glyph_height + text_y_inset,
                    };

                    // TODO(hazeycode): yank uv mapping out of here
                    // debugfont only has a single row and is tightly packed
                    const u = @intToFloat(f32, glyph_width * glyph_idx);
                    const v = @intToFloat(f32, 0);
                    const uv_rect = Rect{
                        .min_x = u / @intToFloat(f32, self.font_texture.width),
                        .min_y = v / @intToFloat(f32, self.font_texture.height),
                        .max_x = (u + glyph_width) / @intToFloat(f32, self.font_texture.width),
                        .max_y = (v + glyph_height) / @intToFloat(f32, self.font_texture.height),
                    };

                    try verts.appendSlice(&rect.textured_vertices(uv_rect));

                    column += 1;
                    if (column > max_column) max_column = column;
                } else switch (c) {
                    '\n', '\r' => {
                        cur_line += 1;
                        if (column > max_column) max_column = column;
                        column = 0;
                    },
                    ' ' => {
                        column += 1;
                        if (column > max_column) max_column = column;
                    },
                    else => {
                        std.debug.panic("graphics.@This() unmapped character {}", .{c});
                    },
                }
            }

            cur_line += 1;

            return Rect{
                .min_x = self.cur_x,
                .min_y = self.cur_y,
                .max_x = self.cur_x + @intToFloat(f32, max_column * glyph_width),
                .max_y = self.cur_y + @intToFloat(f32, cur_line * line_height),
            };
        }
    };
}
