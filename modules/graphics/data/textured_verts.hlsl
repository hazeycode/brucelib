Texture2D texture0;

SamplerState TextureSampler{
    Filter = MIN_MAG_MIP_LINEAR;
    AddressU = Wrap;
    AddressV = Wrap;
};

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
    output.pos = float4(input.pos, 1.0);
    output.uv = input.uv;
    return output;
}

float4 ps_main(VS_Output input) : SV_TARGET {
    return texture0.Sample(TextureSampler, input.uv);
}
