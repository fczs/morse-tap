# SwiftData Storage Models and Repositories Implementation

## Affected modules

- `MorseTap/Data/Storage/UserProfileModel.swift`
- `MorseTap/Data/Storage/SymbolStatisticsModel.swift`
- `MorseTap/Data/Storage/ExerciseStatisticsModel.swift`
- `MorseTap/Data/Repositories/UserProfileRepository.swift`
- `MorseTap/Data/Repositories/StatisticsRepository.swift`
- `MorseTap/App/MorseTapApp.swift`
- `MorseTapTests/Data/RepositoryTests.swift`

## Goal

Implement SwiftData storage models and repository APIs for persistent progress tracking. This includes user profile, per-symbol statistics, and per-exercise statistics. Repositories are protocol-based for dependency injection and testability.

## Dependencies

- Task T1: Application Skeleton (completed) — provides project structure
- No domain service dependencies (repositories are data layer only)

## Execution plan

1. Implement the requested changes (Storage models, Repositories, App configuration)
2. Type checks and build verification (Xcode build)
3. Post-implementation verification (integration tests)
4. Quality checks (SwiftLint, code review)
5. Documentation update (AGENTS.md if needed)
6. Finalization

## Pre-implementation code preparation

1. Open the project in Xcode: `MorseTap.xcodeproj`
2. Verify `MorseTap/Data/Storage/` folder exists
3. Verify `MorseTap/Data/Repositories/` folder exists
4. Verify `MorseTap/App/MorseTapApp.swift` exists
5. Verify test target `MorseTapTests` exists

## Terms/Context

- **UserProfile** — Single record storing user-level data (streak, dates)
- **SymbolStatistics** — Per-character learning statistics (one record per symbol)
- **ExerciseStatistics** — Per-mode exercise statistics (one record per exercise mode)
- **Repository** — Data access layer providing CRUD operations with protocol abstraction

## Block requirements

### Domain Services

No changes.

### Data Storage

#### `MorseTap/Data/Storage/UserProfileModel.swift`

Create SwiftData model for user profile:

```swift
@Model
final class UserProfileModel {
    var firstLaunchDate: Date
    var currentStreak: Int
    var longestStreak: Int
    var lastActivityDate: Date
    
    init(
        firstLaunchDate: Date = Date(),
        currentStreak: Int = 0,
        longestStreak: Int = 0,
        lastActivityDate: Date = Date()
    )
}
```

#### `MorseTap/Data/Storage/SymbolStatisticsModel.swift`

Create SwiftData model for symbol statistics:

```swift
@Model
final class SymbolStatisticsModel {
    @Attribute(.unique) var symbol: String
    var totalAttempts: Int
    var correctAttempts: Int
    var totalInputTime: TimeInterval
    var lastTrainedDate: Date?
    
    var accuracy: Double { computed from correctAttempts/totalAttempts }
    var averageInputTime: TimeInterval { computed from totalInputTime/totalAttempts }
    
    init(
        symbol: String,
        totalAttempts: Int = 0,
        correctAttempts: Int = 0,
        totalInputTime: TimeInterval = 0,
        lastTrainedDate: Date? = nil
    )
}
```

#### `MorseTap/Data/Storage/ExerciseStatisticsModel.swift`

Create SwiftData model for exercise statistics:

```swift
@Model
final class ExerciseStatisticsModel {
    @Attribute(.unique) var modeRawValue: String
    var totalAttempts: Int
    var correctAttempts: Int
    var totalTime: TimeInterval
    var lastPlayedDate: Date?
    
    var accuracy: Double { computed }
    var averageTime: TimeInterval { computed }
    
    init(
        modeRawValue: String,
        totalAttempts: Int = 0,
        correctAttempts: Int = 0,
        totalTime: TimeInterval = 0,
        lastPlayedDate: Date? = nil
    )
}
```

### Data Repositories

#### `MorseTap/Data/Repositories/UserProfileRepository.swift`

Create protocol and implementation:

```swift
protocol UserProfileRepositoryProtocol {
    func loadOrCreateProfile() async throws -> UserProfileModel
    func updateStreak() async throws
    func recordActivity() async throws
}

@MainActor
final class UserProfileRepository: UserProfileRepositoryProtocol {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext)
    
    func loadOrCreateProfile() async throws -> UserProfileModel
    // Returns existing profile or creates new one
    
    func updateStreak() async throws
    // Increments streak if last activity was yesterday, resets if gap > 1 day
    
    func recordActivity() async throws
    // Updates lastActivityDate to now
}
```

