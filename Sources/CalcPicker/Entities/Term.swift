import Foundation

struct Term: CustomStringConvertible, Equatable {
    var digits: [Digit]
    var isResult = false

    var description: String {
        digits.map(\.description).joined()
    }

    var decimalValue: Decimal? {
        guard digits.filter({ $0 == .period }).count <= 1 else {
            return nil
        }
        guard digits != [.period] else {
            return nil
        }
        return Decimal(string: description)
    }
}
