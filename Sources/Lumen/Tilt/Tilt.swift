import SwiftUI

/// How far a surface leans on each axis, from -1 to 1.
///
/// A positive `x` leans toward the trailing edge and a positive `y` toward the bottom edge.
public struct Tilt: Equatable, Sendable {
    /// Lean toward the trailing edge when positive, the leading edge when negative.
    public var x: Double

    /// Lean toward the bottom edge when positive, the top edge when negative.
    public var y: Double

    /// A surface that faces the viewer head-on.
    public static let neutral = Tilt(x: 0, y: 0)

    /// Creates a tilt, clamping each axis to -1...1.
    public init(x: Double, y: Double) {
        self.x = x.clamped(to: -1...1)
        self.y = y.clamped(to: -1...1)
    }

    /// The tilt that leans a surface of the given size toward a point in its coordinate space.
    public init(toward point: CGPoint, in size: CGSize) {
        guard size.width > 0, size.height > 0 else {
            self = .neutral
            return
        }
        self.init(
            x: point.x / size.width * 2 - 1,
            y: point.y / size.height * 2 - 1
        )
    }
}

extension Tilt: Animatable {
    public var animatableData: AnimatablePair<Double, Double> {
        get { AnimatablePair(x, y) }
        set {
            x = newValue.first
            y = newValue.second
        }
    }
}
