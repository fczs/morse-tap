# Progress Screen (Aggregated Statistics Display)

## Goals

- Display aggregated statistics from Learn and Practice modules
- Show current streak and training activity metrics
- Highlight weak symbols for focused practice

## Functional requirements

### Presentation/Progress

- Replace placeholder with functional statistics dashboard
- Display aggregated metrics:
  - Total practice attempts (sum across all exercise modes)
  - Overall accuracy (weighted average)
  - Current streak (from UserProfile)
  - Longest streak (from UserProfile)
- Display weak symbols section:
  - Symbols with lowest accuracy (threshold: < 80%)
  - Symbols least trained (fewest attempts)
  - Show accuracy percentage for each weak symbol
- Handle empty state when no statistics available
- Auto-refresh on screen appear

### Presentation/Progress (ViewModel)

- Load statistics via repositories on screen appear
- Aggregate exercise statistics across all modes
- Calculate weak symbols from symbol statistics
- Expose computed metrics for View binding

### Data/Repositories

- Use existing `StatisticsRepository`:
  - `getAllSymbolStatistics()` for symbol-level data
  - `getAllExerciseStatistics()` for exercise-level data
- Use existing `UserProfileRepository`:
  - `loadOrCreateProfile()` for streak data

## Out-of-scope

- Statistics charts or graphs over time
- Export statistics functionality
- Per-mode detailed statistics breakdown
- Gamification (achievements, badges)
- Statistics reset functionality

## Affected layers and modules (Yes/No/Unknown)

- App/: No
- Presentation/Learn: No
- Presentation/Practice: No
- Presentation/Progress: Yes
- Presentation/Settings: No
- Domain/Services: No
- Domain/UseCases: No
- Domain/Models: No
- Data/Repositories: No (uses existing)
- Data/Storage: No (uses existing models)
- Shared/Components: Unknown
- Shared/Utilities: No

## Dependencies and artifacts

- Task T5: SwiftData Storage (completed) — provides repositories and models
- Task T7: Learn Symbol Card (completed) — records symbol statistics via Learn
- Task T11-T13: Practice modes (completed) — record exercise and symbol statistics
- TECH_SPEC.md: Section 4.4 (Module: Progress)
- AGENTS.md: Presentation/Progress section
