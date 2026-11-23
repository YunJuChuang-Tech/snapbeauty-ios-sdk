
#include <metal_stdlib>
using namespace metal;
template<typename T> T xm_mod(T x,T y) { return x-y*floor(x/y); }
struct Xm_FS_LIP_Uniforms {
    float3 uColor;
    float uAlpha;
    float3 uGate;
    float2 uGateStep;
    float4 uSkinA;
    float4 uSkinB;
};
struct Xm_FS_LIP_Input { float4 position [[position]];
    float2 vUv [[user(locn3)]];
    float vA [[user(locn0)]];
    float2 vMaskUv [[user(locn1)]];
};
struct Xm_FS_LIP {
    float3 uColor;
    float uAlpha;
    float3 uGate;
    float2 uGateStep;
    float4 uSkinA;
    float4 uSkinB;
    float2 vUv;
    float vA;
    float2 vMaskUv;
    texture2d<float> uSrc;
    texture2d<float> uLipMask;
    sampler xm_sampler;
    float4 gl_FragColor;













float redness(float3 c) {
    return (c.r - c.g) / (c.r + c.g + c.b + 0.001);
}
void eval() {
    float3 source = uSrc.sample(xm_sampler, vUv).rgb;
    float coverage = clamp(vA, 0.0, 1.0) * uLipMask.sample(xm_sampler, vMaskUv).r;
    float gate = 1.0;
    if (uGate.x < 1.0) {
        float2 dx = float2(uGateStep.x, 0.0);
        float2 dy = float2(0.0, uGateStep.y);
        float q = (redness(source) + redness(uSrc.sample(xm_sampler, vUv + dx).rgb) + redness(uSrc.sample(xm_sampler, vUv - dx).rgb)
                 + redness(uSrc.sample(xm_sampler, vUv + dy).rgb) + redness(uSrc.sample(xm_sampler, vUv - dy).rgb)) * 0.2;
        float skin = (redness(uSrc.sample(xm_sampler, uSkinA.xy).rgb) + redness(uSrc.sample(xm_sampler, uSkinA.zw).rgb)
                    + redness(uSrc.sample(xm_sampler, uSkinB.xy).rgb) + redness(uSrc.sample(xm_sampler, uSkinB.zw).rgb)) * 0.25;
        gate = mix(uGate.x, 1.0, smoothstep(uGate.y, uGate.z, q - skin));
    }
    float luminance = dot(source, float3(0.299, 0.587, 0.114));
    float shadeLuminance = dot(uColor, float3(0.299, 0.587, 0.114));
    float shadeScale = min(sqrt(luminance / max(shadeLuminance, 0.05)), 1.0);
    float3 shade = uColor * shadeScale;
    float opacity = clamp(uAlpha * coverage * gate, 0.0, 1.0);
    float amount = opacity * (0.35 + 0.37 * sqrt(luminance));
    float3 result = mix(source, shade, amount);
    result += opacity * (0.04 - 0.17 * luminance) * (float3(1.0) - source);
    gl_FragColor = float4(clamp(result, 0.0, 1.0), 1.0);
}

};
fragment float4 xm_FS_LIP(Xm_FS_LIP_Input input [[stage_in]], constant Xm_FS_LIP_Uniforms& u [[buffer(0)]], texture2d<float> uSrc [[texture(0)]], texture2d<float> uLipMask [[texture(1)]], sampler xm_sampler [[sampler(0)]]) {
    Xm_FS_LIP s;
    s.uColor=u.uColor;
    s.uAlpha=u.uAlpha;
    s.uGate=u.uGate;
    s.uGateStep=u.uGateStep;
    s.uSkinA=u.uSkinA;
    s.uSkinB=u.uSkinB;
    s.vUv=input.vUv;
    s.vA=input.vA;
    s.vMaskUv=input.vMaskUv;
    s.uSrc=uSrc;
    s.uLipMask=uLipMask;
    s.xm_sampler=xm_sampler;
    s.eval();
    return s.gl_FragColor;
}
