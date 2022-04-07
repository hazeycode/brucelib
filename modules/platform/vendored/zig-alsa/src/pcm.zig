const std = @import("std");
const off_t = std.c.off_t;
const size_t = std.c.size_t;

const list = @import("list.zig");
const shmarea = @import("shmarea.zig");
const local = @import("local.zig");

pub const snd_pcm_stream_t = enum(c_int) {
    PLAYBACK = 0,
    CAPTURE,
};

pub const snd_pcm_access_t = enum(c_int) {
    MMAP_INTERLEAVED = 0,
    MMAP_NONINTERLEAVED,
    MMAP_COMPLEX,
    RW_INTERLEAVED,
    RW_NONINTERLEAVED,
};

pub const snd_pcm_format_t = enum(c_int) {
    UNKNOWN = -1,
    S8 = 0,
    U8,
    S16_LE,
    S16_BE,
    U16_LE,
    U16_BE,
    S24_LE,
    S24_BE,
    U24_LE,
    U24_BE,
    S32_LE,
    S32_BE,
    U32_LE,
    U32_BE,
    FLOAT_LE,
    FLOAT_BE,
    FLOAT64_LE,
    FLOAT64_BE,
    IEC958_SUBFRAME_LE,
    IEC958_SUBFRAME_BE,
    MU_LAW,
    A_LAW,
    IMA_ADPCM,
    MPEG,
    GSM,
    SPECIAL = 31,
    S24_3LE = 32,
    S24_3BE,
    U24_3LE,
    U24_3BE,
    S20_3LE,
    S20_3BE,
    U20_3LE,
    U20_3BE,
    S18_3LE,
    S18_3BE,
    U18_3LE,
    U18_3BE,
};

pub const snd_pcm_subformat_t = enum(c_int) {
    STD = 0,
};

pub const snd_pcm_tstamp_t = enum(c_int) {
    SND_PCM_TSTAMP_NONE = 0,
    SND_PCM_TSTAMP_ENABLE,
};

pub const snd_pcm_uframes_t = c_ulong;
pub const snd_pcm_sframes_t = c_long;

pub const SND_PCM_NONBLOCK: c_int = 0x00000001;
pub const SND_PCM_ASYNC: c_int = 0x00000002;
pub const SND_PCM_NO_AUTO_RESAMPLE: c_int = 0x00010000;
pub const SND_PCM_NO_AUTO_CHANNELS: c_int = 0x00020000;
pub const SND_PCM_NO_AUTO_FORMAT: c_int = 0x00040000;
pub const SND_PCM_NO_SOFTVOL: c_int = 0x00080000;

pub const snd_pcm_rbptr_t = extern struct {
    master: ?*snd_pcm_t,
    ptr: ?*volatile snd_pcm_uframes_t,
    fd: c_int,
    offset: off_t,
    link_dst_count: c_int,
    link_dst: ?*?*snd_pcm_t,
    private_data: ?*anyopaque,
    changed: ?*anyopaque,
};

pub const snd_pcm_channel_info_t = extern struct {
    channel: c_uint,
    addr: ?*anyopaque,
    first: c_uint,
    step: c_uint,
    type: enum(c_int) { AREA_SHM, AREA_MMAP, AREA_LOCAL },
    u: extern union {
        shm: struct {
            area: ?*shmarea.snd_shm_area_t,
            sdmid: c_int,
        },
        mmap: struct {
            fd: c_int,
            offset: off_t,
        },
    },
    reserved: [64]u8,
};

pub const snd_pcm_ops_t = extern struct {
    close: ?*anyopaque,
    nonblock: ?*anyopaque,
    @"async": ?*anyopaque,
    info: ?*anyopaque,
    hw_refine: ?*anyopaque,
    hw_params: ?*anyopaque,
    hw_free: ?*anyopaque,
    sw_params: ?*anyopaque,
    channel_info: ?*anyopaque,
    dump: ?*anyopaque,
    mmap: ?*anyopaque,
    munmap: ?*anyopaque,
};

pub const snd_pcm_fast_ops_t = extern struct {
    status: ?*anyopaque,
    prepare: ?*anyopaque,
    reset: ?*anyopaque,
    start: ?*anyopaque,
    drop: ?*anyopaque,
    drain: ?*anyopaque,
    pause: ?*anyopaque,
    state: ?*anyopaque,
    hwsync: ?*anyopaque,
    delay: ?*anyopaque,
    @"resume": ?*anyopaque,
    link: ?*anyopaque,
    link_slaves: ?*anyopaque,
    unlink: ?*anyopaque,
    rewindable: ?*anyopaque,
    rewind: ?*anyopaque,
    forwardable: ?*anyopaque,
    forward: ?*anyopaque,
    writei: ?*anyopaque,
    writen: ?*anyopaque,
    readi: ?*anyopaque,
    readn: ?*anyopaque,
    avail_update: ?*anyopaque,
    mmap_commit: ?*anyopaque,
    htimestamp: ?*anyopaque,
    poll_descriptors_count: ?*anyopaque,
    poll_descriptors: ?*anyopaque,
    poll_reevents: ?*anyopaque,
};

