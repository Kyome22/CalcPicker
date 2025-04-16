import Foundation

enum Digit: CustomStringConvertible, Equatable {
    case number(Int)
    case period

    var description: String {
        switch self {
        case let .number(value):
            String(value)
        case .period:
            "."
        }
    }
}

extension Digit {
    init?(_ character: Character) {
        switch character {
        case ".":
            self = .period
        case ("0"..."9"):
            self = .number(Int(character.description)!)
        default:
            return nil
        }
    }
}

extension [Digit] {
    init(decimalValue: Decimal) {
        self = decimalValue.description.compactMap(Digit.init)
    }
}
