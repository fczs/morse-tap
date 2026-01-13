# Learn: Symbol List Screen

## Goals

- Implement the Symbol List screen in the Learn module using MVVM architecture
- Display all Morse alphabet symbols with visual patterns and learning progress
- Enable navigation to Symbol Card screen for detailed learning

## Functional requirements

### Presentation/Learn

- Update `LearnView` to display a scrollable list of all symbols from the alphabet
- Each symbol row shows: character, Morse pattern visualization, progress indicator
- Progress indicator reflects learning statistics from repository (accuracy-based)
- Tapping a row navigates to the Symbol Card screen (placeholder for now)
- Support for empty state when no symbols available (edge case)
- Loading state while fetching statistics

### Presentation/Learn ViewModel

- Update `LearnViewModel` to load symbols from `MorseAlphabet` service
- Load statistics for each symbol from `StatisticsRepository`
- Combine symbol data with statistics for display
- Handle loading, loaded, and error states

### Domain/Services

- No changes; uses existing `MorseAlphabet` service from T2

### Data/Repositories

- No changes; uses existing `StatisticsRepository` from T5

## Out-of-scope

- Symbol Card screen implementation (separate task)
- Audio playback of Morse patterns
- Symbol filtering or search
- Sorting options
- Settings integration

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
- Shared/Components: Unknown
- Shared/Utilities: No

## Dependencies and artifacts

- Task T2: Morse Alphabet Domain (completed) — provides `MorseAlphabet`, `MorseSymbol`
- Task T5: SwiftData Storage (completed) — provides `StatisticsRepository`, `SymbolStatisticsModel`
- TECH_SPEC.md: Section 4.1.1 (Symbol List Screen)
- AGENTS.md: Presentation/Learn section
