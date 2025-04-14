import SwiftUI

enum Command {
    case plusMinus
    case calculate
    case allClear
    case delete
    case complete

    @ViewBuilder
    var body: some View {
        switch self {
        case .plusMinus:
            Image(systemName: "plus.slash.minus")
        case .calculate:
            Image(systemName: "equal")
        case .allClear:
            Text(verbatim: "AC")
        case .delete:
            Image(systemName: "delete.backward")
        case .complete:
            Image(systemName: "text.append")
        }
    }
}
