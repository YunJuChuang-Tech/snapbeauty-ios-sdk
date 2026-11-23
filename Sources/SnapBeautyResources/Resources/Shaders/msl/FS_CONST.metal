
#include <metal_stdlib>
using namespace metal;
template<typename T> T xm_mod(T x,T y) { return x-y*floor(x/y); }
struct Xm_FS_CONST_Uniforms {
    float uV;
};
struct Xm_FS_CONST_Input { float4 position [[position]];
};
struct Xm_FS_CONST {
    float uV;
    float4 gl_FragColor;




void eval() { gl_FragColor = float4(float3(uV), 1.0); }

};
fragment float4 xm_FS_CONST(Xm_FS_CONST_Input input [[stage_in]], constant Xm_FS_CONST_Uniforms& u [[buffer(0)]]) {
    Xm_FS_CONST s;
    s.uV=u.uV;
    s.eval();
    return s.gl_FragColor;
}
