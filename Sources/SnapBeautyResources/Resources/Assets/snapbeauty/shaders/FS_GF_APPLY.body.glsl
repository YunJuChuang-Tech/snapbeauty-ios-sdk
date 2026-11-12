
varying vec2 vUv;
uniform sampler2D uBase;
uniform sampler2D uSrc;
uniform sampler2D uMean;
uniform sampler2D uVar;
uniform sampler2D uMask;
uniform float uK;
void main() {
    vec3 o = texture2D(uBase, vUv).rgb;
    vec3 n = texture2D(uSrc, vUv).rgb;
    vec3 m = texture2D(uMean, vUv).rgb;
    float v = texture2D(uVar, vUv).r / 12.0;
    float a = v / (v + 0.005);
    vec3 g = m + a * (n - m);
    float k = clamp(texture2D(uMask, vUv).b * uK, 0.0, 1.0);
    gl_FragColor = vec4(mix(o, g, k), 1.0);
}
