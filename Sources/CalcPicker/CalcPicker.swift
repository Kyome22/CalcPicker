import SwiftUI

public struct CalcPicker: View {
    @State private var engine = CalcPickerEngine()
    @Binding private var value: Double

    public init(value: Binding<Double>) {
        _value = value
    }

    public var body: some View {
        VStack {
            Text(engine.expression)
                .font(.title)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .foregroundStyle(Color.primary)
            ForEach(engine.rows) { row in
                HStack {
                    ForEach(row.cells) { cell in
                        Button {
                            engine.onTap(cell)
                        } label: {
                            Circle()
                                .fill(cell.area.color)
                                .frame(width: 40, height: 40)
                                .overlay {
                                    cell.role.body
                                        .fontWeight(.bold)
                                        .foregroundStyle(Color.white)
                                }
                        }
                    }
                }
            }
        }
        .padding(8)
    }
}

extension Row.Cell.Area {
    var color: Color {
        switch self {
        case .main:
            Color(.main)
        case .upperSide:
            Color(.upperSide)
        case .rightSide:
            Color(.rightSide)
        }
    }
}

extension Operator {
    var image: Image {
        switch self {
        case .addition:
            Image(systemName: "plus")
        case .subtraction:
            Image(systemName: "minus")
        case .multiplication:
            Image(systemName: "multiply")
        case .division:
            Image(systemName: "divide")
        case .modulus:
            Image(systemName: "percent")
        }
    }
}

extension Row.Cell.Role.Command {
    @ViewBuilder
    var body: some View {
        switch self {
        case .plusMinus:
            Image(systemName: "plus.slash.minus")
        case .calculate:
            Image(systemName: "equal")
        case .allClear:
            Text(verbatim: "AC")
        case .delete:
            Image(systemName: "delete.backward")
        case .complete:
            Image(systemName: "text.append")
        }
    }
}

extension Row.Cell.Role {
    @ViewBuilder
    var body: some View {
        switch self {
        case let .number(value):
            Text(value.description)
        case .period:
            Text(verbatim: ".")
        case let .operator(value):
            value.image
        case let .command(value):
            value.body
        }
    }
}
