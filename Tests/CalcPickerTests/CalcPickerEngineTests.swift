@testable import CalcPicker
import Testing

struct CalcPickerEngineTests {
    @MainActor
    @Test(arguments: [
        .init(role: .number(0), expectedRequests: [], expectedExpression: "0"),
        .init(role: .number(1), expectedRequests: [.term(.init(1))], expectedExpression: "1"),
        .init(role: .number(2), expectedRequests: [.term(.init(2))], expectedExpression: "2"),
        .init(role: .number(3), expectedRequests: [.term(.init(3))], expectedExpression: "3"),
        .init(role: .number(4), expectedRequests: [.term(.init(4))], expectedExpression: "4"),
        .init(role: .number(5), expectedRequests: [.term(.init(5))], expectedExpression: "5"),
        .init(role: .number(6), expectedRequests: [.term(.init(6))], expectedExpression: "6"),
        .init(role: .number(7), expectedRequests: [.term(.init(7))], expectedExpression: "7"),
        .init(role: .number(8), expectedRequests: [.term(.init(8))], expectedExpression: "8"),
        .init(role: .number(9), expectedRequests: [.term(.init(9))], expectedExpression: "9"),
    ] as [OnTapCondition])
    func onTap_adding_number_when_empty(_ condition: OnTapCondition) {
        let sut = CalcPickerEngine()
        sut.onTap(condition.role)
        #expect(sut.requests == condition.expectedRequests)
        #expect(sut.expression == condition.expectedExpression)
    }

    @MainActor
    @Test(arguments: [
        .init(
            role: .operator(.addition),
            expectedRequests: [.term(.init(0)), .operator(.addition)],
            expectedExpression: "0+"
        ),
        .init(
            role: .operator(.subtraction),
            expectedRequests: [.operator(.subtraction)],
            expectedExpression: "-"
        ),
        .init(
            role: .operator(.multiplication),
            expectedRequests: [.term(.init(0)), .operator(.multiplication)],
            expectedExpression: "0×"
        ),
        .init(
            role: .operator(.division),
            expectedRequests: [.term(.init(0)), .operator(.division)],
            expectedExpression: "0÷"
        ),
        .init(
            role: .operator(.modulus),
            expectedRequests: [.term(.init(0)), .operator(.modulus)],
            expectedExpression: "0%"
        ),

    ] as [OnTapCondition])
    func onTap_adding_operator_when_empty(_ condition: OnTapCondition) {
        let sut = CalcPickerEngine()
        sut.onTap(condition.role)
        #expect(sut.requests == condition.expectedRequests)
        #expect(sut.expression == condition.expectedExpression)
    }

    @MainActor @Test
    func onTap_adding_period_when_empty() {
        let sut = CalcPickerEngine()
        sut.onTap(.period)
        #expect(sut.requests == [.term(.init(digits: [.number(0), .period]))])
        #expect(sut.expression == "0.")
    }

    @MainActor
    @Test(arguments: [
        .init(role: .period, premiseRequests: [.term(.init(1))], expectedRequests: [.term(.init(digits: [.number(1), .period]))], expectedExpression: "1."),
        .init(role: .period, premiseRequests: [.term(.init(2))], expectedRequests: [.term(.init(digits: [.number(2), .period]))], expectedExpression: "2."),
        .init(role: .period, premiseRequests: [.term(.init(3))], expectedRequests: [.term(.init(digits: [.number(3), .period]))], expectedExpression: "3."),
        .init(role: .period, premiseRequests: [.term(.init(4))], expectedRequests: [.term(.init(digits: [.number(4), .period]))], expectedExpression: "4."),
        .init(role: .period, premiseRequests: [.term(.init(5))], expectedRequests: [.term(.init(digits: [.number(5), .period]))], expectedExpression: "5."),
        .init(role: .period, premiseRequests: [.term(.init(6))], expectedRequests: [.term(.init(digits: [.number(6), .period]))], expectedExpression: "6."),
        .init(role: .period, premiseRequests: [.term(.init(7))], expectedRequests: [.term(.init(digits: [.number(7), .period]))], expectedExpression: "7."),
        .init(role: .period, premiseRequests: [.term(.init(8))], expectedRequests: [.term(.init(digits: [.number(8), .period]))], expectedExpression: "8."),
        .init(role: .period, premiseRequests: [.term(.init(9))], expectedRequests: [.term(.init(digits: [.number(9), .period]))], expectedExpression: "9."),
    ] as [OnTapCondition])
    func onTap_adding_period_after_number(_ condition: OnTapCondition) {
        let sut = CalcPickerEngine()
        sut.requests = condition.premiseRequests
        sut.onTap(condition.role)
        #expect(sut.requests == condition.expectedRequests)
        #expect(sut.expression == condition.expectedExpression)
    }

