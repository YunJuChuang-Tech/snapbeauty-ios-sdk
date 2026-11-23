
#include <metal_stdlib>
using namespace metal;
template<typename T> T xm_mod(T x,T y) { return x-y*floor(x/y); }
struct Xm_FS_GF_APPLY_Uniforms {
    float uK;
};
struct Xm_FS_GF_APPLY_Input { float4 position [[position]];
    float2 vUv [[user(locn3)]];
};
struct Xm_FS_GF_APPLY {
    float uK;
    float2 vUv;
    texture2d<float> uBase;
    texture2d<float> uSrc;
    texture2d<float> uMean;
    texture2d<float> uVar;
    texture2d<float> uMask;
    sampler xm_sampler;
    float4 gl_FragColor;










void eval() {
    float3 o = uBase.sample(xm_sampler, vUv).rgb;
    float3 n = uSrc.sample(xm_sampler, vUv).rgb;
    float3 m = uMean.sample(xm_sampler, vUv).rgb;
    float v = uVar.sample(xm_sampler, vUv).r / 12.0;
    float a = v / (v + 0.005);
    float3 g = m + a * (n - m);
    float k = clamp(uMask.sample(xm_sampler, vUv).b * uK, 0.0, 1.0);
    gl_FragColor = float4(mix(o, g, k), 1.0);
}

};
fragment float4 xm_FS_GF_APPLY(Xm_FS_GF_APPLY_Input input [[stage_in]], constant Xm_FS_GF_APPLY_Uniforms& u [[buffer(0)]], texture2d<float> uBase [[texture(0)]], texture2d<float> uSrc [[texture(1)]], texture2d<float> uMean [[texture(2)]], texture2d<float> uVar [[texture(3)]], texture2d<float> uMask [[texture(4)]], sampler xm_sampler [[sampler(0)]]) {
    Xm_FS_GF_APPLY s;
    s.uK=u.uK;
    s.vUv=input.vUv;
    s.uBase=uBase;
    s.uSrc=uSrc;
    s.uMean=uMean;
    s.uVar=uVar;
    s.uMask=uMask;
    s.xm_sampler=xm_sampler;
    s.eval();
    return s.gl_FragColor;
}
