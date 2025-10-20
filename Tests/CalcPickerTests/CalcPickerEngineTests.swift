@testable import CalcPicker
import Testing

struct CalcPickerEngineTests {
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
    @MainActor
    func onTap_adding_number_when_empty(_ condition: OnTapCondition) {
        let sut = CalcPickerEngine()
        sut.onTap(condition.role)
        #expect(sut.requests == condition.expectedRequests)
        #expect(sut.expression == condition.expectedExpression)
    }

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
    @MainActor
    func onTap_adding_operator_when_empty(_ condition: OnTapCondition) {
        let sut = CalcPickerEngine()
        sut.onTap(condition.role)
        #expect(sut.requests == condition.expectedRequests)
        #expect(sut.expression == condition.expectedExpression)
    }

    @Test @MainActor
    func onTap_adding_period_when_empty() {
        let sut = CalcPickerEngine()
        sut.onTap(.period)
        #expect(sut.requests == [.term(.init(digits: [.number(0), .period]))])
        #expect(sut.expression == "0.")
    }

    @Test(arguments: [
        .init(
            role: .number(1),
            premiseRequests: [.term(.init(digits: [.number(0)]))],
            expectedRequests: [.term(.init(1))],
            expectedExpression: "1"
        ),
        .init(
            role: .number(1),
            premiseRequests: [.term(.init(digits: [.number(0), .period]))],
            expectedRequests: [.term(.init(digits: [.number(0), .period, .number(1)]))],
            expectedExpression: "0.1"
        ),
        .init(
            role: .number(2),
            premiseRequests: [.term(.init(digits: [.number(0), .period, .number(1)]))],
            expectedRequests: [.term(.init(digits: [.number(0), .period, .number(1), .number(2)]))],
            expectedExpression: "0.12"
        ),
    ] as [OnTapCondition])
    @MainActor
    func onTap_adding_number_after_term(_ condition: OnTapCondition) {
        let sut = CalcPickerEngine()
        sut.requests = condition.premiseRequests
        sut.onTap(condition.role)
        #expect(sut.requests == condition.expectedRequests)
        #expect(sut.expression == condition.expectedExpression)
    }

