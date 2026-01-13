import SwiftUI
import SwiftData

@main
struct MorseTapApp: App {
    
    @State private var settingsStore = SettingsStore()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            UserProfileModel.self,
            SymbolStatisticsModel.self,
            ExerciseStatisticsModel.self
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(settingsStore)
        }
        .modelContainer(sharedModelContainer)
    }
}