#### `MorseTap/Data/Repositories/StatisticsRepository.swift`

Create protocol and implementation:

```swift
protocol StatisticsRepositoryProtocol {
    func getStatistics(forSymbol symbol: Character) async throws -> SymbolStatisticsModel?
    func getAllSymbolStatistics() async throws -> [SymbolStatisticsModel]
    func recordSymbolAttempt(symbol: Character, isCorrect: Bool, inputTime: TimeInterval) async throws
    
    func getStatistics(forMode mode: ExerciseMode) async throws -> ExerciseStatisticsModel?
    func getAllExerciseStatistics() async throws -> [ExerciseStatisticsModel]
    func recordExerciseAttempt(mode: ExerciseMode, isCorrect: Bool, time: TimeInterval) async throws
}

@MainActor
final class StatisticsRepository: StatisticsRepositoryProtocol {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext)
    
    func getStatistics(forSymbol symbol: Character) async throws -> SymbolStatisticsModel?
    // Fetch by symbol, return nil if not found
    
    func getAllSymbolStatistics() async throws -> [SymbolStatisticsModel]
    // Fetch all symbol statistics
    
    func recordSymbolAttempt(symbol: Character, isCorrect: Bool, inputTime: TimeInterval) async throws
    // Create or update statistics for symbol
    
    func getStatistics(forMode mode: ExerciseMode) async throws -> ExerciseStatisticsModel?
    // Fetch by mode rawValue
    
    func getAllExerciseStatistics() async throws -> [ExerciseStatisticsModel]
    // Fetch all exercise statistics
    
    func recordExerciseAttempt(mode: ExerciseMode, isCorrect: Bool, time: TimeInterval) async throws
    // Create or update statistics for mode
}
```

### ViewModels

No changes.

### Views

No changes.

### App Configuration

#### `MorseTap/App/MorseTapApp.swift`

Update app entry point to configure SwiftData:

- Import SwiftData
- Create ModelContainer with all model types:
  - `UserProfileModel.self`
  - `SymbolStatisticsModel.self`
  - `ExerciseStatisticsModel.self`
- Add `.modelContainer()` modifier to root view
- Handle container creation errors gracefully

### Shared Components

No changes.

### Utilities

No changes.

### Models/Types

No changes to Domain/Models. Storage models are separate in Data/Storage.

### Refactoring

No refactoring required.

### NFRs

- All files must compile without errors
- SwiftData models must use proper attributes (`@Model`, `@Attribute`)
- Repositories must be `@MainActor` for thread safety
- All repository methods must be `async throws`
- Computed properties must handle division by zero
- Repositories must be injectable via protocols

## Acceptance criteria

- [ ] App compiles without errors in Xcode
- [ ] `UserProfileModel` SwiftData model created
- [ ] `SymbolStatisticsModel` SwiftData model created
- [ ] `ExerciseStatisticsModel` SwiftData model created
- [ ] `UserProfileRepositoryProtocol` and implementation created
- [ ] `StatisticsRepositoryProtocol` and implementation created
- [ ] SwiftData ModelContainer configured in app entry point
- [ ] `loadOrCreateProfile()` returns or creates profile
- [ ] `recordSymbolAttempt()` creates or updates symbol stats
- [ ] `recordExerciseAttempt()` creates or updates exercise stats
- [ ] Integration test verifies write and read operations
- [ ] Code follows AGENTS.md Code Quality and Style guidelines

## Post-implementation verification

1. Build the project: Xcode → Product → Build (⌘+B)
2. Run unit tests: Xcode → Product → Test (⌘+U)
3. Verify app launches in Simulator without crashes
4. Verify no SwiftData schema errors in console
5. Run SwiftLint if configured

## Documentation update

### README.md

No changes required for this task.

### AGENTS.md

Verify Data Layer section mentions:
- `UserSettingsRepository` — already mentioned
- `ProgressRepository` — verify new repositories align with this

### Module AGENTS.md

Not applicable for this task.

## Post-implementation code preparation

1. Verify all new files are added to Xcode project
2. Ensure all files are properly formatted
3. Remove any debug print statements
4. Verify project builds in both Debug and Release configurations
5. Verify SwiftData container initializes correctly
6. Prepare for code review
