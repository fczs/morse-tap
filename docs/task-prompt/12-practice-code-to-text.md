# Practice: Code → Text Modes Implementation

## Affected modules

- `MorseTap/Presentation/Practice/ExerciseView.swift` (verify/enhance)
- `MorseTap/Presentation/Practice/ExerciseViewModel.swift` (verify/enhance)

## Goal

Ensure Code → Text exercise modes (`codeToWord`, `codeToSentence`) are fully functional. User sees a Morse code prompt, types the decoded text answer using the system keyboard, and submits for validation. Statistics are recorded for each attempt.

## Dependencies

- Task T11: Practice Exercise Screen (completed) — provides `ExerciseView`, `ExerciseViewModel`
- Task T11.1: Practice Input Refactor (completed) — separated input paths by mode
- Task T9: Practice Core (completed) — provides `ExerciseGenerator`, `ExerciseValidator`
- Task T5: SwiftData Storage (completed) — provides `StatisticsRepository`

## Execution plan

1. Review existing Code → Text implementation in `ExerciseView`
2. Verify Morse prompt display formatting
3. Verify keyboard input and answer preview
4. Optional: add clear input button for keyboard mode
5. Verify validation logic in `ExerciseValidator`
6. Verify statistics recording
7. Build and test in Xcode Simulator
8. SwiftUI previews verification
9. Finalization

## Pre-implementation code preparation

1. Open the project in Xcode: `MorseTap.xcodeproj`
2. Review `ExerciseView.swift` — `keyboardInputSection` method
3. Review `ExerciseViewModel.swift` — `userAnswer` property and `submitAnswer` method
4. Review `ExerciseValidator.swift` — validation for non-code modes
5. Review `ExerciseGenerator.swift` — prompt/expectedAnswer generation for Code → Text

## Terms/Context

- **Code → Text modes** — `codeToWord`, `codeToSentence` — user sees Morse code, types decoded text
- **Morse prompt format** — tokens separated by space, words separated by ` / ` (e.g., `".... . .-.. .-.. --- / .-- --- .-. .-.. -.."`)
- **Expected answer** — uppercase text (e.g., `"HELLO WORLD"`)

## Block requirements

### Domain Services

No changes required. Existing implementation handles Code → Text modes:

**ExerciseGenerator** (existing behavior):
- `prompt` = Morse code string
- `expectedAnswer` = original uppercase text

**ExerciseValidator** (existing behavior):
- For `isCodeInput == false`: normalize to uppercase, trim whitespace, compare

### Data Repositories

No changes. Uses existing:
- `recordExerciseAttempt(mode:isCorrect:time:)`
- `recordSymbolAttempt(symbol:isCorrect:inputTime:)`

### ViewModels

#### `MorseTap/Presentation/Practice/ExerciseViewModel.swift`

Verify existing implementation handles Code → Text:

```swift
// userAnswer is already used for keyboard input
var userAnswer: String = ""

// currentAnswer returns userAnswer for non-code modes
var currentAnswer: String {
    mode.isCodeInput ? morseAnswerText : userAnswer
}

// canSubmit checks the correct answer source
var canSubmit: Bool {
    !currentAnswer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty 
        && !isShowingResult 
        && pendingSignals.isEmpty  // Always empty for keyboard mode
}

// submitAnswer validates using currentAnswer
func submitAnswer() async {
    // Uses currentAnswer which returns userAnswer for Code → Text
}
```

**Optional enhancement** — add clear method for keyboard mode:

```swift
func clearTypedAnswer() {
    userAnswer = ""
}
```

### Views

#### `MorseTap/Presentation/Practice/ExerciseView.swift`

Verify existing `keyboardInputSection`:

