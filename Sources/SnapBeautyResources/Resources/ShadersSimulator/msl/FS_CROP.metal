
#include <metal_stdlib>
using namespace metal;
template<typename T> T xm_mod(T x,T y) { return x-y*floor(x/y); }
struct Xm_FS_CROP_Uniforms {
    float2 uFrame;
    float2 uCenter;
    float2 uAxisX;
    float2 uAxisY;
};
struct Xm_FS_CROP_Input { float4 position [[position]];
    float2 vUv [[user(locn3)]];
};
struct Xm_FS_CROP {
    float2 uFrame;
    float2 uCenter;
    float2 uAxisX;
    float2 uAxisY;
    float2 vUv;
    texture2d<float> uTex;
    sampler xm_sampler;
    float4 gl_FragColor;









void eval() {
    float2 p = uCenter + uAxisX * (vUv.x - 0.5) + uAxisY * (vUv.y - 0.5);
    float2 uv = p / uFrame;
    if (uv.x < 0.0 || uv.y < 0.0 || uv.x > 1.0 || uv.y > 1.0) gl_FragColor = float4(0.0, 0.0, 0.0, 1.0);
    else gl_FragColor = uTex.sample(xm_sampler, uv);
}

};
fragment float4 xm_FS_CROP(Xm_FS_CROP_Input input [[stage_in]], constant Xm_FS_CROP_Uniforms& u [[buffer(0)]], texture2d<float> uTex [[texture(0)]], sampler xm_sampler [[sampler(0)]]) {
    Xm_FS_CROP s;
    s.uFrame=u.uFrame;
    s.uCenter=u.uCenter;
    s.uAxisX=u.uAxisX;
    s.uAxisY=u.uAxisY;
    s.vUv=input.vUv;
    s.uTex=uTex;
    s.xm_sampler=xm_sampler;
    s.eval();
    return s.gl_FragColor;
}
