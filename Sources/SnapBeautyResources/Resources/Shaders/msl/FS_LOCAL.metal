
#include <metal_stdlib>
using namespace metal;
template<typename T> T xm_mod(T x,T y) { return x-y*floor(x/y); }
struct Xm_FS_LOCAL_Uniforms {
    float4 uAmt;
    float2 uEyeStep;
};
struct Xm_FS_LOCAL_Input { float4 position [[position]];
    float2 vUv [[user(locn3)]];
};
struct Xm_FS_LOCAL {
    float4 uAmt;
    float2 uEyeStep;
    float2 vUv;
    texture2d<float> uTex;
    texture2d<float> uMask1;
    texture2d<float> uMask2;
    texture2d<float> uSmall;
    texture2d<float> uSmallBlur;
    texture2d<float> uThreeCurve;
    sampler xm_sampler;
    float4 gl_FragColor;












float softLight(float base, float blend) {
    float c1 = 2.0 * base * blend + base * base * (1.0 - 2.0 * blend);
    float c2 = sqrt(base) * (2.0 * blend - 1.0) + 2.0 * base * (1.0 - blend);
    return mix(c1, c2, step(0.5, blend));
}
void eval() {
    float3 c = uTex.sample(xm_sampler, vUv).rgb;
    float4 m1 = uMask1.sample(xm_sampler, vUv);
    float4 m2 = uMask2.sample(xm_sampler, vUv);
    float pouch = uAmt.y * m1.b;
    float fold = uAmt.z * m2.r;
    if (pouch > 0.0 || fold > 0.0) {
        float3 sc = uSmall.sample(xm_sampler, vUv).rgb;
        float3 bl = uSmallBlur.sample(xm_sampler, vUv).rgb;
        float3 diff = (bl - sc) * 1.4 + 0.05 * bl;
        if (pouch > 0.0) c = mix(c, min(c + clamp(diff, 0.0, 0.15), 1.0), pouch * 0.8);
        if (fold > 0.0) c = mix(c, min(c + clamp(diff, 0.0, 0.3), 1.0), fold * 0.7);
    }
    float three = uAmt.x * m1.g;
    if (three > 0.0) {
        float gray = dot(c, float3(0.3, 0.59, 0.11));
        float rate = clamp(uThreeCurve.sample(xm_sampler, float2(gray, 0.5)).r, 0.4, 1.0);
        float t = m1.g;
        float3 res = float3(softLight(c.r, t), softLight(c.g, t), softLight(c.b, t));
        c = mix(c, res, uAmt.x * rate * t);
    }
    float eye = clamp(uAmt.w * m2.g * 6.0, 0.0, 1.0);
    if (eye > 0.003) {
        float3 original = uTex.sample(xm_sampler, vUv).rgb;
        float2 dx = float2(uEyeStep.x, 0.0);
        float2 dy = float2(0.0, uEyeStep.y);
        float3 neighbourhood = 4.0 * original
            + 2.0 * (uTex.sample(xm_sampler, vUv - dx).rgb + uTex.sample(xm_sampler, vUv + dx).rgb
                   + uTex.sample(xm_sampler, vUv - dy).rgb + uTex.sample(xm_sampler, vUv + dy).rgb)
            + uTex.sample(xm_sampler, vUv - dx - dy).rgb + uTex.sample(xm_sampler, vUv - dx + dy).rgb
            + uTex.sample(xm_sampler, vUv + dx - dy).rgb + uTex.sample(xm_sampler, vUv + dx + dy).rgb;
        neighbourhood *= 0.0625;
        float luminance = dot(c, float3(0.2126, 0.7152, 0.0722));
        float darkGate = smoothstep(0.12, 0.38, luminance);
        float lift = (0.07 + 0.056 * sqrt(luminance)) * darkGate;
        c = clamp(c + eye * (lift * (float3(1.0) - c) + 2.0 * (original - neighbourhood)), 0.0, 1.0);
    }
    gl_FragColor = float4(c, 1.0);
}

};
fragment float4 xm_FS_LOCAL(Xm_FS_LOCAL_Input input [[stage_in]], constant Xm_FS_LOCAL_Uniforms& u [[buffer(0)]], texture2d<float> uTex [[texture(0)]], texture2d<float> uMask1 [[texture(1)]], texture2d<float> uMask2 [[texture(2)]], texture2d<float> uSmall [[texture(3)]], texture2d<float> uSmallBlur [[texture(4)]], texture2d<float> uThreeCurve [[texture(5)]], sampler xm_sampler [[sampler(0)]]) {
    Xm_FS_LOCAL s;
    s.uAmt=u.uAmt;
    s.uEyeStep=u.uEyeStep;
    s.vUv=input.vUv;
    s.uTex=uTex;
    s.uMask1=uMask1;
    s.uMask2=uMask2;
    s.uSmall=uSmall;
    s.uSmallBlur=uSmallBlur;
    s.uThreeCurve=uThreeCurve;
    s.xm_sampler=xm_sampler;
    s.eval();
    return s.gl_FragColor;
}
