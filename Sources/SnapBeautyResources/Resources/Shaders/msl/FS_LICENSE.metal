
#include <metal_stdlib>
using namespace metal;
template<typename T> T xm_mod(T x,T y) { return x-y*floor(x/y); }
struct Xm_FS_LICENSE_Uniforms {
    float uPhase;
};
struct Xm_FS_LICENSE_Input { float4 position [[position]];
    float2 vUv [[user(locn3)]];
};
struct Xm_FS_LICENSE {
    float uPhase;
    float2 vUv;
    texture2d<float> uTex;
    sampler xm_sampler;
    float4 gl_FragColor;






float rect(float2 p, float2 lo, float2 hi) {
    float2 a = step(lo, p) * step(p, hi);
    return a.x * a.y;
}
void eval() {
    float4 color = uTex.sample(xm_sampler, vUv);
    float2 p = fract(vUv * float2(4.0, 3.0) + float2(uPhase, 0.0));

    float bars = rect(p, float2(0.12, 0.25), float2(0.38, 0.32))
               + rect(p, float2(0.12, 0.47), float2(0.38, 0.54))
               + rect(p, float2(0.12, 0.69), float2(0.38, 0.76))
               + rect(p, float2(0.12, 0.47), float2(0.19, 0.76))
               + rect(p, float2(0.31, 0.25), float2(0.38, 0.54))
               + rect(p, float2(0.52, 0.25), float2(0.59, 0.76))
               + rect(p, float2(0.52, 0.25), float2(0.80, 0.32))
               + rect(p, float2(0.52, 0.47), float2(0.80, 0.54))
               + rect(p, float2(0.52, 0.69), float2(0.80, 0.76))
               + rect(p, float2(0.73, 0.25), float2(0.80, 0.76));
    float band = step(0.82, fract((vUv.x + vUv.y) * 10.0 + uPhase));
    color.rgb = mix(color.rgb, float3(0.90, 0.20, 0.65), 0.26 * band);
    color.rgb = mix(color.rgb, float3(1.0), 0.78 * min(bars, 1.0));
    gl_FragColor = color;
}

};
fragment float4 xm_FS_LICENSE(Xm_FS_LICENSE_Input input [[stage_in]], constant Xm_FS_LICENSE_Uniforms& u [[buffer(0)]], texture2d<float> uTex [[texture(0)]], sampler xm_sampler [[sampler(0)]]) {
    Xm_FS_LICENSE s;
    s.uPhase=u.uPhase;
    s.vUv=input.vUv;
    s.uTex=uTex;
    s.xm_sampler=xm_sampler;
    s.eval();
    return s.gl_FragColor;
}
