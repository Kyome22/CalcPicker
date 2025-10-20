import Foundation

enum Request: CustomStringConvertible, Equatable {
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
}

extension [Request] {
    var isClear: Bool {
        if case .term = last {
            true
        } else {
            false
        }
    }

    init(decimalValue: Decimal) {
        self = if decimalValue.isSignMinus {
            [.operator(.subtraction)]
        } else {
            []
        }
        append(.term(.init(digits: [Digit](decimalValue: decimalValue.magnitude))))
    }

    mutating func expired() {
        self = map { request in
            switch request {
            case .operator:
                request
            case let .term(value):
                Request.term(value)
            }
        }
    }

    mutating func remove(at: Int, count: Int) {
        guard at + count <= self.count else {
            fatalError("Error: out of range")
        }
        for _ in 0 ..< count {
            remove(at: at)
        }
    }

    func signedTerm(before index: Int) -> SignedTerm? {
        guard (0 ..< count).contains(index) else {
            return nil
        }
        guard 0 < index,
              case let .term(beforeTerm) = self[index - 1],
              let value = beforeTerm.decimalValue else {
            return nil
        }
        guard 1 < index,
              case .operator(.subtraction) = self[index - 2] else {
            return SignedTerm(value: value, cost: 1)
        }
        return SignedTerm(value: -value, cost: 2)
    }

    func signedTerm(after index: Int) -> SignedTerm? {
        guard (0 ..< count).contains(index) else {
            return nil
        }
        if index < count - 1,
           case let .term(afterTerm) = self[index + 1],
           let value = afterTerm.decimalValue {
            return SignedTerm(value: value, cost: 1)
        }
        guard index < count - 2,
              case .operator(.subtraction) = self[index + 1],
              case let .term(afterTerm) = self[index + 2],
              let value = afterTerm.decimalValue else {
            return nil
        }
        return SignedTerm(value: -value, cost: 2)
    }

    func calculated() throws -> [Request]? {
        guard count > 2 else { return nil }
        var copy = self

        let operations: [Operation] = [
            .init(
                operator: .modulus,
                needsZeroValidation: true,
                perform: { $0.remainderValue(by: $1) }
            ),
            .init(
                operator: .division,
                needsZeroValidation: true,
                perform: { $0.dividingValue(by: $1) }
            ),
            .init(
                operator: .multiplication,
                needsZeroValidation: false,
                perform: { $0.multiplyingValue(by: $1) }
            ),
            .init(
                operator: .subtraction,
                needsZeroValidation: false,
                perform: { $0.subtractingValue(with: $1) }
            ),
            .init(
                operator: .addition,
                needsZeroValidation: false,
                perform: { $0.addingValue(with: $1) }
            ),
        ]

        for operation in operations {
            while copy.count > 2, let index = copy.firstOperatorIndex(where: { $0 == .operator(operation.operator) }) {
                guard let beforeSignedTerm = copy.signedTerm(before: index),
                      let afterSignedTerm = copy.signedTerm(after: index) else {
                    return nil
                }
                if operation.needsZeroValidation {
                    guard !afterSignedTerm.value.isZero else {
                        throw CalcPickerError.undefined
                    }
                }
                copy.remove(at: index - beforeSignedTerm.cost, count: beforeSignedTerm.cost + 1 + afterSignedTerm.cost)
                copy.insert(
                    contentsOf: [Request](decimalValue: operation.perform(beforeSignedTerm, afterSignedTerm)),
                    at: index - beforeSignedTerm.cost
                )
            }
        }

        if copy.count == 1, case let .term(value) = copy.first {
            return [.term(.init(digits: value.digits))]
        } else if copy.count == 2, case .operator(.subtraction) = copy.first, case let .term(value) = copy.last {
            return [.operator(.subtraction), .term(.init(digits: value.digits))]
        } else {
            throw CalcPickerError.undefined
        }
    }
}

extension Array {
    func firstOperatorIndex(where predicate: (Element) throws -> Bool) rethrows -> Int? {
        try dropFirst().map(\.self).firstIndex(where: predicate).map({ $0 + 1 })
    }
}
