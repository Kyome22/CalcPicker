import Foundation

struct SignedTerm: Equatable {
    var value: Decimal
    var cost: Int
}

extension SignedTerm {
    func addingValue(with: SignedTerm) -> Decimal {
        (value + with.value).roundingValue()
    }

    func subtractingValue(with: SignedTerm) -> Decimal {
        (value - with.value).roundingValue()
    }

    func multiplyingValue(by: SignedTerm) -> Decimal {
        (value * by.value).roundingValue()
    }

    func dividingValue(by: SignedTerm) -> Decimal {
        (value / by.value).roundingValue()
    }

    func remainderValue(by: SignedTerm) -> Decimal {
        let a = NSDecimalNumber(decimal: value).doubleValue
        let b = NSDecimalNumber(decimal: by.value).doubleValue
        let c = if a * b > .zero {
            a.truncatingRemainder(dividingBy: b)
        } else if a * b < .zero {
            a.remainder(dividingBy: b)
        } else {
            Double.zero
        }
        return Decimal(c).roundingValue()
    }
}

private extension Decimal {
    func roundingValue() -> Decimal {
        let v = NSDecimalNumber(decimal: self).doubleValue
        return Decimal(round(v * 10000000)) / 10000000
    }
}
