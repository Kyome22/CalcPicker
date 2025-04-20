import Foundation

enum CalcPickerError: LocalizedError {
    case undefined

    var errorDescription: String? {
        switch self {
        case .undefined:
            "Undefined"
        }
    }
}
