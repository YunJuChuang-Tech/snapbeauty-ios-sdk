
varying vec2 vUv;
uniform sampler2D uTex;
uniform sampler2D uMask1;
uniform sampler2D uMask2;
uniform sampler2D uSmall;
uniform sampler2D uSmallBlur;
uniform sampler2D uThreeCurve;
uniform vec4 uAmt;
uniform vec2 uEyeStep;
float softLight(float base, float blend) {
    float c1 = 2.0 * base * blend + base * base * (1.0 - 2.0 * blend);
    float c2 = sqrt(base) * (2.0 * blend - 1.0) + 2.0 * base * (1.0 - blend);
    return mix(c1, c2, step(0.5, blend));
}
void main() {
    vec3 c = texture2D(uTex, vUv).rgb;
    vec4 m1 = texture2D(uMask1, vUv);
    vec4 m2 = texture2D(uMask2, vUv);
    float pouch = uAmt.y * m1.b;
    float fold = uAmt.z * m2.r;
    if (pouch > 0.0 || fold > 0.0) {
        vec3 sc = texture2D(uSmall, vUv).rgb;
        vec3 bl = texture2D(uSmallBlur, vUv).rgb;
        vec3 diff = (bl - sc) * 1.4 + 0.05 * bl;
        if (pouch > 0.0) c = mix(c, min(c + clamp(diff, 0.0, 0.15), 1.0), pouch * 0.8);
        if (fold > 0.0) c = mix(c, min(c + clamp(diff, 0.0, 0.3), 1.0), fold * 0.7);
    }
    float three = uAmt.x * m1.g;
    if (three > 0.0) {
        float gray = dot(c, vec3(0.3, 0.59, 0.11));
        float rate = clamp(texture2D(uThreeCurve, vec2(gray, 0.5)).r, 0.4, 1.0);
        float t = m1.g;
        vec3 res = vec3(softLight(c.r, t), softLight(c.g, t), softLight(c.b, t));
        c = mix(c, res, uAmt.x * rate * t);
    }
    float eye = clamp(uAmt.w * m2.g * 6.0, 0.0, 1.0);
    if (eye > 0.003) {
        vec3 original = texture2D(uTex, vUv).rgb;
        vec2 dx = vec2(uEyeStep.x, 0.0);
        vec2 dy = vec2(0.0, uEyeStep.y);
        vec3 neighbourhood = 4.0 * original
            + 2.0 * (texture2D(uTex, vUv - dx).rgb + texture2D(uTex, vUv + dx).rgb
                   + texture2D(uTex, vUv - dy).rgb + texture2D(uTex, vUv + dy).rgb)
            + texture2D(uTex, vUv - dx - dy).rgb + texture2D(uTex, vUv - dx + dy).rgb
            + texture2D(uTex, vUv + dx - dy).rgb + texture2D(uTex, vUv + dx + dy).rgb;
        neighbourhood *= 0.0625;
        float luminance = dot(c, vec3(0.2126, 0.7152, 0.0722));
        float darkGate = smoothstep(0.12, 0.38, luminance);
        float lift = (0.07 + 0.056 * sqrt(luminance)) * darkGate;
        c = clamp(c + eye * (lift * (vec3(1.0) - c) + 2.0 * (original - neighbourhood)), 0.0, 1.0);
    }
    gl_FragColor = vec4(c, 1.0);
}
