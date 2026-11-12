varying vec2 vUv;
uniform sampler2D uTex;
uniform sampler2D uSkin;
uniform sampler2D uSpotA;
uniform sampler2D uSpotB;
uniform vec4 uMode;

void main() {
    vec3 c = texture2D(uTex, vUv).rgb;
    float s = max(clamp(texture2D(uSpotA, vUv).r * uMode.x, 0.0, 1.0), clamp(texture2D(uSpotB, vUv).r * uMode.y, 0.0, 1.0));

    float w = max((1.0 - s) * max(texture2D(uSkin, vUv).r, 0.05), 0.02);
    vec3 v = uMode.z > 0.5 ? vec3(clamp(c.r - c.g + 0.5, 0.0, 1.0)) : c;
    gl_FragColor = vec4(v * w, w);
}
