
varying vec2 vUv;
uniform sampler2D uTex;
uniform vec2 uDir;
void main() {
    vec3 s = texture2D(uTex, vUv).rgb * 0.1532;
    s += (texture2D(uTex, vUv + uDir).rgb + texture2D(uTex, vUv - uDir).rgb) * 0.1449;
    s += (texture2D(uTex, vUv + 2.0 * uDir).rgb + texture2D(uTex, vUv - 2.0 * uDir).rgb) * 0.1226;
    s += (texture2D(uTex, vUv + 3.0 * uDir).rgb + texture2D(uTex, vUv - 3.0 * uDir).rgb) * 0.0929;
    s += (texture2D(uTex, vUv + 4.0 * uDir).rgb + texture2D(uTex, vUv - 4.0 * uDir).rgb) * 0.0630;
    gl_FragColor = vec4(s, 1.0);
}
