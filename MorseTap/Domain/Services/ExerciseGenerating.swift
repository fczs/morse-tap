import Foundation

protocol ExerciseGenerating {
    func generateExercise(mode: ExerciseMode, difficulty: Difficulty) -> Exercise
    func generateExercises(mode: ExerciseMode, difficulty: Difficulty, count: Int) -> [Exercise]
}
