enum Request: CustomStringConvertible {
    case term(Term)
    case `operator`(Operator)

    var description: String {
        switch self {
        case let .term(value):
            value.description
        case let .operator(value):
            value.description
        }
    }

    var isResult: Bool {
        if case let .term(value) = self {
            value.isResult
        } else {
            false
        }
    }
}

extension [Request] {
    var isAllClear: Bool {
        isEmpty || (count == 1 && first!.isResult)
    }

    func calculate() -> Double? {
        var result = Double.zero

        for request in self {
            switch request {
            case let .term(value):
                let a = value.doubleValue
            case let .operator(value):
                switch value {
                case .addition:
                case .subtraction:
                case .multiplication:
                case .division:
                case .modulus:
                }
            }
        }
    }
}
