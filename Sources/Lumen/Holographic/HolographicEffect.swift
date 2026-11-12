import SwiftUI

struct HolographicEffect: ViewModifier, Animatable {
    var tilt: Tilt
    var style: HolographicStyle

    nonisolated var animatableData: Tilt.AnimatableData {
        get { tilt.animatableData }
        set { tilt.animatableData = newValue }
    }

    func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.lumen.holographic(
                .boundingRect,
                .float2(tilt.x, tilt.y),
                .float(style.intensity),
                .float(style.bands),
                .float(style.sparkle)
            )
        )
    }
}

struct InteractiveHolographicEffect: ViewModifier {
    var style: HolographicStyle

    @State private var tilt = Tilt.neutral

    func body(content: Content) -> some View {
        content
            .holographic(tilt: tilt, style: style)
            .tiltable($tilt)
    }
}
