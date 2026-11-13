#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>

using namespace metal;

static constant float pi = 3.14159265359;

static float liquidDepth(float2 unit, float2 size, float2 flow, float progress) {
    float2 centered = unit - 0.5;
    float along = dot(centered, flow) + 0.5;
    float across = dot(centered * size, float2(-flow.y, flow.x)) / 100.0;

    float surface = sin(across * 2.3 + progress * 4.0) * 0.05
        + sin(across * 5.0 + progress * 9.0) * 0.045
        + sin(across * 11.0 - progress * 14.0) * 0.02;
    float swell = sin(progress * pi);
    float level = mix(-0.02, 1.02, progress);

    return level - along - surface * swell;
}

[[ stitchable ]] half4 liquid(
    float2 position,
    SwiftUI::Layer layer,
    float4 bounds,
    float2 flow,
    float progress,
    float stretch
) {
    float2 unit = (position - bounds.xy) / bounds.zw;
    float depth = liquidDepth(unit, bounds.zw, flow, progress) * abs(dot(bounds.zw, flow));

    float inside = smoothstep(0.0, 1.0, depth);
    float settle = saturate(sin(progress * pi) * 4.0);
    float meniscus = exp(-max(depth, 0.0) / 14.0) * settle;
    float glint = exp(-pow((depth - 4.5) / 2.0, 2.0)) * settle;

    half4 original = layer.sample(position);
    half4 stretched = layer.sample(position - flow * meniscus * stretch);
    float coverage = min(1.0, float(original.a) / max(float(stretched.a), 0.001));

    half4 color = stretched * half(coverage * inside);
    color.rgb += half3(0.3 * glint) * color.a;
    return color;
}
