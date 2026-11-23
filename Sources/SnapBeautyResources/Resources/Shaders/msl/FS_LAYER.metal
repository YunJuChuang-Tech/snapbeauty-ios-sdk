
#include <metal_stdlib>
using namespace metal;
template<typename T> T xm_mod(T x,T y) { return x-y*floor(x/y); }
struct Xm_FS_LAYER_Uniforms {
    float uAlpha;
    float uMode;
};
struct Xm_FS_LAYER_Input { float4 position [[position]];
    float2 vUv [[user(locn3)]];
};
struct Xm_FS_LAYER {
    float uAlpha;
    float uMode;
    float2 vUv;
    texture2d<float> uTex;
    sampler xm_sampler;
    float4 gl_FragColor;







void eval() {
    float4 c = uTex.sample(xm_sampler, vUv) * uAlpha;
    if (c.a > 1.0) c /= c.a;
    float3 sh = c.rgb - float3(dot(c.rgb, float3(0.299, 0.587, 0.114)));
    if (uMode < 0.5) gl_FragColor = c;
    else if (uMode < 1.5) gl_FragColor = float4(float3(1.0 - c.a) + c.rgb, 1.0);
    else gl_FragColor = float4(float3(0.5 * c.a) + 0.5 * sh, c.a);
}

};
fragment float4 xm_FS_LAYER(Xm_FS_LAYER_Input input [[stage_in]], constant Xm_FS_LAYER_Uniforms& u [[buffer(0)]], texture2d<float> uTex [[texture(0)]], sampler xm_sampler [[sampler(0)]]) {
    Xm_FS_LAYER s;
    s.uAlpha=u.uAlpha;
    s.uMode=u.uMode;
    s.vUv=input.vUv;
    s.uTex=uTex;
    s.xm_sampler=xm_sampler;
    s.eval();
    return s.gl_FragColor;
}
