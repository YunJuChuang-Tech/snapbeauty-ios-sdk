
#include <metal_stdlib>
using namespace metal;
template<typename T> T xm_mod(T x,T y) { return x-y*floor(x/y); }
struct Xm_FS_FOREHEAD_Uniforms {
    float2 uStep;
    float2 uRef;
    float4 uK;
    float2 uPx;
    float uDetail;
};
struct Xm_FS_FOREHEAD_Input { float4 position [[position]];
    float2 vUv [[user(locn3)]];
};
struct Xm_FS_FOREHEAD {
    float2 uStep;
    float2 uRef;
    float4 uK;
    float2 uPx;
    float uDetail;
    float2 vUv;
    texture2d<float> uTex;
    texture2d<float> uMask;
    sampler xm_sampler;
    float4 gl_FragColor;










const float3 L = float3(0.299, 0.587, 0.114);


float hairGate(float y, float ry) { return smoothstep(uK.z - 0.05, uK.z + 0.05, y / ry); }
void eval() {
    float3 c = uTex.sample(xm_sampler, vUv).rgb;
    float m = uMask.sample(xm_sampler, vUv).r;
    if (m <= 0.0 || uK.x <= 0.0) { gl_FragColor = float4(c, 1.0); return; }
    float3 ref = (uTex.sample(xm_sampler, uRef).rgb + uTex.sample(xm_sampler, uRef + uStep * 3.0).rgb + uTex.sample(xm_sampler, uRef - uStep * 3.0).rgb) / 3.0;
    float ry = max(dot(ref, L), 1e-3);
    float y = dot(c, L);
    float3 s = c;
    float ws = 1.0;
    for (int i = 1; i <= 16; i++) {
        float f = float(i);
        float g = exp(-f * f * uK.w);
        float3 a = uTex.sample(xm_sampler, vUv + uStep * f).rgb;
        float3 b = uTex.sample(xm_sampler, vUv - uStep * f).rgb;
        float ya = dot(a, L), yb = dot(b, L);
        float wa = g * max(1.0 - (ya - y) * (ya - y) / (uK.y * uK.y), 0.0) * hairGate(ya, ry);
        float wb = g * max(1.0 - (yb - y) * (yb - y) / (uK.y * uK.y), 0.0) * hairGate(yb, ry);
        s += a * wa + b * wb;
        ws += wa + wb;
    }

    float3 n = (uTex.sample(xm_sampler, vUv + float2(uPx.x, 0.0)).rgb + uTex.sample(xm_sampler, vUv - float2(uPx.x, 0.0)).rgb
            + uTex.sample(xm_sampler, vUv + float2(0.0, uPx.y)).rgb + uTex.sample(xm_sampler, vUv - float2(0.0, uPx.y)).rgb) * 0.25;
    float3 o = s / ws + (c - n) * uDetail;
    gl_FragColor = float4(clamp(mix(c, o, uK.x * m * hairGate(y, ry)), 0.0, 1.0), 1.0);
}

};
fragment float4 xm_FS_FOREHEAD(Xm_FS_FOREHEAD_Input input [[stage_in]], constant Xm_FS_FOREHEAD_Uniforms& u [[buffer(0)]], texture2d<float> uTex [[texture(0)]], texture2d<float> uMask [[texture(1)]], sampler xm_sampler [[sampler(0)]]) {
    Xm_FS_FOREHEAD s;
    s.uStep=u.uStep;
    s.uRef=u.uRef;
    s.uK=u.uK;
    s.uPx=u.uPx;
    s.uDetail=u.uDetail;
    s.vUv=input.vUv;
    s.uTex=uTex;
    s.uMask=uMask;
    s.xm_sampler=xm_sampler;
    s.eval();
    return s.gl_FragColor;
}
