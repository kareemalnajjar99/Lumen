import Testing

@testable import Lumen

@Suite
struct HolographicStyleTests {
    @Test
    func clampsParametersToValidRanges() {
        let style = HolographicStyle(intensity: 4, bands: -2, sparkle: -1)

        #expect(style.intensity == 1)
        #expect(style.bands == 0)
        #expect(style.sparkle == 0)
    }
}
