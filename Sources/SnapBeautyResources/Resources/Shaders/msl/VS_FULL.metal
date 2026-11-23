
#include <metal_stdlib>
using namespace metal;
template<typename T> T xm_mod(T x,T y) { return x-y*floor(x/y); }
struct Xm_VS_FULL_Uniforms {
};
struct Xm_VS_FULL_Input {
    float2 aPos [[attribute(0)]];
};
struct Xm_VS_FULL_Output { float4 position [[position]];
    float2 vUv [[user(locn3)]];
};
struct Xm_VS_FULL {
    float2 aPos;
    float2 vUv;
    float4 gl_Position;



void eval() { vUv = aPos * 0.5 + 0.5; gl_Position = float4(aPos, 0.0, 1.0); }

};
vertex Xm_VS_FULL_Output xm_VS_FULL(Xm_VS_FULL_Input input [[stage_in]], constant Xm_VS_FULL_Uniforms& u [[buffer(0)]]) {
    Xm_VS_FULL s;
    s.aPos=input.aPos;
    s.eval();
    Xm_VS_FULL_Output result; result.position=float4(s.gl_Position.x,-s.gl_Position.y,(s.gl_Position.z+s.gl_Position.w)*0.5,s.gl_Position.w);
    result.vUv=s.vUv;
    return result;
}
