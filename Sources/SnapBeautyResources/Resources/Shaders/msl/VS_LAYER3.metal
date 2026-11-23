
#include <metal_stdlib>
using namespace metal;
template<typename T> T xm_mod(T x,T y) { return x-y*floor(x/y); }
struct Xm_VS_LAYER3_Uniforms {
};
struct Xm_VS_LAYER3_Input {
    float3 aPos [[attribute(0)]];
    float2 aUv [[attribute(1)]];
};
struct Xm_VS_LAYER3_Output { float4 position [[position]];
    float2 vUv [[user(locn3)]];
};
struct Xm_VS_LAYER3 {
    float3 aPos;
    float2 aUv;
    float2 vUv;
    float4 gl_Position;




void eval() { vUv = aUv; gl_Position = float4(aPos, 1.0); }

};
vertex Xm_VS_LAYER3_Output xm_VS_LAYER3(Xm_VS_LAYER3_Input input [[stage_in]], constant Xm_VS_LAYER3_Uniforms& u [[buffer(0)]]) {
    Xm_VS_LAYER3 s;
    s.aPos=input.aPos;
    s.aUv=input.aUv;
    s.eval();
    Xm_VS_LAYER3_Output result; result.position=float4(s.gl_Position.x,-s.gl_Position.y,(s.gl_Position.z+s.gl_Position.w)*0.5,s.gl_Position.w);
    result.vUv=s.vUv;
    return result;
}
