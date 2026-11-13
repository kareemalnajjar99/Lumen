/// The look of the foil that `holographic(tilt:style:)` lays over a view.
public struct HolographicStyle: Equatable, Sendable {
    /// Strength of the foil over the content, from 0 to 1.
    public var intensity: Double

    /// Number of rainbow bands across the view.
    public var bands: Double

    /// Amount of glitter, from 0 to 1.
    public var sparkle: Double

    /// Creates a style, clamping each value to its valid range.
    public init(intensity: Double = 0.55, bands: Double = 3, sparkle: Double = 0.5) {
        self.intensity = intensity.clamped(to: 0...1)
        self.bands = max(bands, 0)
        self.sparkle = sparkle.clamped(to: 0...1)
    }
}

extension HolographicStyle {
    /// A balanced foil with a little glitter.
    public static let foil = HolographicStyle()

    /// A faint sheen for content that should stay the focus.
    public static let subtle = HolographicStyle(intensity: 0.3, bands: 2, sparkle: 0.2)

    /// A vivid, glittering foil.
    public static let prismatic = HolographicStyle(intensity: 0.8, bands: 6, sparkle: 0.9)
}
