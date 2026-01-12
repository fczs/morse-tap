import Foundation

protocol MorseInputEngineProtocol {
    var currentSignals: [MorseSignal] { get }
    var config: MorseTimingConfig { get set }
    var onSymbolCompleted: (([MorseSignal]) -> Void)? { get set }
    
    func pressDown(at timestamp: Date)
    func pressUp(at timestamp: Date)
    func reset()
    func deleteLastSignal()
}

@Observable
@MainActor
final class MorseInputEngine: MorseInputEngineProtocol {
    
    private(set) var currentSignals: [MorseSignal] = []
    var config: MorseTimingConfig = .standard
    var onSymbolCompleted: (([MorseSignal]) -> Void)?
    
    private var pressDownTimestamp: Date?
    private var completionTask: Task<Void, Never>?
    
    func pressDown(at timestamp: Date) {
        pressDownTimestamp = timestamp
        cancelPendingCompletion()
    }
    
    func pressUp(at timestamp: Date) {
        guard let downTimestamp = pressDownTimestamp else { return }
        
        let duration = timestamp.timeIntervalSince(downTimestamp)
        let signal = classifySignal(duration: duration)
        
        currentSignals.append(signal)
        pressDownTimestamp = nil
        
        startCompletionTimer()
    }
    
    func reset() {
        currentSignals.removeAll()
        pressDownTimestamp = nil
        cancelPendingCompletion()
    }
    
    func deleteLastSignal() {
        guard !currentSignals.isEmpty else { return }
        currentSignals.removeLast()
        
        if currentSignals.isEmpty {
            cancelPendingCompletion()
        } else {
            startCompletionTimer()
        }
    }
    
    private func classifySignal(duration: TimeInterval) -> MorseSignal {
        if duration >= config.dashMinDuration {
            return .dash
        } else {
            return .dot
        }
    }
    
    private func startCompletionTimer() {
        cancelPendingCompletion()
        
        let pauseDuration = config.symbolPauseDuration
        
        completionTask = Task { [weak self] in
            try? await Task.sleep(for: .seconds(pauseDuration))
            
            guard !Task.isCancelled else { return }
            
            await self?.completeSymbol()
        }
    }
    
    private func cancelPendingCompletion() {
        completionTask?.cancel()
        completionTask = nil
    }
    
    private func completeSymbol() {
        guard !currentSignals.isEmpty else { return }
        
        let signals = currentSignals
        currentSignals.removeAll()
        
        onSymbolCompleted?(signals)
    }
}
