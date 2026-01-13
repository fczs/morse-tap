# Learn: Symbol Card + Repeat Input

## Goals

- Implement the Symbol Card screen for practicing individual Morse symbols
- Enable user to input Morse code using the input component and validate against expected pattern
- Provide immediate feedback and record learning statistics

## Functional requirements

### Presentation/Learn

- Update `SymbolCardView` to display symbol character and Morse pattern prominently
- Integrate `MorseInputView` (T4) for user input
- Validate entered signals against expected symbol pattern
- Display immediate visual feedback: correct (success state) or incorrect (error state)
- Trigger haptic feedback on validation result
- Show input time metric after completion
- Allow user to retry after attempt

### Presentation/Learn ViewModel

- Create `SymbolCardViewModel` to manage card state and validation logic
- Track input start time and calculate duration
- Validate completed symbol against expected pattern
- Record attempt in statistics repository (symbol, isCorrect, inputTime)
- Handle states: ready, inputting, correct, incorrect

### Domain/Services

- No changes; uses existing `MorseAlphabet` for pattern comparison

### Data/Repositories

- No changes; uses existing `StatisticsRepository.recordSymbolAttempt()` from T5

### Shared/Components

- No changes; uses existing `MorseInputView` from T4

### Shared/Utilities

- Update `HapticFeedbackManager` to provide success and error feedback methods

## Out-of-scope

- Audio playback of Morse pattern
- Multiple attempts tracking in single session
- Hint system
- Symbol navigation (next/previous)
- Spaced repetition algorithm

## Affected layers and modules (Yes/No/Unknown)

- App/: No
- Presentation/Learn: Yes
- Presentation/Practice: No
- Presentation/Progress: No
- Presentation/Settings: No
- Domain/Services: No (uses existing)
- Domain/UseCases: No
- Domain/Models: No
- Data/Repositories: No (uses existing)
- Data/Storage: No
- Shared/Components: No (uses existing)
- Shared/Utilities: Yes

## Dependencies and artifacts

- Task T4: Morse Input UI Component (completed) — provides `MorseInputView`
- Task T5: SwiftData Storage (completed) — provides `StatisticsRepository`
- Task T6: Symbol List Screen (completed) — provides navigation to Symbol Card
- TECH_SPEC.md: Section 4.1.2 (Symbol Card Screen)
- AGENTS.md: Presentation/Learn section
