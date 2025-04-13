import Foundation

struct Row: Identifiable {
    var id = UUID()
    var cells: [Cell]

    struct Cell: Identifiable {
        var id = UUID()
        var area: Area
        var role: Role

        enum Area {
            case main
            case upperSide
            case rightSide
        }

        enum Role {
            case number(Int)
            case period
            case `operator`(Operator)
            case command(Command)

            enum Command {
                case plusMinus
                case calculate
                case allClear
                case delete
                case complete
            }
        }
    }
}
