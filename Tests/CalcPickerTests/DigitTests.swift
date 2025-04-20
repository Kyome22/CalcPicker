@testable import CalcPicker
import Testing

struct DigitTests {
    @Test(arguments: [
        .init(charactor: ".", expectedDigit: .period),
        .init(charactor: "0", expectedDigit: .number(0)),
        .init(charactor: "1", expectedDigit: .number(1)),
        .init(charactor: "2", expectedDigit: .number(2)),
        .init(charactor: "3", expectedDigit: .number(3)),
        .init(charactor: "4", expectedDigit: .number(4)),
        .init(charactor: "5", expectedDigit: .number(5)),
        .init(charactor: "6", expectedDigit: .number(6)),
        .init(charactor: "7", expectedDigit: .number(7)),
        .init(charactor: "8", expectedDigit: .number(8)),
        .init(charactor: "9", expectedDigit: .number(9)),
        .init(charactor: "+", expectedDigit: nil),
    ] as [DigitCondition])
    func init_from_character(_ condition: DigitCondition) {
        let actual = Digit(condition.charactor)
        #expect(actual == condition.expectedDigit)
    }
}

struct DigitCondition {
    var charactor: Character
    var expectedDigit: Digit?
}
