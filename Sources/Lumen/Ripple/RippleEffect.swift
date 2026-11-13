import SwiftUI

struct WaveRenderer: ViewModifier {
    @Binding var field: WaveField
    var style: RippleStyle

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func body(content: Content) -> some View {
        let isActive = !field.isEmpty && !reduceMotion
        let reach = isActive ? style.amplitude * Double(field.count) : 0

        TimelineView(.animation(paused: !isActive)) { timeline in
            content
                .padding(reach)
                .layerEffect(
                    ShaderLibrary.lumen.ripple(
                        .floatArray(field.encoded(at: timeline.date, inset: reach)),
                        .float(style.amplitude),
                        .float(style.wavelength),
                        .float(style.speed),
                        .float(style.lifetime),
                        .float(style.highlight)
                    ),
                    maxSampleOffset: CGSize(width: reach, height: reach),
                    isEnabled: isActive
                )
                .padding(-reach)
        }
        .task(id: field.latestStart) {
            guard !field.isEmpty else { return }
            try? await Task.sleep(for: .seconds(style.lifetime))
            guard !Task.isCancelled else { return }
            field.removeAll()
        }
    }
}

struct TapRipple: ViewModifier {
    var style: RippleStyle

    @State private var field = WaveField()

    func body(content: Content) -> some View {
        content
            .modifier(WaveRenderer(field: $field, style: style))
            .simultaneousGesture(
                SpatialTapGesture().onEnded { field.add(at: $0.location) }
            )
    }
}

struct TriggeredRipple<Trigger: Equatable>: ViewModifier {
    var origin: CGPoint
    var trigger: Trigger
    var style: RippleStyle

    @State private var field = WaveField()

    func body(content: Content) -> some View {
        content
            .modifier(WaveRenderer(field: $field, style: style))
            .onChange(of: trigger) {
                field.add(at: origin)
            }
    }
}
