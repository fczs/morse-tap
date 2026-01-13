import SwiftUI

struct ExerciseView: View {
    let mode: ExerciseMode
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: mode.isCodeInput ? "hand.tap" : "keyboard")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            
            Text(mode.displayName)
                .font(.title)
            
            Text(mode.description)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Text("Exercise implementation coming soon")
                .font(.caption)
                .foregroundStyle(.tertiary)
                .padding(.top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle(mode.displayName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview("Code to Word") {
    NavigationStack {
        ExerciseView(mode: .codeToWord)
    }
}

#Preview("Word to Code") {
    NavigationStack {
        ExerciseView(mode: .wordToCode)
    }
}
