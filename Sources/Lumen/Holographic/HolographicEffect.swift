import SwiftUI

struct HolographicEffect: ViewModifier, Animatable {
    var tilt: Tilt
    var offset = Tilt.neutral
    var style: HolographicStyle

    nonisolated var animatableData: Tilt.AnimatableData {
        get { tilt.animatableData }
        set { tilt.animatableData = newValue }
    }

    func body(content: Content) -> some View {
        let light = tilt.adding(offset)

        content.colorEffect(
            ShaderLibrary.lumen.holographic(
                .boundingRect,
                .float2(light.x, light.y),
                .float(style.intensity),
                .float(style.bands),
                .float(style.sparkle)
            )
        )
    }
}

struct InteractiveHolographicEffect: ViewModifier {
    var style: HolographicStyle
    var sources: TiltSource

    @State private var drag = Tilt.neutral
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var followsDevice: Bool {
        sources.contains(.deviceMotion) && !reduceMotion
    }

    func body(content: Content) -> some View {
        let device = followsDevice ? DeviceTilt.shared.tilt : .neutral
        let foil = content.modifier(HolographicEffect(tilt: drag, offset: device, style: style))

        Group {
            if sources.contains(.drag) {
                foil.tiltable($drag)
            } else {
                foil
            }
        }
        .task(id: followsDevice) {
            guard followsDevice else { return }
            await DeviceTilt.shared.follow()
        }
    }
}
