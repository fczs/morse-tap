# Practice Input Refactor: Morse Button for Text → Code Modes

## Affected modules

- `MorseTap/Presentation/Practice/ExerciseViewModel.swift`
- `MorseTap/Presentation/Practice/ExerciseView.swift`
- `MorseTap/Shared/Extensions/MorseSignal+Pattern.swift` (new file)

## Goal

Refactor Practice mode so that Text → Code exercises (`wordToCode`, `sentenceToCode`) use the Morse input button instead of keyboard typing. Code → Text exercises (`codeToWord`, `codeToSentence`) remain unchanged with keyboard input. User taps Morse code via button, signals are decoded to characters in real-time, and assembled into the answer string for validation.

## Dependencies

- Task T4: Morse Input UI Component (completed) — provides `MorseInputView`
- Task T3: Universal Morse Input Engine (completed) — provides `MorseInputEngine`, `MorseSignal`
- Task T2: Morse Alphabet Domain (completed) — provides `MorseAlphabet`, `decode(_ pattern:)`
- Task T11: Practice Exercise Screen (completed) — provides current `ExerciseView`, `ExerciseViewModel`

## Execution plan

1. Create signal-to-pattern extension
2. Update `ExerciseViewModel` with mode-specific input state and methods
3. Update `ExerciseView` to conditionally render Morse input or keyboard
4. Build and verify in Xcode
5. Test all four exercise modes in Simulator
6. Verify SwiftUI previews
7. Run SwiftLint
8. Documentation update
9. Finalization

## Pre-implementation code preparation

1. Open the project in Xcode: `MorseTap.xcodeproj`
2. Verify `MorseTap/Shared/Components/MorseInputView.swift` exists with `onSymbolCompleted` callback
3. Verify `MorseTap/Domain/Services/MorseAlphabet.swift` exists with `decode(_ pattern:)` method
4. Verify `MorseTap/Domain/Models/MorseSignal.swift` defines `MorseSignal` enum (dot, dash)
5. Review existing `ExerciseViewModel.swift` and `ExerciseView.swift`

## Terms/Context

- **Text → Code modes** — `wordToCode`, `sentenceToCode` — user sees text prompt, inputs Morse code as answer
- **Code → Text modes** — `codeToWord`, `codeToSentence` — user sees Morse code prompt, types text as answer
- **Signal to Pattern** — Converting `[MorseSignal]` array to pattern string (e.g., `[.dot, .dash]` → ".-")
- **Assembled Answer** — Characters decoded from user's Morse input, concatenated into answer string

## Block requirements

### Domain Services

No changes.

### Data Repositories

No changes.

### Shared Extensions

#### `MorseTap/Shared/Extensions/MorseSignal+Pattern.swift` (new file)

Create extension for converting signals to pattern string:

```swift
import Foundation

extension Array where Element == MorseSignal {
    
    /// Converts array of MorseSignal to pattern string
    /// Example: [.dot, .dash] → ".-"
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

### ViewModels

#### `MorseTap/Presentation/Practice/ExerciseViewModel.swift`

Add new properties for Text → Code mode input:

```swift
// After existing userAnswer property
private(set) var morseAnswerSymbols: [Character] = []

var morseAnswerText: String {
    String(morseAnswerSymbols)
}

private let alphabet: MorseAlphabetProviding
```

Update init to inject alphabet dependency:

```swift
init(
    mode: ExerciseMode,
    difficulty: Difficulty = .beginner,
    totalExercises: Int = 10,
    generator: ExerciseGenerating = ExerciseGenerator(),
    validator: ExerciseValidating = ExerciseValidator(),
    statisticsRepository: StatisticsRepositoryProtocol? = nil,
    alphabet: MorseAlphabetProviding = MorseAlphabet()
) {
    // ... existing assignments ...
    self.alphabet = alphabet
}
```

Update `canSubmit` computed property to handle both modes:

```swift
var canSubmit: Bool {
    let answer = mode.isCodeInput ? morseAnswerText : userAnswer
    return !answer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isShowingResult
}
```

Add computed property for current answer (used in validation):

```swift
var currentAnswer: String {
    mode.isCodeInput ? morseAnswerText : userAnswer
}
```

Update `loadExercise()` to reset Morse answer:

```swift
func loadExercise() {
    currentExercise = generator.generateExercise(mode: mode, difficulty: difficulty)
    userAnswer = ""
    morseAnswerSymbols = []  // Add this line
    validationResult = nil
    isShowingResult = false
    startTime = Date()
}
```

Update `submitAnswer()` to use correct answer source:

```swift
func submitAnswer() async {
    guard let exercise = currentExercise, canSubmit else { return }
    
    let answer = currentAnswer  // Use computed property
    let result = validator.validate(exercise: exercise, userAnswer: answer)
    validationResult = result
    isShowingResult = true
    
    await recordStatistics(result: result)
}
```

Add methods for Morse input handling:

```swift
func onSymbolCompleted(_ signals: [MorseSignal]) {
    let pattern = signals.asPattern
    if let character = alphabet.decode(pattern) {
        morseAnswerSymbols.append(character)
        HapticFeedbackManager.shared.symbolCompletedFeedback()
    } else {
        // Unknown pattern - provide error feedback
        HapticFeedbackManager.shared.errorFeedback()
    }
}

func deleteLastMorseSymbol() {
    guard !morseAnswerSymbols.isEmpty else { return }
    morseAnswerSymbols.removeLast()
}

func insertSpace() {
    morseAnswerSymbols.append(" ")
}

