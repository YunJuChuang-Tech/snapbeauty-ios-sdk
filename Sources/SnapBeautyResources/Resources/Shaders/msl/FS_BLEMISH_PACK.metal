
#include <metal_stdlib>
using namespace metal;
template<typename T> T xm_mod(T x,T y) { return x-y*floor(x/y); }
struct Xm_FS_BLEMISH_PACK_Uniforms {
    float4 uMode;
};
struct Xm_FS_BLEMISH_PACK_Input { float4 position [[position]];
    float2 vUv [[user(locn3)]];
};
struct Xm_FS_BLEMISH_PACK {
    float4 uMode;
    float2 vUv;
    texture2d<float> uTex;
    texture2d<float> uSkin;
    texture2d<float> uSpotA;
    texture2d<float> uSpotB;
    sampler xm_sampler;
    float4 gl_FragColor;









void eval() {
    float3 c = uTex.sample(xm_sampler, vUv).rgb;
    float s = max(clamp(uSpotA.sample(xm_sampler, vUv).r * uMode.x, 0.0, 1.0), clamp(uSpotB.sample(xm_sampler, vUv).r * uMode.y, 0.0, 1.0));

    float w = max((1.0 - s) * max(uSkin.sample(xm_sampler, vUv).r, 0.05), 0.02);
    float3 v = uMode.z > 0.5 ? float3(clamp(c.r - c.g + 0.5, 0.0, 1.0)) : c;
    gl_FragColor = float4(v * w, w);
}

};
fragment float4 xm_FS_BLEMISH_PACK(Xm_FS_BLEMISH_PACK_Input input [[stage_in]], constant Xm_FS_BLEMISH_PACK_Uniforms& u [[buffer(0)]], texture2d<float> uTex [[texture(0)]], texture2d<float> uSkin [[texture(1)]], texture2d<float> uSpotA [[texture(2)]], texture2d<float> uSpotB [[texture(3)]], sampler xm_sampler [[sampler(0)]]) {
    Xm_FS_BLEMISH_PACK s;
    s.uMode=u.uMode;
    s.vUv=input.vUv;
    s.uTex=uTex;
    s.uSkin=uSkin;
    s.uSpotA=uSpotA;
    s.uSpotB=uSpotB;
    s.xm_sampler=xm_sampler;
    s.eval();
    return s.gl_FragColor;
}
