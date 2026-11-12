
varying vec2 vUv;
uniform sampler2D uTex;
uniform float uAlpha;
uniform float uMode;
void main() {
    vec4 c = texture2D(uTex, vUv) * uAlpha;
    if (c.a > 1.0) c /= c.a;
    vec3 sh = c.rgb - vec3(dot(c.rgb, vec3(0.299, 0.587, 0.114)));
    if (uMode < 0.5) gl_FragColor = c;
    else if (uMode < 1.5) gl_FragColor = vec4(vec3(1.0 - c.a) + c.rgb, 1.0);
    else gl_FragColor = vec4(vec3(0.5 * c.a) + 0.5 * sh, c.a);
}
