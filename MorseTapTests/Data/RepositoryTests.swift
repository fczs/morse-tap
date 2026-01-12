import Foundation
import Testing
import SwiftData
@testable import MorseTap

@MainActor
struct RepositoryTests {
    
    private func createTestContainer() throws -> ModelContainer {
        let schema = Schema([
            UserProfileModel.self,
            SymbolStatisticsModel.self,
            ExerciseStatisticsModel.self
        ])
        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: true
        )
        return try ModelContainer(for: schema, configurations: [configuration])
    }
    
    // MARK: - UserProfileRepository Tests
    
    @Test func loadOrCreateProfileCreatesNewProfile() async throws {
        let container = try createTestContainer()
        let repository = UserProfileRepository(modelContext: container.mainContext)
        
        let profile = try await repository.loadOrCreateProfile()
        
        #expect(profile.currentStreak == 0)
        #expect(profile.longestStreak == 0)
    }
    
    @Test func loadOrCreateProfileReturnsExistingProfile() async throws {
        let container = try createTestContainer()
        let repository = UserProfileRepository(modelContext: container.mainContext)
        
        let firstProfile = try await repository.loadOrCreateProfile()
        firstProfile.currentStreak = 5
        try container.mainContext.save()
        
        let secondProfile = try await repository.loadOrCreateProfile()
        
        #expect(secondProfile.currentStreak == 5)
    }
    
    @Test func recordActivityUpdatesLastActivityDate() async throws {
        let container = try createTestContainer()
        let repository = UserProfileRepository(modelContext: container.mainContext)
        
        _ = try await repository.loadOrCreateProfile()
        let beforeDate = Date()
        
        try await repository.recordActivity()
        
        let profile = try await repository.loadOrCreateProfile()
        #expect(profile.lastActivityDate >= beforeDate)
    }
    
    // MARK: - StatisticsRepository Symbol Tests
    
    @Test func recordSymbolAttemptCreatesNewStatistics() async throws {
        let container = try createTestContainer()
        let repository = StatisticsRepository(modelContext: container.mainContext)
        
        try await repository.recordSymbolAttempt(symbol: "A", isCorrect: true, inputTime: 0.5)
        
        let stats = try await repository.getStatistics(forSymbol: "A")
        #expect(stats != nil)
        #expect(stats?.totalAttempts == 1)
        #expect(stats?.correctAttempts == 1)
        #expect(stats?.accuracy == 1.0)
    }
    
    @Test func recordSymbolAttemptUpdatesExistingStatistics() async throws {
        let container = try createTestContainer()
        let repository = StatisticsRepository(modelContext: container.mainContext)
        
        try await repository.recordSymbolAttempt(symbol: "B", isCorrect: true, inputTime: 0.3)
        try await repository.recordSymbolAttempt(symbol: "B", isCorrect: false, inputTime: 0.4)
        try await repository.recordSymbolAttempt(symbol: "B", isCorrect: true, inputTime: 0.5)
        
        let stats = try await repository.getStatistics(forSymbol: "B")
        #expect(stats?.totalAttempts == 3)
        #expect(stats?.correctAttempts == 2)
        #expect(stats?.accuracy == 2.0 / 3.0)
    }
    
    @Test func getAllSymbolStatisticsReturnsAllRecords() async throws {
        let container = try createTestContainer()
        let repository = StatisticsRepository(modelContext: container.mainContext)
        
        try await repository.recordSymbolAttempt(symbol: "X", isCorrect: true, inputTime: 0.1)
        try await repository.recordSymbolAttempt(symbol: "Y", isCorrect: true, inputTime: 0.2)
        try await repository.recordSymbolAttempt(symbol: "Z", isCorrect: true, inputTime: 0.3)
        
        let allStats = try await repository.getAllSymbolStatistics()
        #expect(allStats.count == 3)
    }
    
    @Test func symbolStatisticsHandlesLowercaseSymbols() async throws {
        let container = try createTestContainer()
        let repository = StatisticsRepository(modelContext: container.mainContext)
        
        try await repository.recordSymbolAttempt(symbol: "a", isCorrect: true, inputTime: 0.5)
        
        let stats = try await repository.getStatistics(forSymbol: "A")
        #expect(stats != nil)
        #expect(stats?.symbol == "A")
    }
    
    // MARK: - StatisticsRepository Exercise Tests
    
    @Test func recordExerciseAttemptCreatesNewStatistics() async throws {
        let container = try createTestContainer()
        let repository = StatisticsRepository(modelContext: container.mainContext)
        
        try await repository.recordExerciseAttempt(mode: .codeToWord, isCorrect: true, time: 10.0)
        
        let stats = try await repository.getStatistics(forMode: .codeToWord)
        #expect(stats != nil)
        #expect(stats?.totalAttempts == 1)
        #expect(stats?.correctAttempts == 1)
    }
    
    @Test func recordExerciseAttemptUpdatesExistingStatistics() async throws {
        let container = try createTestContainer()
        let repository = StatisticsRepository(modelContext: container.mainContext)
        
        try await repository.recordExerciseAttempt(mode: .wordToCode, isCorrect: true, time: 5.0)
        try await repository.recordExerciseAttempt(mode: .wordToCode, isCorrect: false, time: 8.0)
        
        let stats = try await repository.getStatistics(forMode: .wordToCode)
        #expect(stats?.totalAttempts == 2)
        #expect(stats?.correctAttempts == 1)
        #expect(stats?.accuracy == 0.5)
        #expect(stats?.averageTime == 6.5)
    }
    
    @Test func getAllExerciseStatisticsReturnsAllRecords() async throws {
        let container = try createTestContainer()
        let repository = StatisticsRepository(modelContext: container.mainContext)
        
        try await repository.recordExerciseAttempt(mode: .codeToWord, isCorrect: true, time: 5.0)
        try await repository.recordExerciseAttempt(mode: .wordToCode, isCorrect: true, time: 6.0)
        
        let allStats = try await repository.getAllExerciseStatistics()
        #expect(allStats.count == 2)
    }
    
    // MARK: - Computed Properties Tests
    
    @Test func symbolStatisticsAccuracyHandlesZeroAttempts() async throws {
        let stats = SymbolStatisticsModel(symbol: "T")
        #expect(stats.accuracy == 0)
        #expect(stats.averageInputTime == 0)
    }
    
    @Test func exerciseStatisticsAccuracyHandlesZeroAttempts() async throws {
        let stats = ExerciseStatisticsModel(modeRawValue: "test")
        #expect(stats.accuracy == 0)
        #expect(stats.averageTime == 0)
    }
}
