# Learn: Symbol Card + Repeat Input Implementation

## Affected modules

- `MorseTap/Presentation/Learn/SymbolCardView.swift`
- `MorseTap/Presentation/Learn/SymbolCardViewModel.swift`
- `MorseTap/Shared/Utilities/HapticFeedbackManager.swift`

## Goal

Implement the Symbol Card screen with interactive Morse input. User sees the symbol and its pattern, inputs Morse code via the button, receives immediate validation feedback, and the attempt is recorded in statistics.

## Dependencies

- Task T4: Morse Input UI Component (completed) — provides `MorseInputView`, `MorseInputEngine`
- Task T5: SwiftData Storage (completed) — provides `StatisticsRepository`
- Task T6: Symbol List Screen (completed) — provides navigation to Symbol Card

## Execution plan

1. Implement the requested changes (ViewModel, View, Utilities)
2. Type checks and build verification (Xcode build)
3. Post-implementation verification (SwiftUI previews, simulator testing)
4. Quality checks (SwiftLint, code review)
5. Documentation update (AGENTS.md if needed)
6. Finalization

## Pre-implementation code preparation

1. Open the project in Xcode: `MorseTap.xcodeproj`
2. Verify `MorseTap/Shared/Components/MorseInputView.swift` exists
3. Verify `MorseTap/Data/Repositories/StatisticsRepository.swift` exists
4. Verify `MorseTap/Presentation/Learn/SymbolCardView.swift` exists

## Terms/Context

- **Validation** — Comparing user-entered signals against expected symbol pattern
- **Input Time** — Duration from first signal to symbol completion
- **Attempt** — Single validation cycle (input → validate → record)

## Block requirements

### Domain Services

No changes. Uses existing `MorseAlphabet` for reference patterns.

### Data Repositories

No changes. Uses existing `StatisticsRepository.recordSymbolAttempt()`.

### ViewModels

#### `MorseTap/Presentation/Learn/SymbolCardViewModel.swift`

Create new ViewModel:

```swift
@Observable
@MainActor
final class SymbolCardViewModel {

    enum State {
        case ready
        case inputting
        case correct(inputTime: TimeInterval)
        case incorrect(expected: [MorseSignal], got: [MorseSignal])
    }

    let symbol: MorseSymbol
    private(set) var state: State = .ready

    private var inputStartTime: Date?
    private let statisticsRepository: StatisticsRepositoryProtocol?

    init(symbol: MorseSymbol, statisticsRepository: StatisticsRepositoryProtocol? = nil)

    func onSignalAdded(_ signal: MorseSignal)
    // Start tracking time on first signal
    // Update state to .inputting

    func onSymbolCompleted(_ signals: [MorseSignal]) async
    // Calculate input duration
    // Compare signals with symbol.signals
    // Update state to .correct or .incorrect
    // Trigger haptic feedback
    // Record attempt in repository

    func retry()
    // Reset state to .ready
    // Clear input start time
}
```

Key behaviors:

- Track input start time on first signal
- Validate by comparing `signals == symbol.signals`
- Record attempt with `recordSymbolAttempt(symbol:isCorrect:inputTime:)`
- Support retry without leaving screen

### Views

#### `MorseTap/Presentation/Learn/SymbolCardView.swift`

Update view with full implementation:

- Inject `SymbolCardViewModel` via init or Environment
- Display symbol character prominently (large font)
- Display expected Morse pattern using `MorseSignalsView`
- Integrate `MorseInputView` for user input
- Connect `onSignalAdded` and `onSymbolCompleted` to ViewModel
- Display state-based feedback:
  - `.ready` — neutral state, prompt to input
  - `.inputting` — show current input progress
  - `.correct` — success visual (green checkmark, input time)
  - `.incorrect` — error visual (red X, show expected vs got)
- Provide "Try Again" button in `.correct` or `.incorrect` states
- Trigger haptic feedback via `HapticFeedbackManager`

Layout structure:

```
VStack {
    Symbol character (large)
    Expected pattern (MorseSignalsView)

    Spacer

    Feedback area (state-dependent)

    MorseInputView (hidden in result states, or show retry button)
}
```

### Shared Components

No changes. Uses existing `MorseInputView`.

### Utilities

#### `MorseTap/Shared/Utilities/HapticFeedbackManager.swift`

Add success feedback method:

```swift
func successFeedback() {
    guard isEnabled else { return }
    notificationGenerator.notificationOccurred(.success)
}
```

### Models/Types

No new models. Uses existing `MorseSymbol`, `MorseSignal`.

### Refactoring

No refactoring required.

### NFRs

- All files must compile without errors
- SwiftUI Previews must render correctly for all states
- ViewModel must support dependency injection for testing
- Preview must work without real repository (mock mode)
- Input time displayed with 1 decimal precision (e.g., "1.2s")
- Feedback must be immediate (no perceptible delay)
- Accessibility labels for VoiceOver

## Acceptance criteria

- [ ] App compiles without errors in Xcode
- [ ] `SymbolCardViewModel` tracks input and validates correctly
- [ ] `SymbolCardView` displays symbol and pattern
- [ ] `MorseInputView` integrated and functional
- [ ] Correct input shows success feedback (visual + haptic)
- [ ] Incorrect input shows error feedback with comparison
- [ ] Input time metric displayed after completion
- [ ] Attempt recorded in `StatisticsRepository`
- [ ] "Try Again" button resets state
- [ ] SwiftUI Previews work for all states
- [ ] End-to-end flow works: list → card → input → feedback → stats updated

## Post-implementation verification

1. Build the project: Xcode → Product → Build (⌘+B)
2. Open SymbolCardView.swift and verify all state previews render
3. Run in Simulator:
   - Navigate to Learn tab
   - Tap any symbol
   - Input correct Morse code → verify success feedback
   - Tap "Try Again" → input incorrect code → verify error feedback
4. Verify haptic feedback triggers (on device or check code)
5. Run SwiftLint if configured

## Documentation update

### README.md

No changes required for this task.

### AGENTS.md

Verify Presentation/Learn section describes symbol card functionality.

### Module AGENTS.md

Not applicable for this task.

## Post-implementation code preparation

1. Verify all new files are added to Xcode project
2. Ensure all files are properly formatted
3. Remove any debug print statements
4. Verify project builds in both Debug and Release configurations
5. Verify all SwiftUI Previews work
6. Prepare for code review
