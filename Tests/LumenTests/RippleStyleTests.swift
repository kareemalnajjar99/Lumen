import Testing

@testable import Lumen

@Suite
struct RippleStyleTests {
    @Test
    func clampsParametersToValidRanges() {
        let style = RippleStyle(amplitude: -5, wavelength: 0, speed: -1, lifetime: 0, highlight: 3)

        #expect(style.amplitude == 0)
        #expect(style.wavelength == 1)
        #expect(style.speed == 1)
        #expect(style.lifetime == 0.1)
        #expect(style.highlight == 1)
    }
}
