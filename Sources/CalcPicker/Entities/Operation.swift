import Foundation

struct Operation {
    var `operator`: Operator
    var needsZeroValidation: Bool
    var perform: (SignedTerm, SignedTerm) -> Decimal
}
