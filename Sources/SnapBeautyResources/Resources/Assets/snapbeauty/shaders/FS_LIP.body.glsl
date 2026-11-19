varying vec2 vUv;
varying float vA;
varying vec2 vMaskUv;
uniform sampler2D uSrc;
uniform sampler2D uLipMask;
uniform vec3 uColor;
uniform float uAlpha;
uniform vec3 uGate;
uniform vec2 uGateStep;
uniform vec4 uSkinA;
uniform vec4 uSkinB;
float redness(vec3 c) {
    return (c.r - c.g) / (c.r + c.g + c.b + 0.001);
}
void main() {
    vec3 source = texture2D(uSrc, vUv).rgb;
    float coverage = clamp(vA, 0.0, 1.0) * texture2D(uLipMask, vMaskUv).r;
    float gate = 1.0;
    if (uGate.x < 1.0) {
        vec2 dx = vec2(uGateStep.x, 0.0);
        vec2 dy = vec2(0.0, uGateStep.y);
        float q = (redness(source) + redness(texture2D(uSrc, vUv + dx).rgb) + redness(texture2D(uSrc, vUv - dx).rgb)
                 + redness(texture2D(uSrc, vUv + dy).rgb) + redness(texture2D(uSrc, vUv - dy).rgb)) * 0.2;
        float skin = (redness(texture2D(uSrc, uSkinA.xy).rgb) + redness(texture2D(uSrc, uSkinA.zw).rgb)
                    + redness(texture2D(uSrc, uSkinB.xy).rgb) + redness(texture2D(uSrc, uSkinB.zw).rgb)) * 0.25;
        gate = mix(uGate.x, 1.0, smoothstep(uGate.y, uGate.z, q - skin));
    }
    float luminance = dot(source, vec3(0.299, 0.587, 0.114));
    float shadeLuminance = dot(uColor, vec3(0.299, 0.587, 0.114));
    float shadeScale = min(sqrt(luminance / max(shadeLuminance, 0.05)), 1.0);
    vec3 shade = uColor * shadeScale;
    float opacity = clamp(uAlpha * coverage * gate, 0.0, 1.0);
    float amount = opacity * (0.35 + 0.37 * sqrt(luminance));
    vec3 result = mix(source, shade, amount);
    result += opacity * (0.04 - 0.17 * luminance) * (vec3(1.0) - source);
    gl_FragColor = vec4(clamp(result, 0.0, 1.0), 1.0);
}
