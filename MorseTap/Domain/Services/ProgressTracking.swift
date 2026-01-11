import Foundation

protocol ProgressTracking {
    /// Records practice attempt
    func recordAttempt(symbol: Character, isCorrect: Bool, duration: TimeInterval)
    
    /// Returns aggregated statistics
    func getStatistics() -> Statistics
    
    /// Returns symbols needing more practice
    func getWeakSymbols() -> [Character]
}
