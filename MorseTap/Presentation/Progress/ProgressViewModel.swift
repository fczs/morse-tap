import Foundation
import SwiftData

@Observable
@MainActor
final class ProgressViewModel {
    
    private(set) var isLoading: Bool = false
    private(set) var totalAttempts: Int = 0
    private(set) var correctAttempts: Int = 0
    private(set) var currentStreak: Int = 0
    private(set) var longestStreak: Int = 0
    private(set) var weakSymbols: [WeakSymbol] = []
    private(set) var hasData: Bool = false
    
    private var statisticsRepository: StatisticsRepositoryProtocol?
    private var userProfileRepository: UserProfileRepositoryProtocol?
    
    var overallAccuracy: Double {
        guard totalAttempts > 0 else { return 0 }
        return Double(correctAttempts) / Double(totalAttempts)
    }
    
    var accuracyPercentage: Int {
        Int(overallAccuracy * 100)
    }
    
    func configure(
        statisticsRepository: StatisticsRepositoryProtocol,
        userProfileRepository: UserProfileRepositoryProtocol
    ) {
        self.statisticsRepository = statisticsRepository
        self.userProfileRepository = userProfileRepository
    }
    
    func loadStatistics() async {
        guard let statsRepo = statisticsRepository,
              let profileRepo = userProfileRepository else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let exerciseStats = try await statsRepo.getAllExerciseStatistics()
            totalAttempts = exerciseStats.reduce(0) { $0 + $1.totalAttempts }
            correctAttempts = exerciseStats.reduce(0) { $0 + $1.correctAttempts }
            
            let profile = try await profileRepo.loadOrCreateProfile()
            currentStreak = profile.currentStreak
            longestStreak = profile.longestStreak
            
            let symbolStats = try await statsRepo.getAllSymbolStatistics()
            weakSymbols = calculateWeakSymbols(from: symbolStats)
            
            hasData = totalAttempts > 0 || !symbolStats.isEmpty
        } catch {
            print("[DEBUG] Failed to load statistics: \(error)")
        }
    }
    
    private func calculateWeakSymbols(from stats: [SymbolStatisticsModel]) -> [WeakSymbol] {
        let weaknessThreshold = 0.8
        let minAttempts = 3
        
        return stats
            .filter { $0.totalAttempts >= minAttempts && $0.accuracy < weaknessThreshold }
            .sorted { $0.accuracy < $1.accuracy }
            .prefix(5)
            .map { WeakSymbol(symbol: $0.symbol, accuracy: $0.accuracy, attempts: $0.totalAttempts) }
    }
}

struct WeakSymbol: Identifiable {
    let id = UUID()
    let symbol: String
    let accuracy: Double
    let attempts: Int
    
    var accuracyPercentage: Int {
        Int(accuracy * 100)
    }
}
