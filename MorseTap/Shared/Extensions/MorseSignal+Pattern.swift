import Foundation

extension Array where Element == MorseSignal {
    
    /// Converts array of MorseSignal to pattern string
    /// Example: [.dot, .dash] → ".-"
    var asPattern: String {
        map { signal in
            switch signal {
            case .dot: return "."
            case .dash: return "-"
            }
        }.joined()
    }
}
