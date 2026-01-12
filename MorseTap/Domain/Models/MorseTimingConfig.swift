import Foundation

struct MorseTimingConfig {
    var dotMaxDuration: TimeInterval
    var dashMinDuration: TimeInterval
    var symbolPauseDuration: TimeInterval
    
    static var standard: MorseTimingConfig {
        MorseTimingConfig(
            dotMaxDuration: 0.2,
            dashMinDuration: 0.2,
            symbolPauseDuration: 0.6
        )
    }
}
