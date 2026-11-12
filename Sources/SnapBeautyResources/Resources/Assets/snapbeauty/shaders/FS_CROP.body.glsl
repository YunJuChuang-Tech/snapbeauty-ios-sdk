
varying vec2 vUv;
uniform sampler2D uTex;
uniform vec2 uFrame;
uniform vec2 uCenter;
uniform vec2 uAxisX;
uniform vec2 uAxisY;
void main() {
    vec2 p = uCenter + uAxisX * (vUv.x - 0.5) + uAxisY * (vUv.y - 0.5);
    vec2 uv = p / uFrame;
    if (uv.x < 0.0 || uv.y < 0.0 || uv.x > 1.0 || uv.y > 1.0) gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
    else gl_FragColor = texture2D(uTex, uv);
}
