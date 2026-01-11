import Foundation

protocol MorseInputProcessing {
    /// Converts tap duration to dot or dash
    func processInput(_ duration: TimeInterval) -> MorseSignal
    
    /// Validates signal sequence and returns recognized character
    func validateSymbol(_ signals: [MorseSignal]) -> Character?
    
    /// Resets current input state
    func reset()
}
