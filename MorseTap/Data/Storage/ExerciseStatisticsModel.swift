import Foundation
import SwiftData

@Model
final class ExerciseStatisticsModel {
    @Attribute(.unique) var modeRawValue: String
    var totalAttempts: Int
    var correctAttempts: Int
    var totalTime: TimeInterval
    var lastPlayedDate: Date?
    
    var accuracy: Double {
        guard totalAttempts > 0 else { return 0 }
        return Double(correctAttempts) / Double(totalAttempts)
    }
    
    var averageTime: TimeInterval {
        guard totalAttempts > 0 else { return 0 }
        return totalTime / Double(totalAttempts)
    }
    
    init(
        modeRawValue: String,
        totalAttempts: Int = 0,
        correctAttempts: Int = 0,
        totalTime: TimeInterval = 0,
        lastPlayedDate: Date? = nil
    ) {
        self.modeRawValue = modeRawValue
        self.totalAttempts = totalAttempts
        self.correctAttempts = correctAttempts
        self.totalTime = totalTime
        self.lastPlayedDate = lastPlayedDate
    }
}
