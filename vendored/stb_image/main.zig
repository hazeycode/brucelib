pub usingnamespace @cImport({
    @cDefine("STBI_NO_SIMD", {});
    @cDefine("STBI_NO_TGA", {});
    @cDefine("STBI_NO_HDR", {});
    @cDefine("STB_IMAGE_IMPLEMENTATION", {});
    @cInclude("stb_image.h");
});
