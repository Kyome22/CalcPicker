import SwiftUI

public struct CalcPicker: View {
    @State private var engine = CalcPickerEngine()
    @State private var scrollPlace = ScrollPlace.fit
    @Binding private var value: String
    @Environment(\.dismiss) private var dismiss

    public init(value: Binding<String>) {
        _value = value
    }

    public var body: some View {
        VStack(spacing: 8) {
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    Text(engine.expression)
                        .font(.title)
                        .fontWeight(.semibold)
                        .fontDesign(.monospaced)
                        .lineLimit(1)
                        .foregroundStyle(Color.primary)
                        .frame(minWidth: 184, alignment: .trailing) // 40*4+8*3
                        .id("expression")
                        .background {
                            GeometryReader { proxy in
                                Color.clear.preference(
                                    key: ScrollPlacePreferenceKey.self,
                                    value: ScrollPlace(width: 184, frame: proxy.frame(in: .named("scroll")))
                                )
                            }
                        }
                }
                .scrollBounceBehavior(.basedOnSize, axes: .horizontal)
                .frame(width: 184)
                .mask(scrollPlace.mask)
                .coordinateSpace(name: "scroll")
                .onPreferenceChange(ScrollPlacePreferenceKey.self) { value in
                    MainActor.assumeIsolated {
                        scrollPlace = value
                    }
                }
                .onChange(of: engine.expression) { _, newValue in
                    value =  newValue
                    proxy.scrollTo("expression", anchor: .trailing)
                }
            }
            ForEach(engine.rows) { row in
                HStack(spacing: 8) {
                    ForEach(row.cells) { cell in
                        Button {
                            engine.onTap(cell.role)
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
                        .accessibilityIdentifier(cell.role.accessibilityIdentifier)
                    }
                }
            }
        }
        .padding(8)
        .fixedSize()
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("calcPicker")
        .onAppear {
            engine.handleDismiss = { dismiss() }
        }
    }
}
