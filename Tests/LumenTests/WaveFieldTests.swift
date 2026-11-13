import CoreGraphics
import Foundation
import Testing

@testable import Lumen

@Suite
struct WaveFieldTests {
    private let start = Date(timeIntervalSinceReferenceDate: 1_000)

    @Test
    func startsEmpty() {
        let field = WaveField()

        #expect(field.isEmpty)
        #expect(field.latestStart == nil)
        #expect(field.encoded(at: start).isEmpty)
    }

    @Test
    func encodesOriginAndAgeOfEachWave() {
        var field = WaveField()
        field.add(at: CGPoint(x: 10, y: 20), start: start)
        field.add(at: CGPoint(x: 30, y: 40), start: start.addingTimeInterval(0.5))

        #expect(field.encoded(at: start.addingTimeInterval(2)) == [10, 20, 2, 30, 40, 1.5])
    }

    @Test
    func tracksTheNewestWave() {
        var field = WaveField()
        field.add(at: .zero, start: start)
        field.add(at: .zero, start: start.addingTimeInterval(3))

        #expect(field.latestStart == start.addingTimeInterval(3))
    }

    @Test
    func dropsTheOldestWavesBeyondCapacity() {
        var field = WaveField()
        for index in 0..<WaveField.capacity + 2 {
            field.add(at: CGPoint(x: index, y: 0), start: start)
        }

        #expect(field.count == WaveField.capacity)
        #expect(field.waves.first?.origin.x == 2)
    }

    @Test
    func removingAllWavesEmptiesTheField() {
        var field = WaveField()
        field.add(at: .zero, start: start)
        field.removeAll()

        #expect(field.isEmpty)
    }
}
