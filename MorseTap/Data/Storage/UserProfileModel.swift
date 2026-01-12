import Foundation
import SwiftData

@Model
final class UserProfileModel {
    var firstLaunchDate: Date
    var currentStreak: Int
    var longestStreak: Int
    var lastActivityDate: Date
    
    init(
        firstLaunchDate: Date = Date(),
        currentStreak: Int = 0,
        longestStreak: Int = 0,
        lastActivityDate: Date = Date()
    ) {
        self.firstLaunchDate = firstLaunchDate
        self.currentStreak = currentStreak
        self.longestStreak = longestStreak
        self.lastActivityDate = lastActivityDate
    }
}
