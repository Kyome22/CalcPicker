enum Operator: CustomStringConvertible {
    case addition
    case subtraction
    case multiplication
    case division
    case modulus

    var description: String {
        switch self {
        case .addition:
            "+"
        case .subtraction:
            "-"
        case .multiplication:
            "×"
        case .division:
            "÷"
        case .modulus:
            "%"
        }
    }
}
