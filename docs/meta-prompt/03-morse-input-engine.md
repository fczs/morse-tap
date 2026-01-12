# Universal Morse Input Engine

## Goals

- Provide a pure logic engine that converts press events into Morse signals (dot/dash)
- Detect symbol completion based on configurable pause duration
- Enable real-time feedback for in-progress symbol input

## Functional requirements

### Domain/

#### Models/

- Add input event types representing press down and press up with timestamp
- Add configuration model for timing thresholds (dot/dash duration, symbol pause)

#### Services/

- Add MorseInputEngine service providing:
  - Press event processing (down/up with timestamp)
  - Current in-progress signals access
  - Symbol completion emission when pause threshold is reached
  - Reset current input state
  - Delete last entered signal
- Use async/await or timer abstraction to detect pause without busy-waiting

## Out-of-scope

- UI components and SwiftUI views
- Haptic and sound feedback
- Visual representation of signals
- Character recognition (handled by MorseAlphabet service)
- Persistence and statistics tracking

## Affected layers and modules (Yes/No/Unknown)

- App/: No
- Presentation/Learn: No
- Presentation/Practice: No
- Presentation/Progress: No
- Presentation/Settings: No
- Domain/Services: Yes
- Domain/UseCases: No
- Domain/Models: Yes
- Data/Repositories: No
- Data/Storage: No
- Shared/Components: No
- Shared/Utilities: No

## Dependencies and artifacts

- TECH_SPEC.md: Section 4.2 (Universal Component: Morse Input), Section 4.2.1 (Morse Input Button)
- AGENTS.md: Domain Layer — InputProcessor description
- Task 02: Morse Alphabet Domain (for MorseSignal model)
