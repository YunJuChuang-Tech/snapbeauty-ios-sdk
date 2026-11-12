
varying vec2 vUv;
uniform sampler2D uTex;
uniform sampler2D uShift;
void main() {
    vec3 c = texture2D(uTex, vUv).rgb + (texture2D(uShift, vUv).rgb - 0.5) * 2.0;
    gl_FragColor = vec4(clamp(c, 0.0, 1.0), 1.0);
}
