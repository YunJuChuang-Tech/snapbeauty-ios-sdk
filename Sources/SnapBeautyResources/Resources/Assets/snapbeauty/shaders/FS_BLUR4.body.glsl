varying vec2 vUv;
uniform sampler2D uTex;
uniform vec2 uStep;

void main() {
    vec4 s = texture2D(uTex, vUv) * 0.2042;
    s += (texture2D(uTex, vUv + uStep) + texture2D(uTex, vUv - uStep)) * 0.1802;
    s += (texture2D(uTex, vUv + 2.0 * uStep) + texture2D(uTex, vUv - 2.0 * uStep)) * 0.1238;
    s += (texture2D(uTex, vUv + 3.0 * uStep) + texture2D(uTex, vUv - 3.0 * uStep)) * 0.0663;
    s += (texture2D(uTex, vUv + 4.0 * uStep) + texture2D(uTex, vUv - 4.0 * uStep)) * 0.0276;
    gl_FragColor = s;
}
