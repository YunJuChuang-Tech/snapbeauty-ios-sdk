
#include <metal_stdlib>
using namespace metal;
template<typename T> T xm_mod(T x,T y) { return x-y*floor(x/y); }
struct Xm_VS_WARP_FIELD_Uniforms {
};
struct Xm_VS_WARP_FIELD_Input {
    float3 aPos [[attribute(0)]];
    float2 aOff [[attribute(1)]];
};
struct Xm_VS_WARP_FIELD_Output { float4 position [[position]];
    float2 vOff [[user(locn2)]];
};
struct Xm_VS_WARP_FIELD {
    float3 aPos;
    float2 aOff;
    float2 vOff;
    float4 gl_Position;




void eval() { vOff = aOff; gl_Position = float4(aPos, 1.0); }

};
vertex Xm_VS_WARP_FIELD_Output xm_VS_WARP_FIELD(Xm_VS_WARP_FIELD_Input input [[stage_in]], constant Xm_VS_WARP_FIELD_Uniforms& u [[buffer(0)]]) {
    Xm_VS_WARP_FIELD s;
    s.aPos=input.aPos;
    s.aOff=input.aOff;
    s.eval();
    Xm_VS_WARP_FIELD_Output result; result.position=float4(s.gl_Position.x,-s.gl_Position.y,(s.gl_Position.z+s.gl_Position.w)*0.5,s.gl_Position.w);
    result.vOff=s.vOff;
    return result;
}
