/// The shape of the wave that `ripple(style:)` sends across a view.
public struct RippleStyle: Equatable, Sendable {
    /// Furthest the content is displaced, in points.
    public var amplitude: Double

    /// Distance between crests, in points.
    public var wavelength: Double

    /// How fast the wave front travels, in points per second.
    public var speed: Double

    /// Seconds until a wave has faded out completely.
    public var lifetime: Double

    /// Brightness added on crests, from 0 to 1.
    public var highlight: Double

    /// Creates a style, clamping each value to its valid range.
    public init(
        amplitude: Double = 9,
        wavelength: Double = 64,
        speed: Double = 450,
        lifetime: Double = 1.6,
        highlight: Double = 0.08
    ) {
        self.amplitude = max(amplitude, 0)
        self.wavelength = max(wavelength, 1)
        self.speed = max(speed, 1)
        self.lifetime = max(lifetime, 0.1)
        self.highlight = highlight.clamped(to: 0...1)
    }
}

extension RippleStyle {
    /// A gentle wave, like a drop landing in water.
    public static let water = RippleStyle()

    /// A small, quick wave that barely disturbs the content.
    public static let subtle = RippleStyle(amplitude: 4, wavelength: 44, speed: 520, lifetime: 1.2, highlight: 0.03)

    /// A wide, fast wave with a bright crest.
    public static let shockwave = RippleStyle(amplitude: 14, wavelength: 110, speed: 800, lifetime: 1.3, highlight: 0.18)
}
