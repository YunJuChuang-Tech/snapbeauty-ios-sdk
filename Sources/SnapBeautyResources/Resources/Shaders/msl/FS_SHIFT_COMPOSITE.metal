
#include <metal_stdlib>
using namespace metal;
template<typename T> T xm_mod(T x,T y) { return x-y*floor(x/y); }
struct Xm_FS_SHIFT_COMPOSITE_Uniforms {
};
struct Xm_FS_SHIFT_COMPOSITE_Input { float4 position [[position]];
    float2 vUv [[user(locn3)]];
};
struct Xm_FS_SHIFT_COMPOSITE {
    float2 vUv;
    texture2d<float> uTex;
    texture2d<float> uShift;
    sampler xm_sampler;
    float4 gl_FragColor;






void eval() {
    float3 c = uTex.sample(xm_sampler, vUv).rgb + (uShift.sample(xm_sampler, vUv).rgb - 0.5) * 2.0;
    gl_FragColor = float4(clamp(c, 0.0, 1.0), 1.0);
}

};
fragment float4 xm_FS_SHIFT_COMPOSITE(Xm_FS_SHIFT_COMPOSITE_Input input [[stage_in]], constant Xm_FS_SHIFT_COMPOSITE_Uniforms& u [[buffer(0)]], texture2d<float> uTex [[texture(0)]], texture2d<float> uShift [[texture(1)]], sampler xm_sampler [[sampler(0)]]) {
    Xm_FS_SHIFT_COMPOSITE s;
    s.vUv=input.vUv;
    s.uTex=uTex;
    s.uShift=uShift;
    s.xm_sampler=xm_sampler;
    s.eval();
    return s.gl_FragColor;
}
