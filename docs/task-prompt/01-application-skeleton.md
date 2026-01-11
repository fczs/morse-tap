# Application Skeleton Implementation

## Affected modules

- `MorseTap/App/MorseTapApp.swift`
- `MorseTap/Presentation/ContentView.swift`
- `MorseTap/Presentation/Learn/LearnView.swift`
- `MorseTap/Presentation/Learn/LearnViewModel.swift`
- `MorseTap/Presentation/Practice/PracticeView.swift`
- `MorseTap/Presentation/Practice/PracticeViewModel.swift`
- `MorseTap/Presentation/Progress/ProgressView.swift`
- `MorseTap/Presentation/Progress/ProgressViewModel.swift`
- `MorseTap/Presentation/Settings/SettingsView.swift`
- `MorseTap/Presentation/Settings/SettingsViewModel.swift`
- `MorseTap/Domain/Services/MorseInputProcessing.swift`
- `MorseTap/Domain/Services/ExerciseGenerating.swift`
- `MorseTap/Domain/Services/ProgressTracking.swift`

## Goal

Implement the initial application skeleton for an iOS SwiftUI app with TabView navigation, MVVM architecture with ViewModels for each screen, and empty service protocols for future feature development. The app must compile and run, providing a foundation for subsequent feature implementation.

## Dependencies

None. This is the first task in the project.

## Execution plan

1. Implement the requested changes (App entry point, Views, ViewModels, Service protocols)
2. Type checks and build verification (Xcode build)
3. Post-implementation verification (Simulator run, SwiftUI previews)
4. Quality checks (SwiftLint, code review)
5. Documentation update (AGENTS.md if needed)
6. Finalization

## Pre-implementation code preparation

1. Open the project in Xcode: `MorseTap.xcodeproj`
2. Verify the folder structure exists: `MorseTap/App`, `MorseTap/Presentation`, `MorseTap/Domain`, `MorseTap/Data`, `MorseTap/Shared`
3. Ensure iOS 17+ deployment target is set in project settings

## Terms/Context

- **@Observable** — Swift 5.9 macro for observable objects, replacement for ObservableObject
- **MVVM** — Model-View-ViewModel architecture pattern
- **Clean Architecture** — Separation of concerns: Presentation → Domain → Data

## Block requirements

### Domain Services

#### `MorseTap/Domain/Services/MorseInputProcessing.swift`

Create protocol `MorseInputProcessing` with the following interface:

- `func processInput(_ duration: TimeInterval) -> MorseSignal` — converts tap duration to dot or dash
- `func validateSymbol(_ signals: [MorseSignal]) -> Character?` — validates signal sequence and returns recognized character
- `func reset()` — resets current input state

#### `MorseTap/Domain/Services/ExerciseGenerating.swift`

Create protocol `ExerciseGenerating` with the following interface:

- `func generateExercise(mode: ExerciseMode, difficulty: Difficulty) -> Exercise` — generates exercise based on mode and difficulty
- `func getNextSymbol() -> Character` — returns next symbol for practice

#### `MorseTap/Domain/Services/ProgressTracking.swift`

Create protocol `ProgressTracking` with the following interface:

- `func recordAttempt(symbol: Character, isCorrect: Bool, duration: TimeInterval)` — records practice attempt
- `func getStatistics() -> Statistics` — returns aggregated statistics
- `func getWeakSymbols() -> [Character]` — returns symbols needing more practice

### Data Repositories

No changes. Folder structure only.

### ViewModels

#### `MorseTap/Presentation/Learn/LearnViewModel.swift`

Create class `LearnViewModel` with `@Observable` macro:

- Empty class with placeholder for future symbol list and learning logic

#### `MorseTap/Presentation/Practice/PracticeViewModel.swift`

Create class `PracticeViewModel` with `@Observable` macro:

- Empty class with placeholder for future exercise management

#### `MorseTap/Presentation/Progress/ProgressViewModel.swift`

Create class `ProgressViewModel` with `@Observable` macro:

- Empty class with placeholder for future statistics display

#### `MorseTap/Presentation/Settings/SettingsViewModel.swift`

Create class `SettingsViewModel` with `@Observable` macro:

