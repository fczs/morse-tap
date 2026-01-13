import Foundation

final class ExerciseGenerator: ExerciseGenerating {
    
    private let alphabet: MorseAlphabetProviding
    
    init(alphabet: MorseAlphabetProviding = MorseAlphabet()) {
        self.alphabet = alphabet
    }
    
    func generateExercise(mode: ExerciseMode, difficulty: Difficulty) -> Exercise {
        let content = selectContent(for: mode, difficulty: difficulty)
        let morseCode = encodeToMorse(content)
        let symbolCount = content.filter { $0.isLetter || $0.isNumber }.count
        
        let prompt: String
        let expectedAnswer: String
        
        switch mode {
        case .codeToWord, .codeToSentence:
            prompt = morseCode
            expectedAnswer = content
        case .wordToCode, .sentenceToCode:
            prompt = content
            expectedAnswer = morseCode
        }
        
        return Exercise(
            mode: mode,
            prompt: prompt,
            expectedAnswer: expectedAnswer,
            difficulty: difficulty,
            symbolCount: symbolCount
        )
    }
    
    func generateExercises(mode: ExerciseMode, difficulty: Difficulty, count: Int) -> [Exercise] {
        (0..<count).map { _ in
            generateExercise(mode: mode, difficulty: difficulty)
        }
    }
    
    private func selectContent(for mode: ExerciseMode, difficulty: Difficulty) -> String {
        if mode.isSentenceMode {
            return WordBank.randomSentence(for: difficulty)
        } else {
            return WordBank.randomWord(for: difficulty)
        }
    }
    
    private func encodeToMorse(_ text: String) -> String {
        let words = text.uppercased().split(separator: " ")
        
        let encodedWords = words.map { word -> String in
            let letters = word.compactMap { char -> String? in
                alphabet.symbol(for: char)?.pattern
            }
            return letters.joined(separator: " ")
        }
        
        return encodedWords.joined(separator: " / ")
    }
}
