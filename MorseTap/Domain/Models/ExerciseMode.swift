import Foundation

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
    
    var isSentenceMode: Bool {
        switch self {
        case .codeToSentence, .sentenceToCode: return true
        case .codeToWord, .wordToCode: return false
        }
    }
}
