
#include <metal_stdlib>
using namespace metal;
template<typename T> T xm_mod(T x,T y) { return x-y*floor(x/y); }
struct Xm_FS_GAUSS9_R_Uniforms {
    float2 uStep;
};
struct Xm_FS_GAUSS9_R_Input { float4 position [[position]];
    float2 vUv [[user(locn3)]];
};
struct Xm_FS_GAUSS9_R {
    float2 uStep;
    float2 vUv;
    texture2d<float> uTex;
    sampler xm_sampler;
    float4 gl_FragColor;






void eval() {
    float s = uTex.sample(xm_sampler, vUv).r * 0.2042;
    s += (uTex.sample(xm_sampler, vUv + uStep).r + uTex.sample(xm_sampler, vUv - uStep).r) * 0.1802;
    s += (uTex.sample(xm_sampler, vUv + 2.0 * uStep).r + uTex.sample(xm_sampler, vUv - 2.0 * uStep).r) * 0.1238;
    s += (uTex.sample(xm_sampler, vUv + 3.0 * uStep).r + uTex.sample(xm_sampler, vUv - 3.0 * uStep).r) * 0.0663;
    s += (uTex.sample(xm_sampler, vUv + 4.0 * uStep).r + uTex.sample(xm_sampler, vUv - 4.0 * uStep).r) * 0.0276;
    gl_FragColor = float4(float3(s), 1.0);
}

};
fragment float4 xm_FS_GAUSS9_R(Xm_FS_GAUSS9_R_Input input [[stage_in]], constant Xm_FS_GAUSS9_R_Uniforms& u [[buffer(0)]], texture2d<float> uTex [[texture(0)]], sampler xm_sampler [[sampler(0)]]) {
    Xm_FS_GAUSS9_R s;
    s.uStep=u.uStep;
    s.vUv=input.vUv;
    s.uTex=uTex;
    s.xm_sampler=xm_sampler;
    s.eval();
    return s.gl_FragColor;
}
