import SwiftUI

enum Area {
    case main
    case upperSide
    case rightSide

    var color: Color {
        switch self {
        case .main:
            Color(.main)
        case .upperSide:
            Color(.upperSide)
        case .rightSide:
            Color(.rightSide)
        }
    }
}