    @MainActor
    @Test(arguments: [
        .init(
            role: .period,
            premiseRequests: [.operator(.addition)],
            expectedRequests: [.operator(.addition), .term(.init(digits: [.number(0), .period]))],
            expectedExpression: "+0."
        ),
        .init(
            role: .period,
            premiseRequests: [.operator(.subtraction)],
            expectedRequests: [.operator(.subtraction), .term(.init(digits: [.number(0), .period]))],
            expectedExpression: "-0."
        ),
        .init(
            role: .period,
            premiseRequests: [.operator(.multiplication)],
            expectedRequests: [.operator(.multiplication), .term(.init(digits: [.number(0), .period]))],
            expectedExpression: "×0."
        ),
        .init(
            role: .period,
            premiseRequests: [.operator(.division)],
            expectedRequests: [.operator(.division), .term(.init(digits: [.number(0), .period]))],
            expectedExpression: "÷0."
        ),
        .init(
            role: .period,
            premiseRequests: [.operator(.modulus)],
            expectedRequests: [.operator(.modulus), .term(.init(digits: [.number(0), .period]))],
            expectedExpression: "%0."
        ),
    ] as [OnTapCondition])
    func onTap_adding_period_after_operator(_ condition: OnTapCondition) {
        let sut = CalcPickerEngine()
        sut.requests = condition.premiseRequests
        sut.onTap(condition.role)
        #expect(sut.requests == condition.expectedRequests)
        #expect(sut.expression == condition.expectedExpression)
    }

    @MainActor
    @Test(arguments: [
        .init(
            role: .operator(.addition),
            premiseRequests: [.term(.init(1))],
            expectedRequests: [.term(.init(1)), .operator(.addition)],
            expectedExpression: "1+"
        ),
        .init(
            role: .operator(.subtraction),
            premiseRequests: [.term(.init(1))],
            expectedRequests: [.term(.init(1)), .operator(.subtraction)],
            expectedExpression: "1-"
        ),
        .init(
            role: .operator(.multiplication),
            premiseRequests: [.term(.init(1))],
            expectedRequests: [.term(.init(1)), .operator(.multiplication)],
            expectedExpression: "1×"
        ),
        .init(
            role: .operator(.division),
            premiseRequests: [.term(.init(1))],
            expectedRequests: [.term(.init(1)), .operator(.division)],
            expectedExpression: "1÷"
        ),
        .init(
            role: .operator(.modulus),
            premiseRequests: [.term(.init(1))],
            expectedRequests: [.term(.init(1)), .operator(.modulus)],
            expectedExpression: "1%"
        ),
    ] as [OnTapCondition])
    func onTap_adding_operator_after_term(_ condition: OnTapCondition) {
        let sut = CalcPickerEngine()
        sut.requests = condition.premiseRequests
        sut.onTap(condition.role)
        #expect(sut.requests == condition.expectedRequests)
        #expect(sut.expression == condition.expectedExpression)
    }

