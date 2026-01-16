# Progress Screen Implementation

## Affected modules

- `MorseTap/Presentation/Progress/UserProgressView.swift`
- `MorseTap/Presentation/Progress/ProgressViewModel.swift`

## Goal

Implement functional Progress screen displaying aggregated statistics from Learn and Practice modules. Show total attempts, overall accuracy, current streak, and weak symbols list. Data loaded from existing repositories.

## Dependencies

- Task T5: SwiftData Storage (completed) — provides `StatisticsRepository`, `UserProfileRepository`
- Task T7: Learn Symbol Card (completed) — records symbol statistics
- Task T11-T13: Practice modes (completed) — record exercise and symbol statistics

## Execution plan

1. Implement `ProgressViewModel` with data loading and aggregation
2. Implement `UserProgressView` with statistics display
3. Add weak symbols section
4. Handle empty state
5. Build and test in Xcode Simulator
6. Verify SwiftUI previews
7. Finalization

## Pre-implementation code preparation

1. Open the project in Xcode: `MorseTap.xcodeproj`
2. Review `StatisticsRepository.swift` — available query methods
3. Review `UserProfileRepository.swift` — streak data access
4. Review `SymbolStatisticsModel.swift` — accuracy computed property
5. Review `ExerciseStatisticsModel.swift` — accuracy computed property

## Terms/Context

- **Aggregated statistics** — combined metrics from all exercise modes and symbol attempts
- **Weak symbols** — symbols with accuracy below threshold or few attempts
- **Streak** — consecutive days with training activity

## Block requirements

### Domain Services

No changes.

### Data Repositories

No changes. Uses existing:
- `StatisticsRepository.getAllSymbolStatistics()`
- `StatisticsRepository.getAllExerciseStatistics()`
- `UserProfileRepository.loadOrCreateProfile()`

### ViewModels

#### `MorseTap/Presentation/Progress/ProgressViewModel.swift`

Replace placeholder with full implementation:

```swift
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
            // Load exercise statistics
            let exerciseStats = try await statsRepo.getAllExerciseStatistics()
            totalAttempts = exerciseStats.reduce(0) { $0 + $1.totalAttempts }
            correctAttempts = exerciseStats.reduce(0) { $0 + $1.correctAttempts }
            
            // Load user profile for streak
            let profile = try await profileRepo.loadOrCreateProfile()
            currentStreak = profile.currentStreak
            longestStreak = profile.longestStreak
            
            // Load symbol statistics for weak symbols
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
```

### Views

#### `MorseTap/Presentation/Progress/UserProgressView.swift`

Replace placeholder with full implementation:

