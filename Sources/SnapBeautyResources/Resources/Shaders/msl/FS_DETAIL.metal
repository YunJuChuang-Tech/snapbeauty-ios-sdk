
#include <metal_stdlib>
using namespace metal;
template<typename T> T xm_mod(T x,T y) { return x-y*floor(x/y); }
struct Xm_FS_DETAIL_Uniforms {
    float4 uFrameStep;
    float uMeanR;
    float4 uAmtA;
    float4 uAmtB;
    float4 uIrisA;
    float4 uIrisB;
    float4 uTeeth;
    float4 uPouchA;
    float4 uPouchB;
    float4 uFoldA;
    float4 uFoldB;
    float4 uNose;
    float4 uShadeA;
    float4 uShadeB;
    float4 uRadii;
    float4 uToothBox;
    float uToothFit;
};
struct Xm_FS_DETAIL_Input { float4 position [[position]];
    float2 vUv [[user(locn3)]];
};
struct Xm_FS_DETAIL {
    float4 uFrameStep;
    float uMeanR;
    float4 uAmtA;
    float4 uAmtB;
    float4 uIrisA;
    float4 uIrisB;
    float4 uTeeth;
    float4 uPouchA;
    float4 uPouchB;
    float4 uFoldA;
    float4 uFoldB;
    float4 uNose;
    float4 uShadeA;
    float4 uShadeB;
    float4 uRadii;
    float4 uToothBox;
    float uToothFit;
    float2 vUv;
    texture2d<float> uTex;
    texture2d<float> uToothMask;
    texture2d<float> uToothLut;
    sampler xm_sampler;
    float4 gl_FragColor;
























const float3 K = float3(0.299, 0.587, 0.114);
float ell(float4 e, float2 p) {
    if (e.z <= 0.0 || e.w <= 0.0) return 0.0;
    return 1.0 - smoothstep(0.5, 1.0, length((p - e.xy) / e.zw));
}
float seg(float4 s, float r, float2 p) {
    if (r <= 0.0) return 0.0;
    float2 ab = s.zw - s.xy;
    float t = clamp(dot(p - s.xy, ab) / max(dot(ab, ab), 1e-3), 0.0, 1.0);
    return 1.0 - smoothstep(0.35 * r, r, distance(p, s.xy + ab * t));
}
float3 toothLut(float3 c) {

    float3 g = clamp(c, 0.0, 1.0) * 8.0;
    float b0 = min(floor(g.b), 7.0);
    float2 rg = (g.rg + 0.5) / float2(81.0, 9.0);
    float3 c0 = uToothLut.sample(xm_sampler, rg + float2(b0 * 9.0 / 81.0, 0.0)).rgb;
    float3 c1 = uToothLut.sample(xm_sampler, rg + float2((b0 + 1.0) * 9.0 / 81.0, 0.0)).rgb;
    return mix(c0, c1, g.b - b0);
}
float skin(float3 c) {
    float y = dot(c, K);
    float cb = (c.b - y) * 0.564 + 0.5;
    float cr = (c.r - y) * 0.713 + 0.5;
    return 1.0 - smoothstep(0.6, 1.2, length(float2((cr - 0.58) / 0.08, (cb - 0.42) / 0.09)));
}
void eval() {
    float3 c = uTex.sample(xm_sampler, vUv).rgb;
    float3 o = c;
    float2 px = vUv * uFrameStep.xy;
    float2 st = uFrameStep.zw;
    if (uAmtA.x > 0.0) {

        float3 n = uTex.sample(xm_sampler, vUv + float2(st.x, 0.0)).rgb + uTex.sample(xm_sampler, vUv - float2(st.x, 0.0)).rgb
               + uTex.sample(xm_sampler, vUv + float2(0.0, st.y)).rgb + uTex.sample(xm_sampler, vUv - float2(0.0, st.y)).rgb;
        o += float3(dot(c - n * 0.25, K) * uAmtA.x * 1.6);
    }
    float spot = uAmtA.z > 0.0 ? skin(c) * uAmtA.z : 0.0;
    float eye = uAmtA.w > 0.0 ? max(ell(uIrisA, px), ell(uIrisB, px)) * uAmtA.w : 0.0;
    float pouch = uAmtB.y > 0.0 ? max(ell(uPouchA, px), ell(uPouchB, px)) * uAmtB.y : 0.0;
    float fold = uAmtB.z > 0.0 ? max(seg(uFoldA, uRadii.x, px), seg(uFoldB, uRadii.x, px)) * uAmtB.z : 0.0;
    if (uAmtA.y > 0.0 || spot > 0.0 || eye > 0.0 || pouch > 0.0 || fold > 0.0) {
        float3 m = float3(0.0);
        float rMin = 1.0;
        float rMax = 0.0;
        for (int i = 0; i < 8; i++) {
            float a = float(i) * 0.785398;
            float3 r = uTex.sample(xm_sampler, vUv + float2(cos(a), sin(a)) * st * uMeanR).rgb;
            m += r;
            float ry = dot(r, K);
            rMin = min(rMin, ry);
            rMax = max(rMax, ry);
        }
        m *= 0.125;
        float y = dot(o, K);
        float my = dot(m, K);

        if (uAmtA.y > 0.0) o += float3((y - my) * uAmtA.y * 0.9 * 4.0 * y * (1.0 - y));


        if (spot > 0.0) o = mix(o, m, spot * smoothstep(0.01, 0.05, my - y) * (1.0 - smoothstep(0.02, 0.05, rMax - rMin)));

        float lift = max(pouch, fold);
        if (lift > 0.0) {
            o += float3(max(my + 0.01 - y, 0.0) * lift);
            o = mix(o, m, lift * 0.25);
        }

        if (eye > 0.0) o += ((o - m) * 0.6 + float3(0.035)) * eye;
    }
    if (uAmtB.x > 0.0 && uToothFit > 0.5) {

        float2 q = (px - uToothBox.xy) / uToothBox.zw;
        float m = q.x >= 0.0 && q.y >= 0.0 && q.x <= 1.0 && q.y <= 1.0 ? uToothMask.sample(xm_sampler, q).r : 0.0;
        o = mix(o, toothLut(o), m * uAmtB.x);
    } else if (uAmtB.x > 0.0) {

        float y = dot(o, K);
        float cr = (o.r - y) * 0.713;
        float t = ell(uTeeth, px) * uAmtB.x * smoothstep(0.25, 0.45, y) * (1.0 - smoothstep(0.04, 0.1, cr));
        o = mix(o, mix(o, float3(y), 0.6) + float3(0.06), t);
    }
    if (uAmtB.w > 0.0) {

        float hi = seg(uNose, uRadii.y, px);
        float sh = max(seg(uShadeA, uRadii.z, px), seg(uShadeB, uRadii.z, px));
        o = o * (1.0 - 0.1 * sh * uAmtB.w) + float3(0.05 * hi * uAmtB.w);
    }
    gl_FragColor = float4(clamp(o, 0.0, 1.0), 1.0);
}

};
fragment float4 xm_FS_DETAIL(Xm_FS_DETAIL_Input input [[stage_in]], constant Xm_FS_DETAIL_Uniforms& u [[buffer(0)]], texture2d<float> uTex [[texture(0)]], texture2d<float> uToothMask [[texture(1)]], texture2d<float> uToothLut [[texture(2)]], sampler xm_sampler [[sampler(0)]]) {
    Xm_FS_DETAIL s;
    s.uFrameStep=u.uFrameStep;
    s.uMeanR=u.uMeanR;
    s.uAmtA=u.uAmtA;
    s.uAmtB=u.uAmtB;
    s.uIrisA=u.uIrisA;
    s.uIrisB=u.uIrisB;
    s.uTeeth=u.uTeeth;
    s.uPouchA=u.uPouchA;
    s.uPouchB=u.uPouchB;
    s.uFoldA=u.uFoldA;
    s.uFoldB=u.uFoldB;
    s.uNose=u.uNose;
    s.uShadeA=u.uShadeA;
    s.uShadeB=u.uShadeB;
    s.uRadii=u.uRadii;
    s.uToothBox=u.uToothBox;
    s.uToothFit=u.uToothFit;
    s.vUv=input.vUv;
    s.uTex=uTex;
    s.uToothMask=uToothMask;
    s.uToothLut=uToothLut;
    s.xm_sampler=xm_sampler;
    s.eval();
    return s.gl_FragColor;
}
