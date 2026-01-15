# Practice: Code → Text Modes (Keyboard Decode)

## Goals

- Ensure Code → Text modes (`codeToWord`, `codeToSentence`) are fully functional with keyboard input
- User decodes displayed Morse code prompt and types the answer
- Provide clear UX for typed answer preview and input management
- Record exercise attempt statistics (mode, correctness, time)

## Functional requirements

### Presentation/Practice (View)

- Display Morse code prompt (encoded word or sentence with proper formatting)
- Input method: system keyboard via TextField
- Show typed answer preview as user types
- Optional: add clear input action button
- Keyboard auto-focuses on screen appear
- Hide keyboard after submission or when showing result
- Ensure Morse prompt is readable (monospace font, proper spacing between tokens)

### Presentation/Practice (ViewModel)

- Manage `userAnswer: String` for keyboard typed input
- Validation: compare `userAnswer` vs `Exercise.expectedAnswer`
- Apply normalization rules (case-insensitive, trim whitespace)
- Record exercise attempt via `StatisticsRepository`:
  - Mode (`codeToWord` or `codeToSentence`)
  - Correctness (boolean)
  - Time elapsed from exercise load to submission
- Record per-symbol statistics for symbols in the decoded text

### Domain/Services (ExerciseGenerator)

- For Code → Text modes:
  - `prompt` = Morse code string (tokens separated by space, words by " / ")
  - `expectedAnswer` = original text (uppercase)
- Existing implementation should be sufficient

### Domain/Services (ExerciseValidator)

- For Code → Text modes (`isCodeInput == false`):
  - Normalize both expected and actual: uppercase, trim whitespace
  - Strict equality comparison (no fuzzy matching for now)
- Existing implementation should be sufficient

### Data/Repositories

- Use existing `StatisticsRepository.recordExerciseAttempt(mode:isCorrect:time:)`
- Use existing `StatisticsRepository.recordSymbolAttempt(symbol:isCorrect:inputTime:)`

## Out-of-scope

- Fuzzy or partial matching for validation
- Hint system for Code → Text modes
- Audio playback of Morse code
- Custom keyboard or Morse input for these modes
- Spaced repetition or adaptive difficulty

## Affected layers and modules (Yes/No/Unknown)

- App/: No
- Presentation/Learn: No
- Presentation/Practice: Yes (verify/enhance existing)
- Presentation/Progress: No
- Presentation/Settings: No
- Domain/Services: No (uses existing)
- Domain/UseCases: No
- Domain/Models: No
- Data/Repositories: No (uses existing)
- Data/Storage: No
- Shared/Components: No
- Shared/Utilities: No

## Dependencies and artifacts

- Task T11: Practice Exercise Screen (completed) — provides `ExerciseView`, `ExerciseViewModel`
- Task T11.1: Practice Input Refactor (completed) — separated Morse/keyboard input paths
- Task T9: Practice Core (completed) — provides `ExerciseGenerator`, `ExerciseValidator`
- Task T5: SwiftData Storage (completed) — provides `StatisticsRepository`
- TECH_SPEC.md: Section 4.3.3 ("Code → Text" Modes)
- AGENTS.md: Presentation/Practice section

## Verification checklist

- [ ] `codeToWord` mode displays Morse-encoded word as prompt
- [ ] `codeToSentence` mode displays Morse-encoded sentence as prompt
- [ ] Keyboard appears automatically in Code → Text modes
- [ ] User can type answer and see preview
- [ ] Submit validates typed answer against expected text
- [ ] Correct/incorrect feedback displays properly
- [ ] Statistics are recorded for each attempt
- [ ] Per-symbol statistics are recorded
- [ ] Next exercise loads after proceeding
- [ ] Session completion works after all exercises
