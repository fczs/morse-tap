import SwiftUI

struct PracticeView: View {
    @State private var viewModel = PracticeViewModel()
    
    var body: some View {
        NavigationStack {
            Text("Practice Morse Tap")
                .font(.title)
                .navigationTitle("Practice")
        }
    }
}

#Preview {
    PracticeView()
}
