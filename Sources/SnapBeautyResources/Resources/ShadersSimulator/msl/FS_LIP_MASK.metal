
#include <metal_stdlib>
using namespace metal;
template<typename T> T xm_mod(T x,T y) { return x-y*floor(x/y); }
struct Xm_FS_LIP_MASK_Uniforms {
};
struct Xm_FS_LIP_MASK_Input { float4 position [[position]];
    float vA [[user(locn0)]];
    float2 vMaskUv [[user(locn1)]];
};
struct Xm_FS_LIP_MASK {
    float vA;
    float2 vMaskUv;
    texture2d<float> uLipMask;
    sampler xm_sampler;
    float4 gl_FragColor;






void eval() {
    float mask = clamp(vA, 0.0, 1.0) * uLipMask.sample(xm_sampler, vMaskUv).r;
    gl_FragColor = float4(float3(mask), 1.0);
}

};
fragment float4 xm_FS_LIP_MASK(Xm_FS_LIP_MASK_Input input [[stage_in]], constant Xm_FS_LIP_MASK_Uniforms& u [[buffer(0)]], texture2d<float> uLipMask [[texture(0)]], sampler xm_sampler [[sampler(0)]]) {
    Xm_FS_LIP_MASK s;
    s.vA=input.vA;
    s.vMaskUv=input.vMaskUv;
    s.uLipMask=uLipMask;
    s.xm_sampler=xm_sampler;
    s.eval();
    return s.gl_FragColor;
}
