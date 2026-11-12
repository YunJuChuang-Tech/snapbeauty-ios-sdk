
varying vec2 vUv;
uniform sampler2D uTex;
uniform vec4 uFrameStep;
uniform float uMeanR;
uniform vec4 uAmtA;
uniform vec4 uAmtB;
uniform vec4 uIrisA;
uniform vec4 uIrisB;
uniform vec4 uTeeth;
uniform vec4 uPouchA;
uniform vec4 uPouchB;
uniform vec4 uFoldA;
uniform vec4 uFoldB;
uniform vec4 uNose;
uniform vec4 uShadeA;
uniform vec4 uShadeB;
uniform vec4 uRadii;
uniform sampler2D uToothMask;
uniform sampler2D uToothLut;
uniform vec4 uToothBox;
uniform float uToothFit;
const vec3 K = vec3(0.299, 0.587, 0.114);
float ell(vec4 e, vec2 p) {
    if (e.z <= 0.0 || e.w <= 0.0) return 0.0;
    return 1.0 - smoothstep(0.5, 1.0, length((p - e.xy) / e.zw));
}
float seg(vec4 s, float r, vec2 p) {
    if (r <= 0.0) return 0.0;
    vec2 ab = s.zw - s.xy;
    float t = clamp(dot(p - s.xy, ab) / max(dot(ab, ab), 1e-3), 0.0, 1.0);
    return 1.0 - smoothstep(0.35 * r, r, distance(p, s.xy + ab * t));
}
vec3 toothLut(vec3 c) {

    vec3 g = clamp(c, 0.0, 1.0) * 8.0;
    float b0 = min(floor(g.b), 7.0);
    vec2 rg = (g.rg + 0.5) / vec2(81.0, 9.0);
    vec3 c0 = texture2D(uToothLut, rg + vec2(b0 * 9.0 / 81.0, 0.0)).rgb;
    vec3 c1 = texture2D(uToothLut, rg + vec2((b0 + 1.0) * 9.0 / 81.0, 0.0)).rgb;
    return mix(c0, c1, g.b - b0);
}
float skin(vec3 c) {
    float y = dot(c, K);
    float cb = (c.b - y) * 0.564 + 0.5;
    float cr = (c.r - y) * 0.713 + 0.5;
    return 1.0 - smoothstep(0.6, 1.2, length(vec2((cr - 0.58) / 0.08, (cb - 0.42) / 0.09)));
}
void main() {
    vec3 c = texture2D(uTex, vUv).rgb;
    vec3 o = c;
    vec2 px = vUv * uFrameStep.xy;
    vec2 st = uFrameStep.zw;
    if (uAmtA.x > 0.0) {

        vec3 n = texture2D(uTex, vUv + vec2(st.x, 0.0)).rgb + texture2D(uTex, vUv - vec2(st.x, 0.0)).rgb
               + texture2D(uTex, vUv + vec2(0.0, st.y)).rgb + texture2D(uTex, vUv - vec2(0.0, st.y)).rgb;
        o += vec3(dot(c - n * 0.25, K) * uAmtA.x * 1.6);
    }
    float spot = uAmtA.z > 0.0 ? skin(c) * uAmtA.z : 0.0;
    float eye = uAmtA.w > 0.0 ? max(ell(uIrisA, px), ell(uIrisB, px)) * uAmtA.w : 0.0;
    float pouch = uAmtB.y > 0.0 ? max(ell(uPouchA, px), ell(uPouchB, px)) * uAmtB.y : 0.0;
    float fold = uAmtB.z > 0.0 ? max(seg(uFoldA, uRadii.x, px), seg(uFoldB, uRadii.x, px)) * uAmtB.z : 0.0;
    if (uAmtA.y > 0.0 || spot > 0.0 || eye > 0.0 || pouch > 0.0 || fold > 0.0) {
        vec3 m = vec3(0.0);
        float rMin = 1.0;
        float rMax = 0.0;
        for (int i = 0; i < 8; i++) {
            float a = float(i) * 0.785398;
            vec3 r = texture2D(uTex, vUv + vec2(cos(a), sin(a)) * st * uMeanR).rgb;
            m += r;
            float ry = dot(r, K);
            rMin = min(rMin, ry);
            rMax = max(rMax, ry);
        }
        m *= 0.125;
        float y = dot(o, K);
        float my = dot(m, K);

        if (uAmtA.y > 0.0) o += vec3((y - my) * uAmtA.y * 0.9 * 4.0 * y * (1.0 - y));


        if (spot > 0.0) o = mix(o, m, spot * smoothstep(0.01, 0.05, my - y) * (1.0 - smoothstep(0.02, 0.05, rMax - rMin)));

        float lift = max(pouch, fold);
        if (lift > 0.0) {
            o += vec3(max(my + 0.01 - y, 0.0) * lift);
            o = mix(o, m, lift * 0.25);
        }

        if (eye > 0.0) o += ((o - m) * 0.6 + vec3(0.035)) * eye;
    }
    if (uAmtB.x > 0.0 && uToothFit > 0.5) {

        vec2 q = (px - uToothBox.xy) / uToothBox.zw;
        float m = q.x >= 0.0 && q.y >= 0.0 && q.x <= 1.0 && q.y <= 1.0 ? texture2D(uToothMask, q).r : 0.0;
        o = mix(o, toothLut(o), m * uAmtB.x);
    } else if (uAmtB.x > 0.0) {

        float y = dot(o, K);
        float cr = (o.r - y) * 0.713;
        float t = ell(uTeeth, px) * uAmtB.x * smoothstep(0.25, 0.45, y) * (1.0 - smoothstep(0.04, 0.1, cr));
        o = mix(o, mix(o, vec3(y), 0.6) + vec3(0.06), t);
    }
    if (uAmtB.w > 0.0) {

        float hi = seg(uNose, uRadii.y, px);
        float sh = max(seg(uShadeA, uRadii.z, px), seg(uShadeB, uRadii.z, px));
        o = o * (1.0 - 0.1 * sh * uAmtB.w) + vec3(0.05 * hi * uAmtB.w);
    }
    gl_FragColor = vec4(clamp(o, 0.0, 1.0), 1.0);
}
