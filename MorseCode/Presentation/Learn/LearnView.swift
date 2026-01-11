import SwiftUI

struct LearnView: View {
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
