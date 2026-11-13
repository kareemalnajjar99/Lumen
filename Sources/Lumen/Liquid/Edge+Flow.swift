import SwiftUI

extension Edge {
    /// The direction liquid travels across a view after entering from this edge.
    func flow(in layoutDirection: LayoutDirection) -> CGVector {
        let leading: CGFloat = layoutDirection == .rightToLeft ? -1 : 1

        return switch self {
        case .top: CGVector(dx: 0, dy: 1)
        case .bottom: CGVector(dx: 0, dy: -1)
        case .leading: CGVector(dx: leading, dy: 0)
        case .trailing: CGVector(dx: -leading, dy: 0)
        }
    }
}
