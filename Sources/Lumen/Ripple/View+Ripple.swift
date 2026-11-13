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
    SampleCard(caption: "Tap anywhere", colors: [.blue, .indigo])
        .ripple()
        .padding(60)
}