pub const snd_pcm_t = extern struct {
    open_func: ?*anyopaque,
    name: [*c]u8,
    type: snd_pcm_type,
    stream: snd_pcm_stream_t,
    mode: c_int,
    minperiodtime: c_long,
    poll_fd_count: c_int,
    poll_fd: c_int,
    poll_events: c_ushort,
    setup_flags: c_int,
    access: snd_pcm_access_t,
    format: snd_pcm_format_t,
    subformat: snd_pcm_subformat_t,
    channels: c_uint,
    rate: c_uint,
    period_size: snd_pcm_uframes_t,
    period_time: c_uint,
    periods: local.snd_interval_t,
    tstamp_mode: snd_pcm_tstamp_t,
    period_step: c_uint,
    avail_min: snd_pcm_uframes_t,
    period_event: c_int,
    start_threshold: snd_pcm_uframes_t,
    stop_threshold: snd_pcm_uframes_t,
    silence_threshold: snd_pcm_uframes_t,
    silence_size: snd_pcm_uframes_t,
    boundary: snd_pcm_uframes_t,
    info: c_uint,
    msbits: c_uint,
    rate_num: c_uint,
    rate_den: c_uint,
    hw_flags: c_uint,
    fifo_size: snd_pcm_uframes_t,
    buffer_size: snd_pcm_uframes_t,
    buffer_time: local.snd_interval_t,
    sample_bits: c_uint,
    frame_bits: c_uint,
    appl: snd_pcm_rbptr_t,
    hw: snd_pcm_rbptr_t,
    min_align: snd_pcm_uframes_t,
    flags: c_uint,
    mmap_channels: [*]snd_pcm_channel_info_t,
    running_areas: [*]snd_pcm_channel_area_t,
    stopped_areas: [*]snd_pcm_channel_area_t,
    ops: ?*const snd_pcm_ops_t,
    fast_ops: ?*const snd_pcm_fast_ops_t,
    op_arg: ?*snd_pcm_t,
    fast_op_arg: ?*snd_pcm_t,
    private_data: ?*anyopaque,
    async_handlers: list.list_head,
};

pub const snd_pcm_type = enum(c_int) {
    HW = 0,
    HOOKS,
    MULTI,
    FILE,
    NULL,
    SHM,
    INET,
    COPY,
    LINEAR,
    ALAW,
    MULAW,
    ADPCM,
    RATE,
    ROUTE,
    PLUG,
    SHARE,
    METER,
    MIX,
    DROUTE,
    LBSERVER,
    LINEAR_FLOAT,
    LADSPA,
    DMIX,
    JACK,
    DSNOOP,
    DSHARE,
    IEC958,
    SOFTVOL,
    IOPLUG,
    EXTPLUG,
    MMAP_EMUL,
};

pub const snd_pcm_channel_area_t = extern struct {
    addr: ?*anyopaque,
    first: c_uint,
    step: c_uint,
};

pub extern "asound" fn snd_pcm_open(
    *?*snd_pcm_t,
    [*c]const u8,
    snd_pcm_stream_t,
    c_int,
) callconv(.C) c_int;

pub extern "asound" fn snd_pcm_close(*snd_pcm_t) callconv(.C) c_int;

pub extern "asound" fn snd_pcm_prepare(*snd_pcm_t) callconv(.C) c_int;

pub extern "asound" fn snd_pcm_drain(*snd_pcm_t) callconv(.C) c_int;

pub extern "asound" fn snd_pcm_hw_params(
    *snd_pcm_t,
    *local.snd_pcm_hw_params_t,
) callconv(.C) c_int;

pub extern "asound" fn snd_pcm_writei(
    *snd_pcm_t,
    *anyopaque,
    snd_pcm_uframes_t,
) callconv(.C) snd_pcm_sframes_t;

pub extern "asound" fn snd_pcm_hw_params_sizeof() callconv(.C) size_t;

pub extern "asound" fn snd_pcm_hw_params_malloc(
    *?*local.snd_pcm_hw_params_t,
) callconv(.C) c_int;

pub extern "asound" fn snd_pcm_hw_params_free(
    *local.snd_pcm_hw_params_t,
) callconv(.C) void;

pub extern "asound" fn snd_pcm_hw_params_copy(
    *local.snd_pcm_hw_params_t,
    *const local.snd_pcm_hw_params_t,
) callconv(.C) void;

pub extern "asound" fn snd_pcm_hw_params_any(
    *snd_pcm_t,
    *local.snd_pcm_hw_params_t,
) callconv(.C) c_int;

pub extern "asound" fn snd_pcm_hw_params_set_rate_resample(
    *snd_pcm_t,
    *local.snd_pcm_hw_params_t,
    c_uint,
) callconv(.C) c_int;

pub extern "asound" fn snd_pcm_hw_params_set_access(
    *snd_pcm_t,
    *local.snd_pcm_hw_params_t,
    snd_pcm_access_t,
) callconv(.C) c_int;

pub extern "asound" fn snd_pcm_hw_params_set_format(
    *snd_pcm_t,
    *local.snd_pcm_hw_params_t,
    snd_pcm_format_t,
) callconv(.C) c_int;

pub extern "asound" fn snd_pcm_hw_params_set_channels(
    *snd_pcm_t,
    *local.snd_pcm_hw_params_t,
    c_uint,
) callconv(.C) c_int;

pub extern "asound" fn snd_pcm_hw_params_set_rate_near(
    *snd_pcm_t,
    *local.snd_pcm_hw_params_t,
    ?*c_uint,
    ?*c_int,
) callconv(.C) c_int;

pub extern "asound" fn snd_pcm_hw_params_get_buffer_size(
    *local.snd_pcm_hw_params_t,
    *snd_pcm_uframes_t,
) callconv(.C) c_int;

pub extern "asound" fn snd_pcm_hw_params_set_buffer_size(
    *snd_pcm_t,
    *local.snd_pcm_hw_params_t,
    snd_pcm_uframes_t,
) callconv(.C) c_int;
