# Practice Module

Exercise-based Morse code practice: pick a mode from a list, then work through a session of generated exercises with validation and statistics recording.

## Key types

- `PracticeView` / `PracticeViewModel` — mode selection list
- `ExerciseView` / `ExerciseViewModel` — exercise session (prompt → input → validate → next)

## Entry point

`PracticeView` is the tab root. It navigates to `ExerciseView` via `NavigationStack` destination, passing the selected `ExerciseMode`.

## Dependencies

- **Domain:** `ExerciseGenerating`, `ExerciseValidating`, `MorseAlphabetProviding`, `MorseTimingConfig`, `Difficulty`, `ExerciseMode`, `Exercise`, `MorseSignal`
- **Data:** `StatisticsRepositoryProtocol` (record exercise and symbol attempts)
- **Shared:** `MorseInputButton`, `HapticFeedbackManager`, `MorseSignal+Pattern`

## Constraints

- `ExerciseViewModel` is `@Observable @MainActor`; `PracticeViewModel` is `@Observable` (no explicit actor — lightweight, no async work).
- `ExerciseViewModel` manages its own Morse input timing (press down/up → dot/dash classification, symbol completion via pause timer) instead of delegating to `MorseInputEngine`.
- Two input paths depending on mode: Morse button input (`isCodeInput == true`) vs keyboard text field.
- Statistics recording failures are logged but do not block the exercise flow.
