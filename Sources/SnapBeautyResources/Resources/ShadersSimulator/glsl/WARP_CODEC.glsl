
const float WARP_RANGE = 0.25;
vec4 encodeOff(vec2 d) {
    vec2 v = clamp(d / (2.0 * WARP_RANGE) + 0.5, 0.0, 1.0) * 255.0;
    vec2 hi = floor(v);
    vec2 lo = v - hi;
    return vec4(hi.x / 255.0, lo.x, hi.y / 255.0, lo.y);
}
vec2 decodeOff(vec4 c) {
    vec2 v = (vec2(c.r, c.b) * 255.0 + vec2(c.g, c.a)) / 255.0;
    return (v - 0.5) * 2.0 * WARP_RANGE;
}
