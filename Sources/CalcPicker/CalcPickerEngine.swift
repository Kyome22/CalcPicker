import SwiftUI
import Observation

@MainActor @Observable final class CalcPickerEngine {
    var rows: [Row]

    var requests: [Request] {
        didSet {
            rows[0].cells[0].role = if requests.isAllClear {
                .command(.allClear)
            } else {
                .command(.delete)
            }
        }
    }

    var expression: String {
        if requests.isEmpty {
            "0"
        } else {
            requests.map(\.description).joined()
        }
    }

    var handleDismiss: (() -> Void)?

    init() {
        rows = [
            Row(cells: [
                .init(area: .upperSide, role: .command(.allClear)),
                .init(area: .upperSide, role: .command(.plusMinus)),
                .init(area: .upperSide, role: .operator(.modulus)),
                .init(area: .rightSide, role: .operator(.division)),
            ]),
            Row(cells: [
                .init(area: .main, role: .number(7)),
                .init(area: .main, role: .number(8)),
                .init(area: .main, role: .number(9)),
                .init(area: .rightSide, role: .operator(.multiplication)),
            ]),
            Row(cells: [
                .init(area: .main, role: .number(4)),
                .init(area: .main, role: .number(5)),
                .init(area: .main, role: .number(6)),
                .init(area: .rightSide, role: .operator(.subtraction)),
            ]),
            Row(cells: [
                .init(area: .main, role: .number(1)),
                .init(area: .main, role: .number(2)),
                .init(area: .main, role: .number(3)),
                .init(area: .rightSide, role: .operator(.addition)),
            ]),
            Row(cells: [
                .init(area: .main, role: .command(.complete)),
                .init(area: .main, role: .number(0)),
                .init(area: .main, role: .period),
                .init(area: .rightSide, role: .command(.calculate)),
            ]),
        ]
        requests = []
    }

    func onTap(_ cell: Cell) {
        switch cell.role {
        case let .number(value):
            handle(number: value)
        case .period:
            handlePeriod()
        case let .operator(value):
            handle(operator: value)
        case let .command(value):
            handle(command: value)
        }
    }

    private func handle(number input: Int) {
        if case var .term(value) = requests.last {
            if value.isZero {
                value.digits = [.number(input)]
            } else {
                value.digits.append(.number(input))
            }
            requests[requests.count - 1] = .term(value)
        } else {
            requests.append(.term(.init(digits: [.number(input)])))
        }
    }

    private func handlePeriod() {
        if case var .term(value) = requests.last {
            guard !value.digits.contains(.period) else {
                return
            }
            value.digits.append(.period)
            requests[requests.count - 1] = .term(value)
        } else {
            requests.append(.term(.init(digits: [.number(0), .period])))
        }
    }

    private func handle(operator input: Operator) {
        switch requests.last {
        case .term:
            requests.append(.operator(input))
        case let .operator(value):
            switch value {
            case .subtraction:
                if requests.count == 1 {
                    if input != .subtraction {
                        requests.removeAll()
                    }
                } else if case let .operator(preValue) = requests.dropLast().last, [.multiplication, .division].contains(preValue) {
                    requests.removeLast(2)
                    requests.append(.operator(input))
                } else if input != .subtraction {
                    requests.removeLast()
                    requests.append(.operator(input))
                }
            case .modulus:
                requests.append(.operator(input))
            case .multiplication, .division:
                if input != .subtraction {
                    requests.removeLast()
                }
                requests.append(.operator(input))
            default:
                requests.removeLast()
                requests.append(.operator(input))
            }
        case .none:
            if input != .subtraction {
                requests.append(.term(.init(digits: [.number(0)])))
            }
            requests.append(.operator(input))
        }
    }

    private func handle(command input: Command) {
        switch input {
        case .plusMinus:
            guard case .term = requests.last else {
                return
            }
            if requests.count == 1 {
                requests.insert(.operator(.subtraction), at: 0)
            } else if case let .operator(value) = requests.dropLast().last {
                if case .term = requests.dropLast(2).last {
                    switch value {
                    case .addition:
                        requests[requests.count - 2] = .operator(.subtraction)
                    case .subtraction:
                        requests[requests.count - 2] = .operator(.addition)
                    case .multiplication, .division, .modulus:
                        requests.insert(.operator(.subtraction), at: requests.count - 1)
                    }
                } else if case let .operator(preValue) = requests.dropLast(2).last {
                    switch (preValue, value) {
                    case (.multiplication, .subtraction), (.division, .subtraction):
                        requests.remove(at: requests.count - 2)
                    case (.modulus, .addition):
                        requests[requests.count - 2] = .operator(.subtraction)
                    case (.modulus, .subtraction):
                        requests[requests.count - 2] = .operator(.addition)
                    case (.modulus, .multiplication), (.modulus, .division):
                        requests.insert(.operator(.subtraction), at: requests.count - 1)
                    default:
                        break
                    }
                } else if value == .subtraction {
                    requests.remove(at: requests.count - 2)
                } else if value == .addition {
                    requests[requests.count - 2] = .operator(.subtraction)
                }
            }
        case .calculate:
            break
        case .allClear:
            requests.removeAll()
        case .delete:
            if case var .term(value) = requests.last {
                value.digits.removeLast()
                if value.digits.isEmpty {
                    requests.removeLast()
                } else {
                    requests[requests.count - 1] = .term(value)
                }
            } else {
                requests.removeLast()
            }
        case .complete:
            handleDismiss?()
        }
    }
}
