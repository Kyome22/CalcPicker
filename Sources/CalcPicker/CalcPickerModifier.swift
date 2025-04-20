import SwiftUI

public struct CalcPickerModifier: ViewModifier {
    @Binding var value: String
    @Binding var isPresented: Bool
    var attachmentAnchor: PopoverAttachmentAnchor
    var arrowEdge: Edge?

    public init(
        value: Binding<String>,
        isPresented: Binding<Bool>,
        attachmentAnchor: PopoverAttachmentAnchor = .rect(.bounds),
        arrowEdge: Edge? = nil
    ) {
        _value = value
        _isPresented = isPresented
        self.attachmentAnchor = attachmentAnchor
        self.arrowEdge = arrowEdge
    }

    public func body(content: Content) -> some View {
        content.popover(
            isPresented: $isPresented,
            attachmentAnchor: attachmentAnchor,
            arrowEdge: arrowEdge
        ) {
            CalcPicker(value: $value)
                .clipShape(Rectangle())
                .presentationCompactAdaptation(.popover)
                .presentationBackground(.ultraThinMaterial)
        }
    }
}

extension View {
    public func calcPicker(
        value: Binding<String>,
        isPresented: Binding<Bool>,
        attachmentAnchor: PopoverAttachmentAnchor = .rect(.bounds),
        arrowEdge: Edge? = nil
    ) -> some View {
        modifier(CalcPickerModifier(
            value: value,
            isPresented: isPresented,
            attachmentAnchor: attachmentAnchor,
            arrowEdge: arrowEdge
        ))
    }
}
