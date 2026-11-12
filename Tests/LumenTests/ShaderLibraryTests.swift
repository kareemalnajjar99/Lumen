import Foundation
import Metal
import Testing

@testable import Lumen

@Suite
struct ShaderLibraryTests {
    @Test(.enabled(if: MTLCreateSystemDefaultDevice() != nil))
    func compiledLibraryExposesEveryShader() throws {
        let device = try #require(MTLCreateSystemDefaultDevice())
        let library = try device.makeDefaultLibrary(bundle: .module)

        #expect(library.functionNames.contains("holographic"))
    }
}
