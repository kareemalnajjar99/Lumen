import SwiftUI

extension View {
    /// Lays a holographic foil over this view, lit according to `tilt`.
    public func holographic(tilt: Tilt, style: HolographicStyle = .foil) -> some View {
        modifier(HolographicEffect(tilt: tilt, style: style))
    }

    /// Lays a holographic foil over this view that the user tilts by dragging.
    public func holographic(style: HolographicStyle = .foil) -> some View {
        modifier(InteractiveHolographicEffect(style: style))
    }
}

#Preview("Holographic") {
    SampleCard(caption: "Drag to tilt", colors: [.indigo, .black])
        .holographic()
        .padding(60)
}
