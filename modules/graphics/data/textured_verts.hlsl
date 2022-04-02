Texture2D texture0 : register(t0);
sampler sampler0 : register(s0);

cbuffer Constants {
    float4x4 mvp;
    float4 colour;
}

struct VS_Input {
    float3 pos : POSITION;
    float2 uv : TEXCOORD;
};

struct VS_Output {
    float4 pos : SV_POSITION;
    float2 uv : TEXCOORD0;
};

VS_Output vs_main(VS_Input input) {
    VS_Output output = (VS_Output)0;
    output.pos = mul(mvp, float4(input.pos, 1.0));
    output.uv = input.uv;
    return output;
}

float4 ps_main(VS_Output input) : SV_TARGET {
    return texture0.Sample(sampler0, input.uv);
}

float4 ps_mono_main(VS_Output input) : SV_TARGET {
    float s = texture0.Sample(sampler0, input.uv);
    return float4(1, 1, 1, s);
}
