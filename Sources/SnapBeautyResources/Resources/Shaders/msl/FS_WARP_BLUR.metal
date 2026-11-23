
#include <metal_stdlib>
using namespace metal;
template<typename T> T xm_mod(T x,T y) { return x-y*floor(x/y); }
struct Xm_FS_WARP_BLUR_Uniforms {
    float2 uStep;
};
struct Xm_FS_WARP_BLUR_Input { float4 position [[position]];
    float2 vUv [[user(locn3)]];
};
struct Xm_FS_WARP_BLUR {
    float2 uStep;
    float2 vUv;
    texture2d<float> uTex;
    sampler xm_sampler;
    float4 gl_FragColor;



const float WARP_RANGE = 0.25;
float4 encodeOff(float2 d) {
    float2 v = clamp(d / (2.0 * WARP_RANGE) + 0.5, 0.0, 1.0) * 255.0;
    float2 hi = floor(v);
    float2 lo = v - hi;
    return float4(hi.x / 255.0, lo.x, hi.y / 255.0, lo.y);
}
float2 decodeOff(float4 c) {
    float2 v = (float2(c.r, c.b) * 255.0 + float2(c.g, c.a)) / 255.0;
    return (v - 0.5) * 2.0 * WARP_RANGE;
}




void eval() {
    float2 sum = decodeOff(uTex.sample(xm_sampler, vUv)) * 0.2042;
    sum += (decodeOff(uTex.sample(xm_sampler, vUv + uStep)) + decodeOff(uTex.sample(xm_sampler, vUv - uStep))) * 0.1802;
    sum += (decodeOff(uTex.sample(xm_sampler, vUv + 2.0 * uStep)) + decodeOff(uTex.sample(xm_sampler, vUv - 2.0 * uStep))) * 0.1238;
    sum += (decodeOff(uTex.sample(xm_sampler, vUv + 3.0 * uStep)) + decodeOff(uTex.sample(xm_sampler, vUv - 3.0 * uStep))) * 0.0663;
    sum += (decodeOff(uTex.sample(xm_sampler, vUv + 4.0 * uStep)) + decodeOff(uTex.sample(xm_sampler, vUv - 4.0 * uStep))) * 0.0276;
    gl_FragColor = encodeOff(sum);
}

};
fragment float4 xm_FS_WARP_BLUR(Xm_FS_WARP_BLUR_Input input [[stage_in]], constant Xm_FS_WARP_BLUR_Uniforms& u [[buffer(0)]], texture2d<float> uTex [[texture(0)]], sampler xm_sampler [[sampler(0)]]) {
    Xm_FS_WARP_BLUR s;
    s.uStep=u.uStep;
    s.vUv=input.vUv;
    s.uTex=uTex;
    s.xm_sampler=xm_sampler;
    s.eval();
    return s.gl_FragColor;
}
