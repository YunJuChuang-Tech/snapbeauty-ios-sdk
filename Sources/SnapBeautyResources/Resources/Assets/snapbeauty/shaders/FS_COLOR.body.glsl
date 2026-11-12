
varying vec2 vUv;
uniform sampler2D uTex;
uniform sampler2D uOrig;
uniform sampler2D uRedLut;
uniform sampler2D uWhiteLut;
uniform sampler2D uClarityLut;
uniform vec2 uPx;
uniform vec4 uAmount;
vec3 lut32(sampler2D t, vec3 c) {
    vec3 g = clamp(c, 0.0, 1.0) * 31.0;
    float b0 = min(floor(g.b), 30.0);
    float b1 = b0 + 1.0;
    vec2 rg = (g.rg + 0.5) / 32.0;
    vec2 t0 = (vec2(b0 - floor(b0 / 8.0) * 8.0, floor(b0 / 8.0)) + rg) * vec2(0.125, 0.25);
    vec2 t1 = (vec2(b1 - floor(b1 / 8.0) * 8.0, floor(b1 / 8.0)) + rg) * vec2(0.125, 0.25);
    return mix(texture2D(t, t0).rgb, texture2D(t, t1).rgb, g.b - b0);
}
void main() {
    vec3 c = texture2D(uTex, vUv).rgb;
    if (uAmount.x > 0.0) {
        vec2 h = uPx * 0.5;
        float sum = texture2D(uOrig, vUv + h).g + texture2D(uOrig, vUv - h).g
                  + texture2D(uOrig, vUv + vec2(-h.x, h.y)).g + texture2D(uOrig, vUv + vec2(h.x, -h.y)).g;
        float hp = texture2D(uOrig, vUv).g - sum * 0.25 + 0.5;
        vec3 hv = 2.0 * hp + c - 1.0;
        vec3 s = hp >= 0.5 ? min(vec3(1.0), hv) : max(vec3(0.0), hv);
        c = mix(c, s, uAmount.x);
    }
    if (uAmount.y > 0.0) c = mix(c, lut32(uRedLut, c), uAmount.y);
    if (uAmount.z > 0.0) c = mix(c, lut32(uWhiteLut, c), uAmount.z);
    if (uAmount.w > 0.0) c = mix(c, lut32(uClarityLut, c), uAmount.w);
    gl_FragColor = vec4(clamp(c, 0.0, 1.0), 1.0);
}
