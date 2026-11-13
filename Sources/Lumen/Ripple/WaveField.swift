import Foundation

/// The waves currently travelling across a view.
struct WaveField: Equatable, Sendable {
    struct Wave: Equatable, Sendable {
        var origin: CGPoint
        var start: Date
    }

    static let capacity = 8

    private(set) var waves: [Wave] = []

    var isEmpty: Bool { waves.isEmpty }
    var count: Int { waves.count }
    var latestStart: Date? { waves.last?.start }

    mutating func add(at origin: CGPoint, start: Date = .now) {
        waves.append(Wave(origin: origin, start: start))
        waves.removeFirst(max(waves.count - Self.capacity, 0))
    }

    mutating func removeAll() {
        waves.removeAll()
    }

    /// Every wave as `x, y, age`, the layout the ripple shader reads, with origins shifted by `inset`.
    func encoded(at date: Date, inset: Double = 0) -> [Float] {
        waves.flatMap { wave in
            [
                Float(wave.origin.x + inset),
                Float(wave.origin.y + inset),
                Float(date.timeIntervalSince(wave.start)),
            ]
        }
    }
}
