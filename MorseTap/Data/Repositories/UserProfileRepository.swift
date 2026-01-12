import Foundation
import SwiftData

protocol UserProfileRepositoryProtocol: Sendable {
    func loadOrCreateProfile() async throws -> UserProfileModel
    func updateStreak() async throws
    func recordActivity() async throws
}

@MainActor
final class UserProfileRepository: UserProfileRepositoryProtocol {
    
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func loadOrCreateProfile() async throws -> UserProfileModel {
        let descriptor = FetchDescriptor<UserProfileModel>()
        let profiles = try modelContext.fetch(descriptor)
        
        if let existingProfile = profiles.first {
            return existingProfile
        }
        
        let newProfile = UserProfileModel()
        modelContext.insert(newProfile)
        try modelContext.save()
        return newProfile
    }
    
    func updateStreak() async throws {
        let profile = try await loadOrCreateProfile()
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let lastActivity = calendar.startOfDay(for: profile.lastActivityDate)
        
        let daysDifference = calendar.dateComponents([.day], from: lastActivity, to: today).day ?? 0
        
        switch daysDifference {
        case 0:
            break
        case 1:
            profile.currentStreak += 1
            if profile.currentStreak > profile.longestStreak {
                profile.longestStreak = profile.currentStreak
            }
        default:
            profile.currentStreak = 1
        }
        
        try modelContext.save()
    }
    
    func recordActivity() async throws {
        let profile = try await loadOrCreateProfile()
        profile.lastActivityDate = Date()
        try modelContext.save()
    }
}
