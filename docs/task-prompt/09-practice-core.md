# Practice Core: Exercise Models, Generator, and Validator Implementation

## Affected modules

- `MorseTap/Domain/Models/ExerciseMode.swift`
- `MorseTap/Domain/Models/Exercise.swift`
- `MorseTap/Domain/Services/ExerciseGenerating.swift`
- `MorseTap/Domain/Services/ExerciseGenerator.swift`
- `MorseTap/Domain/Services/ExerciseValidator.swift`
- `MorseTap/Domain/Services/WordBank.swift`
- `MorseTapTests/Domain/ExerciseGeneratorTests.swift`
- `MorseTapTests/Domain/ExerciseValidatorTests.swift`

## Goal

Implement the core domain logic for practice exercises: complete exercise model, generator service with built-in word/sentence bank, and validator service for answer checking. All services are pure domain logic with no UI dependencies.

## Dependencies

- Task T2: Morse Alphabet Domain (completed) — provides `MorseAlphabet`, `MorseSymbol`

## Execution plan

1. Update ExerciseMode and Exercise models
2. Create WordBank with built-in words/sentences
3. Implement ExerciseGenerator
4. Implement ExerciseValidator
5. Write unit tests
6. Add files to Xcode project
7. Build and verify

## Pre-implementation code preparation

1. Open the project in Xcode: `MorseTap.xcodeproj`
2. Verify `MorseTap/Domain/Services/MorseAlphabet.swift` exists
3. Verify existing `ExerciseMode.swift` and `Exercise.swift`

## Terms/Context

- **codeToWord** — User sees Morse code, types the word
- **codeToSentence** — User sees Morse code, types the sentence
- **wordToCode** — User sees word, inputs Morse code
- **sentenceToCode** — User sees sentence, inputs Morse code
- **WordBank** — Static collection of words and sentences for exercises

## Block requirements

### Domain Models

#### `MorseTap/Domain/Models/ExerciseMode.swift`

Update enum (already has correct cases, add display properties):

```swift
enum ExerciseMode: String, CaseIterable, Codable {
    case codeToWord
    case codeToSentence
    case wordToCode
    case sentenceToCode
    
    var displayName: String {
        switch self {
        case .codeToWord: return "Code → Word"
        case .codeToSentence: return "Code → Sentence"
        case .wordToCode: return "Word → Code"
        case .sentenceToCode: return "Sentence → Code"
        }
    }
    
    var description: String {
        switch self {
        case .codeToWord: return "See Morse code, type the word"
        case .codeToSentence: return "See Morse code, type the sentence"
        case .wordToCode: return "See a word, tap the Morse code"
        case .sentenceToCode: return "See a sentence, tap the Morse code"
        }
    }
    
    var isCodeInput: Bool {
        switch self {
        case .wordToCode, .sentenceToCode: return true
        case .codeToWord, .codeToSentence: return false
        }
    }
}
```

#### `MorseTap/Domain/Models/Exercise.swift`

Update model with complete structure:

```swift
struct Exercise: Identifiable, Equatable {
    let id: UUID
    let mode: ExerciseMode
    let prompt: String           // What user sees (word/sentence or Morse pattern)
    let expectedAnswer: String   // Correct answer (text or Morse pattern)
    let difficulty: Difficulty
    let symbolCount: Int
    let createdAt: Date
    
    init(
        id: UUID = UUID(),
        mode: ExerciseMode,
        prompt: String,
        expectedAnswer: String,
        difficulty: Difficulty,
        symbolCount: Int,
        createdAt: Date = Date()
    )
}
```

### Domain Services

#### `MorseTap/Domain/Services/WordBank.swift`

Create new file with built-in word/sentence lists:

```swift
enum WordBank {
    
    static let easyWords: [String] = [
        "CAT", "DOG", "SUN", "RUN", "HI", "GO", "NO", "UP",
        "ME", "IT", "IS", "AT", "AN", "TO", "SO", "ON",
        "BE", "WE", "HE", "OR", "AS", "IF", "DO", "MY"
    ]
    
    static let mediumWords: [String] = [
        "HELLO", "WORLD", "MORSE", "CODE", "LEARN", "RADIO",
        "SIGNAL", "DOT", "DASH", "ALPHA", "BRAVO", "DELTA",
        "ECHO", "GOLF", "HOTEL", "INDIA", "KILO", "LIMA",
        "MIKE", "OSCAR", "PAPA", "ROMEO", "TANGO", "VICTOR"
    ]
    
    static let hardWords: [String] = [
        "FREQUENCY", "TELEGRAPH", "WIRELESS", "ALPHABET",
        "OPERATOR", "EMERGENCY", "TRANSMIT", "RECEIVER"
    ]
    
    static let easySentences: [String] = [
        "HI THERE", "GOOD DAY", "HELP ME", "COME IN",
        "GO NOW", "YES OR NO", "I AM OK"
    ]
    
    static let mediumSentences: [String] = [
        "HELLO WORLD", "MORSE CODE IS FUN", "LEARN TO TAP",
        "SEND A MESSAGE", "RADIO SIGNAL", "COPY THAT"
    ]
    
    static let hardSentences: [String] = [
        "THE QUICK BROWN FOX", "EMERGENCY BROADCAST",
        "TRANSMIT ON FREQUENCY", "ALPHA BRAVO CHARLIE"
    ]
    
    static func words(for difficulty: Difficulty) -> [String]
    static func sentences(for difficulty: Difficulty) -> [String]
    static func randomWord(for difficulty: Difficulty) -> String
    static func randomSentence(for difficulty: Difficulty) -> String
}
```

