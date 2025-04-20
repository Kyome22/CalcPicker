import SwiftUI

enum Operator: String, CustomStringConvertible {
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

    var image: Image {
        switch self {
        case .addition:
            Image(systemName: "plus")
        case .subtraction:
            Image(systemName: "minus")
        case .multiplication:
            Image(systemName: "multiply")
        case .division:
            Image(systemName: "divide")
        case .modulus:
            Image(systemName: "percent")
        }
    }
}
