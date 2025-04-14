struct Term: CustomStringConvertible {
    var digits: [Digit]
    var isResult = false

    var description: String {
        digits.map(\.description).joined()
    }

    var isZero: Bool {
        if digits.count == 1, case let .number(value) = digits.first, value == .zero {
            true
        } else {
            false
        }
    }

    var doubleValue: Double? {
        Double(description)
    }
}
