varying vec2 vUv;
uniform sampler2D uTex;
uniform sampler2D uHalf;
uniform sampler2D uClean;
uniform sampler2D uScore;
uniform sampler2D uSpotA;
uniform sampler2D uWide;
uniform sampler2D uSpotB;
uniform sampler2D uRed;
uniform sampler2D uSkin;
uniform sampler2D uProtect;
uniform vec2 uProtectK;
uniform vec4 uAmt;
uniform float uRedFade;
uniform float uMaxLift;

void main() {
    vec3 c = texture2D(uTex, vUv).rgb;
    vec3 h = texture2D(uHalf, vUv).rgb;
    vec3 fine = c - h;
    float score = texture2D(uScore, vUv).r;
    vec4 m = texture2D(uClean, vUv);
    vec4 wd = texture2D(uWide, vUv);


    vec3 wide = mix(h, wd.rgb / max(wd.a, 1e-3), smoothstep(0.03, 0.08, wd.a));
    vec3 bg = mix(wide, m.rgb / max(m.a, 1e-3), smoothstep(0.03, 0.08, m.a));
    float keep = 1.0 - smoothstep(uProtectK.x, uProtectK.y, texture2D(uProtect, vUv).g);
    float s = clamp(texture2D(uSpotA, vUv).r * uAmt.y, 0.0, 1.0) * keep;
    vec3 clean = bg + fine * uAmt.w * (1.0 - score);
    vec3 o = c + (clean - c) * (s * uAmt.x);
    float s2 = clamp(texture2D(uSpotB, vUv).r * uAmt.z, 0.0, 1.0) * keep;
    o += (wide + fine * uAmt.w - o) * (s2 * uAmt.x);
    vec4 r = texture2D(uRed, vUv);
    float excess = max((o.r - o.g) - (r.r / max(r.a, 1e-3) - 0.5), 0.0) * texture2D(uSkin, vUv).r * smoothstep(0.03, 0.08, r.a) * keep;
    o.r -= excess * uRedFade * uAmt.x * 0.7;
    o.g += excess * uRedFade * uAmt.x * 0.3;
    float lift = dot(o - c, vec3(0.299, 0.587, 0.114));
    if (lift > uMaxLift) o = c + (o - c) * (uMaxLift / lift);
    gl_FragColor = vec4(clamp(o, 0.0, 1.0), 1.0);
}
