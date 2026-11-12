
varying vec2 vUv;
uniform sampler2D uSmall;
uniform sampler2D uMean;
void main() {
    float d = texture2D(uSmall, vUv).g - texture2D(uMean, vUv).g;
    gl_FragColor = vec4(vec3(clamp(d * d * 12.0, 0.0, 1.0)), 1.0);
}
