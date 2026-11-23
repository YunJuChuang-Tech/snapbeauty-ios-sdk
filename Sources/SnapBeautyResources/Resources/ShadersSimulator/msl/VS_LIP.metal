
#include <metal_stdlib>
using namespace metal;
template<typename T> T xm_mod(T x,T y) { return x-y*floor(x/y); }
struct Xm_VS_LIP_Uniforms {
};
struct Xm_VS_LIP_Input {
    float2 aPos [[attribute(0)]];
    float aA [[attribute(1)]];
    float2 aMaskUv [[attribute(2)]];
};
struct Xm_VS_LIP_Output { float4 position [[position]];
    float2 vUv [[user(locn3)]];
    float vA [[user(locn0)]];
    float2 vMaskUv [[user(locn1)]];
};
struct Xm_VS_LIP {
    float2 aPos;
    float aA;
    float2 aMaskUv;
    float2 vUv;
    float vA;
    float2 vMaskUv;
    float4 gl_Position;







void eval() { vUv = aPos * 0.5 + 0.5; vA = aA; vMaskUv = aMaskUv; gl_Position = float4(aPos, 0.0, 1.0); }

};
vertex Xm_VS_LIP_Output xm_VS_LIP(Xm_VS_LIP_Input input [[stage_in]], constant Xm_VS_LIP_Uniforms& u [[buffer(0)]]) {
    Xm_VS_LIP s;
    s.aPos=input.aPos;
    s.aA=input.aA;
    s.aMaskUv=input.aMaskUv;
    s.eval();
    Xm_VS_LIP_Output result; result.position=float4(s.gl_Position.x,-s.gl_Position.y,(s.gl_Position.z+s.gl_Position.w)*0.5,s.gl_Position.w);
    result.vUv=s.vUv;
    result.vA=s.vA;
    result.vMaskUv=s.vMaskUv;
    return result;
}
