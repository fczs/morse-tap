# AGENTS.md — Morse Tap (root)

## Project Goal

iOS application for learning and practicing Morse code. The core feature is Morse input via a single large circular button, emphasizing rhythm, visualization, and gradual skill progression.

## Tech Stack

- **Platform:** iOS 17+
- **Language:** Swift 5.9+
- **UI Framework:** SwiftUI
- **Architecture:** MVVM
- **Concurrency:** Swift Concurrency (`async/await`)
- **State Management:** SwiftUI (`@State`, `@Observable`, `@Environment`)
- **Data Storage:**
  - UserDefaults — user settings (`SettingsStore`)
  - SwiftData — learning progress and statistics

## Architecture & Layers

- Base scheme — Clean Architecture with MVVM presentation layer.
- Morse logic and exercise generation must be implemented in a separate Domain / Service layer.
- UI must not contain business logic.
- Every module must expose a clear public API.

### Layer Structure

```
MorseTap/
├── App/                    # App entry point, configuration, DI
├── Presentation/           # SwiftUI Views and ViewModels (MVVM)
│   ├── Learn/              # Learning alphabet module
│   ├── Practice/           # Practice exercises module
│   ├── Progress/           # Statistics and progress module
│   └── Settings/           # User settings module
├── Domain/                 # Business logic, use cases, protocols
│   ├── Models/             # Domain entities
│   ├── Services/           # Morse logic, exercise generation
│   └── UseCases/           # Application use cases
├── Data/                   # Data layer
│   ├── Repositories/       # Data repositories
│   ├── Storage/            # SwiftData models, UserDefaults wrappers
│   └── Mappers/            # Entity mappers
└── Shared/                 # Reusable components, utilities, extensions
    ├── Components/         # Common UI components
    ├── Extensions/         # Swift/SwiftUI extensions
    ├── Utilities/          # Helper functions
    └── Resources/          # Assets, colors, fonts
```

## Key Modules

### Presentation Layer

- `Learn/` — Symbol list screen (`LearnView`) and symbol card screen (`SymbolCardView`) for learning the alphabet. Includes input validation and statistics recording.
- `Practice/` — Exercise selection and exercise execution screens (placeholder).
- `Progress/` — Statistics dashboard showing learning progress (placeholder).
- `Settings/` — App configuration (`SettingsView`): timing thresholds, sound, vibration, difficulty level.

### Domain Layer

- `MorseAlphabet` — Morse alphabet data (A-Z, 0-9), symbol lookup, encoding/decoding text to/from Morse patterns.
- `MorseInputEngine` — Processes press events into dot/dash signals, detects symbol completion via pause, supports reset and delete operations.
- `ExerciseGenerating` (protocol) — Generates exercises based on difficulty and progress.
- `ProgressTracking` (protocol) — Tracks and calculates learning statistics.

### Domain Models

- `MorseSymbol` — Character + Morse pattern + computed signals array.
- `MorseSignal` — Enum: `.dot`, `.dash`.
- `MorseInputEvent` — Enum: `.pressDown(timestamp)`, `.pressUp(timestamp)`.
- `MorseTimingConfig` — Configurable timing thresholds for signal classification.
- `Difficulty` — Enum with timing multipliers (beginner/intermediate/advanced).
- `Exercise`, `ExerciseMode`, `Statistics` — Exercise and statistics models.

### Data Layer

- `SettingsStore` — UserDefaults-backed observable settings (timing, feedback, difficulty).
- `StatisticsRepository` — SwiftData-based symbol and exercise statistics storage.
- `UserProfileRepository` — SwiftData-based user profile and streak tracking.
- `SymbolStatisticsModel`, `ExerciseStatisticsModel`, `UserProfileModel` — SwiftData models.

### Shared Components

- `MorseInputButton` — Large circular button for Morse input with press/release detection.
- `MorseSignalsView` — Visual representation of dots and dashes (animated).
- `MorseInputView` — Composite component: button + signals display + engine integration.
- `HapticFeedbackManager` — Haptic feedback for signals, symbol completion, success/error.

## Navigation Structure

The application uses a TabBar with four tabs:

1. **Learn** — Symbol list and learning cards
2. **Practice** — Exercise modes (Code→Text, Text→Code)
3. **Progress** — Statistics and achievements
4. **Settings** — App configuration

## Code Navigation

- Keep module-specific Views, ViewModels, and Models inside their respective folders.
- Create new segments only when justified.
- Export public entities through clear module interfaces.
- Follow Swift naming conventions (PascalCase for types, camelCase for properties/methods).

## Code Quality and Style

- Use SwiftLint for code style enforcement.
- Follow Apple's Swift API Design Guidelines.
- All new code must be strictly typed.
- Use Swift Concurrency for asynchronous operations.
- Write unit tests for Domain layer services.
- Use SwiftUI previews for UI development.

## Non-Functional Requirements

- The application must work fully offline.
- Progress must be saved automatically.
- The interface must be minimalist, visually stable, and suitable for long training sessions.

## Extensibility

The architecture must allow:

- Adding new exercise modes
- Adding audio-based modes
- Adding synchronization (e.g., iCloud) without redesigning the core

## Important for AI

- Communicate in Russian with the user; generate code/files in English.
- Read the relevant `AGENTS.md` (root or module-level) before making changes.
- Do not create new markdown files unless explicitly requested.
- Each logical part must be implemented as an isolated module.
- UI, Morse logic, and storage must be strictly separated.
- Code must be readable and designed for future extension.
