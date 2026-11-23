
attribute vec2 aPos;
attribute float aA;
attribute vec2 aMaskUv;
varying vec2 vUv;
varying float vA;
varying vec2 vMaskUv;
void main() { vUv = aPos * 0.5 + 0.5; vA = aA; vMaskUv = aMaskUv; gl_Position = vec4(aPos, 0.0, 1.0); }
