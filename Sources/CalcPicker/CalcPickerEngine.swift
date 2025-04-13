import SwiftUI
import Observation

@MainActor @Observable final class CalcPickerEngine {
    var rows: [Row]
    var requests: [Request] {
        didSet {
            if requests.isEmpty || (requests.count == 1 && requests[0].isResult) {
                rows[0].cells[0].role = .command(.allClear)
            } else {
                rows[0].cells[0].role = .command(.delete)
            }
        }
    }
    var expression: String {
        if requests.isEmpty {
            "0"
        } else {
            requests.map { request in
                switch request {
                case let .number(value):
                    value.description
                case .period:
                    "."
                case let .operator(value):
                    value.description
                case let .result(value):
                    value.description
                }
            }
            .joined()
        }
    }
    private var lastNomial: Nomial? {
        let reversedRequest: [Request] = requests.reversed()
        guard let index = reversedRequest.lastIndex(where: { $0.isNumber }) else {
            return nil
        }
        if index + 1 < reversedRequest.count, reversedRequest[index + 1].isSubtractionOperator {
            let startIndex = reversedRequest.count - 1 - (index + 1)
            return Nomial(
                index: startIndex,
                requests: Array(requests[startIndex ..< requests.count])
            )
        } else {
            let startIndex = reversedRequest.count - 1 - index
            return Nomial(
                index: startIndex,
                requests: Array(requests[startIndex ..< requests.count])
            )
        }
    }
    private var lastOperators: [Operator] {
        var operators = [Operator]()
        if let request = requests.last, case let .operator(value) = request {
            operators.append(value)
            if let request = requests.dropLast().last, case let .operator(value) = request {
                operators.append(value)
            }
        }
        return operators
    }

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

    func onTap(_ cell: Row.Cell) {
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

    private func handle(number value: Int) {
        if let nominal = lastNomial {
            if nominal.requests.count == 1, nominal.requests[0].isZero {
                requests[nominal.index] = .number(value)
            } else {
                requests.append(.number(value))
            }
        } else if value != 0 {
            requests.append(.number(value))
        }
    }

    private func handlePeriod() {
        if let nominal = lastNomial {
            guard !nominal.requests.contains(where: { $0.isPeriod }) else {
                return
            }
            requests.append(.period)
        } else {
            requests.append(contentsOf: [.number(0), .period])
        }
    }

    private func handle(operator value: Operator) {
        if let request = requests.last {
            switch request {
            case .number, .period:
                requests.append(.operator(value))
            case .operator:
                switch lastOperators {
                case [.addition], [.subtraction], [.modulus]:
                    requests[requests.count - 1] = .operator(value)
                case [.multiplication], [.division]:
                    if value == .subtraction {
                        requests.append(.operator(.subtraction))
                    } else {
                        requests[requests.count - 1] = .operator(value)
                    }
                case [.multiplication, .subtraction], [.division, .subtraction]:
                    break
                 case [.modulus, .multiplication], [.modulus, .division]:
                    break
                default:
                    break
                }
            case .result:
                break
            }
        } else {
            if value != .subtraction {
                requests.append(.number(0))
            }
            requests.append(.operator(value))
        }
    }

    private func handle(command: Row.Cell.Role.Command) {
        switch command {
        case .plusMinus:
            if requests.count == 1, case let .result(value) = requests[0] {
                requests = value.description.compactMap {
                    switch $0 {
                    case "-":
                        Request.operator(.subtraction)
                    case "0", "1", "2", "3", "4", "5", "6", "7":
                        Request.number(Int($0.description)!)
                    case ".":
                        Request.period
                    default:
                        nil
                    }
                }
            } else {
                guard let nominal = lastNomial else { return }
                if nominal.requests[0].isSubtractionOperator {
                    requests.remove(at: nominal.index)
                } else {
                    requests.insert(.operator(.subtraction), at: nominal.index)
                }
            }
        case .calculate:
            break
        case .allClear:
            requests.removeAll()
        case .delete:
            requests.removeLast()
        case .complete:
            break
        }
    }
}

private struct Nomial {
    var index: Int
    var requests: [Request]
}
