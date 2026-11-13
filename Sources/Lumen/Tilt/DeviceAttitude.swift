import Foundation

/// How a device is held, in radians.
struct DeviceAttitude: Equatable, Sendable {
    var pitch: Double
    var roll: Double

    /// This attitude moved a fraction of the way toward another, taking the short way around.
    func drifting(toward other: DeviceAttitude, by fraction: Double) -> DeviceAttitude {
        DeviceAttitude(
            pitch: pitch + Self.shortestTurn(from: pitch, to: other.pitch) * fraction,
            roll: roll + Self.shortestTurn(from: roll, to: other.roll) * fraction
        )
    }

    static func shortestTurn(from start: Double, to end: Double) -> Double {
        let turn = end - start
        return atan2(sin(turn), cos(turn))
    }
}

extension Tilt {
    /// The tilt of a device that turned from `reference` to `attitude`, where turning by `range` radians is a full tilt.
    init(attitude: DeviceAttitude, relativeTo reference: DeviceAttitude, range: Double = .pi / 7) {
        self.init(
            x: DeviceAttitude.shortestTurn(from: reference.roll, to: attitude.roll) / range,
            y: DeviceAttitude.shortestTurn(from: reference.pitch, to: attitude.pitch) / range
        )
    }

    func adding(_ other: Tilt) -> Tilt {
        Tilt(x: x + other.x, y: y + other.y)
    }
}
