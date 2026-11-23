
#include <metal_stdlib>
using namespace metal;
template<typename T> T xm_mod(T x,T y) { return x-y*floor(x/y); }
struct Xm_VS_POS_Uniforms {
};
struct Xm_VS_POS_Input {
    float2 aPos [[attribute(0)]];
};
struct Xm_VS_POS_Output { float4 position [[position]];
};
struct Xm_VS_POS {
    float2 aPos;
    float4 gl_Position;


void eval() { gl_Position = float4(aPos, 0.0, 1.0); }

};
vertex Xm_VS_POS_Output xm_VS_POS(Xm_VS_POS_Input input [[stage_in]], constant Xm_VS_POS_Uniforms& u [[buffer(0)]]) {
    Xm_VS_POS s;
    s.aPos=input.aPos;
    s.eval();
    Xm_VS_POS_Output result; result.position=float4(s.gl_Position.x,-s.gl_Position.y,(s.gl_Position.z+s.gl_Position.w)*0.5,s.gl_Position.w);

    return result;
}