    @Test(arguments: [
        .init(
            role: .period,
            premiseRequests: [.term(.init(1))],
            expectedRequests: [.term(.init(digits: [.number(1), .period]))],
            expectedExpression: "1."
        ),
        .init(
            role: .period,
            premiseRequests: [.term(.init(2))],
            expectedRequests: [.term(.init(digits: [.number(2), .period]))],
            expectedExpression: "2."
        ),
        .init(
            role: .period,
            premiseRequests: [.term(.init(3))],
            expectedRequests: [.term(.init(digits: [.number(3), .period]))],
            expectedExpression: "3."
        ),
        .init(
            role: .period,
            premiseRequests: [.term(.init(4))],
            expectedRequests: [.term(.init(digits: [.number(4), .period]))],
            expectedExpression: "4."
        ),
        .init(
            role: .period,
            premiseRequests: [.term(.init(5))],
            expectedRequests: [.term(.init(digits: [.number(5), .period]))],
            expectedExpression: "5."
        ),
        .init(
            role: .period,
            premiseRequests: [.term(.init(6))],
            expectedRequests: [.term(.init(digits: [.number(6), .period]))],
            expectedExpression: "6."
        ),
        .init(
            role: .period,
            premiseRequests: [.term(.init(7))],
            expectedRequests: [.term(.init(digits: [.number(7), .period]))],
            expectedExpression: "7."
        ),
        .init(
            role: .period,
            premiseRequests: [.term(.init(8))],
            expectedRequests: [.term(.init(digits: [.number(8), .period]))],
            expectedExpression: "8."
        ),
        .init(
            role: .period,
            premiseRequests: [.term(.init(9))],
            expectedRequests: [.term(.init(digits: [.number(9), .period]))],
            expectedExpression: "9."
        ),
        .init(
            role: .period,
            premiseRequests: [.term(.init(1.1))],
            expectedRequests: [.term(.init(1.1))],
            expectedExpression: "1.1"
        ),
    ] as [OnTapCondition])
    @MainActor
    func onTap_adding_period_after_number(_ condition: OnTapCondition) {
        let sut = CalcPickerEngine()
        sut.requests = condition.premiseRequests
        sut.onTap(condition.role)
        #expect(sut.requests == condition.expectedRequests)
        #expect(sut.expression == condition.expectedExpression)
    }

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
    @MainActor
    func onTap_adding_period_after_operator(_ condition: OnTapCondition) {
        let sut = CalcPickerEngine()
        sut.requests = condition.premiseRequests
        sut.onTap(condition.role)
        #expect(sut.requests == condition.expectedRequests)
        #expect(sut.expression == condition.expectedExpression)
    }

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
    @MainActor
    func onTap_adding_operator_after_term(_ condition: OnTapCondition) {
        let sut = CalcPickerEngine()
        sut.requests = condition.premiseRequests
        sut.onTap(condition.role)
        #expect(sut.requests == condition.expectedRequests)
        #expect(sut.expression == condition.expectedExpression)
    }

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
            expectedRequests: [.operator(.addition)],
            expectedExpression: "+"
        ),
    ] as [OnTapCondition])
    @MainActor
    func onTap_adding_addition_after_operator(_ condition: OnTapCondition) {
        let sut = CalcPickerEngine()
        sut.requests = condition.premiseRequests
        sut.onTap(condition.role)
        #expect(sut.requests == condition.expectedRequests)
        #expect(sut.expression == condition.expectedExpression)
    }

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
            expectedRequests: [.term(.init(0)), .operator(.addition)],
            expectedExpression: "0+"
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
            expectedRequests: [.term(.init(0)), .operator(.addition)],
            expectedExpression: "0+"
        ),
    ] as [OnTapCondition])
    @MainActor
    func onTap_adding_addition_after_term_and_operators(_ condition: OnTapCondition) {
        let sut = CalcPickerEngine()
        sut.requests = condition.premiseRequests
        sut.onTap(condition.role)
        #expect(sut.requests == condition.expectedRequests)
        #expect(sut.expression == condition.expectedExpression)
    }

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
    @MainActor
    func onTap_adding_subtraction_after_operator(_ condition: OnTapCondition) {
        let sut = CalcPickerEngine()
        sut.requests = condition.premiseRequests
        sut.onTap(condition.role)
        #expect(sut.requests == condition.expectedRequests)
        #expect(sut.expression == condition.expectedExpression)
    }

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
    ] as [OnTapCondition])
    @MainActor
    func onTap_adding_subtraction_after_term_and_operators(_ condition: OnTapCondition) {
        let sut = CalcPickerEngine()
        sut.requests = condition.premiseRequests
        sut.onTap(condition.role)
        #expect(sut.requests == condition.expectedRequests)
        #expect(sut.expression == condition.expectedExpression)
    }

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
            expectedRequests: [.operator(.multiplication)],
            expectedExpression: "×"
        ),
    ] as [OnTapCondition])
    @MainActor
    func onTap_adding_multiplication_after_operator(_ condition: OnTapCondition) {
        let sut = CalcPickerEngine()
        sut.requests = condition.premiseRequests
        sut.onTap(condition.role)
        #expect(sut.requests == condition.expectedRequests)
        #expect(sut.expression == condition.expectedExpression)
    }

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
            expectedRequests: [.term(.init(0)), .operator(.multiplication)],
            expectedExpression: "0×"
        ),
    ] as [OnTapCondition])
    @MainActor
    func onTap_adding_multiplication_after_term_and_operators(_ condition: OnTapCondition) {
        let sut = CalcPickerEngine()
        sut.requests = condition.premiseRequests
        sut.onTap(condition.role)
        #expect(sut.requests == condition.expectedRequests)
        #expect(sut.expression == condition.expectedExpression)
    }

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
            expectedRequests: [.operator(.division)],
            expectedExpression: "÷"
        ),
    ] as [OnTapCondition])
    @MainActor
    func onTap_adding_division_after_operator(_ condition: OnTapCondition) {
        let sut = CalcPickerEngine()
        sut.requests = condition.premiseRequests
        sut.onTap(condition.role)
        #expect(sut.requests == condition.expectedRequests)
        #expect(sut.expression == condition.expectedExpression)
    }

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
            expectedRequests: [.term(.init(0)), .operator(.division)],
            expectedExpression: "0÷"
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
            expectedRequests: [.term(.init(0)), .operator(.division)],
            expectedExpression: "0÷"
        ),
    ] as [OnTapCondition])
    @MainActor
    func onTap_adding_division_after_term_and_operators(_ condition: OnTapCondition) {
        let sut = CalcPickerEngine()
        sut.requests = condition.premiseRequests
        sut.onTap(condition.role)
        #expect(sut.requests == condition.expectedRequests)
        #expect(sut.expression == condition.expectedExpression)
    }

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
            expectedRequests: [.operator(.modulus)],
            expectedExpression: "%"
        ),
    ] as [OnTapCondition])
    @MainActor
    func onTap_adding_modulus_after_operator(_ condition: OnTapCondition) {
        let sut = CalcPickerEngine()
        sut.requests = condition.premiseRequests
        sut.onTap(condition.role)
        #expect(sut.requests == condition.expectedRequests)
        #expect(sut.expression == condition.expectedExpression)
    }

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
            expectedRequests: [.term(.init(0)), .operator(.modulus)],
            expectedExpression: "0%"
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
    ] as [OnTapCondition])
    @MainActor
    func onTap_adding_modulus_after_term_and_operators(_ condition: OnTapCondition) {
        let sut = CalcPickerEngine()
        sut.requests = condition.premiseRequests
        sut.onTap(condition.role)
        #expect(sut.requests == condition.expectedRequests)
        #expect(sut.expression == condition.expectedExpression)
    }

    @Test(arguments: [
        .init(
            role: .number(0),
            premiseRequests: [.operator(.addition)],
            expectedRequests: [.operator(.addition), .term(.init(0))],
            expectedExpression: "+0"
        ),
        .init(
            role: .number(0),
            premiseRequests: [.operator(.subtraction)],
            expectedRequests: [.operator(.subtraction), .term(.init(0))],
            expectedExpression: "-0"
        ),
        .init(
            role: .number(0),
            premiseRequests: [.operator(.multiplication)],
            expectedRequests: [.operator(.multiplication), .term(.init(0))],
            expectedExpression: "×0"
        ),
        .init(
            role: .number(0),
            premiseRequests: [.operator(.division)],
            expectedRequests: [.operator(.division), .term(.init(0))],
            expectedExpression: "÷0"
        ),
        .init(
            role: .number(0),
            premiseRequests: [.operator(.modulus)],
            expectedRequests: [.operator(.modulus), .term(.init(0))],
            expectedExpression: "%0"
        ),
    ] as [OnTapCondition])
    @MainActor
    func onTap_adding_number_after_operator(_ condition: OnTapCondition) {
        let sut = CalcPickerEngine()
        sut.requests = condition.premiseRequests
        sut.onTap(condition.role)
        #expect(sut.requests == condition.expectedRequests)
        #expect(sut.expression == condition.expectedExpression)
    }

    @Test(arguments: [
        .init(
            role: .command(.plusMinus),
            premiseRequests: [],
            expectedRequests: [],
            expectedExpression: "0"
        ),
        .init(
            role: .command(.plusMinus),
            premiseRequests: [.operator(.subtraction)],
            expectedRequests: [.operator(.subtraction)],
            expectedExpression: "-"
        ),
        .init(
            role: .command(.plusMinus),
            premiseRequests: [.operator(.subtraction), .term(.init(1))],
            expectedRequests: [.term(.init(1))],
            expectedExpression: "1"
        ),
        .init(
            role: .command(.plusMinus),
            premiseRequests: [.term(.init(1))],
            expectedRequests: [.operator(.subtraction), .term(.init(1))],
            expectedExpression: "-1"
        ),
        .init(
            role: .command(.plusMinus),
            premiseRequests: [.term(.init(1)), .operator(.subtraction), .term(.init(0))],
            expectedRequests: [.term(.init(1)), .operator(.addition), .term(.init(0))],
            expectedExpression: "1+0"
        ),
        .init(
            role: .command(.plusMinus),
            premiseRequests: [.term(.init(1)), .operator(.addition), .term(.init(0))],
            expectedRequests: [.term(.init(1)), .operator(.subtraction), .term(.init(0))],
            expectedExpression: "1-0"
        ),
        .init(
            role: .command(.plusMinus),
            premiseRequests: [.operator(.multiplication), .term(.init(1))],
            expectedRequests: [.operator(.multiplication), .operator(.subtraction), .term(.init(1))],
            expectedExpression: "×-1"
        ),
        .init(
            role: .command(.plusMinus),
            premiseRequests: [.operator(.multiplication), .operator(.subtraction), .term(.init(1))],
            expectedRequests: [.operator(.multiplication), .term(.init(1))],
            expectedExpression: "×1"
        ),
        .init(
            role: .command(.plusMinus),
            premiseRequests: [.operator(.division), .term(.init(1))],
            expectedRequests: [.operator(.division), .operator(.subtraction), .term(.init(1))],
            expectedExpression: "÷-1"
        ),
        .init(
            role: .command(.plusMinus),
            premiseRequests: [.operator(.division), .operator(.subtraction), .term(.init(1))],
            expectedRequests: [.operator(.division), .term(.init(1))],
            expectedExpression: "÷1"
        ),
        .init(
            role: .command(.plusMinus),
            premiseRequests: [.operator(.modulus), .operator(.subtraction), .term(.init(1))],
            expectedRequests: [.operator(.modulus), .term(.init(1))],
            expectedExpression: "%1"
        ),
        .init(
            role: .command(.plusMinus),
            premiseRequests: [.operator(.modulus), .term(.init(1))],
            expectedRequests: [.operator(.modulus), .operator(.subtraction), .term(.init(1))],
            expectedExpression: "%-1"
        ),
    ] as [OnTapCondition])
    @MainActor
    func onTap_plus_minus(_ condition: OnTapCondition) {
        let sut = CalcPickerEngine()
        sut.requests = condition.premiseRequests
        sut.onTap(condition.role)
        #expect(sut.requests == condition.expectedRequests)
        #expect(sut.expression == condition.expectedExpression)
    }

    @Test @MainActor
    func onTap_calculate_skipped() {
        let sut = CalcPickerEngine()
        sut.requests = [.term(.init(1)), .operator(.multiplication), .operator(.subtraction)]
        sut.onTap(.command(.calculate))
        #expect(sut.requests == [.term(.init(1)), .operator(.multiplication), .operator(.subtraction)])
    }

    @Test @MainActor
    func onTap_calculate_succeeded() {
        let sut = CalcPickerEngine()
        sut.requests = [.term(.init(1)), .operator(.multiplication), .operator(.subtraction), .term(.init(1))]
        sut.onTap(.command(.calculate))
        #expect(sut.requests == [.operator(.subtraction), .term(.init(1))])
        #expect(sut.expression == "-1")
    }

    @Test(arguments: [.division, .modulus] as [Operator])
    @MainActor
    func onTap_calculate_failed(_ o: Operator) {
        let sut = CalcPickerEngine()
        sut.requests = [.term(.init(1)), .operator(o), .term(.init(0))]
        sut.onTap(.command(.calculate))
        #expect(sut.requests.isEmpty)
        #expect(sut.error == .undefined)
    }

    @Test @MainActor
    func onTap_allClear() {
        let sut = CalcPickerEngine()
        sut.requests = [.term(.init(1)), .operator(.addition), .term(.init(1))]
        sut.onTap(.command(.allClear))
        #expect(sut.requests.isEmpty)
        #expect(sut.expression == "0")
    }

    @Test(arguments: [
        .init(
            role: .command(.clear),
            premiseRequests: [.term(.init(0))],
            expectedRequests: [],
            expectedExpression: "0"
        ),
        .init(
            role: .command(.clear),
            premiseRequests: [.operator(.subtraction), .term(.init(1))],
            expectedRequests: [.operator(.subtraction)],
            expectedExpression: "-"
        ),
    ] as [OnTapCondition])
    @MainActor
    func onTap_clear(_ condition: OnTapCondition) {
        let sut = CalcPickerEngine()
        sut.requests = condition.premiseRequests
        sut.onTap(condition.role)
        #expect(sut.requests == condition.expectedRequests)
        #expect(sut.expression == condition.expectedExpression)
    }

    @Test(arguments: [
        .init(
            role: .command(.delete),
            premiseRequests: [],
            expectedRequests: [],
            expectedExpression: "0"
        ),
        .init(
            role: .command(.delete),
            premiseRequests: [.term(.init(digits: [.number(1)]))],
            expectedRequests: [],
            expectedExpression: "0"
        ),
        .init(
            role: .command(.delete),
            premiseRequests: [.term(.init(digits: [.number(1), .number(2)]))],
            expectedRequests: [.term(.init(digits: [.number(1)]))],
            expectedExpression: "1"
        ),
        .init(
            role: .command(.delete),
            premiseRequests: [.term(.init(digits: [.number(1), .period]))],
            expectedRequests: [.term(.init(digits: [.number(1)]))],
            expectedExpression: "1"
        ),
        .init(
            role: .command(.delete),
            premiseRequests: [.term(.init(digits: [.number(1), .period, .number(2)]))],
            expectedRequests: [.term(.init(digits: [.number(1), .period]))],
            expectedExpression: "1."
        ),
        .init(
            role: .command(.delete),
            premiseRequests: [.term(.init(digits: [.number(1), .period])), .operator(.addition)],
            expectedRequests: [.term(.init(digits: [.number(1), .period]))],
            expectedExpression: "1."
        ),
        .init(
            role: .command(.delete),
            premiseRequests: [.term(.init(digits: [.number(1), .period, .number(2)])), .operator(.addition)],
            expectedRequests: [.term(.init(digits: [.number(1), .period, .number(2)]))],
            expectedExpression: "1.2"
        ),
        .init(
            role: .command(.delete),
            premiseRequests: [.term(.init(0)), .operator(.addition)],
            expectedRequests: [.term(.init(0))],
            expectedExpression: "0"
        ),
        .init(
            role: .command(.delete),
            premiseRequests: [.operator(.subtraction)],
            expectedRequests: [],
            expectedExpression: "0"
        ),
        .init(
            role: .command(.delete),
            premiseRequests: [.term(.init(0)), .operator(.subtraction)],
            expectedRequests: [.term(.init(0))],
            expectedExpression: "0"
        ),
        .init(
            role: .command(.delete),
            premiseRequests: [.term(.init(0)), .operator(.multiplication)],
            expectedRequests: [.term(.init(0))],
            expectedExpression: "0"
        ),
        .init(
            role: .command(.delete),
            premiseRequests: [.term(.init(0)), .operator(.division)],
            expectedRequests: [.term(.init(0))],
            expectedExpression: "0"
        ),
        .init(
            role: .command(.delete),
            premiseRequests: [.term(.init(0)), .operator(.modulus)],
            expectedRequests: [.term(.init(0))],
            expectedExpression: "0"
        ),
    ] as [OnTapCondition])
    @MainActor
    func onTap_delete(_ condition: OnTapCondition) {
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
