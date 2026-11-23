
#include <metal_stdlib>
using namespace metal;
template<typename T> T xm_mod(T x,T y) { return x-y*floor(x/y); }
struct Xm_FS_COPY_Uniforms {
};
struct Xm_FS_COPY_Input { float4 position [[position]];
    float2 vUv [[user(locn3)]];
};
struct Xm_FS_COPY {
    float2 vUv;
    texture2d<float> uTex;
    sampler xm_sampler;
    float4 gl_FragColor;





void eval() { gl_FragColor = uTex.sample(xm_sampler, vUv); }

};
fragment float4 xm_FS_COPY(Xm_FS_COPY_Input input [[stage_in]], constant Xm_FS_COPY_Uniforms& u [[buffer(0)]], texture2d<float> uTex [[texture(0)]], sampler xm_sampler [[sampler(0)]]) {
    Xm_FS_COPY s;
    s.vUv=input.vUv;
    s.uTex=uTex;
    s.xm_sampler=xm_sampler;
    s.eval();
    return s.gl_FragColor;
}
