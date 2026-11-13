#if !os(macOS)
import CoreMotion
#endif
import Observation

/// The device's tilt, shared by every view that follows it.
///
/// The tilt is measured against how the device was recently held, so it settles back
/// to neutral when the user stops moving. A Mac has no motion sensors, so there it stays neutral.
@MainActor
@Observable
final class DeviceTilt {
    static let shared = DeviceTilt()

    private(set) var tilt = Tilt.neutral

    #if !os(macOS)
    @ObservationIgnored private let manager = CMMotionManager()
    #endif
    @ObservationIgnored private var followers = 0
    @ObservationIgnored private var reference: DeviceAttitude?

    /// Keeps `tilt` current until the calling task is cancelled.
    func follow() async {
        followers += 1
        if followers == 1 {
            start()
        }
        defer {
            followers -= 1
            if followers == 0 {
                stop()
            }
        }

        await Self.cancellation()
    }

    /// Suspends until the current task is cancelled.
    private static func cancellation() async {
        let never = AsyncStream<Never> { _ in }
        for await _ in never {}
    }

    private func start() {
        #if !os(macOS)
        guard manager.isDeviceMotionAvailable else { return }

        manager.deviceMotionUpdateInterval = 1 / 60
        manager.startDeviceMotionUpdates(to: .main) { [weak self] motion, _ in
            guard let attitude = motion?.attitude else { return }
            let current = DeviceAttitude(pitch: attitude.pitch, roll: attitude.roll)

            MainActor.assumeIsolated {
                self?.update(to: current)
            }
        }
        #endif
    }

    private func stop() {
        #if !os(macOS)
        manager.stopDeviceMotionUpdates()
        #endif
        reference = nil
        tilt = .neutral
    }

    private func update(to attitude: DeviceAttitude) {
        let settled = (reference ?? attitude).drifting(toward: attitude, by: 0.02)
        reference = settled
        tilt = Tilt(attitude: attitude, relativeTo: settled)
    }
}
