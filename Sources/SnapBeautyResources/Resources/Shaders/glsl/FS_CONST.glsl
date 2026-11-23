
#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform float uV;
void main() { gl_FragColor = vec4(vec3(uV), 1.0); }