    @MainActor
    @Test(arguments: [
        .init(
            role: .operator(.addition),
            premiseRequests: [.operator(.addition)],
            expectedRequests: [.operator(.addition)],
            expectedExpression: "+"
        ),
        .init(
            role: .operator(.addition),
            premiseRequests: [.operator(.subtraction)],
            expectedRequests: [],
            expectedExpression: "0"
        ),
        .init(
            role: .operator(.addition),
            premiseRequests: [.operator(.multiplication)],
            expectedRequests: [.operator(.addition)],
            expectedExpression: "+"
        ),
        .init(
            role: .operator(.addition),
            premiseRequests: [.operator(.division)],
            expectedRequests: [.operator(.addition)],
            expectedExpression: "+"
        ),
        .init(
            role: .operator(.addition),
            premiseRequests: [.operator(.modulus)],
            expectedRequests: [.operator(.modulus), .operator(.addition)],
            expectedExpression: "%+"
        ),
    ] as [OnTapCondition])
    func onTap_adding_addition_after_operator(_ condition: OnTapCondition) {
        let sut = CalcPickerEngine()
        sut.requests = condition.premiseRequests
        sut.onTap(condition.role)
        #expect(sut.requests == condition.expectedRequests)
        #expect(sut.expression == condition.expectedExpression)
    }

    @MainActor
    @Test(arguments: [
        .init(
            role: .operator(.addition),
            premiseRequests: [.term(.init(0)), .operator(.addition)],
            expectedRequests: [.term(.init(0)), .operator(.addition)],
            expectedExpression: "0+"
        ),
        .init(
            role: .operator(.addition),
            premiseRequests: [.term(.init(0)), .operator(.subtraction)],
            expectedRequests: [.term(.init(0)), .operator(.addition)],
            expectedExpression: "0+"
        ),
        .init(
            role: .operator(.addition),
            premiseRequests: [.term(.init(0)), .operator(.multiplication)],
            expectedRequests: [.term(.init(0)), .operator(.addition)],
            expectedExpression: "0+"
        ),
        .init(
            role: .operator(.addition),
            premiseRequests: [.term(.init(0)), .operator(.division)],
            expectedRequests: [.term(.init(0)), .operator(.addition)],
            expectedExpression: "0+"
        ),
        .init(
            role: .operator(.addition),
            premiseRequests: [.term(.init(0)), .operator(.modulus)],
            expectedRequests: [.term(.init(0)), .operator(.modulus), .operator(.addition)],
            expectedExpression: "0%+"
        ),
        .init(
            role: .operator(.addition),
            premiseRequests: [.term(.init(0)), .operator(.multiplication), .operator(.subtraction)],
            expectedRequests: [.term(.init(0)), .operator(.addition)],
            expectedExpression: "0+"
        ),
        .init(
            role: .operator(.addition),
            premiseRequests: [.term(.init(0)), .operator(.division), .operator(.subtraction)],
            expectedRequests: [.term(.init(0)), .operator(.addition)],
            expectedExpression: "0+"
        ),
        .init(
            role: .operator(.addition),
            premiseRequests: [.term(.init(0)), .operator(.modulus), .operator(.subtraction)],
            expectedRequests: [.term(.init(0)), .operator(.modulus), .operator(.addition)],
            expectedExpression: "0%+"
        ),
        .init(
            role: .operator(.addition),
            premiseRequests: [.term(.init(0)), .operator(.modulus), .operator(.multiplication), .operator(.subtraction)],
            expectedRequests: [.term(.init(0)), .operator(.modulus), .operator(.addition)],
            expectedExpression: "0%+"
        ),
        .init(
            role: .operator(.addition),
            premiseRequests: [.term(.init(0)), .operator(.modulus), .operator(.division), .operator(.subtraction)],
            expectedRequests: [.term(.init(0)), .operator(.modulus), .operator(.addition)],
            expectedExpression: "0%+"
        ),
    ] as [OnTapCondition])
    func onTap_adding_addition_after_term_and_operators(_ condition: OnTapCondition) {
        let sut = CalcPickerEngine()
        sut.requests = condition.premiseRequests
        sut.onTap(condition.role)
        #expect(sut.requests == condition.expectedRequests)
        #expect(sut.expression == condition.expectedExpression)
    }

