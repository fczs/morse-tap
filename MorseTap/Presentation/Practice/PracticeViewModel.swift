import Foundation

@Observable
final class PracticeViewModel {
    
    var availableModes: [ExerciseMode] {
        ExerciseMode.allCases
    }
    
    var selectedMode: ExerciseMode?
    
    func selectMode(_ mode: ExerciseMode) {
        selectedMode = mode
    }
}
