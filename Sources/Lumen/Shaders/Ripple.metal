#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>

using namespace metal;

static constant float tau = 6.28318530718;

static float waveHeight(float reach, float age, float wavelength, float speed, float lifetime) {
    float behind = speed * age - reach;
    if (behind < 0.0) {
        return 0.0;
    }
    float fade = 1.0 - saturate(age / lifetime);
    float trail = exp(-behind / (wavelength * 2.0));
    return sin(behind / wavelength * tau) * trail * fade * fade;
}

[[ stitchable ]] half4 ripple(
    float2 position,
    SwiftUI::Layer layer,
    device const float *waves,
    int count,
    float amplitude,
    float wavelength,
    float speed,
    float lifetime,
    float highlight
) {
    float2 offset = float2(0.0);
    float crest = 0.0;

    for (int index = 0; index + 2 < count; index += 3) {
        float2 fromOrigin = position - float2(waves[index], waves[index + 1]);
        float reach = length(fromOrigin);
        float height = waveHeight(reach, waves[index + 2], wavelength, speed, lifetime);
        offset += height * fromOrigin / max(reach, 0.001);
        crest += height;
    }

    half4 color = layer.sample(position + offset * amplitude);
    color.rgb += half3(highlight * crest) * color.a;
    return color;
}