    @MainActor
    @Test(arguments: [
        .init(
            role: .operator(.subtraction),
            premiseRequests: [.operator(.addition)],
            expectedRequests: [.operator(.subtraction)],
            expectedExpression: "-"
        ),
        .init(
            role: .operator(.subtraction),
            premiseRequests: [.operator(.subtraction)],
            expectedRequests: [.operator(.subtraction)],
            expectedExpression: "-"
        ),
        .init(
            role: .operator(.subtraction),
            premiseRequests: [.operator(.multiplication)],
            expectedRequests: [.operator(.multiplication), .operator(.subtraction)],
            expectedExpression: "×-"
        ),
        .init(
            role: .operator(.subtraction),
            premiseRequests: [.operator(.division)],
            expectedRequests: [.operator(.division), .operator(.subtraction)],
            expectedExpression: "÷-"
        ),
        .init(
            role: .operator(.subtraction),
            premiseRequests: [.operator(.modulus)],
            expectedRequests: [.operator(.modulus), .operator(.subtraction)],
            expectedExpression: "%-"
        ),
    ] as [OnTapCondition])
    func onTap_adding_subtraction_after_operator(_ condition: OnTapCondition) {
        let sut = CalcPickerEngine()
        sut.requests = condition.premiseRequests
        sut.onTap(condition.role)
        #expect(sut.requests == condition.expectedRequests)
        #expect(sut.expression == condition.expectedExpression)
    }

    @MainActor
    @Test(arguments: [
        .init(
            role: .operator(.subtraction),
            premiseRequests: [.term(.init(0)), .operator(.addition)],
            expectedRequests: [.term(.init(0)), .operator(.subtraction)],
            expectedExpression: "0-"
        ),
        .init(
            role: .operator(.subtraction),
            premiseRequests: [.term(.init(0)), .operator(.subtraction)],
            expectedRequests: [.term(.init(0)), .operator(.subtraction)],
            expectedExpression: "0-"
        ),
        .init(
            role: .operator(.subtraction),
            premiseRequests: [.term(.init(0)), .operator(.multiplication)],
            expectedRequests: [.term(.init(0)), .operator(.multiplication), .operator(.subtraction)],
            expectedExpression: "0×-"
        ),
        .init(
            role: .operator(.subtraction),
            premiseRequests: [.term(.init(0)), .operator(.division)],
            expectedRequests: [.term(.init(0)), .operator(.division), .operator(.subtraction)],
            expectedExpression: "0÷-"
        ),
        .init(
            role: .operator(.subtraction),
            premiseRequests: [.term(.init(0)), .operator(.modulus)],
            expectedRequests: [.term(.init(0)), .operator(.modulus), .operator(.subtraction)],
            expectedExpression: "0%-"
        ),
        .init(
            role: .operator(.subtraction),
            premiseRequests: [.term(.init(0)), .operator(.multiplication), .operator(.subtraction)],
            expectedRequests: [.term(.init(0)), .operator(.multiplication), .operator(.subtraction)],
            expectedExpression: "0×-"
        ),
        .init(
            role: .operator(.subtraction),
            premiseRequests: [.term(.init(0)), .operator(.division), .operator(.subtraction)],
            expectedRequests: [.term(.init(0)), .operator(.division), .operator(.subtraction)],
            expectedExpression: "0÷-"
        ),
        .init(
            role: .operator(.subtraction),
            premiseRequests: [.term(.init(0)), .operator(.modulus), .operator(.subtraction)],
            expectedRequests: [.term(.init(0)), .operator(.modulus), .operator(.subtraction)],
            expectedExpression: "0%-"
        ),
        .init(
            role: .operator(.subtraction),
            premiseRequests: [.term(.init(0)), .operator(.modulus), .operator(.multiplication), .operator(.subtraction)],
            expectedRequests: [.term(.init(0)), .operator(.modulus), .operator(.multiplication), .operator(.subtraction)],
            expectedExpression: "0%×-"
        ),
        .init(
            role: .operator(.subtraction),
            premiseRequests: [.term(.init(0)), .operator(.modulus), .operator(.division), .operator(.subtraction)],
            expectedRequests: [.term(.init(0)), .operator(.modulus), .operator(.division), .operator(.subtraction)],
            expectedExpression: "0%÷-"
        ),
    ] as [OnTapCondition])
    func onTap_adding_subtraction_after_term_and_operators(_ condition: OnTapCondition) {
        let sut = CalcPickerEngine()
        sut.requests = condition.premiseRequests
        sut.onTap(condition.role)
        #expect(sut.requests == condition.expectedRequests)
        #expect(sut.expression == condition.expectedExpression)
    }