- Empty class with placeholder for future settings management

### Views

#### `MorseTap/App/MorseTapApp.swift`

- Use `@main` attribute for app entry point
- Create `WindowGroup` with `ContentView` as root

#### `MorseTap/Presentation/ContentView.swift`

- Implement `TabView` with four tabs: Learn, Practice, Progress, Settings
- Use SF Symbols for tab icons: `book.fill`, `hand.tap.fill`, `chart.bar.fill`, `gearshape.fill`

#### `MorseTap/Presentation/Learn/LearnView.swift`

- Wrap content in `NavigationStack`
- Create instance of `LearnViewModel` using `@State`
- Display placeholder text "Learn Morse Tap"
- Add `#Preview` macro

#### `MorseTap/Presentation/Practice/PracticeView.swift`

- Wrap content in `NavigationStack`
- Create instance of `PracticeViewModel` using `@State`
- Display placeholder text "Practice Morse Tap"
- Add `#Preview` macro

#### `MorseTap/Presentation/Progress/ProgressView.swift`

- Wrap content in `NavigationStack`
- Create instance of `ProgressViewModel` using `@State`
- Display placeholder text "Your Progress"
- Add `#Preview` macro

#### `MorseTap/Presentation/Settings/SettingsView.swift`

- Wrap content in `NavigationStack`
- Create instance of `SettingsViewModel` using `@State`
- Display placeholder text "Settings"
- Add `#Preview` macro

### Shared Components

No changes. Folder structure only.

### Utilities

No changes. Folder structure only.

### Models/Types

#### `MorseTap/Domain/Models/MorseSignal.swift`

Create enum `MorseSignal`:

- `case dot`
- `case dash`

#### `MorseTap/Domain/Models/ExerciseMode.swift`

Create enum `ExerciseMode`:

- `case codeToWord`
- `case codeToSentence`
- `case wordToCode`
- `case sentenceToCode`

#### `MorseTap/Domain/Models/Difficulty.swift`

Create enum `Difficulty`:

- `case beginner`
- `case intermediate`
- `case advanced`

#### `MorseTap/Domain/Models/Exercise.swift`

Create struct `Exercise`:

- `let mode: ExerciseMode`
- `let difficulty: Difficulty`
- `let content: String`

#### `MorseTap/Domain/Models/Statistics.swift`

Create struct `Statistics`:

- `let totalAttempts: Int`
- `let correctAttempts: Int`
- `let accuracy: Double`
- `let currentStreak: Int`

### Refactoring

No refactoring required. This is a greenfield implementation.

### NFRs

- All files must compile without errors
- All SwiftUI previews must render correctly
- Code must follow Swift naming conventions (PascalCase for types, camelCase for properties)
- All types must be strictly typed (no `Any`)

## Acceptance criteria

- [ ] App compiles without errors in Xcode
- [ ] App launches in iOS Simulator
- [ ] TabView displays four tabs with correct icons and labels
- [ ] Each tab navigates to its respective placeholder screen
- [ ] All SwiftUI previews render correctly
- [ ] All ViewModels are created with `@Observable` macro
- [ ] All service protocols are defined with documented interfaces
- [ ] All domain models are created as enums/structs
- [ ] Folder structure matches AGENTS.md Layer Structure
- [ ] Code follows AGENTS.md Code Quality and Style guidelines

## Post-implementation verification

1. Build the project: Xcode → Product → Build (⌘+B)
2. Run in Simulator: Xcode → Product → Run (⌘+R)
3. Verify each tab displays correct placeholder content
4. Check SwiftUI previews for all Views (⌥+⌘+P)
5. Verify no warnings or errors in Xcode console
6. Run SwiftLint if configured

## Documentation update

### README.md

No changes required for this task.

### AGENTS.md

Verify the Layer Structure section matches the implemented folder structure. No changes expected.

### Module AGENTS.md

Not applicable. Module-level AGENTS.md files will be created in future tasks when modules have significant implementation.

## Post-implementation code preparation

1. Verify all new files are added to Xcode project
2. Ensure all files are properly formatted
3. Remove any debug print statements
4. Verify project builds in both Debug and Release configurations
5. Prepare for code review
