import SwiftUI

enum Command: String {
    case plusMinus
    case calculate
    case allClear
    case clear
    case delete

    @ViewBuilder
    var body: some View {
        switch self {
        case .plusMinus:
            Image(systemName: "plus.slash.minus")
        case .calculate:
            Image(systemName: "equal")
        case .allClear:
            Text(verbatim: "AC")
        case .clear:
            Text(verbatim: "C")
        case .delete:
            Image(systemName: "delete.backward")
        }
    }
}
