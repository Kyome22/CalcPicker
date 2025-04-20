import SwiftUI

struct ScrollPlacePreferenceKey: PreferenceKey {
    typealias Value = ScrollPlace
    static let defaultValue: Value = .fit

    static func reduce(value _: inout Value, nextValue: () -> Value) {
        _ = nextValue()
    }
}
