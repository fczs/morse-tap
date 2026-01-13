import Foundation

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
        let normalizedExpected = normalize(exercise.expectedAnswer, for: exercise.mode)
        let normalizedActual = normalize(userAnswer, for: exercise.mode)
        
        let isCorrect = normalizedExpected == normalizedActual
        
        return ValidationResult(
            isCorrect: isCorrect,
            expected: exercise.expectedAnswer,
            actual: userAnswer,
            mode: exercise.mode
        )
    }
    
    private func normalize(_ answer: String, for mode: ExerciseMode) -> String {
        let trimmed = answer.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if mode.isCodeInput {
            return normalizeCode(trimmed)
        } else {
            return trimmed.uppercased()
        }
    }
    
    private func normalizeCode(_ code: String) -> String {
        code
            .components(separatedBy: .whitespaces)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
            .replacingOccurrences(of: "  /  ", with: " / ")
            .replacingOccurrences(of: " /", with: " / ")
            .replacingOccurrences(of: "/ ", with: " / ")
    }
}
