
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
