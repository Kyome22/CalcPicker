enum Request {
    case number(Int)
    case period
    case `operator`(Operator)
    case result(Double)

    var isNumber: Bool {
        if case .number = self {
            true
        } else {
            false
        }
    }

    var isZero: Bool {
        if case let .number(value) = self, value == 0 {
            true
        } else {
            false
        }
    }

    var isPeriod: Bool {
        if case .period = self {
            true
        } else {
            false
        }
    }

    var isOperator: Bool {
        if case .operator = self {
            true
        } else {
            false
        }
    }

    var isSubtractionOperator: Bool {
        if case let .operator(value) = self, value == .subtraction {
            true
        } else {
            false
        }
    }

    var isResult: Bool {
        if case .result = self {
            true
        } else {
            false
        }
    }
}