func clearMorseAnswer() {
    morseAnswerSymbols.removeAll()
}
```

Update `restartSession()` to also reset Morse answer:

```swift
func restartSession() {
    currentIndex = 0
    isSessionComplete = false
    morseAnswerSymbols = []  // Add this line
    loadExercise()
}
```

### Views

#### `MorseTap/Presentation/Practice/ExerciseView.swift`

Update imports if needed:

```swift
import SwiftUI
```

Remove or update `@FocusState` to only apply to keyboard modes:

```swift
@FocusState private var isInputFocused: Bool
```

Replace `inputSection` method with conditional rendering:

```swift
@ViewBuilder
private func inputSection(viewModel: ExerciseViewModel) -> some View {
    VStack(spacing: 12) {
        Text("Your answer:")
            .font(.subheadline)
            .foregroundStyle(.secondary)
        
        if mode.isCodeInput {
            morseInputSection(viewModel: viewModel)
        } else {
            keyboardInputSection(viewModel: viewModel)
        }
    }
}

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

@ViewBuilder
private func morseInputSection(viewModel: ExerciseViewModel) -> some View {
    VStack(spacing: 20) {
        // Live preview of assembled answer
        Text(viewModel.morseAnswerText.isEmpty ? "..." : viewModel.morseAnswerText)
            .font(.title2.monospaced())
            .fontWeight(.medium)
            .frame(maxWidth: .infinity)
            .frame(minHeight: 44)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.quaternary)
            )
        
        // Morse input button
        if !viewModel.isShowingResult {
            MorseInputView(
                onSymbolCompleted: { signals in
                    viewModel.onSymbolCompleted(signals)
                }
            )
            
            // Action buttons
            HStack(spacing: 16) {
                Button {
                    viewModel.deleteLastMorseSymbol()
                } label: {
                    Label("Delete", systemImage: "delete.left")
                        .font(.callout)
                }
                .buttonStyle(.bordered)
                .disabled(viewModel.morseAnswerText.isEmpty)
                
                Button {
                    viewModel.insertSpace()
                } label: {
                    Label("Space", systemImage: "space")
                        .font(.callout)
                }
                .buttonStyle(.bordered)
                
                Button {
                    viewModel.clearMorseAnswer()
                } label: {
                    Label("Clear", systemImage: "trash")
                        .font(.callout)
                }
                .buttonStyle(.bordered)
                .disabled(viewModel.morseAnswerText.isEmpty)
            }
            .foregroundStyle(.secondary)
        }
    }
}
```

Update `proceedToNext` button action to reset focus only for keyboard modes:

```swift
Button {
    viewModel.proceedToNext()
    if !mode.isCodeInput {
        isInputFocused = true
    }
} label: {
    Text("Next")
    // ... rest of button styling
}
```

Update result feedback section if needed to handle both answer types properly (the existing `result.actual` from `ValidationResult` will contain the correct answer since we updated `submitAnswer`).

### Shared Components

No changes to existing components. Reuse `MorseInputView` as-is.

### Utilities

No changes beyond the new extension file.

### Models/Types

No changes.

### Refactoring

No additional refactoring.

### NFRs

- Keyboard must NOT appear in Text → Code modes
- Text → Code modes work fully with Morse button input only
- Code → Text modes work exactly as before with keyboard
- Live preview updates immediately as symbols are decoded
- Delete/Space/Clear actions work correctly
- Invalid patterns trigger error haptic feedback
- App compiles and all four modes work end-to-end
- SwiftUI previews render correctly

## Acceptance criteria

- [ ] App compiles without errors in Xcode
- [ ] `wordToCode` mode uses Morse button input (no keyboard)
- [ ] `sentenceToCode` mode uses Morse button input (no keyboard)
- [ ] `codeToWord` mode uses keyboard input (unchanged)
- [ ] `codeToSentence` mode uses keyboard input (unchanged)
- [ ] Tapped Morse code is decoded to characters in real-time
- [ ] Live preview shows assembled answer text
- [ ] Delete button removes last decoded character
- [ ] Space button inserts space in answer
- [ ] Clear button resets answer
- [ ] Invalid Morse patterns trigger error feedback
- [ ] Submit validates assembled answer correctly
- [ ] Result feedback shows expected/actual comparison
- [ ] Session completion works for all modes
- [ ] SwiftUI previews render for both modes
- [ ] Code follows AGENTS.md rules

## Post-implementation verification

1. Build the project: Xcode → Product → Build (⌘+B)
2. Run in Simulator: Xcode → Product → Run (⌘+R)
3. Navigate to Practice tab
4. Test `wordToCode` mode:
   - Verify NO keyboard appears
   - Tap Morse code for letters (e.g., ".-" for A)
   - Verify character appears in preview
   - Use Space button between words
   - Submit and verify validation
5. Test `sentenceToCode` mode:
   - Same as above with sentence
6. Test `codeToWord` mode:
   - Verify keyboard appears
   - Type text answer
   - Submit and verify validation
7. Test `codeToSentence` mode:
   - Same as above with sentence
8. Complete full session in each mode
9. Check Xcode console for errors
10. Check SwiftUI previews

## Documentation update

### README.md

No changes required.

### AGENTS.md

Add to Shared/Extensions section if not already documented:

```
- `MorseSignal+Pattern.swift`: Extension to convert [MorseSignal] to pattern string
```

### Module AGENTS.md

Not applicable for this task.

## Post-implementation code preparation

1. Verify all new files are added to Xcode project
2. Ensure all files are properly formatted
3. Remove any debug print statements
4. Run SwiftLint and fix issues
5. Verify project builds in Debug configuration
6. Test all four exercise modes manually
7. Prepare for code review
