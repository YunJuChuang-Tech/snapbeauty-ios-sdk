varying vec2 vUv;
uniform sampler2D uTex;
uniform sampler2D uBg;
uniform sampler2D uSkin;
uniform vec4 uK;
uniform vec2 uDark;
uniform vec2 uCore;
uniform vec3 uSat;
const vec3 L = vec3(0.299, 0.587, 0.114);


void main() {
    vec3 c = texture2D(uTex, vUv).rgb;
    vec4 b = texture2D(uBg, vUv);
    vec3 bg = b.rgb / max(b.a, 1e-3);
    float y = dot(c, L), by = dot(bg, L);
    float red = (c.r - c.g) - (bg.r - bg.g);
    float dark = clamp(by - y, 0.0, uDark.x);

    float sat = (c.r - c.g) / max(y, 1e-3) - (bg.r - bg.g) / max(by, 1e-3);
    dark *= mix(1.0, smoothstep(uSat.y, uSat.z, sat), uSat.x);

    float sc = smoothstep(uK.z, uK.w, max(red * uK.x, dark * uK.y)) * smoothstep(0.03, 0.08, b.a);
    float region = texture2D(uSkin, vUv).r, ratio = y / max(by, 1e-3);
    float skin = region * smoothstep(uDark.y - 0.05, uDark.y + 0.05, ratio);
    float core = max(1.0 - smoothstep(uCore.x - 0.05, uCore.x + 0.05, ratio), smoothstep(uCore.y - 0.05, uCore.y + 0.05, ratio));
    gl_FragColor = vec4(sc * skin, core * smoothstep(0.1, 0.5, region), 0.0, 1.0);
}
