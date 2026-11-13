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
    VStack(alignment: .leading) {
        Text("Lumen")
            .font(.title2.bold())
        Spacer()
        Text("Drag to tilt")
            .font(.footnote)
            .opacity(0.7)
    }
    .foregroundStyle(.white)
    .padding(24)
    .frame(width: 320, height: 200, alignment: .leading)
    .background(
        .linearGradient(colors: [.indigo, .black], startPoint: .topLeading, endPoint: .bottomTrailing),
        in: .rect(cornerRadius: 28)
    )
    .holographic()
    .padding(60)
}
