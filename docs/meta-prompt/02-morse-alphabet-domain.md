# Morse Alphabet Domain

## Goals

- Provide a complete Morse alphabet data layer (A–Z, 0–9)
- Enable text-to-Morse and Morse-to-text conversions
- Establish a testable, UI-independent Domain foundation

## Functional requirements

### Domain/

#### Models/

- Add MorseSymbol entity representing a single character with its Morse pattern

#### Services/

- Add MorseAlphabet service providing:
  - Full alphabet listing
  - Lookup by character
  - Lookup by Morse pattern
- Add encoding operation: convert text string to Morse tokens
- Add decoding operation: convert Morse token to character (returns nil for unknown patterns)

## Out-of-scope

- UI components and screens
- Input timing and gesture handling
- Sound and haptic feedback
- Exercise generation logic
- Data persistence
- Presentation layer changes

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

- TECH_SPEC.md: Section 4.1 (Module: Learning the Alphabet), Section 4.2 (Universal Component: Morse Input)
- AGENTS.md: Domain Layer — MorseCodeService description
