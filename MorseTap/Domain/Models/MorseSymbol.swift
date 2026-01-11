import Foundation

struct MorseSymbol: Equatable, Hashable {
    let character: Character
    let pattern: String
    
    var signals: [MorseSignal] {
        pattern.compactMap { char in
            switch char {
            case ".":
                return .dot
            case "-":
                return .dash
            default:
                return nil
            }
        }
    }
}
