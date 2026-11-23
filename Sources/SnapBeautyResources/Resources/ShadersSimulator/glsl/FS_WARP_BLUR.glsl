
#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

const float WARP_RANGE = 0.25;
vec4 encodeOff(vec2 d) {
    vec2 v = clamp(d / (2.0 * WARP_RANGE) + 0.5, 0.0, 1.0) * 255.0;
    vec2 hi = floor(v);
    vec2 lo = v - hi;
    return vec4(hi.x / 255.0, lo.x, hi.y / 255.0, lo.y);
}
vec2 decodeOff(vec4 c) {
    vec2 v = (vec2(c.r, c.b) * 255.0 + vec2(c.g, c.a)) / 255.0;
    return (v - 0.5) * 2.0 * WARP_RANGE;
}

varying vec2 vUv;
uniform sampler2D uTex;
uniform vec2 uStep;
void main() {
    vec2 sum = decodeOff(texture2D(uTex, vUv)) * 0.2042;
    sum += (decodeOff(texture2D(uTex, vUv + uStep)) + decodeOff(texture2D(uTex, vUv - uStep))) * 0.1802;
    sum += (decodeOff(texture2D(uTex, vUv + 2.0 * uStep)) + decodeOff(texture2D(uTex, vUv - 2.0 * uStep))) * 0.1238;
    sum += (decodeOff(texture2D(uTex, vUv + 3.0 * uStep)) + decodeOff(texture2D(uTex, vUv - 3.0 * uStep))) * 0.0663;
    sum += (decodeOff(texture2D(uTex, vUv + 4.0 * uStep)) + decodeOff(texture2D(uTex, vUv - 4.0 * uStep))) * 0.0276;
    gl_FragColor = encodeOff(sum);
}
