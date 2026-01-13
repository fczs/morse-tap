import SwiftUI
import SwiftData

struct LearnView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: LearnViewModel?
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Learn")
                .task {
                    if viewModel == nil {
                        let repository = StatisticsRepository(modelContext: modelContext)
                        viewModel = LearnViewModel(statisticsRepository: repository)
                    }
                    await viewModel?.loadSymbols()
                }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if let viewModel = viewModel {
            switch viewModel.state {
            case .loading:
                ProgressView("Loading symbols...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            case .loaded:
                symbolList(viewModel: viewModel)
                
            case .error(let message):
                ContentUnavailableView(
                    "Error",
                    systemImage: "exclamationmark.triangle",
                    description: Text(message)
                )
            }
        } else {
            ProgressView("Loading...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    private func symbolList(viewModel: LearnViewModel) -> some View {
        List(viewModel.symbolItems) { item in
            NavigationLink(value: item.symbol) {
                SymbolRowView(item: item)
            }
        }
        .listStyle(.plain)
        .navigationDestination(for: MorseSymbol.self) { symbol in
            SymbolCardView(symbol: symbol)
        }
    }
}

#Preview {
    LearnView()
        .modelContainer(for: [SymbolStatisticsModel.self], inMemory: true)
}
