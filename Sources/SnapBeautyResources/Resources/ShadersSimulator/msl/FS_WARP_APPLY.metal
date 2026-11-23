
#include <metal_stdlib>
using namespace metal;
template<typename T> T xm_mod(T x,T y) { return x-y*floor(x/y); }
struct Xm_FS_WARP_APPLY_Uniforms {
};
struct Xm_FS_WARP_APPLY_Input { float4 position [[position]];
    float2 vUv [[user(locn3)]];
};
struct Xm_FS_WARP_APPLY {
    float2 vUv;
    texture2d<float> uTex;
    texture2d<float> uField;
    texture2d<float> uField2;
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





float2 field(float2 uv) { return decodeOff(uField.sample(xm_sampler, uv)) + decodeOff(uField2.sample(xm_sampler, uv)); }
void eval() {

    float2 d = field(vUv);
    d = field(vUv - d);
    d = field(vUv - d);
    d = field(vUv - d);
    gl_FragColor = uTex.sample(xm_sampler, vUv - d);
}

};
fragment float4 xm_FS_WARP_APPLY(Xm_FS_WARP_APPLY_Input input [[stage_in]], constant Xm_FS_WARP_APPLY_Uniforms& u [[buffer(0)]], texture2d<float> uTex [[texture(0)]], texture2d<float> uField [[texture(1)]], texture2d<float> uField2 [[texture(2)]], sampler xm_sampler [[sampler(0)]]) {
    Xm_FS_WARP_APPLY s;
    s.vUv=input.vUv;
    s.uTex=uTex;
    s.uField=uField;
    s.uField2=uField2;
    s.xm_sampler=xm_sampler;
    s.eval();
    return s.gl_FragColor;
}
