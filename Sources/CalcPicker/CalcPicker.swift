import SwiftUI

public struct CalcPicker: View {
    @State private var engine = CalcPickerEngine()
    @Binding private var value: Double
    @Environment(\.dismiss) private var dismiss

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
        .onAppear {
            engine.handleDismiss = { dismiss() }
        }
//        .onChange(of: engine.expression) { _, newValue in
//            value = 
//        }
    }
}
