import Foundation

protocol MorseAlphabetProviding {
    var allSymbols: [MorseSymbol] { get }
    func symbol(for character: Character) -> MorseSymbol?
    func symbol(forPattern pattern: String) -> MorseSymbol?
    func encode(_ text: String) -> [MorseSymbol?]
    func decode(_ pattern: String) -> Character?
}

final class MorseAlphabet: MorseAlphabetProviding {
    
    let allSymbols: [MorseSymbol]
    
    private let characterLookup: [Character: MorseSymbol]
    private let patternLookup: [String: MorseSymbol]
    
    init() {
        let symbols = Self.buildAlphabet()
        self.allSymbols = symbols
        
        var charMap: [Character: MorseSymbol] = [:]
        var patternMap: [String: MorseSymbol] = [:]
        
        for symbol in symbols {
            charMap[symbol.character] = symbol
            patternMap[symbol.pattern] = symbol
        }
        
        self.characterLookup = charMap
        self.patternLookup = patternMap
    }
    
    func symbol(for character: Character) -> MorseSymbol? {
        characterLookup[Character(character.uppercased())]
    }
    
    func symbol(forPattern pattern: String) -> MorseSymbol? {
        patternLookup[pattern]
    }
    
    func encode(_ text: String) -> [MorseSymbol?] {
        text.map { symbol(for: $0) }
    }
    
    func decode(_ pattern: String) -> Character? {
        patternLookup[pattern]?.character
    }
    
    private static func buildAlphabet() -> [MorseSymbol] {
        let data: [(Character, String)] = [
            // Letters A-Z
            ("A", ".-"),
            ("B", "-..."),
            ("C", "-.-."),
            ("D", "-.."),
            ("E", "."),
            ("F", "..-."),
            ("G", "--."),
            ("H", "...."),
            ("I", ".."),
            ("J", ".---"),
            ("K", "-.-"),
            ("L", ".-.."),
            ("M", "--"),
            ("N", "-."),
            ("O", "---"),
            ("P", ".--."),
            ("Q", "--.-"),
            ("R", ".-."),
            ("S", "..."),
            ("T", "-"),
            ("U", "..-"),
            ("V", "...-"),
            ("W", ".--"),
            ("X", "-..-"),
            ("Y", "-.--"),
            ("Z", "--.."),
            // Digits 0-9
            ("0", "-----"),
            ("1", ".----"),
            ("2", "..---"),
            ("3", "...--"),
            ("4", "....-"),
            ("5", "....."),
            ("6", "-...."),
            ("7", "--..."),
            ("8", "---.."),
            ("9", "----."),
        ]
        
        return data.map { MorseSymbol(character: $0.0, pattern: $0.1) }
    }
}
