
varying float vA;
varying vec2 vMaskUv;
uniform sampler2D uLipMask;
void main() {
    float mask = clamp(vA, 0.0, 1.0) * texture2D(uLipMask, vMaskUv).r;
    gl_FragColor = vec4(vec3(mask), 1.0);
}
