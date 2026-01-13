import Foundation

@Observable
final class SettingsStore {
    
    private let defaults = UserDefaults.standard
    
    private enum Keys {
        static let dotMaxDuration = "settings.dotMaxDuration"
        static let dashMinDuration = "settings.dashMinDuration"
        static let symbolPauseDuration = "settings.symbolPauseDuration"
        static let soundEnabled = "settings.soundEnabled"
        static let vibrationEnabled = "settings.vibrationEnabled"
        static let difficulty = "settings.difficulty"
    }
    
    static let defaultDotMaxDuration: TimeInterval = 0.2
    static let defaultDashMinDuration: TimeInterval = 0.2
    static let defaultSymbolPauseDuration: TimeInterval = 0.6
    
    var dotMaxDuration: TimeInterval {
        didSet { defaults.set(dotMaxDuration, forKey: Keys.dotMaxDuration) }
    }
    
    var dashMinDuration: TimeInterval {
        didSet { defaults.set(dashMinDuration, forKey: Keys.dashMinDuration) }
    }
    
    var symbolPauseDuration: TimeInterval {
        didSet { defaults.set(symbolPauseDuration, forKey: Keys.symbolPauseDuration) }
    }
    
    var soundEnabled: Bool {
        didSet { defaults.set(soundEnabled, forKey: Keys.soundEnabled) }
    }
    
    var vibrationEnabled: Bool {
        didSet {
            defaults.set(vibrationEnabled, forKey: Keys.vibrationEnabled)
            HapticFeedbackManager.shared.isEnabled = vibrationEnabled
        }
    }
    
    var difficulty: Difficulty {
        didSet { defaults.set(difficulty.rawValue, forKey: Keys.difficulty) }
    }
    
    init() {
        self.dotMaxDuration = defaults.object(forKey: Keys.dotMaxDuration) as? TimeInterval
            ?? Self.defaultDotMaxDuration
        self.dashMinDuration = defaults.object(forKey: Keys.dashMinDuration) as? TimeInterval
            ?? Self.defaultDashMinDuration
        self.symbolPauseDuration = defaults.object(forKey: Keys.symbolPauseDuration) as? TimeInterval
            ?? Self.defaultSymbolPauseDuration
        self.soundEnabled = defaults.object(forKey: Keys.soundEnabled) as? Bool ?? true
        self.vibrationEnabled = defaults.object(forKey: Keys.vibrationEnabled) as? Bool ?? true
        self.difficulty = Difficulty(rawValue: defaults.string(forKey: Keys.difficulty) ?? "") ?? .beginner
        
        HapticFeedbackManager.shared.isEnabled = self.vibrationEnabled
    }
    
    var timingConfig: MorseTimingConfig {
        let multiplier = difficulty.timingMultiplier
        return MorseTimingConfig(
            dotMaxDuration: dotMaxDuration * multiplier,
            dashMinDuration: dashMinDuration * multiplier,
            symbolPauseDuration: symbolPauseDuration * multiplier
        )
    }
    
    func resetToDefaults() {
        dotMaxDuration = Self.defaultDotMaxDuration
        dashMinDuration = Self.defaultDashMinDuration
        symbolPauseDuration = Self.defaultSymbolPauseDuration
        soundEnabled = true
        vibrationEnabled = true
        difficulty = .beginner
    }
}
