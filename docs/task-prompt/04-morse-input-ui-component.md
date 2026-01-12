# Morse Input UI Component Implementation

## Affected modules

- `MorseTap/Shared/Components/MorseInputButton.swift`
- `MorseTap/Shared/Components/MorseSignalsView.swift`
- `MorseTap/Shared/Components/MorseInputView.swift`
- `MorseTap/Shared/Utilities/HapticFeedbackManager.swift`

## Goal

Implement a reusable SwiftUI component for Morse code input featuring a large circular button with press-and-hold gesture handling, real-time display of entered signals, and integration with `MorseInputEngine`. The component will be used across Learn and Practice modules.

## Dependencies

- Task T3: Universal Morse Input Engine (completed) — provides `MorseInputEngine`, `MorseSignal`, `MorseTimingConfig`

## Execution plan

1. Implement the requested changes (Components, Utilities)
2. Type checks and build verification (Xcode build)
3. Post-implementation verification (SwiftUI previews, simulator)
4. Quality checks (SwiftLint, code review)
5. Documentation update (AGENTS.md if needed)
6. Finalization

## Pre-implementation code preparation

1. Open the project in Xcode: `MorseTap.xcodeproj`
2. Verify `MorseTap/Domain/Services/MorseInputEngine.swift` exists
3. Verify `MorseTap/Domain/Models/MorseSignal.swift` exists
4. Verify `MorseTap/Shared/Components/` folder exists
5. Verify `MorseTap/Shared/Utilities/` folder exists

## Terms/Context

- **Morse Input Button** — Large circular button that detects press-and-hold gestures to generate dots and dashes
- **Signals View** — Visual representation of entered dots and dashes for the current symbol
- **Haptic Feedback** — Tactile feedback on signal input (stubbed for this task)

## Block requirements

### Domain Services

No changes. Uses existing `MorseInputEngine` from T3.

### Data Repositories

No changes.

### ViewModels

No changes. Components manage their own state internally.

### Views

No changes to existing views.

### Shared Components

#### `MorseTap/Shared/Components/MorseInputButton.swift`

Create a SwiftUI View for the main input button:

- Large circular button (recommended size: 200x200 points minimum)
- Visual states:
  - Default/idle state
  - Pressed state (visual feedback while holding)
- Gesture handling:
  - Detect press down → call `onPressDown`
  - Detect press up → call `onPressUp`
- Use `DragGesture(minimumDistance: 0)` for reliable press detection
- Callbacks:
  - `onPressDown: () -> Void`
  - `onPressUp: () -> Void`
- Visual design:
  - Circular shape with gradient or solid fill
  - Scale animation on press
  - Color change on press state
- Include SwiftUI Preview

#### `MorseTap/Shared/Components/MorseSignalsView.swift`

Create a SwiftUI View for displaying entered signals:

- Input: `signals: [MorseSignal]`
- Display dots as small circles
- Display dashes as horizontal rectangles/capsules
- Horizontal layout with spacing between signals
- Animate appearance of new signals
- Empty state when no signals
- Configurable:
  - `dotSize: CGFloat` (default: 12)
  - `dashWidth: CGFloat` (default: 36)
  - `dashHeight: CGFloat` (default: 12)
  - `spacing: CGFloat` (default: 8)
- Include SwiftUI Preview with sample signals

#### `MorseTap/Shared/Components/MorseInputView.swift`

Create a composite SwiftUI View combining button and signals display:

- Contains `MorseInputButton` and `MorseSignalsView`
- Owns an instance of `MorseInputEngine`
- Connects button gestures to engine:
  - `onPressDown` → `engine.pressDown(at: Date())`
  - `onPressUp` → `engine.pressUp(at: Date())`
- Displays `engine.currentSignals` in `MorseSignalsView`
- Exposes callbacks:
  - `onSignalAdded: ((MorseSignal) -> Void)?`
  - `onSymbolCompleted: (([MorseSignal]) -> Void)?`
- Calls `HapticFeedbackManager.shared.signalFeedback()` on each signal
- Vertical layout: signals view on top, button below
- Optional: delete last signal button
- Include SwiftUI Preview

### Utilities

#### `MorseTap/Shared/Utilities/HapticFeedbackManager.swift`

Create a stub manager for haptic feedback:

- Singleton pattern: `static let shared`
- Methods (stubbed, empty implementation):
  - `func signalFeedback()` — called when dot/dash is entered
  - `func symbolCompletedFeedback()` — called when symbol is completed
  - `func errorFeedback()` — called on error (future use)
- Use `UIImpactFeedbackGenerator` internally (can be disabled via flag)
- Property: `var isEnabled: Bool` (default: true)

### Models/Types

No changes. Uses existing `MorseSignal` from Domain/Models.

### Refactoring

No refactoring required.

### NFRs

- All files must compile without errors
- SwiftUI Previews must render correctly
- Components must be reusable without dependencies on specific screens
- Follow SwiftUI best practices for state management
- Use `@Observable` pattern where appropriate
- Minimum button touch target: 44x44 points (Apple HIG)
- Actual button size: 200x200 points for comfortable Morse input

## Acceptance criteria

- [ ] App compiles without errors in Xcode
- [ ] `MorseInputButton` created with press gesture handling
- [ ] `MorseSignalsView` created displaying dots and dashes
- [ ] `MorseInputView` created combining button and signals display
- [ ] `HapticFeedbackManager` stub created
- [ ] Button shows visual feedback on press
- [ ] Signals appear in real-time as user taps
- [ ] `onSignalAdded` callback fires on each dot/dash
- [ ] `onSymbolCompleted` callback fires after pause
- [ ] All SwiftUI Previews render correctly
- [ ] Code follows AGENTS.md Code Quality and Style guidelines

## Post-implementation verification

1. Build the project: Xcode → Product → Build (⌘+B)
2. Open each component file and verify SwiftUI Preview renders
3. Run in Simulator and test tap interactions
4. Verify haptic feedback stub is called (add temporary print for verification)
5. Test signal accumulation and symbol completion
6. Run SwiftLint if configured

## Documentation update

### README.md

No changes required for this task.

### AGENTS.md

Verify Shared/Components section mentions `MorseInputButton` and `MorseCodeDisplay`. The new components implement this functionality.

### Module AGENTS.md

Not applicable for this task.

## Post-implementation code preparation

1. Verify all new files are added to Xcode project
2. Ensure all files are properly formatted
3. Remove any debug print statements
4. Verify project builds in both Debug and Release configurations
5. Verify all SwiftUI Previews work
6. Prepare for code review
