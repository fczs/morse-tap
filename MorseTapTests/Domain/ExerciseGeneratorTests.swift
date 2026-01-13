import XCTest
@testable import MorseTap

final class ExerciseGeneratorTests: XCTestCase {
    
    var generator: ExerciseGenerator!
    
    override func setUp() {
        super.setUp()
        generator = ExerciseGenerator()
    }
    
    override func tearDown() {
        generator = nil
        super.tearDown()
    }
    
    // MARK: - Code to Word
    
    func testGenerateCodeToWordExercise() {
        let exercise = generator.generateExercise(mode: .codeToWord, difficulty: .beginner)
        
        XCTAssertEqual(exercise.mode, .codeToWord)
        XCTAssertEqual(exercise.difficulty, .beginner)
        XCTAssertFalse(exercise.prompt.isEmpty)
        XCTAssertFalse(exercise.expectedAnswer.isEmpty)
        XCTAssertTrue(exercise.prompt.contains(".") || exercise.prompt.contains("-"))
        XCTAssertFalse(exercise.expectedAnswer.contains("."))
        XCTAssertFalse(exercise.expectedAnswer.contains("-"))
    }
    
    // MARK: - Code to Sentence
    
    func testGenerateCodeToSentenceExercise() {
        let exercise = generator.generateExercise(mode: .codeToSentence, difficulty: .intermediate)
        
        XCTAssertEqual(exercise.mode, .codeToSentence)
        XCTAssertTrue(exercise.prompt.contains(" / "), "Sentence morse should contain word separator")
        XCTAssertTrue(exercise.expectedAnswer.contains(" "), "Sentence should contain spaces")
    }
    
    // MARK: - Word to Code
    
    func testGenerateWordToCodeExercise() {
        let exercise = generator.generateExercise(mode: .wordToCode, difficulty: .beginner)
        
        XCTAssertEqual(exercise.mode, .wordToCode)
        XCTAssertFalse(exercise.prompt.contains("."))
        XCTAssertFalse(exercise.prompt.contains("-"))
        XCTAssertTrue(exercise.expectedAnswer.contains(".") || exercise.expectedAnswer.contains("-"))
    }
    
    // MARK: - Sentence to Code
    
    func testGenerateSentenceToCodeExercise() {
        let exercise = generator.generateExercise(mode: .sentenceToCode, difficulty: .advanced)
        
        XCTAssertEqual(exercise.mode, .sentenceToCode)
        XCTAssertTrue(exercise.prompt.contains(" "), "Sentence prompt should contain spaces")
        XCTAssertTrue(exercise.expectedAnswer.contains(" / "), "Morse sentence should contain word separator")
    }
    
    // MARK: - Multiple Exercises
    
    func testGenerateMultipleExercises() {
        let exercises = generator.generateExercises(mode: .codeToWord, difficulty: .beginner, count: 5)
        
        XCTAssertEqual(exercises.count, 5)
        
        let uniqueIds = Set(exercises.map { $0.id })
        XCTAssertEqual(uniqueIds.count, 5, "All exercises should have unique IDs")
    }
    
    // MARK: - Morse Encoding Format
    
    func testMorseEncodingFormat() {
        let exercise = generator.generateExercise(mode: .wordToCode, difficulty: .beginner)
        
        let patterns = exercise.expectedAnswer.components(separatedBy: " ")
        for pattern in patterns where pattern != "/" {
            XCTAssertTrue(
                pattern.allSatisfy { $0 == "." || $0 == "-" },
                "Pattern '\(pattern)' should only contain dots and dashes"
            )
        }
    }
    
    // MARK: - Symbol Count
    
    func testSymbolCountIsCorrect() {
        let exercise = generator.generateExercise(mode: .codeToWord, difficulty: .beginner)
        
        let letterCount = exercise.expectedAnswer.filter { $0.isLetter || $0.isNumber }.count
        XCTAssertEqual(exercise.symbolCount, letterCount)
    }
    
    // MARK: - Difficulty Affects Content
    
    func testDifficultyAffectsWordLength() {
        var beginnerLengths: [Int] = []
        var advancedLengths: [Int] = []
        
        for _ in 0..<20 {
            let beginner = generator.generateExercise(mode: .codeToWord, difficulty: .beginner)
            let advanced = generator.generateExercise(mode: .codeToWord, difficulty: .advanced)
            beginnerLengths.append(beginner.expectedAnswer.count)
            advancedLengths.append(advanced.expectedAnswer.count)
        }
        
        let avgBeginner = Double(beginnerLengths.reduce(0, +)) / Double(beginnerLengths.count)
        let avgAdvanced = Double(advancedLengths.reduce(0, +)) / Double(advancedLengths.count)
        
        XCTAssertLessThanOrEqual(avgBeginner, avgAdvanced + 3, "Advanced words should generally be longer or equal")
    }
}
