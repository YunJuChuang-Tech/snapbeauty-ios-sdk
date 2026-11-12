
varying vec2 vUv;
uniform sampler2D uTex;
uniform sampler2D uLut;
uniform float uStrength;
uniform float uStrip;
uniform float uScale;
void main() {
    vec4 c = texture2D(uTex, vUv);
    vec3 q = c.rgb * uScale;
    if (uStrip > 0.5) {

        vec2 st = q.rg * (15.0 / 16.0) + 0.5 / 16.0;
        float b16 = q.b * 15.0 + 0.1;
        float s0 = min(floor(b16), 15.0);
        float s1 = min(s0 + 1.0, 15.0);
        vec3 n0 = texture2D(uLut, vec2((s0 + st.x) / 16.0, st.y)).rgb;
        vec3 n1 = texture2D(uLut, vec2((s1 + st.x) / 16.0, st.y)).rgb;
        gl_FragColor = vec4(mix(c.rgb, mix(n0, n1, b16-s0), uStrength), 1.0);
        return;
    }
    float b = q.b * 63.0;
    vec2 q1; q1.y = floor(floor(b) / 8.0); q1.x = floor(b) - q1.y * 8.0;
    vec2 q2; q2.y = floor(ceil(b) / 8.0); q2.x = ceil(b) - q2.y * 8.0;
    vec2 t1 = q1 * 0.125 + 0.5 / 512.0 + (0.125 - 1.0 / 512.0) * q.rg;
    vec2 t2 = q2 * 0.125 + 0.5 / 512.0 + (0.125 - 1.0 / 512.0) * q.rg;
    vec3 n = mix(texture2D(uLut, t1).rgb, texture2D(uLut, t2).rgb, fract(b));
    gl_FragColor = vec4(mix(c.rgb, n, uStrength), 1.0);
}
