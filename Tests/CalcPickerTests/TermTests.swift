@testable import CalcPicker
import Foundation
import Testing

struct TermTests {
    @Test(arguments: [
        .init(
            digits: [],
            expectedDescription: "",
            expectedDecimalValue: nil,
            expectedIsZero: false
        ),
        .init(
            digits: [.number(1)],
            expectedDescription: "1",
            expectedDecimalValue: 1,
            expectedIsZero: false
        ),
        .init(
            digits: [.number(0)],
            expectedDescription: "0",
            expectedDecimalValue: 0,
            expectedIsZero: true
        ),
        .init(
            digits: [.number(1), .number(2), .number(3)],
            expectedDescription: "123",
            expectedDecimalValue: 123,
            expectedIsZero: false
        ),
        .init(
            digits: [.number(1), .period],
            expectedDescription: "1.",
            expectedDecimalValue: 1,
            expectedIsZero: false
        ),
        .init(
            digits: [.number(0), .period],
            expectedDescription: "0.",
            expectedDecimalValue: 0,
            expectedIsZero: true
        ),
        .init(
            digits: [.period],
            expectedDescription: ".",
            expectedDecimalValue: nil,
            expectedIsZero: false
        ),
        .init(
            digits: [.number(1), .period, .number(2)],
            expectedDescription: "1.2",
            expectedDecimalValue: 1.2,
            expectedIsZero: false
        ),
        .init(
            digits: [.number(1), .period, .number(2), .period, .number(3)],
            expectedDescription: "1.2.3",
            expectedDecimalValue: nil,
            expectedIsZero: false
        ),
    ] as [TermCondition])
    func decimalValue(_ condition: TermCondition) {
        let actual = Term(digits: condition.digits)
        #expect(actual.decimalValue == condition.expectedDecimalValue)
    }
}

struct TermCondition {
    var digits: [Digit]
    var expectedDescription: String
    var expectedDecimalValue: Decimal?
    var expectedIsZero: Bool
}
