# Progress Module

Read-only statistics dashboard showing overall learning progress: streaks, accuracy, attempt counts, and weakest symbols that need more practice.

## Key types

- `UserProgressView` / `ProgressViewModel` — statistics dashboard
- `StatCard` — reusable stat card component (local to this module)
- `WeakSymbolRow` / `WeakSymbol` — weak symbol display (accuracy < 80%, min 3 attempts, top 5)

## Entry point

`UserProgressView` is the tab root. No outgoing navigation.

## Dependencies

- **Data:** `StatisticsRepositoryProtocol` (exercise and symbol stats), `UserProfileRepositoryProtocol` (streak data)
- **Data:** `SymbolStatisticsModel` (used directly for weak symbol calculation)

## Constraints

- `ProgressViewModel` is `@Observable @MainActor`.
- Repositories are injected via a `configure(...)` method called from the View's `.task`; the ViewModel does not receive them at `init` time.
- The module is read-only — it never writes data; all stats come from Learn and Practice modules.
