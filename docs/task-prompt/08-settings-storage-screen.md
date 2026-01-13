# Settings: UserDefaults + Screen Implementation

## Affected modules

- `MorseTap/Data/Storage/SettingsStore.swift`
- `MorseTap/Presentation/Settings/SettingsView.swift`
- `MorseTap/Presentation/Settings/SettingsViewModel.swift`
- `MorseTap/Domain/Models/Difficulty.swift`
- `MorseTap/App/MorseTapApp.swift`

## Goal

Implement persistent settings storage using UserDefaults and a full Settings screen UI. Settings include timing thresholds, sound/vibration toggles, and difficulty level. The `SettingsStore` is injectable via SwiftUI Environment and provides `MorseTimingConfig` for `MorseInputEngine`.

## Dependencies

- Task T3: Morse Input Engine (completed) — provides `MorseTimingConfig`

## Execution plan

1. Update Difficulty enum for persistence
2. Create SettingsStore with UserDefaults
3. Update SettingsViewModel
4. Update SettingsView with full UI
5. Inject SettingsStore in app entry point
6. Add files to Xcode project
7. Build and verify

## Pre-implementation code preparation

1. Open the project in Xcode: `MorseTap.xcodeproj`
2. Verify `MorseTap/Domain/Models/MorseTimingConfig.swift` exists
3. Verify `MorseTap/Domain/Models/Difficulty.swift` exists

## Terms/Context

- **SettingsStore** — Observable class with UserDefaults-backed properties
- **Timing Thresholds** — dotMaxDuration, dashMinDuration, symbolPauseDuration
- **Feedback Preferences** — soundEnabled, vibrationEnabled

## Block requirements

### Domain Models

#### `MorseTap/Domain/Models/Difficulty.swift`

Update enum for persistence and UI:

```swift
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
}
```

### Data Storage

#### `MorseTap/Data/Storage/SettingsStore.swift`

Create new file:

```swift
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
```

### ViewModels

#### `MorseTap/Presentation/Settings/SettingsViewModel.swift`

Update ViewModel:

```swift
import Foundation

@Observable
@MainActor
final class SettingsViewModel {

    let settingsStore: SettingsStore

    init(settingsStore: SettingsStore) {
        self.settingsStore = settingsStore
    }

    func resetToDefaults() {
        settingsStore.resetToDefaults()
    }
}
```

### Views

#### `MorseTap/Presentation/Settings/SettingsView.swift`

Update with full UI:

- Use `Form` with `Section` for organization
- **Timing Section:**
  - Slider: Dot threshold (0.1 - 0.5s), step 0.05
  - Slider: Dash threshold (0.1 - 0.5s), step 0.05
  - Slider: Pause duration (0.3 - 1.5s), step 0.1
  - Display current value next to each slider
- **Feedback Section:**
  - Toggle: Sound enabled
  - Toggle: Vibration enabled
- **Difficulty Section:**
  - Picker: Difficulty level (segmented or wheel)
  - Text description of current difficulty effect
- **Actions Section:**
  - Button: Reset to Defaults (with confirmation alert optional)

Layout:

```swift
Form {
    Section("Timing") {
        // Sliders with labels
    }
    Section("Feedback") {
        // Toggles
    }
    Section("Difficulty") {
        // Picker
    }
    Section {
        // Reset button
    }
}
```

### App Entry Point

#### `MorseTap/App/MorseTapApp.swift`

Inject `SettingsStore` into environment:

```swift
@main
struct MorseTapApp: App {
    @State private var settingsStore = SettingsStore()

    var sharedModelContainer: ModelContainer = { ... }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(settingsStore)
        }
        .modelContainer(sharedModelContainer)
    }
}
```

### Refactoring

No major refactoring required.

### NFRs

- All files must compile without errors
- Settings persist across app restarts
- SwiftUI Previews must work
- Slider values display with 2 decimal precision
- Form scrolls smoothly
- Accessibility labels for VoiceOver

## Acceptance criteria

- [ ] App compiles without errors in Xcode
- [ ] `SettingsStore` created with all properties
- [ ] All values persist to UserDefaults
- [ ] Settings persist across app restarts
- [ ] `SettingsView` displays all controls
- [ ] Sliders adjust timing thresholds (0.1-0.5s for dot/dash, 0.3-1.5s for pause)
- [ ] Toggles control sound/vibration
- [ ] Difficulty picker works with all 3 options
- [ ] Reset to Defaults restores all values
- [ ] `timingConfig` returns correct values with difficulty multiplier
- [ ] Vibration toggle syncs with `HapticFeedbackManager.isEnabled`
- [ ] `SettingsStore` injected in app environment
- [ ] SwiftUI Previews work

## Post-implementation verification

1. Build the project: Xcode → Product → Build (⌘+B)
2. Run in Simulator
3. Navigate to Settings tab
4. Adjust all sliders and verify values update
5. Toggle sound and vibration
6. Change difficulty level
7. Force quit app (Simulator → Device → App Switcher → swipe up)
8. Relaunch and verify all settings persisted
9. Tap "Reset to Defaults" and verify values reset
10. Test haptic feedback respects vibration toggle (on device)

## Documentation update

### README.md

No changes required for this task.

### AGENTS.md

Verify Data/Storage and Presentation/Settings sections are accurate.

### Module AGENTS.md

Not applicable for this task.

## Post-implementation code preparation

1. Verify all new files are added to Xcode project
2. Ensure all files are properly formatted
3. Remove any debug print statements
4. Verify project builds in both Debug and Release configurations
5. Verify all SwiftUI Previews work
6. Prepare for code review
