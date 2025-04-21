import SwiftUI
import Observation

@MainActor @Observable final class CalcPickerEngine {
    var rows: [Row]

    var requests: [Request] {
        didSet {
            rows[0].cells[0].role = if error != nil || requests.isAllClear {
                .command(.allClear)
            } else {
                .command(.delete)
            }
        }
    }

    var expression: String {
        if let error {
            error.localizedDescription
        } else if requests.isEmpty {
            "0"
        } else {
            requests.map(\.description).joined()
        }
    }

    var handleDismiss: (() -> Void)?

    var error: CalcPickerError?

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

    func onTap(_ role: Role) {
        switch role {
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
        switch requests.last {
        case var .term(value):
            if value.digits == [.number(0)] {
                value.digits = [.number(input)]
            } else {
                value.digits.append(.number(input))
            }
            requests[requests.count - 1] = .term(value)
        case .operator:
            requests.append(.term(.init(digits: [.number(input)])))
        case .none:
            if input != .zero {
                requests.append(.term(.init(digits: [.number(input)])))
            }
        }
        requests.expired()
    }

    private func handlePeriod() {
        switch requests.last {
        case var .term(value):
            guard !value.digits.contains(.period) else {
                return
            }
            value.digits.append(.period)
            requests[requests.count - 1] = .term(value)
        case .operator, .none:
            requests.append(.term(.init(digits: [.number(0), .period])))
        }
        requests.expired()
    }

    private func handle(operator input: Operator) {
        switch requests.last {
        case .term:
            requests.append(.operator(input))
        case let .operator(value):
            switch value {
            case .addition:
                requests.removeLast()
                requests.append(.operator(input))
            case .subtraction:
                guard input != .subtraction else {
                    return
                }
                switch requests.dropLast().last {
                case .term:
                    requests.removeLast()
                    requests.append(.operator(input))
                case .operator:
                    requests.removeLast(2)
                    requests.append(.operator(input))
                case .none:
                    requests.removeAll()
                }
            case .multiplication, .division, .modulus:
                if input != .subtraction {
                    requests.removeLast()
                }
                requests.append(.operator(input))
            }
        case .none:
            if input != .subtraction {
                requests.append(.term(.init(digits: [.number(0)])))
            }
            requests.append(.operator(input))
        }
        requests.expired()
    }

    private func handle(command input: Command) {
        switch input {
        case .plusMinus:
            guard case .term = requests.last else {
                return
            }
            switch requests.dropLast().last {
            case .term: // term term
                fatalError("Error: There are two or more consecutive terms.")
            case let .operator(value):
                switch requests.dropLast(2).last {
                case .term: // term operator term
                    switch value {
                    case .addition:
                        requests[requests.count - 2] = .operator(.subtraction)
                    case .subtraction:
                        requests[requests.count - 2] = .operator(.addition)
                    case .multiplication, .division, .modulus:
                        requests.insert(.operator(.subtraction), at: requests.count - 1)
                    }
                case let .operator(preValue): // operator operator term
                    switch (preValue, value) {
                    case (.multiplication, .subtraction),
                        (.division, .subtraction),
                        (.modulus, .subtraction):
                        requests.remove(at: requests.count - 2)
                    default:
                        fatalError("Error: There are two or more consecutive operators.")
                    }
                case .none: // operator term
                    if value == .subtraction {
                        requests.removeFirst()
                    } else {
                        requests.insert(.operator(.subtraction), at: 1)
                    }
                }
            case .none: // term
                requests.insert(.operator(.subtraction), at: 0)
            }
            requests.expired()
        case .calculate:
            do {
                guard let result = try requests.calculated() else {
                    return
                }
                requests = result
            } catch let error as CalcPickerError {
                self.error = error
                requests.removeAll()
            } catch {
                fatalError("Error: \(error.localizedDescription)")
            }
        case .allClear:
            error = nil
            requests.removeAll()
        case .delete:
            switch requests.last {
            case var .term(value):
                value.digits.removeLast()
                if value.digits.isEmpty {
                    requests.removeLast()
                } else {
                    requests[requests.count - 1] = .term(value)
                }
            case .operator:
                requests.removeLast()
            case .none:
                return
            }
        case .complete:
            handleDismiss?()
        }
    }
}
