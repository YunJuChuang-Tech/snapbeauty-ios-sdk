
#include <metal_stdlib>
using namespace metal;
template<typename T> T xm_mod(T x,T y) { return x-y*floor(x/y); }
struct Xm_FS_GAUSS_Uniforms {
    float2 uDir;
};
struct Xm_FS_GAUSS_Input { float4 position [[position]];
    float2 vUv [[user(locn3)]];
};
struct Xm_FS_GAUSS {
    float2 uDir;
    float2 vUv;
    texture2d<float> uTex;
    sampler xm_sampler;
    float4 gl_FragColor;






void eval() {
    float3 s = uTex.sample(xm_sampler, vUv).rgb * 0.1532;
    s += (uTex.sample(xm_sampler, vUv + uDir).rgb + uTex.sample(xm_sampler, vUv - uDir).rgb) * 0.1449;
    s += (uTex.sample(xm_sampler, vUv + 2.0 * uDir).rgb + uTex.sample(xm_sampler, vUv - 2.0 * uDir).rgb) * 0.1226;
    s += (uTex.sample(xm_sampler, vUv + 3.0 * uDir).rgb + uTex.sample(xm_sampler, vUv - 3.0 * uDir).rgb) * 0.0929;
    s += (uTex.sample(xm_sampler, vUv + 4.0 * uDir).rgb + uTex.sample(xm_sampler, vUv - 4.0 * uDir).rgb) * 0.0630;
    gl_FragColor = float4(s, 1.0);
}

};
fragment float4 xm_FS_GAUSS(Xm_FS_GAUSS_Input input [[stage_in]], constant Xm_FS_GAUSS_Uniforms& u [[buffer(0)]], texture2d<float> uTex [[texture(0)]], sampler xm_sampler [[sampler(0)]]) {
    Xm_FS_GAUSS s;
    s.uDir=u.uDir;
    s.vUv=input.vUv;
    s.uTex=uTex;
    s.xm_sampler=xm_sampler;
    s.eval();
    return s.gl_FragColor;
}
