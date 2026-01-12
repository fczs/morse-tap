import Foundation
import SwiftData

protocol StatisticsRepositoryProtocol: Sendable {
    func getStatistics(forSymbol symbol: Character) async throws -> SymbolStatisticsModel?
    func getAllSymbolStatistics() async throws -> [SymbolStatisticsModel]
    func recordSymbolAttempt(symbol: Character, isCorrect: Bool, inputTime: TimeInterval) async throws
    
    func getStatistics(forMode mode: ExerciseMode) async throws -> ExerciseStatisticsModel?
    func getAllExerciseStatistics() async throws -> [ExerciseStatisticsModel]
    func recordExerciseAttempt(mode: ExerciseMode, isCorrect: Bool, time: TimeInterval) async throws
}

@MainActor
final class StatisticsRepository: StatisticsRepositoryProtocol {
    
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // MARK: - Symbol Statistics
    
    func getStatistics(forSymbol symbol: Character) async throws -> SymbolStatisticsModel? {
        let symbolString = String(symbol).uppercased()
        let descriptor = FetchDescriptor<SymbolStatisticsModel>(
            predicate: #Predicate { $0.symbol == symbolString }
        )
        return try modelContext.fetch(descriptor).first
    }
    
    func getAllSymbolStatistics() async throws -> [SymbolStatisticsModel] {
        let descriptor = FetchDescriptor<SymbolStatisticsModel>(
            sortBy: [SortDescriptor(\.symbol)]
        )
        return try modelContext.fetch(descriptor)
    }
    
    func recordSymbolAttempt(symbol: Character, isCorrect: Bool, inputTime: TimeInterval) async throws {
        let symbolString = String(symbol).uppercased()
        
        if let existing = try await getStatistics(forSymbol: symbol) {
            existing.totalAttempts += 1
            if isCorrect {
                existing.correctAttempts += 1
            }
            existing.totalInputTime += inputTime
            existing.lastTrainedDate = Date()
        } else {
            let newStats = SymbolStatisticsModel(
                symbol: symbolString,
                totalAttempts: 1,
                correctAttempts: isCorrect ? 1 : 0,
                totalInputTime: inputTime,
                lastTrainedDate: Date()
            )
            modelContext.insert(newStats)
        }
        
        try modelContext.save()
    }
    
    // MARK: - Exercise Statistics
    
    func getStatistics(forMode mode: ExerciseMode) async throws -> ExerciseStatisticsModel? {
        let modeRaw = mode.rawValue
        let descriptor = FetchDescriptor<ExerciseStatisticsModel>(
            predicate: #Predicate { $0.modeRawValue == modeRaw }
        )
        return try modelContext.fetch(descriptor).first
    }
    
    func getAllExerciseStatistics() async throws -> [ExerciseStatisticsModel] {
        let descriptor = FetchDescriptor<ExerciseStatisticsModel>(
            sortBy: [SortDescriptor(\.modeRawValue)]
        )
        return try modelContext.fetch(descriptor)
    }
    
    func recordExerciseAttempt(mode: ExerciseMode, isCorrect: Bool, time: TimeInterval) async throws {
        if let existing = try await getStatistics(forMode: mode) {
            existing.totalAttempts += 1
            if isCorrect {
                existing.correctAttempts += 1
            }
            existing.totalTime += time
            existing.lastPlayedDate = Date()
        } else {
            let newStats = ExerciseStatisticsModel(
                modeRawValue: mode.rawValue,
                totalAttempts: 1,
                correctAttempts: isCorrect ? 1 : 0,
                totalTime: time,
                lastPlayedDate: Date()
            )
            modelContext.insert(newStats)
        }
        
        try modelContext.save()
    }
}
