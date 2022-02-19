const sndrv_pcm_uframes_t = c_ulong;
const sndrv_pcm_sframes_t = c_long;

pub const sndrv_pcm_hw_param_t = enum(c_int) {
    ACCESS = 0,
    FORMAT,
    SUBFORMAT,

    SAMPLE_BITS = 8,
    FRAME_BITS,
    CHANNELS,
    RATE,
    PERIOD_TIME,

    PERIOD_SIZE,
    PERIOD_BYTES,
    PERIODS,
    BUFFER_TIME,
    BUFFER_SIZE,
    BUFFER_BYTES,
    TICK_TIME,

    const first_mask = @This().ACCESS;
    const last_mask = @This().SUBFORMAT;
    const first_interval = @This().SAMPLE_BITS;
    const last_interval = @This().TICK_TIME;
};

pub const sndrv_interval_t = extern struct {
    min: c_uint,
    max: c_uint,
    flags: c_uint,
};

pub const SNDRV_MASK_MAX = 256;

pub const sndrv_mask_t = extern struct {
    bits: [(SNDRV_MASK_MAX + 31) / 32]u32,
};

pub const sndrv_pcm_hw_params_t = extern struct {
    flags: c_uint,
    masks: [@enumToInt(sndrv_pcm_hw_param_t.last_mask) - @enumToInt(sndrv_pcm_hw_param_t.first_mask) + 1]sndrv_mask_t,
    mres: [5]sndrv_mask_t,
    intervals: [@enumToInt(sndrv_pcm_hw_param_t.last_interval) - @enumToInt(sndrv_pcm_hw_param_t.first_interval) + 1]sndrv_interval_t,
    ires: [9]sndrv_interval_t,
    rmask: c_uint,
    cmask: c_uint,
    info: c_uint,
    msbits: c_uint,
    rate_num: c_uint,
    rate_den: c_uint,
    fifo_size: sndrv_pcm_uframes_t,
    reserved: [64]u8,
};
