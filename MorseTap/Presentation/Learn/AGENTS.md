# Learn Module

Morse alphabet learning flow: browse all symbols in a list, then practice individual symbol input on a detail card with immediate correct/incorrect feedback.

## Key types

- `LearnView` / `LearnViewModel` — symbol list with per-symbol accuracy stats
- `SymbolCardView` / `SymbolCardViewModel` — single-symbol practice card (input → validate → record result)
- `SymbolRowView` — list row component
- `SymbolListItem` — lightweight view-model struct for list rows

## Entry point

`LearnView` is the tab root. It navigates to `SymbolCardView` via `NavigationStack` destination.

## Dependencies

- **Domain:** `MorseAlphabetProviding` (symbol catalog), `MorseSymbol`, `MorseSignal`
- **Data:** `StatisticsRepositoryProtocol` (read accuracy, record attempts)
- **Shared:** `MorseInputView`, `MorseSignalsView`, `HapticFeedbackManager`

## Constraints

- Both ViewModels are `@Observable @MainActor`.
- `StatisticsRepository` is injected via `@Environment(\.modelContext)` at the View level; ViewModels receive the protocol, not the concrete type.
- Statistics recording failures are non-critical and silently ignored.
