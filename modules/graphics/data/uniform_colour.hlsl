struct VS_Input {
    float3 pos : POSITION;
};

struct VS_Output {
    float4 pos : SV_POSITION;
};

cbuffer Constants {
    float4 colour;
}

VS_Output vs_main(VS_Input input) {
    VS_Output output = (VS_Output)0;
    output.pos = float4(input.pos, 1.0);
    return output;
}

float4 ps_main(VS_Output input) : SV_TARGET {
    return colour;
}
