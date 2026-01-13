import SwiftUI

struct PracticeView: View {
    @State private var viewModel = PracticeViewModel()
    
    var body: some View {
        NavigationStack {
            List(viewModel.availableModes, id: \.self) { mode in
                ExerciseModeRow(mode: mode)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.selectMode(mode)
                    }
            }
            .navigationTitle("Practice")
            .navigationDestination(item: $viewModel.selectedMode) { mode in
                ExerciseView(mode: mode)
            }
        }
    }
}

struct ExerciseModeRow: View {
    let mode: ExerciseMode
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(mode.displayName)
                    .font(.headline)
                
                Text(mode.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    PracticeView()
}
