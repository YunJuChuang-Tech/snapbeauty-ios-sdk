
#include <metal_stdlib>
using namespace metal;
template<typename T> T xm_mod(T x,T y) { return x-y*floor(x/y); }
struct Xm_FS_BLEMISH_APPLY_Uniforms {
    float2 uProtectK;
    float4 uAmt;
    float uRedFade;
    float uMaxLift;
};
struct Xm_FS_BLEMISH_APPLY_Input { float4 position [[position]];
    float2 vUv [[user(locn3)]];
};
struct Xm_FS_BLEMISH_APPLY {
    float2 uProtectK;
    float4 uAmt;
    float uRedFade;
    float uMaxLift;
    float2 vUv;
    texture2d<float> uTex;
    texture2d<float> uHalf;
    texture2d<float> uClean;
    texture2d<float> uScore;
    texture2d<float> uSpotA;
    texture2d<float> uWide;
    texture2d<float> uSpotB;
    texture2d<float> uRed;
    texture2d<float> uSkin;
    texture2d<float> uProtect;
    sampler xm_sampler;
    float4 gl_FragColor;


















void eval() {
    float3 c = uTex.sample(xm_sampler, vUv).rgb;
    float3 h = uHalf.sample(xm_sampler, vUv).rgb;
    float3 fine = c - h;
    float score = uScore.sample(xm_sampler, vUv).r;
    float4 m = uClean.sample(xm_sampler, vUv);
    float4 wd = uWide.sample(xm_sampler, vUv);


    float3 wide = mix(h, wd.rgb / max(wd.a, 1e-3), smoothstep(0.03, 0.08, wd.a));
    float3 bg = mix(wide, m.rgb / max(m.a, 1e-3), smoothstep(0.03, 0.08, m.a));
    float keep = 1.0 - smoothstep(uProtectK.x, uProtectK.y, uProtect.sample(xm_sampler, vUv).g);
    float s = clamp(uSpotA.sample(xm_sampler, vUv).r * uAmt.y, 0.0, 1.0) * keep;
    float3 clean = bg + fine * uAmt.w * (1.0 - score);
    float3 o = c + (clean - c) * (s * uAmt.x);
    float s2 = clamp(uSpotB.sample(xm_sampler, vUv).r * uAmt.z, 0.0, 1.0) * keep;
    o += (wide + fine * uAmt.w - o) * (s2 * uAmt.x);
    float4 r = uRed.sample(xm_sampler, vUv);
    float excess = max((o.r - o.g) - (r.r / max(r.a, 1e-3) - 0.5), 0.0) * uSkin.sample(xm_sampler, vUv).r * smoothstep(0.03, 0.08, r.a) * keep;
    o.r -= excess * uRedFade * uAmt.x * 0.7;
    o.g += excess * uRedFade * uAmt.x * 0.3;
    float lift = dot(o - c, float3(0.299, 0.587, 0.114));
    if (lift > uMaxLift) o = c + (o - c) * (uMaxLift / lift);
    gl_FragColor = float4(clamp(o, 0.0, 1.0), 1.0);
}

};
fragment float4 xm_FS_BLEMISH_APPLY(Xm_FS_BLEMISH_APPLY_Input input [[stage_in]], constant Xm_FS_BLEMISH_APPLY_Uniforms& u [[buffer(0)]], texture2d<float> uTex [[texture(0)]], texture2d<float> uHalf [[texture(1)]], texture2d<float> uClean [[texture(2)]], texture2d<float> uScore [[texture(3)]], texture2d<float> uSpotA [[texture(4)]], texture2d<float> uWide [[texture(5)]], texture2d<float> uSpotB [[texture(6)]], texture2d<float> uRed [[texture(7)]], texture2d<float> uSkin [[texture(8)]], texture2d<float> uProtect [[texture(9)]], sampler xm_sampler [[sampler(0)]]) {
    Xm_FS_BLEMISH_APPLY s;
    s.uProtectK=u.uProtectK;
    s.uAmt=u.uAmt;
    s.uRedFade=u.uRedFade;
    s.uMaxLift=u.uMaxLift;
    s.vUv=input.vUv;
    s.uTex=uTex;
    s.uHalf=uHalf;
    s.uClean=uClean;
    s.uScore=uScore;
    s.uSpotA=uSpotA;
    s.uWide=uWide;
    s.uSpotB=uSpotB;
    s.uRed=uRed;
    s.uSkin=uSkin;
    s.uProtect=uProtect;
    s.xm_sampler=xm_sampler;
    s.eval();
    return s.gl_FragColor;
}
