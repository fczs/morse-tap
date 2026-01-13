import Foundation

@Observable
@MainActor
final class SettingsViewModel {
    
    let settingsStore: SettingsStore
    
    init(settingsStore: SettingsStore) {
        self.settingsStore = settingsStore
    }
    
    func resetToDefaults() {
        settingsStore.resetToDefaults()
    }
}
