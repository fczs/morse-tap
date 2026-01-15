# Practice Input Refactor: Morse Button for Text → Code Modes

## Goals

- Replace keyboard input with Morse button for Text → Code modes (`wordToCode`, `sentenceToCode`)
- Keep keyboard input for Code → Text modes (`codeToWord`, `codeToSentence`)
- Decode tapped Morse signals to characters and assemble user answer in real-time
- Provide actions to delete last symbol, insert space, and clear answer

## Functional requirements

### Presentation/Practice (ViewModel)

- Add mode-specific input state:
  - For Code → Text modes: use existing `userAnswer: String` (keyboard typed)
  - For Text → Code modes: add `morseAnswerSymbols: [Character]` buffer for assembled answer
  - Add computed `morseAnswerText: String` derived from `morseAnswerSymbols`
- Add method `onSymbolCompleted(_ signals: [MorseSignal])` for decoding completed Morse symbols:
  - Convert signals array to pattern string (dot = ".", dash = "-")
  - Use `MorseAlphabet.decode(pattern)` to get Character
  - If valid character, append to `morseAnswerSymbols`
  - If unknown pattern, provide feedback (haptic or visual)
- Add methods for editing assembled answer:
  - `deleteLastMorseSymbol()` — remove last character from `morseAnswerSymbols`
  - `insertSpace()` — append space character to `morseAnswerSymbols`
  - `clearMorseAnswer()` — reset `morseAnswerSymbols` to empty
- Update `canSubmit` computed property:
  - For Text → Code modes: check `!morseAnswerText.isEmpty && !isShowingResult`
  - For Code → Text modes: existing keyboard-based check
- Update `submitAnswer()` to use `morseAnswerText` as user answer for Text → Code modes
- Update `loadExercise()` to reset `morseAnswerSymbols` for Text → Code modes
- Inject `MorseAlphabetProviding` dependency for decoding (default: `MorseAlphabet()`)

### Presentation/Practice (View)

- Modify `inputSection` to conditionally render based on `mode.isCodeInput`:
  - For Text → Code modes (`isCodeInput == true`):
    - Show `MorseInputView` component
    - Wire `onSymbolCompleted` callback to ViewModel
    - Display live preview of assembled answer (`morseAnswerText`)
    - Add action buttons: delete last symbol, insert space, optional clear
    - Do NOT show keyboard or TextField
  - For Code → Text modes (`isCodeInput == false`):
    - Keep existing `TextField` with keyboard input
    - Keep existing focus management
- Remove any `.focused` or keyboard focus modifiers from Text → Code mode UI path
- Update result feedback to display expected/actual comparison appropriately for both modes

### Shared/Utilities

- Add extension or helper function to convert `[MorseSignal]` to pattern string:
  - `MorseSignal.dot` → "."
  - `MorseSignal.dash` → "-"
  - Example: `[.dot, .dash]` → ".-"
  - Can be added as extension on `Array where Element == MorseSignal`

### Domain/Services

- No changes to `MorseAlphabet` — use existing `decode(_ pattern: String) -> Character?`
- No changes to `MorseInputEngine` — use existing implementation

### Shared/Components

- Reuse existing `MorseInputView`:
  - Already provides `onSignalAdded` and `onSymbolCompleted` callbacks
  - Already shows current signals and delete button
  - No modifications needed to component itself

## Out-of-scope

- New exercise modes or difficulty levels
- Modifications to MorseInputEngine timing or behavior
- Sound or audio feedback for decoding
- Per-character validation during input (only validate on submit)
- Spaced repetition or adaptive difficulty
- Animations beyond existing haptic feedback

## Affected layers and modules (Yes/No/Unknown)

- App/: No
- Presentation/Learn: No
- Presentation/Practice: Yes
- Presentation/Progress: No
- Presentation/Settings: No
- Domain/Services: No
- Domain/UseCases: No
- Domain/Models: No
- Data/Repositories: No
- Data/Storage: No
- Shared/Components: No
- Shared/Utilities: Yes (add signal-to-pattern helper)
- Shared/Extensions: Unknown

## Dependencies and artifacts

- Task T4: Morse Input UI Component (completed) — provides `MorseInputView`, `MorseInputButton`, `MorseSignalsView`
- Task T3: Universal Morse Input Engine (completed) — provides `MorseInputEngine`, `MorseSignal`
- Task T2: Morse Alphabet Domain (completed) — provides `MorseAlphabet`, `decode(_ pattern:)`
- Task T11: Practice Exercise Screen (completed) — provides current `ExerciseView`, `ExerciseViewModel`
- TECH_SPEC.md: Section 4.3.3 ("Code → Text" modes - Morse button input), Section 4.3.4 ("Text → Code" modes)
- AGENTS.md: Presentation/Practice, Shared/Utilities sections
