# Settings Module

App configuration screen: Morse timing thresholds, feedback toggles (sound/vibration), difficulty level, and reset to defaults.

## Key types

- `SettingsView` / `SettingsViewModel` — settings form

## Entry point

`SettingsView` is the tab root. No outgoing navigation.

## Dependencies

- **Data:** `SettingsStore` (injected via `@Environment`, not via repository protocol)
- **Domain:** `Difficulty` (enum used for difficulty picker)

## Constraints

- `SettingsView` binds directly to `SettingsStore` using `@Bindable`; `SettingsViewModel` exists but is not currently used by the View.
- `SettingsStore` is an `@Observable` object backed by UserDefaults — changes persist immediately, no explicit save action.
