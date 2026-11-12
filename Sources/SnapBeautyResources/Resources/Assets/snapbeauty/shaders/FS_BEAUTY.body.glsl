
varying vec2 vUv;
uniform sampler2D uTex;
uniform sampler2D uMask;
uniform vec2 uPx;
uniform vec2 uMix;
uniform float uUseMask;
uniform float uNoFace;
vec4 tap(vec2 off, float g, float yf) {
    vec3 t = texture2D(uTex, vUv + off).rgb;
    float d = t.g - g;
    float w = 1.0 - min(d * d * yf, 1.0);
    return vec4(t * w, w);
}
void main() {
    vec3 c = texture2D(uTex, vUv).rgb;
    if (uMix.x <= 0.0) { gl_FragColor = vec4(c, 1.0); return; }
    float g = c.g;
    vec4 s1 = vec4(c, 1.0);
    vec4 s2 = vec4(c, 1.0);
    for (int i = 0; i < 8; i++) {
        float a = float(i) * 0.785398;
        vec2 d = vec2(cos(a), sin(a)) * uPx * 6.0;
        s1 += tap(d, g, 100.0);
        s2 += tap(d, g, 35.0) + tap(d * 2.0, g, 35.0) + tap(d * 3.0, g, 35.0);
    }
    vec3 b1 = s1.rgb / s1.a;
    vec3 b2 = s2.rgb / s2.a;
    float m = uUseMask > 0.5 ? texture2D(uMask, vUv).r : 1.0;
    vec3 even = clamp(c - b1 + b2, 0.0, 1.0);
    even = mix(c, even, m);
    even = mix(even, b2, m * uMix.y);
    vec3 outc = mix(c, even, uMix.x);


    if (uUseMask < 0.5 && uNoFace > 0.0) outc = mix(c, outc, uNoFace * smoothstep(0.35, 0.55, dot(c, vec3(0.299, 0.587, 0.114))));
    gl_FragColor = vec4(outc, 1.0);
}
