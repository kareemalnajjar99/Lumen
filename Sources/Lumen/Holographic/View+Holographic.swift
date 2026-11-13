import SwiftUI

extension View {
    /// Lays a holographic foil over this view, lit according to `tilt`.
    public func holographic(tilt: Tilt, style: HolographicStyle = .foil) -> some View {
        modifier(HolographicEffect(tilt: tilt, style: style))
    }

    /// Lays a holographic foil over this view that follows the user's drag and the device's tilt.
    ///
    /// Dragging also leans the view in 3D. With Reduce Motion on, the view stays flat and ignores device motion.
    public func holographic(style: HolographicStyle = .foil, follows sources: TiltSource = .all) -> some View {
        modifier(InteractiveHolographicEffect(style: style, sources: sources))
    }
}

#Preview("Holographic") {
    SampleCard(caption: "Drag to tilt", colors: [.indigo, .black])
        .holographic()
        .padding(60)
}
