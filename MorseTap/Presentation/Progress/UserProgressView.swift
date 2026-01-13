import SwiftUI

struct UserProgressView: View {
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
    UserProgressView()
}
