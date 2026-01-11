import SwiftUI

struct LearnView: View {
    @State private var viewModel = LearnViewModel()
    
    var body: some View {
        NavigationStack {
            Text("Learn Morse Tap")
                .font(.title)
                .navigationTitle("Learn")
        }
    }
}

#Preview {
    LearnView()
}
