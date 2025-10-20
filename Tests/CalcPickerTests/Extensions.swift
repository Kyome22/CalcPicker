@testable import CalcPicker

extension [Digit] {
    init(doubleValue: Double) {
        self = if abs(doubleValue.truncatingRemainder(dividingBy: 1)).isLess(than: .ulpOfOne) {
            Int(doubleValue).description.compactMap(Digit.init)
        } else {
            doubleValue.description.compactMap(Digit.init)
        }
    }
}

extension Term {
    init(_ doubleValue: Double) {
        self.init(digits: [Digit](doubleValue: doubleValue))
    }
}
