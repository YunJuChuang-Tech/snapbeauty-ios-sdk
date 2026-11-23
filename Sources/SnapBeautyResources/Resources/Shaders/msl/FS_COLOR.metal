
#include <metal_stdlib>
using namespace metal;
template<typename T> T xm_mod(T x,T y) { return x-y*floor(x/y); }
struct Xm_FS_COLOR_Uniforms {
    float2 uPx;
    float4 uAmount;
};
struct Xm_FS_COLOR_Input { float4 position [[position]];
    float2 vUv [[user(locn3)]];
};
struct Xm_FS_COLOR {
    float2 uPx;
    float4 uAmount;
    float2 vUv;
    texture2d<float> uTex;
    texture2d<float> uOrig;
    texture2d<float> uRedLut;
    texture2d<float> uWhiteLut;
    texture2d<float> uClarityLut;
    sampler xm_sampler;
    float4 gl_FragColor;











float3 lut32(texture2d<float> t, float3 c) {
    float3 g = clamp(c, 0.0, 1.0) * 31.0;
    float b0 = min(floor(g.b), 30.0);
    float b1 = b0 + 1.0;
    float2 rg = (g.rg + 0.5) / 32.0;
    float2 t0 = (float2(b0 - floor(b0 / 8.0) * 8.0, floor(b0 / 8.0)) + rg) * float2(0.125, 0.25);
    float2 t1 = (float2(b1 - floor(b1 / 8.0) * 8.0, floor(b1 / 8.0)) + rg) * float2(0.125, 0.25);
    return mix(t.sample(xm_sampler, t0).rgb, t.sample(xm_sampler, t1).rgb, g.b - b0);
}
void eval() {
    float3 c = uTex.sample(xm_sampler, vUv).rgb;
    if (uAmount.x > 0.0) {
        float2 h = uPx * 0.5;
        float sum = uOrig.sample(xm_sampler, vUv + h).g + uOrig.sample(xm_sampler, vUv - h).g
                  + uOrig.sample(xm_sampler, vUv + float2(-h.x, h.y)).g + uOrig.sample(xm_sampler, vUv + float2(h.x, -h.y)).g;
        float hp = uOrig.sample(xm_sampler, vUv).g - sum * 0.25 + 0.5;
        float3 hv = 2.0 * hp + c - 1.0;
        float3 s = hp >= 0.5 ? min(float3(1.0), hv) : max(float3(0.0), hv);
        c = mix(c, s, uAmount.x);
    }
    if (uAmount.y > 0.0) c = mix(c, lut32(uRedLut, c), uAmount.y);
    if (uAmount.z > 0.0) c = mix(c, lut32(uWhiteLut, c), uAmount.z);
    if (uAmount.w > 0.0) c = mix(c, lut32(uClarityLut, c), uAmount.w);
    gl_FragColor = float4(clamp(c, 0.0, 1.0), 1.0);
}

};
fragment float4 xm_FS_COLOR(Xm_FS_COLOR_Input input [[stage_in]], constant Xm_FS_COLOR_Uniforms& u [[buffer(0)]], texture2d<float> uTex [[texture(0)]], texture2d<float> uOrig [[texture(1)]], texture2d<float> uRedLut [[texture(2)]], texture2d<float> uWhiteLut [[texture(3)]], texture2d<float> uClarityLut [[texture(4)]], sampler xm_sampler [[sampler(0)]]) {
    Xm_FS_COLOR s;
    s.uPx=u.uPx;
    s.uAmount=u.uAmount;
    s.vUv=input.vUv;
    s.uTex=uTex;
    s.uOrig=uOrig;
    s.uRedLut=uRedLut;
    s.uWhiteLut=uWhiteLut;
    s.uClarityLut=uClarityLut;
    s.xm_sampler=xm_sampler;
    s.eval();
    return s.gl_FragColor;
}
