import CoreGraphics
import Testing

@testable import Lumen

@Suite
struct TiltTests {
    private let size = CGSize(width: 100, height: 200)

    @Test
    func clampsComponentsToUnitRange() {
        #expect(Tilt(x: 3, y: -3) == Tilt(x: 1, y: -1))
    }

    @Test
    func centerOfSurfaceIsNeutral() {
        #expect(Tilt(toward: CGPoint(x: 50, y: 100), in: size) == .neutral)
    }

    @Test
    func cornersReachFullTilt() {
        #expect(Tilt(toward: .zero, in: size) == Tilt(x: -1, y: -1))
        #expect(Tilt(toward: CGPoint(x: 100, y: 200), in: size) == Tilt(x: 1, y: 1))
    }

    @Test
    func pointsOutsideSurfaceStayClamped() {
        #expect(Tilt(toward: CGPoint(x: 500, y: -500), in: size) == Tilt(x: 1, y: -1))
    }

    @Test
    func emptySurfaceIsNeutral() {
        #expect(Tilt(toward: CGPoint(x: 10, y: 10), in: .zero) == .neutral)
    }

    @Test
    func addingTiltsCombinesAndClampsThem() {
        #expect(Tilt(x: 0.75, y: -0.5).adding(Tilt(x: 0.75, y: 0.25)) == Tilt(x: 1, y: -0.25))
    }

    @Test
    func everySourceCoversDragAndDeviceMotion() {
        #expect(TiltSource.all.contains(.drag))
        #expect(TiltSource.all.contains(.deviceMotion))
        #expect(!TiltSource.drag.contains(.deviceMotion))
    }

    @Test
    func animatableDataRoundTrips() {
        var tilt = Tilt.neutral
        tilt.animatableData = Tilt(x: 0.25, y: -0.5).animatableData
        #expect(tilt == Tilt(x: 0.25, y: -0.5))
    }
}
