import SwiftUI

/// A transition that pours a view in from one edge and drains it back out.
public struct LiquidTransition: Transition {
    public var edge: Edge

    public init(edge: Edge = .bottom) {
        self.edge = edge
    }

    public func body(content: Content, phase: TransitionPhase) -> some View {
        content.modifier(LiquidEffect(progress: phase.isIdentity ? 1 : 0, edge: edge))
    }
}

extension Transition where Self == LiquidTransition {
    /// Pours the view in from the bottom edge and drains it back out.
    public static var liquid: LiquidTransition {
        LiquidTransition()
    }

    /// Pours the view in from `edge` and drains it back out.
    public static func liquid(from edge: Edge) -> LiquidTransition {
        LiquidTransition(edge: edge)
    }
}

#Preview("Liquid transition") {
    @Previewable @State var isShown = true

    VStack(spacing: 32) {
        ZStack {
            if isShown {
                SampleCard(caption: "Liquid transition", colors: [.green, .blue])
                    .transition(.liquid)
            }
        }
        .frame(width: 320, height: 200)

        Button(isShown ? "Drain" : "Pour") {
            withAnimation(.easeInOut(duration: 1.4)) {
                isShown.toggle()
            }
        }
        .buttonStyle(.borderedProminent)
    }
    .padding(60)
}
