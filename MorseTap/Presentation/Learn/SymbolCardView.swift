import SwiftUI
import SwiftData

struct SymbolCardView: View {
    
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: SymbolCardViewModel?
    
    let symbol: MorseSymbol
    
    var body: some View {
        VStack(spacing: 24) {
            symbolDisplay
            
            Spacer()
            
            feedbackArea
            
            inputArea
        }
        .padding()
        .navigationTitle(String(symbol.character))
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if viewModel == nil {
                let repository = StatisticsRepository(modelContext: modelContext)
                viewModel = SymbolCardViewModel(symbol: symbol, statisticsRepository: repository)
            }
        }
    }
    
    private var symbolDisplay: some View {
        VStack(spacing: 16) {
            Text(String(symbol.character))
                .font(.system(size: 100, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)
            
            MorseSignalsView(
                signals: symbol.signals,
                dotSize: 14,
                dashWidth: 42,
                dashHeight: 14,
                spacing: 10
            )
            
            Text(symbol.pattern)
                .font(.title3.monospaced())
                .foregroundStyle(.secondary)
        }
    }
    
    @ViewBuilder
    private var feedbackArea: some View {
        if let viewModel = viewModel {
            switch viewModel.state {
            case .ready:
                Text("Tap the button to input Morse code")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(height: 80)
                
            case .inputting:
                Text("Keep going...")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(height: 80)
                
            case .correct(let inputTime):
                correctFeedback(inputTime: inputTime)
                
            case .incorrect(let expected, let got):
                incorrectFeedback(expected: expected, got: got)
            }
        } else {
            Text("Loading...")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(height: 80)
        }
    }
    
    private func correctFeedback(inputTime: TimeInterval) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 48))
                .foregroundStyle(.green)
            
            Text("Correct!")
                .font(.title2.bold())
                .foregroundStyle(.green)
            
            Text(String(format: "%.1fs", inputTime))
                .font(.subheadline.monospaced())
                .foregroundStyle(.secondary)
        }
        .frame(height: 120)
        .transition(.scale.combined(with: .opacity))
    }
    
    private func incorrectFeedback(expected: [MorseSignal], got: [MorseSignal]) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 48))
                .foregroundStyle(.red)
            
            Text("Incorrect")
                .font(.title2.bold())
                .foregroundStyle(.red)
            
            HStack(spacing: 24) {
                VStack(spacing: 4) {
                    Text("Expected")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    MorseSignalsView(
                        signals: expected,
                        dotSize: 8,
                        dashWidth: 24,
                        dashHeight: 8,
                        spacing: 4
                    )
                }
                
                VStack(spacing: 4) {
                    Text("Got")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    MorseSignalsView(
                        signals: got,
                        dotSize: 8,
                        dashWidth: 24,
                        dashHeight: 8,
                        spacing: 4
                    )
                }
            }
        }
        .frame(height: 140)
        .transition(.scale.combined(with: .opacity))
    }
    
    @ViewBuilder
    private var inputArea: some View {
        if let viewModel = viewModel {
            switch viewModel.state {
            case .ready, .inputting:
                MorseInputView(
                    onSignalAdded: { signal in
                        viewModel.onSignalAdded(signal)
                    },
                    onSymbolCompleted: { signals in
                        Task {
                            await viewModel.onSymbolCompleted(signals)
                        }
                    }
                )
                
            case .correct, .incorrect:
                Button(action: {
                    withAnimation(.spring(duration: 0.3)) {
                        viewModel.retry()
                    }
                }) {
                    Label("Try Again", systemImage: "arrow.counterclockwise")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.accentColor)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
        }
    }
}

#Preview("Ready State") {
    NavigationStack {
        SymbolCardView(symbol: MorseSymbol(character: "A", pattern: ".-"))
    }
    .modelContainer(for: [SymbolStatisticsModel.self], inMemory: true)
}

#Preview("SOS") {
    NavigationStack {
        SymbolCardView(symbol: MorseSymbol(character: "S", pattern: "..."))
    }
    .modelContainer(for: [SymbolStatisticsModel.self], inMemory: true)
}
