#include <metal_stdlib>

using namespace metal;

constant float tau = 6.28318530718;

static float3 spectrum(float phase) {
    return 0.5 + 0.5 * cos(tau * (phase + float3(0.0, 0.33, 0.67)));
}

static float hash(float2 cell) {
    return fract(sin(dot(cell, float2(127.1, 311.7))) * 43758.5453);
}

static float valueNoise(float2 point) {
    float2 cell = floor(point);
    float2 local = fract(point);
    float2 blend = local * local * (3.0 - 2.0 * local);
    float top = mix(hash(cell), hash(cell + float2(1.0, 0.0)), blend.x);
    float bottom = mix(hash(cell + float2(0.0, 1.0)), hash(cell + float2(1.0, 1.0)), blend.x);
    return mix(top, bottom, blend.y);
}

static float glitter(float2 position, float2 tilt) {
    float2 grid = position / 5.0;
    float2 cell = floor(grid);
    float2 flake = mix(float2(0.25), float2(0.75), float2(hash(cell + 7.0), hash(cell + 13.0)));
    float falloff = 1.0 - smoothstep(0.06, 0.22, distance(fract(grid), flake));
    float facet = sin(hash(cell) * tau * 8.0 + dot(tilt, float2(11.0, 7.0)));
    float present = step(0.55, hash(cell + 31.0));
    return present * falloff * pow(saturate(facet), 12.0);
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
    float2 unit = (position - bounds.xy) / bounds.zw - 0.5;
    float2 surface = unit * float2(bounds.z / bounds.w, 1.0);

    float warp = valueNoise(surface * 2.5 + tilt * 0.4) - 0.5;
    float phase = dot(surface, float2(0.6, 0.4)) * bands * 0.5 + dot(tilt, float2(0.7, 0.5)) + warp * 0.5;
    float3 hue = mix(float3(1.0), spectrum(phase), 0.75);

    float sweep = dot(surface, float2(0.8, 0.6)) - dot(tilt, float2(0.5, 0.32));
    float streak = exp(-sweep * sweep / 0.08);
    float2 offset = surface - tilt * 0.4;
    float hotspot = exp(-dot(offset, offset) / 0.3);
    float light = saturate(0.15 + 0.7 * streak + 0.35 * hotspot);

    float3 foil = hue * light * intensity + glitter(position, tilt) * sparkle * (0.3 + 0.7 * light);

    float3 base = float3(color.rgb);
    float alpha = float(color.a);
    float3 tinted = base * mix(float3(1.0), hue, 0.5 * light * intensity);
    float3 lit = tinted + saturate(foil) * (alpha - tinted);

    return half4(half3(lit), color.a);
}
