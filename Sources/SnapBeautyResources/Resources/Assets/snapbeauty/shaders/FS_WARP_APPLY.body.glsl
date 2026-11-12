
varying vec2 vUv;
uniform sampler2D uTex;
uniform sampler2D uField;
uniform sampler2D uField2;
vec2 field(vec2 uv) { return decodeOff(texture2D(uField, uv)) + decodeOff(texture2D(uField2, uv)); }
void main() {

    vec2 d = field(vUv);
    d = field(vUv - d);
    d = field(vUv - d);
    d = field(vUv - d);
    gl_FragColor = texture2D(uTex, vUv - d);
}
