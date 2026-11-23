
#include <metal_stdlib>
using namespace metal;
template<typename T> T xm_mod(T x,T y) { return x-y*floor(x/y); }
struct Xm_FS_BEAUTY_Uniforms {
    float2 uPx;
    float2 uMix;
    float uUseMask;
    float uNoFace;
};
struct Xm_FS_BEAUTY_Input { float4 position [[position]];
    float2 vUv [[user(locn3)]];
};
struct Xm_FS_BEAUTY {
    float2 uPx;
    float2 uMix;
    float uUseMask;
    float uNoFace;
    float2 vUv;
    texture2d<float> uTex;
    texture2d<float> uMask;
    sampler xm_sampler;
    float4 gl_FragColor;










float4 tap(float2 off, float g, float yf) {
    float3 t = uTex.sample(xm_sampler, vUv + off).rgb;
    float d = t.g - g;
    float w = 1.0 - min(d * d * yf, 1.0);
    return float4(t * w, w);
}
void eval() {
    float3 c = uTex.sample(xm_sampler, vUv).rgb;
    if (uMix.x <= 0.0) { gl_FragColor = float4(c, 1.0); return; }
    float g = c.g;
    float4 s1 = float4(c, 1.0);
    float4 s2 = float4(c, 1.0);
    for (int i = 0; i < 8; i++) {
        float a = float(i) * 0.785398;
        float2 d = float2(cos(a), sin(a)) * uPx * 6.0;
        s1 += tap(d, g, 100.0);
        s2 += tap(d, g, 35.0) + tap(d * 2.0, g, 35.0) + tap(d * 3.0, g, 35.0);
    }
    float3 b1 = s1.rgb / s1.a;
    float3 b2 = s2.rgb / s2.a;
    float m = uUseMask > 0.5 ? uMask.sample(xm_sampler, vUv).r : 1.0;
    float3 even = clamp(c - b1 + b2, 0.0, 1.0);
    even = mix(c, even, m);
    even = mix(even, b2, m * uMix.y);
    float3 outc = mix(c, even, uMix.x);


    if (uUseMask < 0.5 && uNoFace > 0.0) outc = mix(c, outc, uNoFace * smoothstep(0.35, 0.55, dot(c, float3(0.299, 0.587, 0.114))));
    gl_FragColor = float4(outc, 1.0);
}

};
fragment float4 xm_FS_BEAUTY(Xm_FS_BEAUTY_Input input [[stage_in]], constant Xm_FS_BEAUTY_Uniforms& u [[buffer(0)]], texture2d<float> uTex [[texture(0)]], texture2d<float> uMask [[texture(1)]], sampler xm_sampler [[sampler(0)]]) {
    Xm_FS_BEAUTY s;
    s.uPx=u.uPx;
    s.uMix=u.uMix;
    s.uUseMask=u.uUseMask;
    s.uNoFace=u.uNoFace;
    s.vUv=input.vUv;
    s.uTex=uTex;
    s.uMask=uMask;
    s.xm_sampler=xm_sampler;
    s.eval();
    return s.gl_FragColor;
}
