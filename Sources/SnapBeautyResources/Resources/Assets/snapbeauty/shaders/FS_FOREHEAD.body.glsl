varying vec2 vUv;
uniform sampler2D uTex;
uniform sampler2D uMask;
uniform vec2 uStep;
uniform vec2 uRef;
uniform vec4 uK;
uniform vec2 uPx;
uniform float uDetail;
const vec3 L = vec3(0.299, 0.587, 0.114);


float hairGate(float y, float ry) { return smoothstep(uK.z - 0.05, uK.z + 0.05, y / ry); }
void main() {
    vec3 c = texture2D(uTex, vUv).rgb;
    float m = texture2D(uMask, vUv).r;
    if (m <= 0.0 || uK.x <= 0.0) { gl_FragColor = vec4(c, 1.0); return; }
    vec3 ref = (texture2D(uTex, uRef).rgb + texture2D(uTex, uRef + uStep * 3.0).rgb + texture2D(uTex, uRef - uStep * 3.0).rgb) / 3.0;
    float ry = max(dot(ref, L), 1e-3);
    float y = dot(c, L);
    vec3 s = c;
    float ws = 1.0;
    for (int i = 1; i <= 16; i++) {
        float f = float(i);
        float g = exp(-f * f * uK.w);
        vec3 a = texture2D(uTex, vUv + uStep * f).rgb;
        vec3 b = texture2D(uTex, vUv - uStep * f).rgb;
        float ya = dot(a, L), yb = dot(b, L);
        float wa = g * max(1.0 - (ya - y) * (ya - y) / (uK.y * uK.y), 0.0) * hairGate(ya, ry);
        float wb = g * max(1.0 - (yb - y) * (yb - y) / (uK.y * uK.y), 0.0) * hairGate(yb, ry);
        s += a * wa + b * wb;
        ws += wa + wb;
    }

    vec3 n = (texture2D(uTex, vUv + vec2(uPx.x, 0.0)).rgb + texture2D(uTex, vUv - vec2(uPx.x, 0.0)).rgb
            + texture2D(uTex, vUv + vec2(0.0, uPx.y)).rgb + texture2D(uTex, vUv - vec2(0.0, uPx.y)).rgb) * 0.25;
    vec3 o = s / ws + (c - n) * uDetail;
    gl_FragColor = vec4(clamp(mix(c, o, uK.x * m * hairGate(y, ry)), 0.0, 1.0), 1.0);
}