    @MainActor
    @Test(arguments: [
        .init(
            role: .operator(.multiplication),
            premiseRequests: [.operator(.addition)],
            expectedRequests: [.operator(.multiplication)],
            expectedExpression: "×"
        ),
        .init(
            role: .operator(.multiplication),
            premiseRequests: [.operator(.subtraction)],
            expectedRequests: [],
            expectedExpression: "0"
        ),
        .init(
            role: .operator(.multiplication),
            premiseRequests: [.operator(.multiplication)],
            expectedRequests: [.operator(.multiplication)],
            expectedExpression: "×"
        ),
        .init(
            role: .operator(.multiplication),
            premiseRequests: [.operator(.division)],
            expectedRequests: [.operator(.multiplication)],
            expectedExpression: "×"
        ),
        .init(
            role: .operator(.multiplication),
            premiseRequests: [.operator(.modulus)],
            expectedRequests: [.operator(.modulus), .operator(.multiplication)],
            expectedExpression: "%×"
        ),
    ] as [OnTapCondition])
    func onTap_adding_multiplication_after_operator(_ condition: OnTapCondition) {
        let sut = CalcPickerEngine()
        sut.requests = condition.premiseRequests
        sut.onTap(condition.role)
        #expect(sut.requests == condition.expectedRequests)
        #expect(sut.expression == condition.expectedExpression)
    }

    @MainActor
    @Test(arguments: [
        .init(
            role: .operator(.multiplication),
            premiseRequests: [.term(.init(0)), .operator(.addition)],
            expectedRequests: [.term(.init(0)), .operator(.multiplication)],
            expectedExpression: "0×"
        ),
        .init(
            role: .operator(.multiplication),
            premiseRequests: [.term(.init(0)), .operator(.subtraction)],
            expectedRequests: [.term(.init(0)), .operator(.multiplication)],
            expectedExpression: "0×"
        ),
        .init(
            role: .operator(.multiplication),
            premiseRequests: [.term(.init(0)), .operator(.multiplication)],
            expectedRequests: [.term(.init(0)), .operator(.multiplication)],
            expectedExpression: "0×"
        ),
        .init(
            role: .operator(.multiplication),
            premiseRequests: [.term(.init(0)), .operator(.division)],
            expectedRequests: [.term(.init(0)), .operator(.multiplication)],
            expectedExpression: "0×"
        ),
        .init(
            role: .operator(.multiplication),
            premiseRequests: [.term(.init(0)), .operator(.modulus)],
            expectedRequests: [.term(.init(0)), .operator(.modulus), .operator(.multiplication)],
            expectedExpression: "0%×"
        ),
        .init(
            role: .operator(.multiplication),
            premiseRequests: [.term(.init(0)), .operator(.multiplication), .operator(.subtraction)],
            expectedRequests: [.term(.init(0)), .operator(.multiplication)],
            expectedExpression: "0×"
        ),
        .init(
            role: .operator(.multiplication),
            premiseRequests: [.term(.init(0)), .operator(.division), .operator(.subtraction)],
            expectedRequests: [.term(.init(0)), .operator(.multiplication)],
            expectedExpression: "0×"
        ),
        .init(
            role: .operator(.multiplication),
            premiseRequests: [.term(.init(0)), .operator(.modulus), .operator(.subtraction)],
            expectedRequests: [.term(.init(0)), .operator(.modulus), .operator(.multiplication)],
            expectedExpression: "0%×"
        ),
        .init(
            role: .operator(.multiplication),
            premiseRequests: [.term(.init(0)), .operator(.modulus), .operator(.multiplication), .operator(.subtraction)],
            expectedRequests: [.term(.init(0)), .operator(.modulus), .operator(.multiplication)],
            expectedExpression: "0%×"
        ),
        .init(
            role: .operator(.multiplication),
            premiseRequests: [.term(.init(0)), .operator(.modulus), .operator(.division), .operator(.subtraction)],
            expectedRequests: [.term(.init(0)), .operator(.modulus), .operator(.multiplication)],
            expectedExpression: "0%×"
        ),
    ] as [OnTapCondition])
    func onTap_adding_multiplication_after_term_and_operators(_ condition: OnTapCondition) {
        let sut = CalcPickerEngine()
        sut.requests = condition.premiseRequests
        sut.onTap(condition.role)
        #expect(sut.requests == condition.expectedRequests)
        #expect(sut.expression == condition.expectedExpression)
    }

