import Testing
@testable import MorseTap

struct MorseAlphabetTests {
    
    let alphabet = MorseAlphabet()
    
    // MARK: - All Symbols
    
    @Test func allSymbolsContainsFullAlphabet() {
        #expect(alphabet.allSymbols.count == 36)
    }
    
    @Test func allSymbolsContainsLettersAtoZ() {
        let letters = alphabet.allSymbols.filter { $0.character.isLetter }
        #expect(letters.count == 26)
    }
    
    @Test func allSymbolsContainsDigits0to9() {
        let digits = alphabet.allSymbols.filter { $0.character.isNumber }
        #expect(digits.count == 10)
    }
    
    // MARK: - Lookup by Character
    
    @Test func lookupLetterA() {
        let symbol = alphabet.symbol(for: "A")
        #expect(symbol?.pattern == ".-")
    }
    
    @Test func lookupLetterLowercaseA() {
        let symbol = alphabet.symbol(for: "a")
        #expect(symbol?.pattern == ".-")
    }
    
    @Test func lookupLetterS() {
        let symbol = alphabet.symbol(for: "S")
        #expect(symbol?.pattern == "...")
    }
    
    @Test func lookupLetterO() {
        let symbol = alphabet.symbol(for: "O")
        #expect(symbol?.pattern == "---")
    }
    
    @Test func lookupDigit0() {
        let symbol = alphabet.symbol(for: "0")
        #expect(symbol?.pattern == "-----")
    }
    
    @Test func lookupDigit5() {
        let symbol = alphabet.symbol(for: "5")
        #expect(symbol?.pattern == ".....")
    }
    
    @Test func lookupUnknownCharacterReturnsNil() {
        let symbol = alphabet.symbol(for: "!")
        #expect(symbol == nil)
    }
    
    @Test func lookupSpaceReturnsNil() {
        let symbol = alphabet.symbol(for: " ")
        #expect(symbol == nil)
    }
    
    // MARK: - Lookup by Pattern
    
    @Test func lookupPatternDotDash() {
        let symbol = alphabet.symbol(forPattern: ".-")
        #expect(symbol?.character == "A")
    }
    
    @Test func lookupPatternSOS() {
        let symbolS = alphabet.symbol(forPattern: "...")
        let symbolO = alphabet.symbol(forPattern: "---")
        #expect(symbolS?.character == "S")
        #expect(symbolO?.character == "O")
    }
    
    @Test func lookupUnknownPatternReturnsNil() {
        let symbol = alphabet.symbol(forPattern: "........")
        #expect(symbol == nil)
    }
    
    @Test func lookupEmptyPatternReturnsNil() {
        let symbol = alphabet.symbol(forPattern: "")
        #expect(symbol == nil)
    }
    
    // MARK: - Encode
    
    @Test func encodeSOS() {
        let result = alphabet.encode("SOS")
        #expect(result.count == 3)
        #expect(result[0]?.pattern == "...")
        #expect(result[1]?.pattern == "---")
        #expect(result[2]?.pattern == "...")
    }
    
    @Test func encodeLowercaseText() {
        let result = alphabet.encode("abc")
        #expect(result[0]?.pattern == ".-")
        #expect(result[1]?.pattern == "-...")
        #expect(result[2]?.pattern == "-.-.")
    }
    
    @Test func encodeTextWithUnknownCharacters() {
        let result = alphabet.encode("A B")
        #expect(result.count == 3)
        #expect(result[0]?.pattern == ".-")
        #expect(result[1] == nil)
        #expect(result[2]?.pattern == "-...")
    }
    
    @Test func encodeDigits() {
        let result = alphabet.encode("123")
        #expect(result[0]?.pattern == ".----")
        #expect(result[1]?.pattern == "..---")
        #expect(result[2]?.pattern == "...--")
    }
    
    // MARK: - Decode
    
    @Test func decodePatternToA() {
        let char = alphabet.decode(".-")
        #expect(char == "A")
    }
    
    @Test func decodePatternToDigit() {
        let char = alphabet.decode("-----")
        #expect(char == "0")
    }
    
    @Test func decodeUnknownPatternReturnsNil() {
        let char = alphabet.decode(".-.-.-.-")
        #expect(char == nil)
    }
    
    // MARK: - MorseSymbol Signals
    
    @Test func signalsForLetterA() {
        let symbol = alphabet.symbol(for: "A")
        #expect(symbol?.signals == [.dot, .dash])
    }
    
    @Test func signalsForLetterS() {
        let symbol = alphabet.symbol(for: "S")
        #expect(symbol?.signals == [.dot, .dot, .dot])
    }
    
    @Test func signalsForLetterO() {
        let symbol = alphabet.symbol(for: "O")
        #expect(symbol?.signals == [.dash, .dash, .dash])
    }
    
    @Test func signalsForDigit0() {
        let symbol = alphabet.symbol(for: "0")
        #expect(symbol?.signals == [.dash, .dash, .dash, .dash, .dash])
    }
}
