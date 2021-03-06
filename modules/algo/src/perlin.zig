//! Zig implementation of Ken Perlin's Improved Noise (2002). Reference: https://rosettacode.org/wiki/Perlin_noise#Java

pub fn noise(x: f64, y: f64, z: f64) f64 {
    const cube_x = @floatToInt(u32, x) & 255;
    const cube_y = @floatToInt(u32, y) & 255;
    const cube_z = @floatToInt(u32, z) & 255;

    const local_x = x - @intToFloat(f64, cube_x);
    const local_y = y - @intToFloat(f64, cube_y);
    const local_z = z - @intToFloat(f64, cube_z);

    const u = fade(local_x);
    const v = fade(local_y);
    const w = fade(local_z);

    const a = p[cube_x] + cube_y;
    const aa = p[a] + cube_z;
    const ab = p[a + 1] + cube_z;
    const b = p[cube_x + 1] + cube_y;
    const ba = p[b] + cube_z;
    const bb = p[b + 1] + cube_z;

    return lerp(
        w,
        lerp(
            v,
            lerp(
                u,
                grad(p[aa], local_x, local_y, local_z),
                grad(p[ba], local_x - 1, local_y, local_z),
            ),
            lerp(
                u,
                grad(p[ab], local_x, local_y - 1, local_z),
                grad(p[bb], local_x - 1, local_y - 1, local_z),
            ),
        ),
        lerp(
            v,
            lerp(
                u,
                grad(p[aa + 1], local_x, local_y, local_z - 1),
                grad(p[ba + 1], local_x - 1, local_y, local_z - 1),
            ),
            lerp(
                u,
                grad(p[ab + 1], local_x, local_y - 1, local_z - 1),
                grad(p[bb + 1], local_x - 1, local_y - 1, local_z - 1),
            ),
        ),
    );
}

fn fade(t: f64) f64 {
    return t * t * t * (t * (t * 6 - 15) + 10);
}

fn lerp(t: f64, a: f64, b: f64) f64 {
    return a + t * (b - a);
}

fn grad(hash: u32, x: f64, y: f64, z: f64) f64 {
    const h = hash & 15;
    const u = if (h < 8) x else y;
    const v = if (h < 4) y else if (h == 12 or h == 14) x else z;
    return (if ((h & 1) == 0) u else -u) + (if ((h & 2) == 0) v else -v);
}

pub const p: [512]u8 = .{
    151, 160, 137, 91,  90,  15,
    131, 13,  201, 95,  96,  53,
    194, 233, 7,   225, 140, 36,
    103, 30,  69,  142, 8,   99,
    37,  240, 21,  10,  23,  190,
    6,   148, 247, 120, 234, 75,
    0,   26,  197, 62,  94,  252,
    219, 203, 117, 35,  11,  32,
    57,  177, 33,  88,  237, 149,
    56,  87,  174, 20,  125, 136,
    171, 168, 68,  175, 74,  165,
    71,  134, 139, 48,  27,  166,
    77,  146, 158, 231, 83,  111,
    229, 122, 60,  211, 133, 230,
    220, 105, 92,  41,  55,  46,
    245, 40,  244, 102, 143, 54,
    65,  25,  63,  161, 1,   216,
    80,  73,  209, 76,  132, 187,
    208, 89,  18,  169, 200, 196,
    135, 130, 116, 188, 159, 86,
    164, 100, 109, 198, 173, 186,
    3,   64,  52,  217, 226, 250,
    124, 123, 5,   202, 38,  147,
    118, 126, 255, 82,  85,  212,
    207, 206, 59,  227, 47,  16,
    58,  17,  182, 189, 28,  42,
    223, 183, 170, 213, 119, 248,
    152, 2,   44,  154, 163, 70,
    221, 153, 101, 155, 167, 43,
    172, 9,   129, 22,  39,  253,
    19,  98,  108, 110, 79,  113,
    224, 232, 178, 185, 112, 104,
    218, 246, 97,  228, 251, 34,
    242, 193, 238, 210, 144, 12,
    191, 179, 162, 241, 81,  51,
    145, 235, 249, 14,  239, 107,
    49,  192, 214, 31,  181, 199,
    106, 157, 184, 84,  204, 176,
    115, 121, 50,  45,  127, 4,
    150, 254, 138, 236, 205, 93,
    222, 114, 67,  29,  24,  72,
    243, 141, 128, 195, 78,  66,
    215, 61,  156, 180,

    // repeated
    151, 160,
    137, 91,  90,  15,  131, 13,
    201, 95,  96,  53,  194, 233,
    7,   225, 140, 36,  103, 30,
    69,  142, 8,   99,  37,  240,
    21,  10,  23,  190, 6,   148,
    247, 120, 234, 75,  0,   26,
    197, 62,  94,  252, 219, 203,
    117, 35,  11,  32,  57,  177,
    33,  88,  237, 149, 56,  87,
    174, 20,  125, 136, 171, 168,
    68,  175, 74,  165, 71,  134,
    139, 48,  27,  166, 77,  146,
    158, 231, 83,  111, 229, 122,
    60,  211, 133, 230, 220, 105,
    92,  41,  55,  46,  245, 40,
    244, 102, 143, 54,  65,  25,
    63,  161, 1,   216, 80,  73,
    209, 76,  132, 187, 208, 89,
    18,  169, 200, 196, 135, 130,
    116, 188, 159, 86,  164, 100,
    109, 198, 173, 186, 3,   64,
    52,  217, 226, 250, 124, 123,
    5,   202, 38,  147, 118, 126,
    255, 82,  85,  212, 207, 206,
    59,  227, 47,  16,  58,  17,
    182, 189, 28,  42,  223, 183,
    170, 213, 119, 248, 152, 2,
    44,  154, 163, 70,  221, 153,
    101, 155, 167, 43,  172, 9,
    129, 22,  39,  253, 19,  98,
    108, 110, 79,  113, 224, 232,
    178, 185, 112, 104, 218, 246,
    97,  228, 251, 34,  242, 193,
    238, 210, 144, 12,  191, 179,
    162, 241, 81,  51,  145, 235,
    249, 14,  239, 107, 49,  192,
    214, 31,  181, 199, 106, 157,
    184, 84,  204, 176, 115, 121,
    50,  45,  127, 4,   150, 254,
    138, 236, 205, 93,  222, 114,
    67,  29,  24,  72,  243, 141,
    128, 195, 78,  66,  215, 61,
    156, 180,
};

const testing = @import("std").testing;

test {
    try testing.expectApproxEqAbs(
        @as(f64, 0.13691995878400012),
        noise(3.14, 42.0, 7.0),
        0.00000000000000001,
    );
}
