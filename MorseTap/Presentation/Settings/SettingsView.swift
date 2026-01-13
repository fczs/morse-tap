import SwiftUI

struct SettingsView: View {
    @Environment(SettingsStore.self) private var settingsStore
    
    var body: some View {
        NavigationStack {
            Form {
                timingSection
                feedbackSection
                difficultySection
                actionsSection
            }
            .navigationTitle("Settings")
        }
    }
    
    private var timingSection: some View {
        @Bindable var store = settingsStore
        
        return Section {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Dot Max Duration")
                    Spacer()
                    Text(String(format: "%.2fs", store.dotMaxDuration))
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                }
                Slider(
                    value: $store.dotMaxDuration,
                    in: 0.1...0.5,
                    step: 0.05
                )
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Dash Min Duration")
                    Spacer()
                    Text(String(format: "%.2fs", store.dashMinDuration))
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                }
                Slider(
                    value: $store.dashMinDuration,
                    in: 0.1...0.5,
                    step: 0.05
                )
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Symbol Pause")
                    Spacer()
                    Text(String(format: "%.2fs", store.symbolPauseDuration))
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                }
                Slider(
                    value: $store.symbolPauseDuration,
                    in: 0.3...1.5,
                    step: 0.1
                )
            }
        } header: {
            Text("Timing")
        } footer: {
            Text("Adjust how long a tap is considered a dot vs dash, and the pause between symbols.")
        }
    }
    
    private var feedbackSection: some View {
        @Bindable var store = settingsStore
        
        return Section("Feedback") {
            Toggle("Sound", isOn: $store.soundEnabled)
            Toggle("Vibration", isOn: $store.vibrationEnabled)
        }
    }
    
    private var difficultySection: some View {
        @Bindable var store = settingsStore
        
        return Section {
            Picker("Difficulty", selection: $store.difficulty) {
                ForEach(Difficulty.allCases, id: \.self) { difficulty in
                    Text(difficulty.displayName).tag(difficulty)
                }
            }
            .pickerStyle(.segmented)
            
            Text(store.difficulty.description)
                .font(.footnote)
                .foregroundStyle(.secondary)
        } header: {
            Text("Difficulty")
        } footer: {
            Text("Difficulty affects timing thresholds. Beginner is more forgiving, Advanced requires precision.")
        }
    }
    
    private var actionsSection: some View {
        Section {
            Button(role: .destructive) {
                settingsStore.resetToDefaults()
            } label: {
                HStack {
                    Spacer()
                    Text("Reset to Defaults")
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    SettingsView()
        .environment(SettingsStore())
}
