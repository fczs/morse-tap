# Practice: Generic Exercise Screen Implementation

## Affected modules

- `MorseTap/Presentation/Practice/ExerciseView.swift`
- `MorseTap/Presentation/Practice/ExerciseViewModel.swift` (new)
- `MorseTap/Presentation/Practice/PracticeView.swift`
- `MorseTap/Data/Repositories/StatisticsRepository.swift`

## Goal

Implement the Generic Exercise Screen that provides a complete end-to-end exercise flow: load exercise from generator, display prompt with progress indicator, accept user input via placeholder text field, validate answer, show feedback, and record statistics. This screen serves as the foundation for all four exercise modes.

## Dependencies

- Task T5: SwiftData Storage (completed) — provides `StatisticsRepository`, `StatisticsRepositoryProtocol`
- Task T9: Practice Core (completed) — provides `ExerciseGenerator`, `ExerciseValidator`, `Exercise`, `ValidationResult`
- Task T10: Exercise Selection Screen (completed) — provides navigation from `PracticeView` to `ExerciseView`

## Execution plan

1. Create `ExerciseViewModel` with exercise session management
2. Update `ExerciseView` to display exercise with input and validation
3. Update `PracticeView` to pass dependencies to `ExerciseView`
4. Build and verify in Xcode
5. Test end-to-end flow in Simulator
6. Verify SwiftUI previews
7. Run SwiftLint
8. Documentation update
9. Finalization

## Pre-implementation code preparation

1. Open the project in Xcode: `MorseTap.xcodeproj`
2. Verify `MorseTap/Domain/Services/ExerciseGenerator.swift` exists with `generateExercise(mode:difficulty:)` method
3. Verify `MorseTap/Domain/Services/ExerciseValidator.swift` exists with `validate(exercise:userAnswer:)` method
4. Verify `MorseTap/Data/Repositories/StatisticsRepository.swift` exists with `recordExerciseAttempt(mode:isCorrect:time:)` method
5. Review existing `ExerciseView.swift` placeholder implementation

## Terms/Context

- **Generic Exercise Screen** — Universal exercise execution screen for all four practice modes
- **Exercise Session** — A sequence of exercises with tracked progress (e.g., 1/10)
- **Placeholder Input** — Text field used for initial implementation; will be replaced with Morse input in future tasks
- **Validation Feedback** — Visual indication of correct/incorrect answer after submission

## Block requirements

### Domain Services

No changes.

### Data Repositories

#### `MorseTap/Data/Repositories/StatisticsRepository.swift`

Use existing methods:

- `recordExerciseAttempt(mode: ExerciseMode, isCorrect: Bool, time: TimeInterval) async throws` — record exercise attempt after validation
- `recordSymbolAttempt(symbol: Character, isCorrect: Bool, inputTime: TimeInterval) async throws` — record per-symbol statistics

### ViewModels

#### `MorseTap/Presentation/Practice/ExerciseViewModel.swift` (new file)

Create new ViewModel to manage exercise session:

Properties:
- `mode: ExerciseMode` — exercise mode passed from selection screen
- `currentExercise: Exercise?` — currently active exercise
- `currentIndex: Int` — current exercise number (0-based)
- `totalExercises: Int` — total exercises in session (default: 10)
- `userAnswer: String` — bound to text field input
- `validationResult: ValidationResult?` — result after submission
- `isShowingResult: Bool` — controls result feedback visibility
- `isSessionComplete: Bool` — true when all exercises completed
- `startTime: Date?` — tracks time for current exercise

Computed properties:
- `progressText: String` — formatted as "1 / 10"
- `canSubmit: Bool` — true when userAnswer is not empty and not showing result

Dependencies (injected via init):
- `generator: ExerciseGenerating` — default `ExerciseGenerator()`
- `validator: ExerciseValidating` — default `ExerciseValidator()`
- `statisticsRepository: StatisticsRepositoryProtocol?` — optional, for recording stats

Methods:
- `init(mode: ExerciseMode, generator: ExerciseGenerating, validator: ExerciseValidating, statisticsRepository: StatisticsRepositoryProtocol?)` — initialize with dependencies
- `loadExercise()` — generate new exercise using generator, reset input state, record start time
- `submitAnswer() async` — validate answer, show result, record statistics
- `proceedToNext()` — advance to next exercise or mark session complete
- `restartSession()` — reset session state and load first exercise