    @MainActor
    @Test(arguments: [
        .init(
            role: .operator(.division),
            premiseRequests: [.operator(.addition)],
            expectedRequests: [.operator(.division)],
            expectedExpression: "÷"
        ),
        .init(
            role: .operator(.division),
            premiseRequests: [.operator(.subtraction)],
            expectedRequests: [],
            expectedExpression: "0"
        ),
        .init(
            role: .operator(.division),
            premiseRequests: [.operator(.multiplication)],
            expectedRequests: [.operator(.division)],
            expectedExpression: "÷"
        ),
        .init(
            role: .operator(.division),
            premiseRequests: [.operator(.division)],
            expectedRequests: [.operator(.division)],
            expectedExpression: "÷"
        ),
        .init(
            role: .operator(.division),
            premiseRequests: [.operator(.modulus)],
            expectedRequests: [.operator(.modulus), .operator(.division)],
            expectedExpression: "%÷"
        ),
    ] as [OnTapCondition])
    func onTap_adding_division_after_operator(_ condition: OnTapCondition) {
        let sut = CalcPickerEngine()
        sut.requests = condition.premiseRequests
        sut.onTap(condition.role)
        #expect(sut.requests == condition.expectedRequests)
        #expect(sut.expression == condition.expectedExpression)
    }

