import SwiftUI

extension View {
    /// Sends a ripple across this view from wherever the user taps it.
    ///
    /// With Reduce Motion on, the view stays still.
    public func ripple(style: RippleStyle = .water) -> some View {
        modifier(TapRipple(style: style))
    }

    /// Sends a ripple across this view from `origin` each time `trigger` changes.
    ///
    /// With Reduce Motion on, the view stays still.
    public func ripple(at origin: CGPoint, trigger: some Equatable, style: RippleStyle = .water) -> some View {
        modifier(TriggeredRipple(origin: origin, trigger: trigger, style: style))
    }
}

#Preview("Ripple") {
    SampleCard(caption: "Tap anywhere", colors: [.blue, .indigo])
        .ripple()
        .padding(60)
}
