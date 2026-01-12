# Universal Morse Input Engine Implementation

## Affected modules

- `MorseTap/Domain/Models/MorseInputEvent.swift`
- `MorseTap/Domain/Models/MorseTimingConfig.swift`
- `MorseTap/Domain/Services/MorseInputEngine.swift`
- `MorseTapTests/Domain/MorseInputEngineTests.swift`

## Goal

Implement a pure logic Morse input engine that converts press events into dot/dash signals and detects symbol completion based on pause duration. The engine provides real-time access to in-progress signals and emits completed symbols using async/await pattern. No UI dependencies.

## Dependencies

- Task 02: Morse Alphabet Domain (completed) — provides `MorseSignal` enum

## Execution plan

1. Implement the requested changes (Models, MorseInputEngine service)
2. Type checks and build verification (Xcode build)
3. Post-implementation verification (unit tests)
4. Quality checks (SwiftLint, code review)
5. Documentation update (AGENTS.md if needed)
6. Finalization

## Pre-implementation code preparation

1. Open the project in Xcode: `MorseTap.xcodeproj`
2. Verify `MorseTap/Domain/Models/MorseSignal.swift` exists
3. Verify `MorseTap/Domain/Services/` folder exists
4. Verify test target `MorseTapTests` exists

## Terms/Context

- **Press event** — User interaction representing finger down or up with timestamp
- **Dot** — Short press (duration < dotMaxDuration)
- **Dash** — Long press (duration >= dashMinDuration)
- **Symbol pause** — Time between signals that triggers symbol completion
- **In-progress signals** — Current sequence of dots/dashes before symbol completion

## Block requirements

### Domain Services

#### `MorseTap/Domain/Services/MorseInputEngine.swift`

Create protocol `MorseInputEngineProtocol` with the following interface:

- `var currentSignals: [MorseSignal] { get }` — returns in-progress signals
- `var config: MorseTimingConfig { get set }` — timing configuration
- `var onSymbolCompleted: (([MorseSignal]) -> Void)? { get set }` — callback when symbol is completed
- `func pressDown(at timestamp: Date)` — handles press start
- `func pressUp(at timestamp: Date)` — handles press end, classifies signal
- `func reset()` — clears current signals and cancels pending completion
- `func deleteLastSignal()` — removes last signal from current sequence

Create class `MorseInputEngine` implementing `MorseInputEngineProtocol`:

- Store press down timestamp to calculate duration on press up
- Classify signal based on duration:
  - `duration < config.dotMaxDuration` → `.dot`
  - `duration >= config.dashMinDuration` → `.dash`
  - Between thresholds → `.dot` (default to shorter)
- After adding signal, start async Task to wait for `symbolPauseDuration`
- If no new press occurs within pause duration, emit `onSymbolCompleted` with current signals and clear them
- Cancel pending completion Task when new press occurs
- Use `@MainActor` for thread safety
- Mark class as `@Observable` for SwiftUI integration readiness

Default timing values (configurable):

- `dotMaxDuration`: 0.2 seconds
- `dashMinDuration`: 0.2 seconds
- `symbolPauseDuration`: 0.6 seconds

### Data Repositories

No changes.

### ViewModels

No changes.

### Views

No changes.

### Shared Components

No changes.

### Utilities

No changes.

### Models/Types

#### `MorseTap/Domain/Models/MorseInputEvent.swift`

Create enum `MorseInputEvent`:

- `case pressDown(timestamp: Date)`
- `case pressUp(timestamp: Date)`

#### `MorseTap/Domain/Models/MorseTimingConfig.swift`

Create struct `MorseTimingConfig`:

- `var dotMaxDuration: TimeInterval` — maximum duration for dot (default: 0.2)
- `var dashMinDuration: TimeInterval` — minimum duration for dash (default: 0.2)
- `var symbolPauseDuration: TimeInterval` — pause to complete symbol (default: 0.6)
- `static var standard: MorseTimingConfig` — default configuration

### Refactoring

#### `MorseTap/Domain/Services/MorseInputProcessing.swift`

This protocol can be deprecated or removed as `MorseInputEngine` provides more complete functionality. Keep for now but mark with comment that `MorseInputEngine` is the preferred implementation.

### NFRs

- All files must compile without errors
- All unit tests must pass
- Engine must be stateless regarding UI (pure logic)
- No busy-waiting — use async Task for pause detection
- Thread-safe — use `@MainActor`
- Code must follow Swift naming conventions

## Acceptance criteria

- [ ] App compiles without errors in Xcode
- [ ] `MorseInputEvent` enum created with pressDown/pressUp cases
- [ ] `MorseTimingConfig` struct created with timing thresholds
- [ ] `MorseInputEngineProtocol` protocol defined with all required methods
- [ ] `MorseInputEngine` class implements the protocol
- [ ] Press duration correctly classifies dot vs dash
- [ ] Symbol completion triggers after pause duration
- [ ] `reset()` clears signals and cancels pending completion
- [ ] `deleteLastSignal()` removes last signal
- [ ] New press cancels pending symbol completion
- [ ] Unit tests cover: dot/dash classification, symbol completion timing, reset, delete
- [ ] Code follows AGENTS.md Code Quality and Style guidelines

## Post-implementation verification

1. Build the project: Xcode → Product → Build (⌘+B)
2. Run unit tests: Xcode → Product → Test (⌘+U)
3. Verify all tests pass in test navigator
4. Verify no warnings or errors in Xcode console
5. Run SwiftLint if configured

## Documentation update

### README.md

No changes required for this task.

### AGENTS.md

Verify Domain Layer section mentions InputProcessor. The new `MorseInputEngine` implements this functionality.

### Module AGENTS.md

Not applicable for this task.

## Post-implementation code preparation

1. Verify all new files are added to Xcode project
2. Verify test target includes new test files
3. Ensure all files are properly formatted
4. Remove any debug print statements
5. Verify project builds in both Debug and Release configurations
6. Prepare for code review
