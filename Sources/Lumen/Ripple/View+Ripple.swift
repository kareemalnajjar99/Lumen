import SwiftUI

extension View {
    /// Sends a ripple across this view from wherever the user taps it.
    public func ripple(style: RippleStyle = .water) -> some View {
        modifier(TapRipple(style: style))
    }

    /// Sends a ripple across this view from `origin` each time `trigger` changes.
    public func ripple(at origin: CGPoint, trigger: some Equatable, style: RippleStyle = .water) -> some View {
        modifier(TriggeredRipple(origin: origin, trigger: trigger, style: style))
    }
}

#Preview("Ripple") {
    VStack(alignment: .leading) {
        Text("Lumen")
            .font(.title2.bold())
        Spacer()
        Text("Tap anywhere")
            .font(.footnote)
            .opacity(0.7)
    }
    .foregroundStyle(.white)
    .padding(24)
    .frame(width: 320, height: 200, alignment: .leading)
    .background(
        .linearGradient(colors: [.blue, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing),
        in: .rect(cornerRadius: 28)
    )
    .ripple()
    .padding(60)
}
