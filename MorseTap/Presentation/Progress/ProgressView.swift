import SwiftUI

struct ProgressView: View {
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
