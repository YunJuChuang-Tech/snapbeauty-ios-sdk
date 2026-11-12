
varying vec2 vUv;
varying float vA;
varying vec2 vMaskUv;
uniform sampler2D uSrc;
uniform sampler2D uLipMask;
uniform vec3 uColor;
uniform float uAlpha;
void main() {
    vec3 source = texture2D(uSrc, vUv).rgb;
    float coverage = clamp(vA, 0.0, 1.0) * texture2D(uLipMask, vMaskUv).r;
    float luminance = dot(source, vec3(0.299, 0.587, 0.114));
    float shadeLuminance = dot(uColor, vec3(0.299, 0.587, 0.114));
    float shadeScale = min(sqrt(luminance / max(shadeLuminance, 0.05)), 1.0);
    vec3 shade = uColor * shadeScale;
    float opacity = clamp(uAlpha * coverage, 0.0, 1.0);
    float amount = opacity * (0.35 + 0.37 * sqrt(luminance));
    vec3 result = mix(source, shade, amount);
    result += opacity * (0.04 - 0.17 * luminance) * (vec3(1.0) - source);
    gl_FragColor = vec4(clamp(result, 0.0, 1.0), 1.0);
}
