# SwiftData Storage Models and Repositories

## Goals

- Implement persistent storage for user progress and statistics using SwiftData
- Provide repository APIs for reading and writing progress data
- Enable tracking of per-symbol and per-exercise statistics

## Functional requirements

### Domain/Models

- Add `UserProfile` entity for user-level data: launch date, streak tracking, last activity
- Add `SymbolStatistics` entity for per-symbol learning statistics: attempts, accuracy, timing
- Add `ExerciseStatistics` entity for per-exercise mode statistics: attempts, accuracy, timing

### Data/Storage

- Add SwiftData model container configuration
- Add SwiftData `@Model` classes for all entities

### Data/Repositories

- Add `UserProfileRepository` for user profile operations
- Add `StatisticsRepository` for symbol and exercise statistics operations
- Repositories must be protocol-based for dependency injection
- Operations: load/create profile, get/record symbol stats, get/record exercise stats

### App/

- Configure SwiftData model container in app entry point

## Out-of-scope

- UI integration
- ViewModel changes
- Statistics calculations and aggregations (handled by domain services)
- iCloud sync
- Data migration strategies

## Affected layers and modules (Yes/No/Unknown)

- App/: Yes
- Presentation/Learn: No
- Presentation/Practice: No
- Presentation/Progress: No
- Presentation/Settings: No
- Domain/Services: No
- Domain/UseCases: No
- Domain/Models: Yes
- Data/Repositories: Yes
- Data/Storage: Yes
- Data/Mappers: Unknown
- Shared/Components: No
- Shared/Utilities: No

## Dependencies and artifacts

- TECH_SPEC.md: Section 2.5 (Data Storage), Section 4.4 (Progress Module)
- AGENTS.md: Data Layer section (Repositories, Storage)
