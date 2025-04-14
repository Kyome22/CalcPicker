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
