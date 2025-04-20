import SwiftUI

enum Role {
    case number(Int)
    case period
    case `operator`(Operator)
    case command(Command)

    @ViewBuilder
    var body: some View {
        switch self {
        case let .number(value):
            Text(value.description)
        case .period:
            Text(verbatim: ".")
        case let .operator(value):
            value.image
        case let .command(value):
            value.body
        }
    }

    var accessibilityIdentifier: String {
        switch self {
        case let .number(value):
            "number\(value)Button"
        case .period:
            "periodButton"
        case let .operator(value):
            "\(value.rawValue)Button"
        case let .command(value):
            "\(value.rawValue)Button"
        }
    }
}
