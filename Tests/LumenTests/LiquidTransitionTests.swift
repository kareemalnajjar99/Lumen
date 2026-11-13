import SwiftUI
import Testing

@testable import Lumen

@Suite
struct LiquidTransitionTests {
    @Test
    func liquidFlowsAwayFromTheEdgeItEnters() {
        #expect(Edge.top.flow(in: .leftToRight) == CGVector(dx: 0, dy: 1))
        #expect(Edge.bottom.flow(in: .leftToRight) == CGVector(dx: 0, dy: -1))
        #expect(Edge.leading.flow(in: .leftToRight) == CGVector(dx: 1, dy: 0))
        #expect(Edge.trailing.flow(in: .leftToRight) == CGVector(dx: -1, dy: 0))
    }

    @Test
    func horizontalFlowMirrorsInRightToLeftLayouts() {
        #expect(Edge.leading.flow(in: .rightToLeft) == CGVector(dx: -1, dy: 0))
        #expect(Edge.trailing.flow(in: .rightToLeft) == CGVector(dx: 1, dy: 0))
        #expect(Edge.top.flow(in: .rightToLeft) == Edge.top.flow(in: .leftToRight))
    }

    @MainActor
    @Test
    func entersFromTheBottomUnlessToldOtherwise() {
        #expect(LiquidTransition.liquid.edge == .bottom)
        #expect(LiquidTransition.liquid(from: .trailing).edge == .trailing)
    }
}
