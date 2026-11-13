import SwiftUI

struct WaveRenderer: ViewModifier {
    @Binding var field: WaveField
    var style: RippleStyle

    func body(content: Content) -> some View {
        let reach = style.amplitude * Double(field.count)

        TimelineView(.animation(paused: field.isEmpty)) { timeline in
            content.layerEffect(
                ShaderLibrary.lumen.ripple(
                    .floatArray(field.encoded(at: timeline.date)),
                    .float(style.amplitude),
                    .float(style.wavelength),
                    .float(style.speed),
                    .float(style.lifetime),
                    .float(style.highlight)
                ),
                maxSampleOffset: CGSize(width: reach, height: reach),
                isEnabled: !field.isEmpty
            )
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
