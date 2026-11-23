
attribute vec3 aPos;
attribute vec2 aOff;
varying vec2 vOff;
void main() { vOff = aOff; gl_Position = vec4(aPos, 1.0); }
