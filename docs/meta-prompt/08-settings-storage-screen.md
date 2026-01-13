# Settings: UserDefaults + Screen

## Goals

- Implement persistent settings storage using UserDefaults
- Create Settings screen with controls for all configurable options
- Provide injectable settings store for use across the app

## Functional requirements

### Data/Storage

- Create `SettingsStore` with UserDefaults-backed properties
- Store timing thresholds: dotMaxDuration, dashMinDuration, symbolPauseDuration
- Store preferences: soundEnabled, vibrationEnabled
- Store difficulty level (enum)
- Make `SettingsStore` observable for SwiftUI binding

### Presentation/Settings

- Update `SettingsView` with full UI implementation
- Sliders for timing thresholds with value labels
- Toggles for sound and vibration
- Picker for difficulty level
- Group controls logically (Timing, Feedback, Difficulty)
- Reset to defaults option

### Domain/Models

- Update `Difficulty` enum for persistence and UI (CaseIterable, rawValue)

### Domain/Services

- Wire `MorseInputEngine` to consume timing config from `SettingsStore`

### App/

- Inject `SettingsStore` into environment at app entry point

## Out-of-scope

- iCloud sync for settings
- Advanced timing presets
- Per-symbol custom timings
- Theme/appearance settings

## Affected layers and modules (Yes/No/Unknown)

- App/: Yes
- Presentation/Learn: No
- Presentation/Practice: No
- Presentation/Progress: No
- Presentation/Settings: Yes
- Domain/Services: Yes
- Domain/UseCases: No
- Domain/Models: Yes
- Data/Repositories: No
- Data/Storage: Yes
- Shared/Components: No
- Shared/Utilities: No

## Dependencies and artifacts

- Task T3: Morse Input Engine (completed) — provides `MorseTimingConfig`
- TECH_SPEC.md: Section 4.4 (Settings Screen)
- AGENTS.md: Data/Storage and Presentation/Settings sections