Private methods:
- `recordStatistics(result: ValidationResult) async` — record to repository if available
- `recordSymbolStatistics(for exercise: Exercise, isCorrect: Bool) async` — extract symbols from exercise and record each

Use `@Observable` macro for SwiftUI integration.

Mark class as `@MainActor` for thread safety with repository calls.

### Views

#### `MorseTap/Presentation/Practice/ExerciseView.swift`

Replace placeholder with functional exercise screen:

Structure:
- Accept `ExerciseMode` and optional `StatisticsRepositoryProtocol` via init
- Create `ExerciseViewModel` as `@State` property
- Call `viewModel.loadExercise()` in `.onAppear`

Layout (VStack):
1. Progress indicator — display `viewModel.progressText` at top
2. Prompt section — display `viewModel.currentExercise?.prompt` in prominent style
3. Input section:
   - `TextField` bound to `viewModel.userAnswer`
   - For code input modes: use monospace font
   - For text modes: use standard font
   - Disable when showing result
4. Submit button:
   - Title: "Check" or "Submit"
   - Disabled when `!viewModel.canSubmit`
   - Action: call `viewModel.submitAnswer()`
5. Result feedback (conditional on `viewModel.isShowingResult`):
   - Green checkmark for correct, red X for incorrect
   - Show expected answer if incorrect
   - "Next" button to proceed
6. Session complete state (conditional on `viewModel.isSessionComplete`):
   - Success message
   - "Back to Practice" and "Try Again" buttons

Navigation:
- Title: mode display name
- Back button via NavigationStack

Use `.task` modifier for async operations where appropriate.

#### `MorseTap/Presentation/Practice/PracticeView.swift`

Update to pass repository to `ExerciseView`:

- Add `@Environment(\.modelContext) private var modelContext`
- Create `StatisticsRepository` instance using modelContext
- Pass repository to `ExerciseView` in `navigationDestination`

Update `navigationDestination`:
```swift
.navigationDestination(item: $viewModel.selectedMode) { mode in
    ExerciseView(
        mode: mode,
        statisticsRepository: StatisticsRepository(modelContext: modelContext)
    )
}
```

### Shared Components

No changes.

### Utilities

No changes.

### Models/Types

No changes (uses existing `Exercise`, `ExerciseMode`, `ValidationResult`).

### Refactoring

No changes.

### NFRs

- Exercise loads immediately on screen appear
- Input field auto-focuses for text modes
- Result feedback is clear and immediate
- Session progress is visible at all times
- SwiftUI previews for `ExerciseView` with mock data
- Follow MVVM: View binds to ViewModel, business logic in services
- Use Swift Concurrency (`async/await`) for repository calls
- Handle errors gracefully (show alert or retry option)

## Acceptance criteria

- [ ] App compiles without errors in Xcode
- [ ] Navigating to exercise mode loads first exercise
- [ ] Exercise prompt displays correctly for mode
- [ ] Progress indicator shows "1 / 10" format
- [ ] Text field accepts user input
- [ ] Submit button validates answer
- [ ] Correct answer shows green feedback
- [ ] Incorrect answer shows red feedback with expected answer
- [ ] "Next" button loads next exercise
- [ ] Session complete screen appears after all exercises
- [ ] Statistics are recorded to repository (verify in debug)
- [ ] SwiftUI previews render for `ExerciseView`
- [ ] Code follows AGENTS.md rules

## Post-implementation verification

1. Build the project: Xcode → Product → Build (⌘+B)
2. Run in Simulator: Xcode → Product → Run (⌘+R)
3. Navigate to Practice tab
4. Select any exercise mode
5. Verify exercise loads with prompt and progress
6. Enter an answer in text field
7. Tap Submit and verify feedback appears
8. Tap Next and verify next exercise loads
9. Complete 10 exercises and verify session complete screen
10. Verify back navigation works
11. Check Xcode console for any errors
12. Check SwiftUI previews: `ExerciseView`

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
