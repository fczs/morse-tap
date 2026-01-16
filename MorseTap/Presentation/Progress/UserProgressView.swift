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
                icon: "flame.fill",
                color: .orange
            )
            
            StatCard(
                title: "Longest Streak",
                value: "\(viewModel.longestStreak)",
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
                icon: "list.bullet.clipboard",
                color: .blue
            )
            
            StatCard(
                title: "Correct",
                value: "\(viewModel.correctAttempts)",
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
