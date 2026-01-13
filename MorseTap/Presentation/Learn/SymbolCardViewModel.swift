import Foundation

@Observable
@MainActor
final class SymbolCardViewModel {
    
    enum State: Equatable {
        case ready
        case inputting
        case correct(inputTime: TimeInterval)
        case incorrect(expected: [MorseSignal], got: [MorseSignal])
    }
    
    let symbol: MorseSymbol
    private(set) var state: State = .ready
    
    private var inputStartTime: Date?
    private let statisticsRepository: StatisticsRepositoryProtocol?
    
    init(symbol: MorseSymbol, statisticsRepository: StatisticsRepositoryProtocol? = nil) {
        self.symbol = symbol
        self.statisticsRepository = statisticsRepository
    }
    
    func onSignalAdded(_ signal: MorseSignal) {
        if inputStartTime == nil {
            inputStartTime = Date()
        }
        state = .inputting
    }
    
    func onSymbolCompleted(_ signals: [MorseSignal]) async {
        let inputTime = inputStartTime.map { Date().timeIntervalSince($0) } ?? 0
        let isCorrect = signals == symbol.signals
        
        if isCorrect {
            state = .correct(inputTime: inputTime)
            HapticFeedbackManager.shared.successFeedback()
        } else {
            state = .incorrect(expected: symbol.signals, got: signals)
            HapticFeedbackManager.shared.errorFeedback()
        }
        
        if let repository = statisticsRepository {
            do {
                try await repository.recordSymbolAttempt(
                    symbol: symbol.character,
                    isCorrect: isCorrect,
                    inputTime: inputTime
                )
            } catch {
                // Silently fail for now; stats recording is non-critical
            }
        }
    }
    
    func retry() {
        state = .ready
        inputStartTime = nil
    }
}
