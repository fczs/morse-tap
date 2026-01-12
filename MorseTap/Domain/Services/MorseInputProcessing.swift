import Foundation

// Note: MorseInputEngine provides more complete functionality including
// async pause detection and symbol completion. Consider using MorseInputEngine
// for new implementations.
protocol MorseInputProcessing {
    /// Converts tap duration to dot or dash
    func processInput(_ duration: TimeInterval) -> MorseSignal
    
    /// Validates signal sequence and returns recognized character
    func validateSymbol(_ signals: [MorseSignal]) -> Character?
    
    /// Resets current input state
    func reset()
}
