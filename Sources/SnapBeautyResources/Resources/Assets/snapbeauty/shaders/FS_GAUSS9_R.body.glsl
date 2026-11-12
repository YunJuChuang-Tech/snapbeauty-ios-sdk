
varying vec2 vUv;
uniform sampler2D uTex;
uniform vec2 uStep;
void main() {
    float s = texture2D(uTex, vUv).r * 0.2042;
    s += (texture2D(uTex, vUv + uStep).r + texture2D(uTex, vUv - uStep).r) * 0.1802;
    s += (texture2D(uTex, vUv + 2.0 * uStep).r + texture2D(uTex, vUv - 2.0 * uStep).r) * 0.1238;
    s += (texture2D(uTex, vUv + 3.0 * uStep).r + texture2D(uTex, vUv - 3.0 * uStep).r) * 0.0663;
    s += (texture2D(uTex, vUv + 4.0 * uStep).r + texture2D(uTex, vUv - 4.0 * uStep).r) * 0.0276;
    gl_FragColor = vec4(vec3(s), 1.0);
}
