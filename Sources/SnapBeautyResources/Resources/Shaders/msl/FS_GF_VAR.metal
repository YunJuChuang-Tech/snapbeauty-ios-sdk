
#include <metal_stdlib>
using namespace metal;
template<typename T> T xm_mod(T x,T y) { return x-y*floor(x/y); }
struct Xm_FS_GF_VAR_Uniforms {
};
struct Xm_FS_GF_VAR_Input { float4 position [[position]];
    float2 vUv [[user(locn3)]];
};
struct Xm_FS_GF_VAR {
    float2 vUv;
    texture2d<float> uSmall;
    texture2d<float> uMean;
    sampler xm_sampler;
    float4 gl_FragColor;






void eval() {
    float d = uSmall.sample(xm_sampler, vUv).g - uMean.sample(xm_sampler, vUv).g;
    gl_FragColor = float4(float3(clamp(d * d * 12.0, 0.0, 1.0)), 1.0);
}

};
fragment float4 xm_FS_GF_VAR(Xm_FS_GF_VAR_Input input [[stage_in]], constant Xm_FS_GF_VAR_Uniforms& u [[buffer(0)]], texture2d<float> uSmall [[texture(0)]], texture2d<float> uMean [[texture(1)]], sampler xm_sampler [[sampler(0)]]) {
    Xm_FS_GF_VAR s;
    s.vUv=input.vUv;
    s.uSmall=uSmall;
    s.uMean=uMean;
    s.xm_sampler=xm_sampler;
    s.eval();
    return s.gl_FragColor;
}
