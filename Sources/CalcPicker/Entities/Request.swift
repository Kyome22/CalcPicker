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
    var isResult: Bool {
        if count == 1, case let .term(value) = first, value.isResult {
            true
        } else if count == 2, case .operator(.subtraction) = first, case let .term(value) = last, value.isResult {
            true
        } else {
            false
        }
    }

    var isAllClear: Bool {
        isEmpty || isResult
    }

    init(decimalValue: Decimal) {
        self = if decimalValue.isSignMinus {
            [.operator(.subtraction)]
        } else {
            []
        }
        append(.term(.init(digits: [Digit](decimalValue: decimalValue.magnitude))))
    }

    mutating func remove(at: Int, count: Int) {
        for _ in 0 ..< count {
            remove(at: at)
        }
    }

    func signedTerm(before index: Int) -> SignedTerm? {
        guard 0 < index, case let .term(beforeTerm) = self[index - 1], let value = beforeTerm.decimalValue else {
            return nil
        }
        guard 1 < index, case .operator(.subtraction) = self[index - 2] else {
            return SignedTerm(value: value, cost: 1)
        }
        return SignedTerm(value: -value, cost: 2)
    }

    func signedTerm(after index: Int) -> SignedTerm? {
        guard index < count - 1 else {
            return nil
        }
        if case let .term(afterTerm) = self[index + 1], let value = afterTerm.decimalValue {
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
        guard count >= 2 else { return nil }
        var copy = self

        // MARK: modulus
        while let index = copy.firstIndex(where: { $0 == .operator(.modulus) }) {
            guard let beforeSignedTerm = copy.signedTerm(before: index) else {
                return nil
            }
            guard let afterSignedTerm = copy.signedTerm(after: index), !afterSignedTerm.value.isSignMinus else {
                copy.remove(at: index - beforeSignedTerm.cost, count: beforeSignedTerm.cost + 1)
                copy.insert(
                    contentsOf: [Request](decimalValue: beforeSignedTerm.percentageValue),
                    at: index - beforeSignedTerm.cost
                )
                continue
            }
            guard !afterSignedTerm.value.isZero else {
                throw CalcPickerError.undefined
            }
            copy.remove(at: index - beforeSignedTerm.cost, count: beforeSignedTerm.cost + 1 + afterSignedTerm.cost)
            copy.insert(
                contentsOf: [Request](decimalValue: beforeSignedTerm.remainderValue(by: afterSignedTerm)),
                at: index - beforeSignedTerm.cost
            )
        }

        // MARK: division
        while let index = copy.firstIndex(where: { $0 == .operator(.division) }) {
            guard let beforeSignedTerm = copy.signedTerm(before: index),
                  let afterSignedTerm = copy.signedTerm(after: index) else {
                return nil
            }
            guard !afterSignedTerm.value.isZero else {
                throw CalcPickerError.undefined
            }
            copy.remove(at: index - beforeSignedTerm.cost, count: beforeSignedTerm.cost + 1 + afterSignedTerm.cost)
            copy.insert(
                contentsOf: [Request](decimalValue: beforeSignedTerm.dividingValue(by: afterSignedTerm)),
                at: index - beforeSignedTerm.cost
            )
        }

        // MARK: multiplication
        while let index = copy.firstIndex(where: { $0 == .operator(.multiplication) }) {
            guard let beforeSignedTerm = copy.signedTerm(before: index),
                  let afterSignedTerm = copy.signedTerm(after: index) else {
                return nil
            }
            copy.remove(at: index - beforeSignedTerm.cost, count: beforeSignedTerm.cost + 1 + afterSignedTerm.cost)
            copy.insert(
                contentsOf: [Request](decimalValue: beforeSignedTerm.multiplyingValue(by: afterSignedTerm)),
                at: index - beforeSignedTerm.cost
            )
        }

        // MARK: subtraction
        while let index = copy.firstIndex(where: { $0 == .operator(.subtraction) }) {
            guard let beforeSignedTerm = copy.signedTerm(before: index),
                  let afterSignedTerm = copy.signedTerm(after: index) else {
                return nil
            }
            copy.remove(at: index - beforeSignedTerm.cost, count: beforeSignedTerm.cost + 1 + afterSignedTerm.cost)
            copy.insert(
                contentsOf: [Request](decimalValue: beforeSignedTerm.subtractingValue(with: afterSignedTerm)),
                at: index - beforeSignedTerm.cost
            )
        }

        // MARK: addition
        while let index = copy.firstIndex(where: { $0 == .operator(.addition) }) {
            guard let beforeSignedTerm = copy.signedTerm(before: index),
                  let afterSignedTerm = copy.signedTerm(after: index) else {
                return nil
            }
            copy.remove(at: index - beforeSignedTerm.cost, count: beforeSignedTerm.cost + 1 + afterSignedTerm.cost)
            copy.insert(
                contentsOf: [Request](decimalValue: beforeSignedTerm.addingValue(with: afterSignedTerm)),
                at: index - beforeSignedTerm.cost
            )
        }

        if copy.count == 1, case let .term(value) = first {
            return [.term(.init(digits: value.digits, isResult: true))]
        } else if copy.count == 2, case .operator(.subtraction) = first, case let .term(value) = last {
            return [.operator(.subtraction), .term(.init(digits: value.digits, isResult: true))]
        } else {
            throw CalcPickerError.undefined
        }
    }
}
