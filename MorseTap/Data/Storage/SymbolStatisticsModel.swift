import Foundation
import SwiftData

@Model
final class SymbolStatisticsModel {
    @Attribute(.unique) var symbol: String
    var totalAttempts: Int
    var correctAttempts: Int
    var totalInputTime: TimeInterval
    var lastTrainedDate: Date?
    
    var accuracy: Double {
        guard totalAttempts > 0 else { return 0 }
        return Double(correctAttempts) / Double(totalAttempts)
    }
    
    var averageInputTime: TimeInterval {
        guard totalAttempts > 0 else { return 0 }
        return totalInputTime / Double(totalAttempts)
    }
    
    init(
        symbol: String,
        totalAttempts: Int = 0,
        correctAttempts: Int = 0,
        totalInputTime: TimeInterval = 0,
        lastTrainedDate: Date? = nil
    ) {
        self.symbol = symbol
        self.totalAttempts = totalAttempts
        self.correctAttempts = correctAttempts
        self.totalInputTime = totalInputTime
        self.lastTrainedDate = lastTrainedDate
    }
}
