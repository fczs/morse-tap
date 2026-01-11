import SwiftUI

struct ProgressView: View {
    @State private var viewModel = ProgressViewModel()
    
    var body: some View {
        NavigationStack {
            Text("Your Progress")
                .font(.title)
                .navigationTitle("Progress")
        }
    }
}

#Preview {
    ProgressView()
}
