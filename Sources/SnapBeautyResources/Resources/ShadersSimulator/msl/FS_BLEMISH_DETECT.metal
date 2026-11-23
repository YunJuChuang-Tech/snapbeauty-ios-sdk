
#include <metal_stdlib>
using namespace metal;
template<typename T> T xm_mod(T x,T y) { return x-y*floor(x/y); }
struct Xm_FS_BLEMISH_DETECT_Uniforms {
    float4 uK;
    float2 uDark;
    float2 uCore;
    float3 uSat;
};
struct Xm_FS_BLEMISH_DETECT_Input { float4 position [[position]];
    float2 vUv [[user(locn3)]];
};
struct Xm_FS_BLEMISH_DETECT {
    float4 uK;
    float2 uDark;
    float2 uCore;
    float3 uSat;
    float2 vUv;
    texture2d<float> uTex;
    texture2d<float> uBg;
    texture2d<float> uSkin;
    sampler xm_sampler;
    float4 gl_FragColor;










const float3 L = float3(0.299, 0.587, 0.114);


void eval() {
    float3 c = uTex.sample(xm_sampler, vUv).rgb;
    float4 b = uBg.sample(xm_sampler, vUv);
    float3 bg = b.rgb / max(b.a, 1e-3);
    float y = dot(c, L), by = dot(bg, L);
    float red = (c.r - c.g) - (bg.r - bg.g);
    float dark = clamp(by - y, 0.0, uDark.x);

    float sat = (c.r - c.g) / max(y, 1e-3) - (bg.r - bg.g) / max(by, 1e-3);
    dark *= mix(1.0, smoothstep(uSat.y, uSat.z, sat), uSat.x);

    float sc = smoothstep(uK.z, uK.w, max(red * uK.x, dark * uK.y)) * smoothstep(0.03, 0.08, b.a);
    float region = uSkin.sample(xm_sampler, vUv).r, ratio = y / max(by, 1e-3);
    float skin = region * smoothstep(uDark.y - 0.05, uDark.y + 0.05, ratio);
    float core = max(1.0 - smoothstep(uCore.x - 0.05, uCore.x + 0.05, ratio), smoothstep(uCore.y - 0.05, uCore.y + 0.05, ratio));
    gl_FragColor = float4(sc * skin, core * smoothstep(0.1, 0.5, region), 0.0, 1.0);
}

};
fragment float4 xm_FS_BLEMISH_DETECT(Xm_FS_BLEMISH_DETECT_Input input [[stage_in]], constant Xm_FS_BLEMISH_DETECT_Uniforms& u [[buffer(0)]], texture2d<float> uTex [[texture(0)]], texture2d<float> uBg [[texture(1)]], texture2d<float> uSkin [[texture(2)]], sampler xm_sampler [[sampler(0)]]) {
    Xm_FS_BLEMISH_DETECT s;
    s.uK=u.uK;
    s.uDark=u.uDark;
    s.uCore=u.uCore;
    s.uSat=u.uSat;
    s.vUv=input.vUv;
    s.uTex=uTex;
    s.uBg=uBg;
    s.uSkin=uSkin;
    s.xm_sampler=xm_sampler;
    s.eval();
    return s.gl_FragColor;
}
