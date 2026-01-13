# Practice: Exercise Selection Screen Implementation

## Affected modules

- `MorseTap/Presentation/Practice/PracticeView.swift`
- `MorseTap/Presentation/Practice/PracticeViewModel.swift`
- `MorseTap/Presentation/Practice/ExerciseView.swift` (placeholder)

## Goal

Implement the Exercise Selection screen in the Practice module that displays all four exercise modes and enables navigation to the Generic Exercise Screen with the selected mode passed as a parameter.

## Dependencies

- Task T9: Practice Core (completed) — provides `ExerciseMode` with `displayName`, `description`, `isCodeInput`

## Execution plan

1. Update `PracticeViewModel` with mode selection logic
2. Update `PracticeView` with mode list and navigation
3. Create placeholder `ExerciseView` as navigation destination
4. Build and verify in Xcode
5. Test navigation in Simulator
6. Verify SwiftUI previews
7. Run SwiftLint
8. Documentation update
9. Finalization

## Pre-implementation code preparation

1. Open the project in Xcode: `MorseTap.xcodeproj`
2. Verify `MorseTap/Domain/Models/ExerciseMode.swift` exists with all four modes
3. Review existing `PracticeView.swift` and `PracticeViewModel.swift`

## Terms/Context

- **Exercise Selection Screen** — Main Practice tab screen showing available exercise modes
- **Generic Exercise Screen** — Target screen for exercise execution (placeholder in this task)
- **ExerciseMode** — Enum with four cases: `codeToWord`, `codeToSentence`, `wordToCode`, `sentenceToCode`

## Block requirements

### Domain Services

No changes.

### Data Repositories

No changes.

### ViewModels

#### `MorseTap/Presentation/Practice/PracticeViewModel.swift`

Update to manage mode list and selection:

- Property `availableModes: [ExerciseMode]` — returns `ExerciseMode.allCases`
- Property `selectedMode: ExerciseMode?` — tracks currently selected mode for navigation
- Method `selectMode(_ mode: ExerciseMode)` — sets selected mode to trigger navigation

### Views

#### `MorseTap/Presentation/Practice/PracticeView.swift`

Replace placeholder with Exercise Selection screen:

- Embed in `NavigationStack`
- Display list of exercise modes using `List` or `LazyVStack`
- Each mode item shows:
  - Mode display name (`ExerciseMode.displayName`)
  - Mode description (`ExerciseMode.description`)
  - Visual indicator (chevron or arrow)
- Use `navigationDestination(item:)` for navigation to `ExerciseView`
- Navigation title: "Practice"

#### `MorseTap/Presentation/Practice/ExerciseView.swift`

Create new placeholder view as navigation destination:

- Accept `ExerciseMode` as init parameter
- Display mode name as placeholder content
- Navigation title based on mode

### Shared Components

No changes.

### Utilities

No changes.

### Models/Types

No changes (uses existing `ExerciseMode`).

### Refactoring

No changes.

### NFRs

- Simple, clean UI without complex animations
- Navigation must work correctly and pass mode
- SwiftUI previews for all views
- Follow MVVM: View binds to ViewModel, no business logic in View
- Use SwiftUI navigation APIs (`NavigationStack`, `navigationDestination`)

## Acceptance criteria

- [ ] App compiles without errors in Xcode
- [ ] Practice tab shows Exercise Selection screen with 4 modes
- [ ] Each mode displays title and description
- [ ] Tapping a mode navigates to ExerciseView
- [ ] ExerciseView receives correct `ExerciseMode`
- [ ] Back navigation works correctly
- [ ] SwiftUI previews render for `PracticeView` and `ExerciseView`
- [ ] Code follows AGENTS.md rules

## Post-implementation verification

1. Build the project: Xcode → Product → Build (⌘+B)
2. Run in Simulator: Xcode → Product → Run (⌘+R)
3. Navigate to Practice tab
4. Verify all 4 modes are displayed with titles and descriptions
5. Tap each mode and verify navigation to ExerciseView
6. Verify ExerciseView shows correct mode name
7. Verify back navigation works
8. Check SwiftUI previews: `PracticeView`, `ExerciseView`

## Documentation update

### README.md

No changes required.

### AGENTS.md

No changes required — Practice module structure already documented.

### Module AGENTS.md

Not applicable for this task.

## Post-implementation code preparation

1. Verify all new files are added to Xcode project
2. Ensure all files are properly formatted
3. Remove any debug print statements
4. Run SwiftLint and fix issues
5. Verify project builds in Debug configuration
6. Prepare for code review