```swift
@ViewBuilder
private func keyboardInputSection(viewModel: ExerciseViewModel) -> some View {
    TextField(
        "Enter text...",
        text: Binding(
            get: { viewModel.userAnswer },
            set: { viewModel.userAnswer = $0 }
        )
    )
    .font(.body)
    .textFieldStyle(.roundedBorder)
    .textInputAutocapitalization(.characters)
    .autocorrectionDisabled()
    .disabled(viewModel.isShowingResult)
    .focused($isInputFocused)
    .onAppear {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isInputFocused = true
        }
    }
}
```

**Optional enhancement** — add typed answer preview and clear button:

```swift
@ViewBuilder
private func keyboardInputSection(viewModel: ExerciseViewModel) -> some View {
    VStack(spacing: 16) {
        TextField(
            "Type the decoded text...",
            text: Binding(
                get: { viewModel.userAnswer },
                set: { viewModel.userAnswer = $0 }
            )
        )
        .font(.body)
        .textFieldStyle(.roundedBorder)
        .textInputAutocapitalization(.characters)
        .autocorrectionDisabled()
        .disabled(viewModel.isShowingResult)
        .focused($isInputFocused)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isInputFocused = true
            }
        }
        
        if !viewModel.userAnswer.isEmpty && !viewModel.isShowingResult {
            Button {
                viewModel.clearTypedAnswer()
            } label: {
                Label("Clear", systemImage: "xmark.circle")
                    .font(.callout)
            }
            .buttonStyle(.bordered)
            .foregroundStyle(.secondary)
        }
    }
}
```

Verify `promptSection` displays Morse code properly:

```swift
// For Code → Text modes, prompt is Morse code
Text(exercise.prompt)
    .font(mode.isCodeInput ? .largeTitle : .title2.monospaced())
    // For codeToWord/codeToSentence, uses .title2.monospaced() ✓
```

### Shared Components

No changes.

### Utilities

No changes.

### Models/Types

No changes.

### Refactoring

No changes.

### NFRs

- Keyboard auto-focuses in Code → Text modes
- Morse prompt is readable with monospace font
- Text input supports uppercase letters automatically
- Autocorrection is disabled for accurate input
- Statistics are recorded on submission
- SwiftUI previews work for Code → Text modes

## Acceptance criteria

- [ ] `codeToWord` displays Morse-encoded word as prompt
- [ ] `codeToSentence` displays Morse-encoded sentence as prompt
- [ ] Morse prompt uses monospace font with proper token spacing
- [ ] Keyboard appears automatically
- [ ] User can type decoded text
- [ ] TextField shows typed answer as preview
- [ ] Submit button validates answer
- [ ] Correct feedback (green checkmark) for correct answers
- [ ] Incorrect feedback (red X + expected answer) for wrong answers
- [ ] Statistics recorded to repository (verify in debug logs)
- [ ] Session completes after all exercises
- [ ] Keyboard modes do NOT show Morse input button
- [ ] Code follows AGENTS.md rules

## Post-implementation verification

1. Build the project: Xcode → Product → Build (⌘+B)
2. Run in Simulator: Xcode → Product → Run (⌘+R)
3. Navigate to Practice tab
4. Select "Code → Word" mode:
   - Verify Morse code appears as prompt (e.g., `.... . .-.. .-.. ---`)
   - Verify keyboard appears
   - Type decoded word (e.g., "HELLO")
   - Tap "Check"
   - Verify correct/incorrect feedback
5. Select "Code → Sentence" mode:
   - Verify Morse sentence with ` / ` word separators
   - Type decoded sentence
   - Submit and verify
6. Complete full session
7. Check Xcode console for statistics debug logs
8. Verify SwiftUI previews: "Code to Word" preview

## Documentation update

### README.md

No changes required.

### AGENTS.md

No changes required — modes already documented.

### Module AGENTS.md

Not applicable.

## Post-implementation code preparation

1. Verify Code → Text flow works end-to-end
2. Ensure no debug print statements remain (except statistics logs)
3. Run SwiftLint and fix issues
4. Verify project builds in Debug configuration
5. Prepare for code review
