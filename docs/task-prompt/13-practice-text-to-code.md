# Practice: Text → Code Modes Implementation

## Affected modules

- `MorseTap/Presentation/Practice/ExerciseView.swift` (verify)
- `MorseTap/Presentation/Practice/ExerciseViewModel.swift` (verify)
- `MorseTap/Shared/Extensions/MorseSignal+Pattern.swift` (verify)

## Goal

Verify that Text → Code exercise modes (`wordToCode`, `sentenceToCode`) are fully functional with Morse button input only. User sees target text, taps Morse code via button, and assembled answer is validated on submit. Keyboard must not appear.

## Dependencies

- Task T11.1: Practice Input Refactor (completed) — implemented core functionality
- Task T4: Morse Input UI Component (completed) — provides `MorseInputButton`
- Task T2: Morse Alphabet Domain (completed) — provides `MorseAlphabet.decode()`
- Task T9: Practice Core (completed) — provides `ExerciseValidator`

## Execution plan

1. Review existing Text → Code implementation
2. Verify Morse button input flow
3. Verify inline preview with pending signals
4. Verify symbol completion and decoding
5. Verify action buttons (Delete, Space, Clear)
6. Verify validation logic
7. Verify statistics recording
8. Build and test in Xcode Simulator
9. Finalization

## Pre-implementation code preparation

1. Open the project in Xcode: `MorseTap.xcodeproj`
2. Review `ExerciseView.swift` — `morseInputSection` method
3. Review `ExerciseViewModel.swift` — Morse input handling methods
4. Review `MorseSignal+Pattern.swift` — `asPattern` extension

## Terms/Context

- **Text → Code modes** — `wordToCode`, `sentenceToCode` — user sees text, taps Morse code
- **Pending signals** — dots/dashes being entered before symbol completion
- **Symbol completion** — pause after last signal triggers decode
- **Assembled answer** — decoded characters from Morse input

## Block requirements

### Domain Services

No changes. Uses existing:
- `MorseAlphabet.decode(_ pattern:) -> Character?`
- `ExerciseValidator.validate(exercise:userAnswer:)`

### Data Repositories

No changes. Uses existing:
- `recordExerciseAttempt(mode:isCorrect:time:)`
- `recordSymbolAttempt(symbol:isCorrect:inputTime:)`

### ViewModels

#### `MorseTap/Presentation/Practice/ExerciseViewModel.swift`

Verify existing implementation (implemented in T11.1):

**Properties:**
```swift
private(set) var pendingSignals: [MorseSignal] = []
private(set) var morseAnswerSymbols: [Character] = []

var pendingPattern: String {
    pendingSignals.asPattern
}

var displayAnswer: String {
    // Combines morseAnswerText + pendingPattern
}

var canSubmit: Bool {
    // Blocks submit while pendingSignals is not empty
}
```

**Morse input methods:**
```swift
func handlePressDown()    // Records timestamp, cancels timer
func handlePressUp()      // Classifies signal, starts completion timer
func deleteLastSignal()   // Removes last signal or symbol
func insertSpace()        // Completes pending, appends space
func clearMorseAnswer()   // Resets all input state
```

**Internal completion logic:**
```swift
private func startCompletionTimer()     // Waits for pause duration
private func cancelPendingCompletion()  // Cancels timer
private func completeCurrentSymbol()    // Decodes and appends character
```

### Views

#### `MorseTap/Presentation/Practice/ExerciseView.swift`

Verify existing `morseInputSection` (implemented in T11.1):

```swift
@ViewBuilder
private func morseInputSection(viewModel: ExerciseViewModel) -> some View {
    VStack(spacing: 24) {
        answerPreview(viewModel: viewModel)
        
        if !viewModel.isShowingResult {
            MorseInputButton(
                onPressDown: { viewModel.handlePressDown() },
                onPressUp: { viewModel.handlePressUp() }
            )
            
            actionButtons(viewModel: viewModel)
        }
    }
}
```

**Answer preview with inline pending signals:**
```swift
@ViewBuilder
private func answerPreview(viewModel: ExerciseViewModel) -> some View {
    HStack(spacing: 0) {
        Text(viewModel.morseAnswerText)           // Completed (default color)
        Text(viewModel.pendingPattern)            // Pending (orange)
            .foregroundStyle(.orange)
        // Placeholder if empty
    }
}
```

**Action buttons:**
```swift
@ViewBuilder
private func actionButtons(viewModel: ExerciseViewModel) -> some View {
    HStack(spacing: 16) {
        // Delete button
        // Space button  
        // Clear button
    }
}
```

### Shared Extensions

#### `MorseTap/Shared/Extensions/MorseSignal+Pattern.swift`

Verify existing extension:

```swift
extension Array where Element == MorseSignal {
    var asPattern: String {
        map { signal in
            switch signal {
            case .dot: return "."
            case .dash: return "-"
            }
        }.joined()
    }
}
```

### Shared Components

No changes. Uses existing `MorseInputButton`.

### Utilities

No changes. Uses existing `HapticFeedbackManager`.

### Models/Types

No changes.

### Refactoring

No changes.

### NFRs

- Keyboard must NOT appear in Text → Code modes
- Morse button is the only input method
- Pending signals visible inline in orange
- Symbol completes after configurable pause
- Invalid patterns trigger error haptic
- Statistics recorded on submission

## Acceptance criteria

- [ ] `wordToCode` displays target word as prompt
- [ ] `sentenceToCode` displays target sentence as prompt
- [ ] Morse input button appears (large circular button)
- [ ] Keyboard does NOT appear
- [ ] Short press generates dot
- [ ] Long press generates dash
- [ ] Pending signals appear inline (orange)
- [ ] Pause completes symbol → character appears
- [ ] Invalid pattern triggers error haptic
- [ ] Delete removes last signal (or last symbol if no pending)
- [ ] Space inserts space character
- [ ] Clear resets all input
- [ ] Submit validates assembled answer vs expected
- [ ] Correct feedback (green checkmark)
- [ ] Incorrect feedback (red X + expected answer)
- [ ] Statistics recorded to repository
- [ ] Session completes after all exercises
- [ ] Code follows AGENTS.md rules

## Post-implementation verification

1. Build the project: Xcode → Product → Build (⌘+B)
2. Run in Simulator: Xcode → Product → Run (⌘+R)
3. Navigate to Practice tab
4. Select "Word → Code" mode:
   - Verify target word appears as prompt
   - Verify Morse button appears (NO keyboard)
   - Tap short: verify dot appears in preview (orange)
   - Tap long: verify dash appears
   - Wait: verify symbol completes and character appears
   - Test Delete, Space, Clear buttons
   - Submit correct answer → verify green feedback
   - Submit wrong answer → verify red feedback with expected
5. Select "Sentence → Code" mode:
   - Verify sentence prompt
   - Use Space between words
   - Complete full sentence
6. Complete full session (10 exercises)
7. Check Xcode console for statistics logs

## Documentation update

### README.md

No changes required.

### AGENTS.md

No changes required.

### Module AGENTS.md

Not applicable.

## Post-implementation code preparation

1. Verify Text → Code flow works end-to-end
2. Verify keyboard never appears
3. Run SwiftLint and fix issues
4. Verify project builds
5. Prepare for code review
