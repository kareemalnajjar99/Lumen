import Foundation
import Testing

@testable import Lumen

@Suite
struct DeviceAttitudeTests {
    private let held = DeviceAttitude(pitch: 0.8, roll: 0)

    private func isClose(_ tilt: Tilt, x: Double, y: Double) -> Bool {
        abs(tilt.x - x) < 1e-9 && abs(tilt.y - y) < 1e-9
    }

    @Test
    func deviceThatHasNotMovedIsNeutral() {
        #expect(Tilt(attitude: held, relativeTo: held) == .neutral)
    }

    @Test
    func rollingLeansAlongTheHorizontalAxis() {
        let rolled = DeviceAttitude(pitch: 0.8, roll: 0.1)

        #expect(isClose(Tilt(attitude: rolled, relativeTo: held, range: 0.2), x: 0.5, y: 0))
    }

    @Test
    func pitchingLeansAlongTheVerticalAxis() {
        let pitched = DeviceAttitude(pitch: 0.7, roll: 0)

        #expect(isClose(Tilt(attitude: pitched, relativeTo: held, range: 0.2), x: 0, y: -0.5))
    }

    @Test
    func turningPastTheRangeIsAFullTilt() {
        let turned = DeviceAttitude(pitch: 0.8, roll: 1)

        #expect(Tilt(attitude: turned, relativeTo: held, range: 0.2) == Tilt(x: 1, y: 0))
    }

    @Test
    func turnsTakeTheShortWayAcrossTheWrapAround() {
        let before = DeviceAttitude(pitch: 0, roll: .pi - 0.05)
        let after = DeviceAttitude(pitch: 0, roll: -.pi + 0.05)

        #expect(isClose(Tilt(attitude: after, relativeTo: before, range: 0.2), x: 0.5, y: 0))
    }

    @Test
    func driftingMovesAFractionOfTheWay() {
        let drifted = held.drifting(toward: DeviceAttitude(pitch: 1, roll: 0.4), by: 0.5)

        #expect(abs(drifted.pitch - 0.9) < 1e-9)
        #expect(abs(drifted.roll - 0.2) < 1e-9)
    }
}
