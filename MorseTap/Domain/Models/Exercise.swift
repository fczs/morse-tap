import Foundation

struct Exercise: Identifiable, Equatable {
    let id: UUID
    let mode: ExerciseMode
    let prompt: String
    let expectedAnswer: String
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
    ) {
        self.id = id
        self.mode = mode
        self.prompt = prompt
        self.expectedAnswer = expectedAnswer
        self.difficulty = difficulty
        self.symbolCount = symbolCount
        self.createdAt = createdAt
    }
}