    @MainActor
    @Test(arguments: [
        .init(
            role: .operator(.division),
            premiseRequests: [.term(.init(0)), .operator(.addition)],
            expectedRequests: [.term(.init(0)), .operator(.division)],
            expectedExpression: "0÷"
        ),
        .init(
            role: .operator(.division),
            premiseRequests: [.term(.init(0)), .operator(.subtraction)],
            expectedRequests: [.term(.init(0)), .operator(.division)],
            expectedExpression: "0÷"
        ),
        .init(
            role: .operator(.division),
            premiseRequests: [.term(.init(0)), .operator(.multiplication)],
            expectedRequests: [.term(.init(0)), .operator(.division)],
            expectedExpression: "0÷"
        ),
        .init(
            role: .operator(.division),
            premiseRequests: [.term(.init(0)), .operator(.division)],
            expectedRequests: [.term(.init(0)), .operator(.division)],
            expectedExpression: "0÷"
        ),
        .init(
            role: .operator(.division),
            premiseRequests: [.term(.init(0)), .operator(.modulus)],
            expectedRequests: [.term(.init(0)), .operator(.modulus), .operator(.division)],
            expectedExpression: "0%÷"
        ),
        .init(
            role: .operator(.division),
            premiseRequests: [.term(.init(0)), .operator(.multiplication), .operator(.subtraction)],
            expectedRequests: [.term(.init(0)), .operator(.division)],
            expectedExpression: "0÷"
        ),
        .init(
            role: .operator(.division),
            premiseRequests: [.term(.init(0)), .operator(.division), .operator(.subtraction)],
            expectedRequests: [.term(.init(0)), .operator(.division)],
            expectedExpression: "0÷"
        ),
        .init(
            role: .operator(.division),
            premiseRequests: [.term(.init(0)), .operator(.modulus), .operator(.subtraction)],
            expectedRequests: [.term(.init(0)), .operator(.modulus), .operator(.division)],
            expectedExpression: "0%÷"
        ),
        .init(
            role: .operator(.division),
            premiseRequests: [.term(.init(0)), .operator(.modulus), .operator(.multiplication), .operator(.subtraction)],
            expectedRequests: [.term(.init(0)), .operator(.modulus), .operator(.division)],
            expectedExpression: "0%÷"
        ),
        .init(
            role: .operator(.division),
            premiseRequests: [.term(.init(0)), .operator(.modulus), .operator(.division), .operator(.subtraction)],
            expectedRequests: [.term(.init(0)), .operator(.modulus), .operator(.division)],
            expectedExpression: "0%÷"
        ),
    ] as [OnTapCondition])
    func onTap_adding_division_after_term_and_operators(_ condition: OnTapCondition) {
        let sut = CalcPickerEngine()
        sut.requests = condition.premiseRequests
        sut.onTap(condition.role)
        #expect(sut.requests == condition.expectedRequests)
        #expect(sut.expression == condition.expectedExpression)
    }

    @MainActor
    @Test(arguments: [
        .init(
            role: .operator(.modulus),
            premiseRequests: [.operator(.addition)],
            expectedRequests: [.operator(.modulus)],
            expectedExpression: "%"
        ),
        .init(
            role: .operator(.modulus),
            premiseRequests: [.operator(.subtraction)],
            expectedRequests: [],
            expectedExpression: "0"
        ),
        .init(
            role: .operator(.modulus),
            premiseRequests: [.operator(.multiplication)],
            expectedRequests: [.operator(.modulus)],
            expectedExpression: "%"
        ),
        .init(
            role: .operator(.modulus),
            premiseRequests: [.operator(.division)],
            expectedRequests: [.operator(.modulus)],
            expectedExpression: "%"
        ),
        .init(
            role: .operator(.modulus),
            premiseRequests: [.operator(.modulus)],
            expectedRequests: [.operator(.modulus), .operator(.modulus)],
            expectedExpression: "%%"
        ),
    ] as [OnTapCondition])
    func onTap_adding_modulus_after_operator(_ condition: OnTapCondition) {
        let sut = CalcPickerEngine()
        sut.requests = condition.premiseRequests
        sut.onTap(condition.role)
        #expect(sut.requests == condition.expectedRequests)
        #expect(sut.expression == condition.expectedExpression)
    }

