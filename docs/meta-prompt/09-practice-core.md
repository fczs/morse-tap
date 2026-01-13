# Practice Core: Exercise Models, Generator, and Validator

## Goals

- Define complete exercise model for all practice modes
- Implement exercise generator using Morse alphabet and built-in word/sentence list
- Implement answer validator for strict comparison

## Functional requirements

### Domain/Models

- Update `ExerciseMode` with all four modes: codeToWord, codeToSentence, wordToCode, sentenceToCode
- Update `Exercise` model with complete structure: id, mode, prompt, expectedAnswer, metadata (difficulty, symbolCount, createdAt)

### Domain/Services

- Implement `ExerciseGenerator` conforming to `ExerciseGenerating` protocol
- Use `MorseAlphabet` for encoding/decoding
- Built-in word list (50-100 common short words) and sentence list (20-30 simple sentences)
- Generate exercises based on mode and difficulty
- Support random selection with optional weighting by weak symbols

### Domain/Services (Validator)

- Create `ExerciseValidator` service
- Compare user answer to expected answer
- Strict equality for initial implementation
- Return validation result with details (correct/incorrect, expected, got)

## Out-of-scope

- Spaced repetition algorithm
- External word/sentence sources
- Partial matching or fuzzy validation
- Exercise history tracking
- Audio-based exercises

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

- Task T2: Morse Alphabet Domain (completed) — provides `MorseAlphabet`, `MorseSymbol`
- Existing `ExerciseMode` and `Exercise` models
- Existing `ExerciseGenerating` protocol
- TECH_SPEC.md: Section 4.2 (Practice Module)
- AGENTS.md: Domain/Services section
