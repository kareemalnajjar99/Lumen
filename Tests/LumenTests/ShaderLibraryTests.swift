import Foundation
import Metal
import Testing

@testable import Lumen

@Suite
struct ShaderLibraryTests {
    @Test(.enabled(if: MTLCreateSystemDefaultDevice() != nil), arguments: ["holographic", "ripple", "liquid"])
    func compiledLibraryExposes(shader: String) throws {
        let device = try #require(MTLCreateSystemDefaultDevice())
        let library = try device.makeDefaultLibrary(bundle: .module)

        #expect(library.functionNames.contains(shader))
    }
}
