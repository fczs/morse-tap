# UI Component: Morse Input Button + Live Signals View

## Goals

- Provide a reusable SwiftUI component for Morse code input via press-and-hold gesture
- Display entered signals (dots/dashes) for the current symbol in real-time
- Enable haptic feedback integration for input confirmation

## Functional requirements

### Presentation/

- No changes to existing screens; component is standalone and reusable

### Domain/

- No new domain logic; integrate with existing `MorseInputEngine` from T3

### Shared/Components

- Add `MorseInputButton` — large circular button handling press-and-hold gesture
- Add `MorseSignalsView` — visual display of entered signals (dots/dashes) for current symbol
- Add `MorseInputView` — composite component combining button and signals display
- Expose callbacks: `onSignalAdded`, `onSymbolCompleted`
- Provide haptic feedback hooks (can be stubbed for initial implementation)

### Shared/Utilities

- Add `HapticFeedbackManager` stub for future haptic integration

## Out-of-scope

- Business logic and exercise flow
- Navigation and screen integration
- Actual haptic feedback implementation (stub only)
- Sound feedback
- Settings and configuration screens
- Data persistence

## Affected layers and modules (Yes/No/Unknown)

- App/: No
- Presentation/Learn: No
- Presentation/Practice: No
- Presentation/Progress: No
- Presentation/Settings: No
- Domain/Services: No (uses existing MorseInputEngine)
- Domain/UseCases: No
- Domain/Models: No
- Data/Repositories: No
- Data/Storage: No
- Shared/Components: Yes
- Shared/Utilities: Yes
- Shared/Extensions: Unknown

## Dependencies and artifacts

- Task T3: Universal Morse Input Engine (completed) — provides `MorseInputEngine`, `MorseSignal`
- TECH_SPEC.md: Section 4.2 (Input via Large Circular Button)
- AGENTS.md: Shared/Components section (`MorseInputButton`, `MorseCodeDisplay`)
