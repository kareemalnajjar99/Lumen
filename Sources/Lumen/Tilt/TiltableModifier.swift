import SwiftUI

struct TiltableModifier: ViewModifier {
    @Binding var tilt: Tilt
    var maxAngle: Angle

    @State private var size = CGSize.zero

    func body(content: Content) -> some View {
        content
            .onGeometryChange(for: CGSize.self) { $0.size } action: { size = $0 }
            .rotation3DEffect(maxAngle * tilt.x, axis: (x: 0, y: 1, z: 0))
            .rotation3DEffect(maxAngle * -tilt.y, axis: (x: 1, y: 0, z: 0))
            .gesture(drag)
    }

    private var drag: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { tilt = Tilt(toward: $0.location, in: size) }
            .onEnded { _ in
                withAnimation(.spring(duration: 0.6, bounce: 0.35)) {
                    tilt = .neutral
                }
            }
    }
}

extension View {
    /// Lets the user tilt this view in 3D by dragging across it, springing back on release.
    public func tiltable(_ tilt: Binding<Tilt>, maxAngle: Angle = .degrees(10)) -> some View {
        modifier(TiltableModifier(tilt: tilt, maxAngle: maxAngle))
    }
}
