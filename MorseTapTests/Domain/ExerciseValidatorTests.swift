import XCTest
@testable import MorseTap

final class ExerciseValidatorTests: XCTestCase {
    
    var validator: ExerciseValidator!
    
    override func setUp() {
        super.setUp()
        validator = ExerciseValidator()
    }
    
    override func tearDown() {
        validator = nil
        super.tearDown()
    }
    
    // MARK: - Correct Text Answer
    
    func testValidateCorrectTextAnswer() {
        let exercise = Exercise(
            mode: .codeToWord,
            prompt: ".... ..",
            expectedAnswer: "HI",
            difficulty: .beginner,
            symbolCount: 2
        )
        
        let result = validator.validate(exercise: exercise, userAnswer: "HI")
        
        XCTAssertTrue(result.isCorrect)
        XCTAssertEqual(result.expected, "HI")
        XCTAssertEqual(result.actual, "HI")
        XCTAssertEqual(result.mode, .codeToWord)
    }
    
    // MARK: - Incorrect Text Answer
    
    func testValidateIncorrectTextAnswer() {
        let exercise = Exercise(
            mode: .codeToWord,
            prompt: ".... ..",
            expectedAnswer: "HI",
            difficulty: .beginner,
            symbolCount: 2
        )
        
        let result = validator.validate(exercise: exercise, userAnswer: "HELLO")
        
        XCTAssertFalse(result.isCorrect)
        XCTAssertEqual(result.expected, "HI")
        XCTAssertEqual(result.actual, "HELLO")
    }
    
    // MARK: - Correct Code Answer
    
    func testValidateCorrectCodeAnswer() {
        let exercise = Exercise(
            mode: .wordToCode,
            prompt: "HI",
            expectedAnswer: ".... ..",
            difficulty: .beginner,
            symbolCount: 2
        )
        
        let result = validator.validate(exercise: exercise, userAnswer: ".... ..")
        
        XCTAssertTrue(result.isCorrect)
    }
    
    // MARK: - Incorrect Code Answer
    
    func testValidateIncorrectCodeAnswer() {
        let exercise = Exercise(
            mode: .wordToCode,
            prompt: "HI",
            expectedAnswer: ".... ..",
            difficulty: .beginner,
            symbolCount: 2
        )
        
        let result = validator.validate(exercise: exercise, userAnswer: ".... ...")
        
        XCTAssertFalse(result.isCorrect)
    }
    
    // MARK: - Case Insensitive
    
    func testValidateCaseInsensitive() {
        let exercise = Exercise(
            mode: .codeToWord,
            prompt: ".... ..",
            expectedAnswer: "HI",
            difficulty: .beginner,
            symbolCount: 2
        )
        
        let result = validator.validate(exercise: exercise, userAnswer: "hi")
        
        XCTAssertTrue(result.isCorrect, "Validation should be case insensitive for text")
    }
    
    // MARK: - Trims Whitespace
    
    func testValidateTrimsWhitespace() {
        let exercise = Exercise(
            mode: .codeToWord,
            prompt: ".... ..",
            expectedAnswer: "HI",
            difficulty: .beginner,
            symbolCount: 2
        )
        
        let result = validator.validate(exercise: exercise, userAnswer: "  HI  ")
        
        XCTAssertTrue(result.isCorrect, "Validation should trim whitespace")
    }
    
    // MARK: - Sentence Validation
    
    func testValidateCorrectSentenceAnswer() {
        let exercise = Exercise(
            mode: .codeToSentence,
            prompt: ".... .. / - .... . .-. .",
            expectedAnswer: "HI THERE",
            difficulty: .beginner,
            symbolCount: 7
        )
        
        let result = validator.validate(exercise: exercise, userAnswer: "hi there")
        
        XCTAssertTrue(result.isCorrect)
    }
    
    // MARK: - Code Normalization
    
    func testValidateNormalizesCodeSpaces() {
        let exercise = Exercise(
            mode: .wordToCode,
            prompt: "HI",
            expectedAnswer: ".... ..",
            difficulty: .beginner,
            symbolCount: 2
        )
        
        let result = validator.validate(exercise: exercise, userAnswer: "....  ..")
        
        XCTAssertTrue(result.isCorrect, "Extra spaces in code should be normalized")
    }
}
