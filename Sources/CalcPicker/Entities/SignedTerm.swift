import Foundation

struct SignedTerm {
    var value: Decimal
    var cost: Int
}

extension SignedTerm {
    var percentageValue: Decimal {
        value / 100
    }

    func addingValue(with: SignedTerm) -> Decimal {
        value + with.value
    }

    func subtractingValue(with: SignedTerm) -> Decimal {
        value - with.value
    }

    func multiplyingValue(by: SignedTerm) -> Decimal {
        value * by.value
    }

    func dividingValue(by: SignedTerm) -> Decimal {
        value / by.value
    }

    func remainderValue(by: SignedTerm) -> Decimal {
        let a = NSDecimalNumber(decimal: value).doubleValue
        let b = NSDecimalNumber(decimal: by.value).doubleValue
        let c = if value.isSignMinus {
            a.truncatingRemainder(dividingBy: b)
        } else {
            a.remainder(dividingBy: b)
        }
        return Decimal(c)
    }
}
