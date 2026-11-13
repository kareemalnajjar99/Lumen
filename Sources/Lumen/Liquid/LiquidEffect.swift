import SwiftUI

struct LiquidEffect: ViewModifier, Animatable {
    private static let stretch: CGFloat = 10

    var progress: Double
    var edge: Edge

    @Environment(\.layoutDirection) private var layoutDirection

    nonisolated var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }

    func body(content: Content) -> some View {
        let flow = edge.flow(in: layoutDirection)

        content.layerEffect(
            ShaderLibrary.lumen.liquid(
                .boundingRect,
                .float2(flow.dx, flow.dy),
                .float(progress),
                .float(Self.stretch)
            ),
            maxSampleOffset: CGSize(width: Self.stretch, height: Self.stretch),
            isEnabled: progress < 1
        )
    }
}
