# Learn: Symbol List Screen Implementation

## Affected modules

- `MorseTap/Presentation/Learn/LearnView.swift`
- `MorseTap/Presentation/Learn/LearnViewModel.swift`
- `MorseTap/Presentation/Learn/SymbolRowView.swift`
- `MorseTap/Presentation/Learn/SymbolCardView.swift`

## Goal

Implement the Symbol List screen in the Learn module displaying all Morse alphabet symbols with their patterns and learning progress. Uses MVVM architecture with dependency injection for repositories. Tapping a symbol navigates to a placeholder Symbol Card screen.

## Dependencies

- Task T2: Morse Alphabet Domain (completed) — provides `MorseAlphabet`, `MorseSymbol`
- Task T5: SwiftData Storage (completed) — provides `StatisticsRepository`, `SymbolStatisticsModel`

## Execution plan

1. Implement the requested changes (ViewModel, Views, Components)
2. Type checks and build verification (Xcode build)
3. Post-implementation verification (SwiftUI previews, simulator)
4. Quality checks (SwiftLint, code review)
5. Documentation update (AGENTS.md if needed)
6. Finalization

## Pre-implementation code preparation

1. Open the project in Xcode: `MorseTap.xcodeproj`
2. Verify `MorseTap/Domain/Services/MorseAlphabet.swift` exists
3. Verify `MorseTap/Data/Repositories/StatisticsRepository.swift` exists
4. Verify `MorseTap/Presentation/Learn/` folder exists

## Terms/Context

- **Symbol Row** — List item displaying character, Morse pattern, and progress
- **Progress Indicator** — Visual representation of learning progress (0-100% based on accuracy)
- **Symbol Card** — Detail screen for practicing individual symbol (placeholder in this task)

## Block requirements

### Domain Services

No changes. Uses existing `MorseAlphabet` from T2.

### Data Repositories

No changes. Uses existing `StatisticsRepository` from T5.

### ViewModels

#### `MorseTap/Presentation/Learn/LearnViewModel.swift`

Update ViewModel with full implementation:

```swift
@Observable
@MainActor
final class LearnViewModel {

    enum State {
        case loading
        case loaded
        case error(String)
    }

    private(set) var state: State = .loading
    private(set) var symbolItems: [SymbolListItem] = []

    private let alphabet: MorseAlphabetProviding
    private let statisticsRepository: StatisticsRepositoryProtocol?

    init(
        alphabet: MorseAlphabetProviding = MorseAlphabet(),
        statisticsRepository: StatisticsRepositoryProtocol? = nil
    )

    func loadSymbols() async
    // Load all symbols from alphabet
    // Fetch statistics for each symbol
    // Create SymbolListItem combining symbol + stats
    // Update state to loaded
}

struct SymbolListItem: Identifiable {
    let id: String  // character as string
    let symbol: MorseSymbol
    let accuracy: Double  // 0.0 to 1.0
    let totalAttempts: Int
}
```

Key behaviors:

- On init with nil repository, work in preview mode (no stats)
- `loadSymbols()` fetches alphabet and combines with statistics
- Progress is based on accuracy from `SymbolStatisticsModel`
- Symbols without statistics show 0% progress

### Views

#### `MorseTap/Presentation/Learn/LearnView.swift`

Update main view:

- Use `NavigationStack` for navigation
- Display `List` of symbols using `SymbolRowView`
- Show loading indicator while `state == .loading`
- Show error message if `state == .error`
- Call `viewModel.loadSymbols()` in `.task` modifier
- Navigation to `SymbolCardView` on row tap
- Navigation title: "Learn"

#### `MorseTap/Presentation/Learn/SymbolRowView.swift`

Create new view for symbol row:

- Input: `SymbolListItem`
- Layout (horizontal):
  - Large character (font: .largeTitle or .title)
  - Morse pattern using `MorseSignalsView` from Shared/Components
  - Progress indicator (circular or bar)
- Consistent row height
- Accessible tap target
- Include SwiftUI Preview

#### `MorseTap/Presentation/Learn/SymbolCardView.swift`

Create placeholder view for symbol detail:

- Input: `MorseSymbol`
- Display: character and pattern (placeholder layout)
- Navigation title: the character itself
- Text: "Symbol Card - Coming Soon"
- Include SwiftUI Preview

### Shared Components

No new components. Uses existing `MorseSignalsView` from T4.

### Utilities

No changes.

### Models/Types

Add `SymbolListItem` struct in LearnViewModel file (or separate file if preferred).

### Refactoring

No refactoring required.

### NFRs

- All files must compile without errors
- SwiftUI Previews must render correctly
- ViewModel must support dependency injection for testing
- Preview must work without real repository (mock data)
- List must scroll smoothly with 36 items (A-Z + 0-9)
- Accessibility labels for VoiceOver support

## Acceptance criteria

- [ ] App compiles without errors in Xcode
- [ ] `LearnViewModel` loads symbols and statistics
- [ ] `LearnView` displays scrollable list of all symbols
- [ ] Each row shows character, Morse pattern, and progress
- [ ] Progress indicator reflects accuracy from statistics
- [ ] Symbols without stats show 0% progress
- [ ] Tapping row navigates to `SymbolCardView`
- [ ] Loading state shown while fetching data
- [ ] SwiftUI Previews work for all views
- [ ] Code follows AGENTS.md Code Quality and Style guidelines

## Post-implementation verification

1. Build the project: Xcode → Product → Build (⌘+B)
2. Open each view file and verify SwiftUI Preview renders
3. Run in Simulator and verify list displays
4. Tap symbols and verify navigation works
5. Verify smooth scrolling with all 36 symbols
6. Run SwiftLint if configured

## Documentation update

### README.md

No changes required for this task.

### AGENTS.md

Verify Presentation/Learn section describes symbol list functionality.

### Module AGENTS.md

Not applicable for this task.

## Post-implementation code preparation

1. Verify all new files are added to Xcode project
2. Ensure all files are properly formatted
3. Remove any debug print statements
4. Verify project builds in both Debug and Release configurations
5. Verify all SwiftUI Previews work
6. Prepare for code review
