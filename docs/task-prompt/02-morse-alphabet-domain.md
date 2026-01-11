# Morse Alphabet Domain Implementation

## Affected modules

- `MorseTap/Domain/Models/MorseSymbol.swift`
- `MorseTap/Domain/Services/MorseAlphabet.swift`
- `MorseTapTests/Domain/MorseAlphabetTests.swift`

## Goal

Implement a complete Morse alphabet data layer with encoding and decoding capabilities. The service provides the full alphabet (A–Z, 0–9), supports lookup by character or Morse pattern, and enables text-to-Morse and Morse-to-text conversions. All code must be testable and UI-independent.

## Dependencies

- Task 01: Application Skeleton (completed) — provides Domain/Models and Domain/Services folder structure

## Execution plan

1. Implement the requested changes (MorseSymbol model, MorseAlphabet service)
2. Type checks and build verification (Xcode build)
3. Post-implementation verification (unit tests, Simulator build)
4. Quality checks (SwiftLint, code review)
5. Documentation update (AGENTS.md if needed)
6. Finalization

## Pre-implementation code preparation

1. Open the project in Xcode: `MorseTap.xcodeproj`
2. Verify `MorseTap/Domain/Models/` folder exists
3. Verify `MorseTap/Domain/Services/` folder exists
4. Create test target `MorseTapTests` if not exists

## Terms/Context

- **MorseSymbol** — Domain entity representing a single character with its Morse pattern
- **Morse pattern** — String representation using dots (.) and dashes (-), e.g., ".-" for letter A
- **Encoding** — Converting text characters to Morse patterns
- **Decoding** — Converting Morse patterns back to characters

## Block requirements

### Domain Services

#### `MorseTap/Domain/Services/MorseAlphabet.swift`

Create protocol `MorseAlphabetProviding` with the following interface:

- `var allSymbols: [MorseSymbol] { get }` — returns full alphabet (A–Z, 0–9)
- `func symbol(for character: Character) -> MorseSymbol?` — lookup by character (case-insensitive)
- `func symbol(forPattern pattern: String) -> MorseSymbol?` — lookup by Morse pattern
- `func encode(_ text: String) -> [MorseSymbol?]` — converts text to array of MorseSymbol (nil for unknown characters)
- `func decode(_ pattern: String) -> Character?` — converts single Morse pattern to character (nil if unknown)

Create class `MorseAlphabet` implementing `MorseAlphabetProviding`:

- Initialize with complete alphabet data (A–Z, 0–9)
- Store symbols in efficient data structure for O(1) lookups
- Character lookup must be case-insensitive

Standard Morse alphabet to implement:

| Char | Pattern | Char | Pattern | Char | Pattern |
| ---- | ------- | ---- | ------- | ---- | ------- |
| A    | .-      | N    | -.      | 0    | -----   |
| B    | -...    | O    | ---     | 1    | .----   |
| C    | -.-.    | P    | .--.    | 2    | ..---   |
| D    | -..     | Q    | --.-    | 3    | ...--   |
| E    | .       | R    | .-.     | 4    | ....-   |
| F    | ..-.    | S    | ...     | 5    | .....   |
| G    | --.     | T    | -       | 6    | -....   |
| H    | ....    | U    | ..-     | 7    | --...   |
| I    | ..      | V    | ...-    | 8    | ---..   |
| J    | .---    | W    | .--     | 9    | ----.   |
| K    | -.-     | X    | -..-    |      |         |
| L    | .-..    | Y    | -.--    |      |         |
| M    | --      | Z    | --..    |      |         |

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

#### `MorseTap/Domain/Models/MorseSymbol.swift`

Create struct `MorseSymbol`:

- `let character: Character` — the represented character (uppercase)
- `let pattern: String` — Morse pattern as string (e.g., ".-")
- `var signals: [MorseSignal] { get }` — computed property converting pattern to array of MorseSignal

The `signals` computed property must convert:

- `.` → `MorseSignal.dot`
- `-` → `MorseSignal.dash`

Conform to `Equatable` and `Hashable`.

### Refactoring

No refactoring required.

### NFRs

- All files must compile without errors
- All unit tests must pass
- Code must follow Swift naming conventions
- All types must be strictly typed (no `Any`)
- Service must be stateless and thread-safe
- Lookups must be O(1) complexity

## Acceptance criteria

- [ ] App compiles without errors in Xcode
- [ ] `MorseSymbol` struct created with character, pattern, and signals properties
- [ ] `MorseAlphabetProviding` protocol defined with all required methods
- [ ] `MorseAlphabet` class implements the protocol
- [ ] Full alphabet (A–Z, 0–9) is available via `allSymbols`
- [ ] Lookup by character works (case-insensitive)
- [ ] Lookup by pattern works
- [ ] Encode function converts text to Morse symbols
- [ ] Decode function converts pattern to character
- [ ] Unknown characters/patterns return nil
- [ ] Unit tests cover: lookup, encode/decode for several letters/digits, unknown input cases
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

Verify Domain Layer section mentions MorseCodeService. No changes expected as this implements the described service.

### Module AGENTS.md

Not applicable for this task.

## Post-implementation code preparation

1. Verify all new files are added to Xcode project
2. Verify test target includes new test files
3. Ensure all files are properly formatted
4. Remove any debug print statements
5. Verify project builds in both Debug and Release configurations
6. Prepare for code review
