import Foundation

protocol ExerciseGenerating {
    /// Generates exercise based on mode and difficulty
    func generateExercise(mode: ExerciseMode, difficulty: Difficulty) -> Exercise
    
    /// Returns next symbol for practice
    func getNextSymbol() -> Character
}
