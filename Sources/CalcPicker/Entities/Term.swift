import Foundation

struct Term: CustomStringConvertible, Equatable {
    var digits: [Digit]
    var isResult = false

    var description: String {
        digits.map(\.description).joined()
    }

    var decimalValue: Decimal? {
        Decimal(string: description)
    }

    var isZero: Bool {
        decimalValue?.isZero ?? false
    }
}