```swift
import SwiftUI
import SwiftData

struct UserProgressView: View {
    @State private var viewModel = ProgressViewModel()
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .padding(.top, 100)
                } else if viewModel.hasData {
                    statisticsContent
                } else {
                    emptyStateView
                }
            }
            .navigationTitle("Progress")
            .task {
                configureRepositories()
                await viewModel.loadStatistics()
            }
        }
    }
    
    private func configureRepositories() {
        let statsRepo = StatisticsRepository(modelContext: modelContext)
        let profileRepo = UserProfileRepository(modelContext: modelContext)
        viewModel.configure(statisticsRepository: statsRepo, userProfileRepository: profileRepo)
    }
    
    @ViewBuilder
    private var statisticsContent: some View {
        VStack(spacing: 24) {
            streakSection
            accuracySection
            attemptsSection
            
            if !viewModel.weakSymbols.isEmpty {
                weakSymbolsSection
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 32)
    }
    
    @ViewBuilder
    private var streakSection: some View {
        HStack(spacing: 16) {
            StatCard(
                title: "Current Streak",
                value: "\(viewModel.currentStreak)",
                subtitle: "days",
                icon: "flame.fill",
                color: .orange
            )
            
            StatCard(
                title: "Longest Streak",
                value: "\(viewModel.longestStreak)",
                subtitle: "days",
                icon: "trophy.fill",
                color: .yellow
            )
        }
    }
    
    @ViewBuilder
    private var accuracySection: some View {
        VStack(spacing: 12) {
            Text("Overall Accuracy")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Text("\(viewModel.accuracyPercentage)%")
                .font(.system(size: 64, weight: .bold, design: .rounded))
                .foregroundStyle(accuracyColor)
            
            ProgressView(value: viewModel.overallAccuracy)
                .tint(accuracyColor)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.quaternary.opacity(0.5))
        )
    }
    
    private var accuracyColor: Color {
        switch viewModel.accuracyPercentage {
        case 80...: return .green
        case 60..<80: return .yellow
        default: return .red
        }
    }
    
    @ViewBuilder
    private var attemptsSection: some View {
        HStack(spacing: 16) {
            StatCard(
                title: "Total Attempts",
                value: "\(viewModel.totalAttempts)",
                subtitle: "exercises",
                icon: "list.bullet.clipboard",
                color: .blue
            )
            
            StatCard(
                title: "Correct",
                value: "\(viewModel.correctAttempts)",
                subtitle: "answers",
                icon: "checkmark.circle.fill",
                color: .green
            )
        }
    }
    
    @ViewBuilder
    private var weakSymbolsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Needs Practice")
                .font(.headline)
            
            ForEach(viewModel.weakSymbols) { symbol in
                WeakSymbolRow(symbol: symbol)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.quaternary.opacity(0.5))
        )
    }
    
    @ViewBuilder
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "chart.bar.xaxis")
                .font(.system(size: 64))
                .foregroundStyle(.tertiary)
            
            Text("No Statistics Yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Complete some exercises in Learn or Practice to see your progress.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 40)
        .padding(.top, 100)
    }
}

// MARK: - Supporting Views

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
            
            Text(value)
                .font(.system(size: 32, weight: .bold, design: .rounded))
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.quaternary.opacity(0.5))
        )
    }
}

struct WeakSymbolRow: View {
    let symbol: WeakSymbol
    
    var body: some View {
        HStack {
            Text(symbol.symbol)
                .font(.title2.monospaced())
                .fontWeight(.bold)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 2) {
                ProgressView(value: symbol.accuracy)
                    .tint(symbol.accuracy < 0.5 ? .red : .yellow)
                
                Text("\(symbol.attempts) attempts")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text("\(symbol.accuracyPercentage)%")
                .font(.headline.monospacedDigit())
                .foregroundStyle(symbol.accuracy < 0.5 ? .red : .yellow)
        }
    }
}

#Preview {
    UserProgressView()
        .modelContainer(for: [
            SymbolStatisticsModel.self,
            ExerciseStatisticsModel.self,
            UserProfileModel.self
        ], inMemory: true)
}
```

### Shared Components

No new shared components. `StatCard` and `WeakSymbolRow` are local to Progress module.

### Utilities

No changes.

### Models/Types

`WeakSymbol` struct is local to ProgressViewModel.

### Refactoring

No changes.

### NFRs

- Statistics load on screen appear
- Handle empty state gracefully
- Accuracy color-coded (green/yellow/red)
- Weak symbols sorted by accuracy (worst first)
- Maximum 5 weak symbols displayed
- SwiftUI previews work with in-memory container

## Acceptance criteria

- [ ] Progress screen displays current streak
- [ ] Progress screen displays longest streak
- [ ] Overall accuracy shows as percentage
- [ ] Accuracy is color-coded (≥80% green, 60-79% yellow, <60% red)
- [ ] Total attempts count displayed
- [ ] Correct attempts count displayed
- [ ] Weak symbols section shows symbols with <80% accuracy
- [ ] Weak symbols show accuracy percentage
- [ ] Empty state shown when no data
- [ ] Loading state shown during data fetch
- [ ] Statistics update after Learn practice
- [ ] Statistics update after Practice exercises
- [ ] SwiftUI previews render correctly
- [ ] Code follows AGENTS.md rules

## Post-implementation verification

1. Build the project: Xcode → Product → Build (⌘+B)
2. Run in Simulator: Xcode → Product → Run (⌘+R)
3. Navigate to Progress tab:
   - Verify empty state if no data
4. Complete some Learn exercises:
   - Navigate to Learn → select symbol → practice
   - Return to Progress → verify stats updated
5. Complete some Practice exercises:
   - Navigate to Practice → select mode → complete session
   - Return to Progress → verify stats updated
6. Verify streak displays correctly
7. Verify weak symbols appear for symbols with low accuracy
8. Check SwiftUI preview

## Documentation update

### README.md

No changes required.

### AGENTS.md

No changes required — Progress module already documented.

### Module AGENTS.md

Not applicable.

## Post-implementation code preparation

1. Verify Progress screen works end-to-end
2. Ensure statistics aggregate correctly from all sources
3. Run SwiftLint and fix issues
4. Verify project builds
5. Prepare for code review
