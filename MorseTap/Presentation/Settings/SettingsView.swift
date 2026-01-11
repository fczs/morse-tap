import SwiftUI

struct SettingsView: View {
    @State private var viewModel = SettingsViewModel()
    
    var body: some View {
        NavigationStack {
            Text("Settings")
                .font(.title)
                .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
