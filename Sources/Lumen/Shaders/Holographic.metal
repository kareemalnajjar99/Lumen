#include <metal_stdlib>

using namespace metal;

constant float tau = 6.28318530718;

static float3 spectrum(float phase) {
    return 0.5 + 0.5 * cos(tau * (phase + float3(0.0, 0.33, 0.67)));
}

static float hash(float2 cell) {
    return fract(sin(dot(cell, float2(127.1, 311.7))) * 43758.5453);
}

static float glitter(float2 position, float2 tilt) {
    float2 cell = floor(position / 2.5);
    float facet = sin(hash(cell) * tau * 8.0 + dot(tilt, float2(11.0, 7.0)));
    float present = step(0.82, hash(cell + 31.0));
    return present * pow(saturate(facet), 10.0);
}

[[ stitchable ]] half4 holographic(
    float2 position,
    half4 color,
    float4 bounds,
    float2 tilt,
    float intensity,
    float bands,
    float sparkle
) {
    float2 centered = (position - bounds.xy) / bounds.zw - 0.5;

    float phase = dot(centered, float2(0.8, 0.6)) * bands + dot(tilt, float2(0.9, 0.7));
    float glare = 1.0 - smoothstep(0.0, 0.85, distance(centered, tilt * 0.5));

    float3 sheen = spectrum(phase) * mix(0.35, 1.0, glare) + glitter(position, tilt) * sparkle;
    sheen = saturate(sheen * intensity);

    float3 base = float3(color.rgb);
    float alpha = float(color.a);
    float3 lit = base + sheen * (alpha - base);

    return half4(half3(lit), color.a);
}
