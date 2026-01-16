# Practice: Text → Code Modes (Morse Encode via Button)

## Goals

- Ensure Text → Code modes (`wordToCode`, `sentenceToCode`) are fully functional with Morse button input
- User sees target text and encodes it by tapping Morse code
- Assemble user answer from decoded completed symbols in real-time
- Keyboard must NOT appear in these modes
- Record exercise attempt statistics

## Functional requirements

### Presentation/Practice (View)

- Display target text prompt (word or sentence in uppercase)
- Input method: `MorseInputButton` only (no TextField, no keyboard)
- Show live preview of assembled answer:
  - Completed symbols (decoded characters)
  - Pending signals (dots/dashes being entered, shown inline)
- Action buttons:
  - Delete last signal or symbol
  - Insert space (for multi-word input)
  - Clear all (optional)
- Hide input controls when showing result feedback

### Presentation/Practice (ViewModel)

- Manage Morse input state:
  - `pendingSignals: [MorseSignal]` — signals being entered
  - `morseAnswerSymbols: [Character]` — decoded characters buffer
  - `morseAnswerText: String` — assembled answer string
  - `displayAnswer: String` — completed + pending pattern for preview
- Handle press events:
  - `handlePressDown()` — record timestamp, cancel completion timer
  - `handlePressUp()` — classify signal (dot/dash), start completion timer
- Decode completed symbol:
  - Convert signals to pattern via `asPattern`
  - Decode pattern to character via `MorseAlphabet.decode()`
  - Append to `morseAnswerSymbols` or show error feedback
- Input management:
  - `deleteLastSignal()` — remove last signal or last symbol
  - `insertSpace()` — complete pending symbol, append space
  - `clearMorseAnswer()` — reset all input state
- Validation:
  - Compare `morseAnswerText` vs `Exercise.expectedAnswer`
  - Block submit while `pendingSignals` is not empty

### Domain/Services

- Use existing `MorseAlphabet.decode(_ pattern:)` for symbol decoding
- Use existing `ExerciseValidator` for answer comparison
- Validation normalization: uppercase, trim whitespace

### Data/Repositories

- Record exercise attempt via `StatisticsRepository.recordExerciseAttempt()`
- Record per-symbol statistics via `StatisticsRepository.recordSymbolAttempt()`

### Shared/Extensions

- Use existing `[MorseSignal].asPattern` extension for signal-to-pattern conversion

## Out-of-scope

- Per-symbol live validation during input (only validate on submit)
- Hint system showing expected Morse code
- Audio feedback for signals
- Spaced repetition or adaptive difficulty

## Affected layers and modules (Yes/No/Unknown)

- App/: No
- Presentation/Learn: No
- Presentation/Practice: Yes (implemented in T11.1)
- Presentation/Progress: No
- Presentation/Settings: No
- Domain/Services: No (uses existing)
- Domain/UseCases: No
- Domain/Models: No
- Data/Repositories: No (uses existing)
- Data/Storage: No
- Shared/Components: No (uses existing MorseInputButton)
- Shared/Extensions: No (uses existing asPattern)
- Shared/Utilities: No (uses existing HapticFeedbackManager)

## Dependencies and artifacts

- Task T11.1: Practice Input Refactor (completed) — implemented Morse button input for Text → Code
- Task T4: Morse Input UI Component (completed) — provides `MorseInputButton`
- Task T2: Morse Alphabet Domain (completed) — provides `MorseAlphabet.decode()`
- Task T9: Practice Core (completed) — provides `ExerciseValidator`
- Task T5: SwiftData Storage (completed) — provides `StatisticsRepository`
- TECH_SPEC.md: Section 4.3.4 ("Text → Code" Modes)
- AGENTS.md: Presentation/Practice section

## Implementation status

This functionality was implemented as part of Task T11.1 (Practice Input Refactor). Key components:

1. **ExerciseViewModel** — manages Morse input engine inline:
   - `pendingSignals`, `morseAnswerSymbols`, `displayAnswer`
   - `handlePressDown()`, `handlePressUp()`
   - Internal completion timer for symbol recognition

2. **ExerciseView** — uses `MorseInputButton` directly:
   - Inline preview showing completed text + pending pattern (orange)
   - Action buttons: Delete, Space, Clear

3. **MorseSignal+Pattern.swift** — `asPattern` extension for signal conversion

## Verification checklist

- [ ] `wordToCode` mode displays target word as prompt
- [ ] `sentenceToCode` mode displays target sentence as prompt
- [ ] Morse input button appears (no keyboard)
- [ ] Tapping generates dots and dashes
- [ ] Pending signals appear inline in preview (orange color)
- [ ] Pause completes symbol and decodes to character
- [ ] Invalid patterns trigger error haptic feedback
- [ ] Delete removes last signal or last symbol
- [ ] Space inserts space character
- [ ] Clear resets all input
- [ ] Submit validates assembled answer
- [ ] Correct/incorrect feedback displays properly
- [ ] Statistics are recorded for each attempt
- [ ] Session completion works after all exercises
- [ ] Keyboard does NOT appear in Text → Code modes
