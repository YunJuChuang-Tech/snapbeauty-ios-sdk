
#include <metal_stdlib>
using namespace metal;
template<typename T> T xm_mod(T x,T y) { return x-y*floor(x/y); }
struct Xm_FS_WARP_FIELD_Uniforms {
};
struct Xm_FS_WARP_FIELD_Input { float4 position [[position]];
    float2 vOff [[user(locn2)]];
};
struct Xm_FS_WARP_FIELD {
    float2 vOff;
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


void eval() { gl_FragColor = encodeOff(vOff); }

};
fragment float4 xm_FS_WARP_FIELD(Xm_FS_WARP_FIELD_Input input [[stage_in]], constant Xm_FS_WARP_FIELD_Uniforms& u [[buffer(0)]]) {
    Xm_FS_WARP_FIELD s;
    s.vOff=input.vOff;
    s.eval();
    return s.gl_FragColor;
}
