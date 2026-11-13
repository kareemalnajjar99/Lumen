/// What moves a view's holographic foil.
public struct TiltSource: OptionSet, Sendable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    /// The user dragging across the view.
    public static let drag = TiltSource(rawValue: 1 << 0)

    /// The user tilting the device.
    public static let deviceMotion = TiltSource(rawValue: 1 << 1)

    /// Dragging and device motion together.
    public static let all: TiltSource = [.drag, .deviceMotion]
}
