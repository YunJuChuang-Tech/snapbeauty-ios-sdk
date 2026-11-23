
#include <metal_stdlib>
using namespace metal;
template<typename T> T xm_mod(T x,T y) { return x-y*floor(x/y); }
struct Xm_FS_LUT_Uniforms {
    float uStrength;
    float uStrip;
    float uScale;
};
struct Xm_FS_LUT_Input { float4 position [[position]];
    float2 vUv [[user(locn3)]];
};
struct Xm_FS_LUT {
    float uStrength;
    float uStrip;
    float uScale;
    float2 vUv;
    texture2d<float> uTex;
    texture2d<float> uLut;
    sampler xm_sampler;
    float4 gl_FragColor;









void eval() {
    float4 c = uTex.sample(xm_sampler, vUv);
    float3 q = c.rgb * uScale;
    if (uStrip > 0.5) {

        float2 st = q.rg * (15.0 / 16.0) + 0.5 / 16.0;
        float b16 = q.b * 15.0 + 0.1;
        float s0 = min(floor(b16), 15.0);
        float s1 = min(s0 + 1.0, 15.0);
        float3 n0 = uLut.sample(xm_sampler, float2((s0 + st.x) / 16.0, st.y)).rgb;
        float3 n1 = uLut.sample(xm_sampler, float2((s1 + st.x) / 16.0, st.y)).rgb;
        gl_FragColor = float4(mix(c.rgb, mix(n0, n1, b16-s0), uStrength), 1.0);
        return;
    }
    float b = q.b * 63.0;
    float2 q1; q1.y = floor(floor(b) / 8.0); q1.x = floor(b) - q1.y * 8.0;
    float2 q2; q2.y = floor(ceil(b) / 8.0); q2.x = ceil(b) - q2.y * 8.0;
    float2 t1 = q1 * 0.125 + 0.5 / 512.0 + (0.125 - 1.0 / 512.0) * q.rg;
    float2 t2 = q2 * 0.125 + 0.5 / 512.0 + (0.125 - 1.0 / 512.0) * q.rg;
    float3 n = mix(uLut.sample(xm_sampler, t1).rgb, uLut.sample(xm_sampler, t2).rgb, fract(b));
    gl_FragColor = float4(mix(c.rgb, n, uStrength), 1.0);
}

};
fragment float4 xm_FS_LUT(Xm_FS_LUT_Input input [[stage_in]], constant Xm_FS_LUT_Uniforms& u [[buffer(0)]], texture2d<float> uTex [[texture(0)]], texture2d<float> uLut [[texture(1)]], sampler xm_sampler [[sampler(0)]]) {
    Xm_FS_LUT s;
    s.uStrength=u.uStrength;
    s.uStrip=u.uStrip;
    s.uScale=u.uScale;
    s.vUv=input.vUv;
    s.uTex=uTex;
    s.uLut=uLut;
    s.xm_sampler=xm_sampler;
    s.eval();
    return s.gl_FragColor;
}
