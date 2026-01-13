import Foundation

enum Difficulty: String, CaseIterable, Codable {
    case beginner
    case intermediate
    case advanced
    
    var displayName: String {
        switch self {
        case .beginner: return "Beginner"
        case .intermediate: return "Intermediate"
        case .advanced: return "Advanced"
        }
    }
    
    var timingMultiplier: Double {
        switch self {
        case .beginner: return 1.5
        case .intermediate: return 1.0
        case .advanced: return 0.7
        }
    }
    
    var description: String {
        switch self {
        case .beginner: return "Slower timing, more forgiving"
        case .intermediate: return "Standard Morse timing"
        case .advanced: return "Faster timing, more precise"
        }
    }
}