    @MainActor
    @Test(arguments: [
        .init(
            role: .operator(.modulus),
            premiseRequests: [.term(.init(0)), .operator(.addition)],
            expectedRequests: [.term(.init(0)), .operator(.modulus)],
            expectedExpression: "0%"
        ),
        .init(
            role: .operator(.modulus),
            premiseRequests: [.term(.init(0)), .operator(.subtraction)],
            expectedRequests: [.term(.init(0)), .operator(.modulus)],
            expectedExpression: "0%"
        ),
        .init(
            role: .operator(.modulus),
            premiseRequests: [.term(.init(0)), .operator(.multiplication)],
            expectedRequests: [.term(.init(0)), .operator(.modulus)],
            expectedExpression: "0%"
        ),
        .init(
            role: .operator(.modulus),
            premiseRequests: [.term(.init(0)), .operator(.division)],
            expectedRequests: [.term(.init(0)), .operator(.modulus)],
            expectedExpression: "0%"
        ),
        .init(
            role: .operator(.modulus),
            premiseRequests: [.term(.init(0)), .operator(.modulus)],
            expectedRequests: [.term(.init(0)), .operator(.modulus), .operator(.modulus)],
            expectedExpression: "0%%"
        ),
        .init(
            role: .operator(.modulus),
            premiseRequests: [.term(.init(0)), .operator(.multiplication), .operator(.subtraction)],
            expectedRequests: [.term(.init(0)), .operator(.modulus)],
            expectedExpression: "0%"
        ),
        .init(
            role: .operator(.modulus),
            premiseRequests: [.term(.init(0)), .operator(.division), .operator(.subtraction)],
            expectedRequests: [.term(.init(0)), .operator(.modulus)],
            expectedExpression: "0%"
        ),
        .init(
            role: .operator(.modulus),
            premiseRequests: [.term(.init(0)), .operator(.modulus), .operator(.subtraction)],
            expectedRequests: [.term(.init(0)), .operator(.modulus)],
            expectedExpression: "0%"
        ),
        .init(
            role: .operator(.modulus),
            premiseRequests: [.term(.init(0)), .operator(.modulus), .operator(.multiplication), .operator(.subtraction)],
            expectedRequests: [.term(.init(0)), .operator(.modulus), .operator(.modulus)],
            expectedExpression: "0%%"
        ),
        .init(
            role: .operator(.modulus),
            premiseRequests: [.term(.init(0)), .operator(.modulus), .operator(.division), .operator(.subtraction)],
            expectedRequests: [.term(.init(0)), .operator(.modulus), .operator(.modulus)],
            expectedExpression: "0%%"
        ),
    ] as [OnTapCondition])
    func onTap_adding_modulus_after_term_and_operators(_ condition: OnTapCondition) {
        let sut = CalcPickerEngine()
        sut.requests = condition.premiseRequests
        sut.onTap(condition.role)
        #expect(sut.requests == condition.expectedRequests)
        #expect(sut.expression == condition.expectedExpression)
    }

    @MainActor
    @Test(arguments: [
        .init(
            role: .number(1),
            premiseRequests: [.operator(.addition)],
            expectedRequests: [.operator(.addition), .term(.init(1))],
            expectedExpression: "+1"
        ),
        .init(
            role: .number(1),
            premiseRequests: [.operator(.subtraction)],
            expectedRequests: [.operator(.subtraction), .term(.init(1))],
            expectedExpression: "-1"
        ),
        .init(
            role: .number(1),
            premiseRequests: [.operator(.multiplication)],
            expectedRequests: [.operator(.multiplication), .term(.init(1))],
            expectedExpression: "×1"
        ),
        .init(
            role: .number(1),
            premiseRequests: [.operator(.division)],
            expectedRequests: [.operator(.division), .term(.init(1))],
            expectedExpression: "÷1"
        ),
        .init(
            role: .number(1),
            premiseRequests: [.operator(.modulus)],
            expectedRequests: [.operator(.modulus), .term(.init(1))],
            expectedExpression: "%1"
        ),
    ] as [OnTapCondition])
    func onTap_adding_number_after_operator(_ condition: OnTapCondition) {
        let sut = CalcPickerEngine()
        sut.requests = condition.premiseRequests
        sut.onTap(condition.role)
        #expect(sut.requests == condition.expectedRequests)
        #expect(sut.expression == condition.expectedExpression)
    }
}

struct OnTapCondition {
    var role: Role
    var premiseRequests = [Request]()
    var expectedRequests: [Request]
    var expectedExpression: String
}

extension [Digit] {
    init(integerValue: Int) {
        self = integerValue.description.compactMap(Digit.init)
    }
}

extension Term {
    init(_ integerValue: Int) {
        self.init(digits: [Digit](integerValue: integerValue))
    }
}
