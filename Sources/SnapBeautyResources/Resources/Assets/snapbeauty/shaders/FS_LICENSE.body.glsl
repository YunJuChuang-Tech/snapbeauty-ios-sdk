
varying vec2 vUv;
uniform sampler2D uTex;
uniform float uPhase;
float rect(vec2 p, vec2 lo, vec2 hi) {
    vec2 a = step(lo, p) * step(p, hi);
    return a.x * a.y;
}
void main() {
    vec4 color = texture2D(uTex, vUv);
    vec2 p = fract(vUv * vec2(4.0, 3.0) + vec2(uPhase, 0.0));

    float bars = rect(p, vec2(0.12, 0.25), vec2(0.38, 0.32))
               + rect(p, vec2(0.12, 0.47), vec2(0.38, 0.54))
               + rect(p, vec2(0.12, 0.69), vec2(0.38, 0.76))
               + rect(p, vec2(0.12, 0.47), vec2(0.19, 0.76))
               + rect(p, vec2(0.31, 0.25), vec2(0.38, 0.54))
               + rect(p, vec2(0.52, 0.25), vec2(0.59, 0.76))
               + rect(p, vec2(0.52, 0.25), vec2(0.80, 0.32))
               + rect(p, vec2(0.52, 0.47), vec2(0.80, 0.54))
               + rect(p, vec2(0.52, 0.69), vec2(0.80, 0.76))
               + rect(p, vec2(0.73, 0.25), vec2(0.80, 0.76));
    float band = step(0.82, fract((vUv.x + vUv.y) * 10.0 + uPhase));
    color.rgb = mix(color.rgb, vec3(0.90, 0.20, 0.65), 0.26 * band);
    color.rgb = mix(color.rgb, vec3(1.0), 0.78 * min(bars, 1.0));
    gl_FragColor = color;
}
