import Foundation
import SwiftData

struct SymbolListItem: Identifiable {
    let id: String
    let symbol: MorseSymbol
    let accuracy: Double
    let totalAttempts: Int
    
    init(symbol: MorseSymbol, accuracy: Double = 0, totalAttempts: Int = 0) {
        self.id = String(symbol.character)
        self.symbol = symbol
        self.accuracy = accuracy
        self.totalAttempts = totalAttempts
    }
}

@Observable
@MainActor
final class LearnViewModel {
    
    enum State {
        case loading
        case loaded
        case error(String)
    }
    
    private(set) var state: State = .loading
    private(set) var symbolItems: [SymbolListItem] = []
    
    private let alphabet: MorseAlphabetProviding
    private let statisticsRepository: StatisticsRepositoryProtocol?
    
    init(
        alphabet: MorseAlphabetProviding = MorseAlphabet(),
        statisticsRepository: StatisticsRepositoryProtocol? = nil
    ) {
        self.alphabet = alphabet
        self.statisticsRepository = statisticsRepository
    }
    
    func loadSymbols() async {
        state = .loading
        
        let symbols = alphabet.allSymbols
        
        var items: [SymbolListItem] = []
        
        for symbol in symbols {
            var accuracy: Double = 0
            var attempts: Int = 0
            
            if let repository = statisticsRepository {
                do {
                    if let stats = try await repository.getStatistics(forSymbol: symbol.character) {
                        accuracy = stats.accuracy
                        attempts = stats.totalAttempts
                    }
                } catch {
                    // Continue with default values on error
                }
            }
            
            items.append(SymbolListItem(
                symbol: symbol,
                accuracy: accuracy,
                totalAttempts: attempts
            ))
        }
        
        symbolItems = items
        state = .loaded
    }
}
