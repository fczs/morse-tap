import Foundation

enum WordBank {
    
    static let easyWords: [String] = [
        "CAT", "DOG", "SUN", "RUN", "HI", "GO", "NO", "UP",
        "ME", "IT", "IS", "AT", "AN", "TO", "SO", "ON",
        "BE", "WE", "HE", "OR", "AS", "IF", "DO", "MY",
        "OK", "AM", "IN", "OF", "BY", "US", "AX", "OX"
    ]
    
    static let mediumWords: [String] = [
        "HELLO", "WORLD", "MORSE", "CODE", "LEARN", "RADIO",
        "SIGNAL", "DOT", "DASH", "ALPHA", "BRAVO", "DELTA",
        "ECHO", "GOLF", "HOTEL", "INDIA", "KILO", "LIMA",
        "MIKE", "OSCAR", "PAPA", "ROMEO", "TANGO", "VICTOR",
        "ZULU", "FOXTROT", "SIERRA", "WHISKEY", "YANKEE"
    ]
    
    static let hardWords: [String] = [
        "FREQUENCY", "TELEGRAPH", "WIRELESS", "ALPHABET",
        "OPERATOR", "EMERGENCY", "TRANSMIT", "RECEIVER",
        "BROADCAST", "COMMUNICATE", "WAVELENGTH", "MODULATION"
    ]
    
    static let easySentences: [String] = [
        "HI THERE", "GOOD DAY", "HELP ME", "COME IN",
        "GO NOW", "YES OR NO", "I AM OK", "CALL ME",
        "STOP NOW", "GO AHEAD", "OVER AND OUT"
    ]
    
    static let mediumSentences: [String] = [
        "HELLO WORLD", "MORSE CODE IS FUN", "LEARN TO TAP",
        "SEND A MESSAGE", "RADIO SIGNAL", "COPY THAT",
        "ROGER THAT", "STANDING BY", "MESSAGE RECEIVED",
        "LOUD AND CLEAR", "OVER TO YOU"
    ]
    
    static let hardSentences: [String] = [
        "THE QUICK BROWN FOX", "EMERGENCY BROADCAST",
        "TRANSMIT ON FREQUENCY", "ALPHA BRAVO CHARLIE",
        "REQUEST IMMEDIATE ASSISTANCE", "ALL STATIONS COPY",
        "MAYDAY MAYDAY MAYDAY", "PAN PAN PAN"
    ]
    
    static func words(for difficulty: Difficulty) -> [String] {
        switch difficulty {
        case .beginner:
            return easyWords
        case .intermediate:
            return easyWords + mediumWords
        case .advanced:
            return easyWords + mediumWords + hardWords
        }
    }
    
    static func sentences(for difficulty: Difficulty) -> [String] {
        switch difficulty {
        case .beginner:
            return easySentences
        case .intermediate:
            return easySentences + mediumSentences
        case .advanced:
            return easySentences + mediumSentences + hardSentences
        }
    }
    
    static func randomWord(for difficulty: Difficulty) -> String {
        words(for: difficulty).randomElement() ?? "MORSE"
    }
    
    static func randomSentence(for difficulty: Difficulty) -> String {
        sentences(for: difficulty).randomElement() ?? "HELLO WORLD"
    }
}