#### `MorseTap/Domain/Services/ExerciseGenerating.swift`

Update protocol:

```swift
protocol ExerciseGenerating {
    func generateExercise(mode: ExerciseMode, difficulty: Difficulty) -> Exercise
    func generateExercises(mode: ExerciseMode, difficulty: Difficulty, count: Int) -> [Exercise]
}
```

#### `MorseTap/Domain/Services/ExerciseGenerator.swift`

Create new file implementing the protocol:

```swift
final class ExerciseGenerator: ExerciseGenerating {
    
    private let alphabet: MorseAlphabetProviding
    
    init(alphabet: MorseAlphabetProviding = MorseAlphabet())
    
    func generateExercise(mode: ExerciseMode, difficulty: Difficulty) -> Exercise {
        // Based on mode:
        // - codeToWord/codeToSentence: prompt = Morse pattern, answer = text
        // - wordToCode/sentenceToCode: prompt = text, answer = Morse pattern
    }
    
    func generateExercises(mode: ExerciseMode, difficulty: Difficulty, count: Int) -> [Exercise]
    
    // Private helpers:
    private func encodeToMorse(_ text: String) -> String
    // Returns patterns separated by " " for letters, " / " for words
    
    private func selectContent(for mode: ExerciseMode, difficulty: Difficulty) -> String
    // Returns word or sentence based on mode
}
```

Key behaviors:
- Use `MorseAlphabet.encode()` for text → Morse conversion
- Morse format: letters separated by space, words separated by " / "
- Example: "HI" → ".... ..", "HI THERE" → ".... .. / - .... . .-. ."
- Handle unknown characters gracefully (skip or placeholder)

#### `MorseTap/Domain/Services/ExerciseValidator.swift`

Create new file:

```swift
struct ValidationResult: Equatable {
    let isCorrect: Bool
    let expected: String
    let actual: String
    let mode: ExerciseMode
}

protocol ExerciseValidating {
    func validate(exercise: Exercise, userAnswer: String) -> ValidationResult
}

final class ExerciseValidator: ExerciseValidating {
    
    func validate(exercise: Exercise, userAnswer: String) -> ValidationResult {
        // Normalize both answers (trim, uppercase for text)
        // Strict equality comparison
        // Return ValidationResult
    }
    
    private func normalize(_ answer: String, for mode: ExerciseMode) -> String
    // For text modes: trim, uppercase
    // For code modes: trim, normalize spaces
}
```

### Refactoring

- Remove `getNextSymbol()` from `ExerciseGenerating` protocol (not needed for this design)

### NFRs

- All files must compile without errors
- Pure domain logic, no UI dependencies
- No SwiftUI imports in Domain layer
- Thread-safe (no mutable shared state)
- Unit tests cover all exercise modes

## Acceptance criteria

- [ ] App compiles without errors in Xcode
- [ ] `ExerciseMode` has display properties
- [ ] `Exercise` model has complete structure (id, prompt, expectedAnswer, etc.)
- [ ] `WordBank` contains 50+ words and 15+ sentences
- [ ] `ExerciseGenerator` generates valid exercises for all 4 modes
- [ ] Morse encoding produces correct patterns with proper separators
- [ ] `ExerciseValidator` correctly validates answers
- [ ] Unit tests pass for generator (all modes)
- [ ] Unit tests pass for validator (correct/incorrect cases)
- [ ] No UI dependencies in Domain layer

## Post-implementation verification

1. Build the project: Xcode → Product → Build (⌘+B)
2. Run unit tests: Xcode → Product → Test (⌘+U)
3. Verify all tests pass
4. Review generated exercises manually for correctness

## Unit test requirements

### ExerciseGeneratorTests

```swift
// Test cases:
- testGenerateCodeToWordExercise()
- testGenerateCodeToSentenceExercise()
- testGenerateWordToCodeExercise()
- testGenerateSentenceToCodeExercise()
- testGenerateMultipleExercises()
- testMorseEncodingFormat()
- testDifficultyAffectsContent()
```

### ExerciseValidatorTests

```swift
// Test cases:
- testValidateCorrectTextAnswer()
- testValidateIncorrectTextAnswer()
- testValidateCorrectCodeAnswer()
- testValidateIncorrectCodeAnswer()
- testValidateCaseInsensitive()
- testValidateTrimsWhitespace()
```

## Documentation update

### README.md

No changes required for this task.

### AGENTS.md

Update Domain/Services section to include `ExerciseGenerator`, `ExerciseValidator`, `WordBank`.

### Module AGENTS.md

Not applicable for this task.

## Post-implementation code preparation

1. Verify all new files are added to Xcode project
2. Ensure all files are properly formatted
3. Remove any debug print statements
4. Verify project builds in both Debug and Release configurations
5. Verify all unit tests pass
6. Prepare for code review
