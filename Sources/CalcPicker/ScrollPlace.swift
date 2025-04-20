import SwiftUI

enum ScrollPlace: Equatable {
    case fit
    case start
    case between
    case end

    init(width: CGFloat, frame: CGRect) {
        self = if width == frame.width {
            .fit
        } else if frame.minX.rounded() > -5 {
            .start
        } else if frame.maxX.rounded() < width + 5 {
            .end
        } else {
            .between
        }
    }
}

extension ScrollPlace {
    var stops: [Gradient.Stop] {
        switch self {
        case .fit:
            []
        case .start:
            [
                .init(color: .black, location: 0.0),
                .init(color: .black, location: 0.8),
                .init(color: .clear, location: 1.0),
            ]
        case .between:
            [
                .init(color: .clear, location: 0.0),
                .init(color: .black, location: 0.2),
                .init(color: .black, location: 0.8),
                .init(color: .clear, location: 1.0),
            ]
        case .end:
            [
                .init(color: .clear, location: 0.0),
                .init(color: .black, location: 0.2),
                .init(color: .black, location: 1.0),
            ]
        }
    }

    @ViewBuilder
    var mask: some View {
        switch self {
        case .fit:
            Color.black
        case .start, .between, .end:
            LinearGradient(stops: stops, startPoint: .leading, endPoint: .trailing)
        }
    }
}
