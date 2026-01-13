import Foundation

@Observable
@MainActor
final class ExerciseViewModel {
    
    let mode: ExerciseMode
    private(set) var currentExercise: Exercise?
    private(set) var currentIndex: Int = 0
    let totalExercises: Int
    var userAnswer: String = ""
    private(set) var validationResult: ValidationResult?
    private(set) var isShowingResult: Bool = false
    private(set) var isSessionComplete: Bool = false
    private var startTime: Date?
    
    private let generator: ExerciseGenerating
    private let validator: ExerciseValidating
    private let statisticsRepository: StatisticsRepositoryProtocol?
    private let difficulty: Difficulty
    
    var progressText: String {
        "\(currentIndex + 1) / \(totalExercises)"
    }
    
    var canSubmit: Bool {
        !userAnswer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isShowingResult
    }
    
    init(
        mode: ExerciseMode,
        difficulty: Difficulty = .beginner,
        totalExercises: Int = 10,
        generator: ExerciseGenerating = ExerciseGenerator(),
        validator: ExerciseValidating = ExerciseValidator(),
        statisticsRepository: StatisticsRepositoryProtocol? = nil
    ) {
        self.mode = mode
        self.difficulty = difficulty
        self.totalExercises = totalExercises
        self.generator = generator
        self.validator = validator
        self.statisticsRepository = statisticsRepository
    }
    
    func loadExercise() {
        currentExercise = generator.generateExercise(mode: mode, difficulty: difficulty)
        userAnswer = ""
        validationResult = nil
        isShowingResult = false
        startTime = Date()
    }
    
    func submitAnswer() async {
        guard let exercise = currentExercise, canSubmit else { return }
        
        let result = validator.validate(exercise: exercise, userAnswer: userAnswer)
        validationResult = result
        isShowingResult = true
        
        await recordStatistics(result: result)
    }
    
    func proceedToNext() {
        if currentIndex + 1 >= totalExercises {
            isSessionComplete = true
        } else {
            currentIndex += 1
            loadExercise()
        }
    }
    
    func restartSession() {
        currentIndex = 0
        isSessionComplete = false
        loadExercise()
    }
    
    private func recordStatistics(result: ValidationResult) async {
        guard let repository = statisticsRepository,
              let exercise = currentExercise else { return }
        
        let elapsed = startTime.map { Date().timeIntervalSince($0) } ?? 0
        
        do {
            try await repository.recordExerciseAttempt(
                mode: mode,
                isCorrect: result.isCorrect,
                time: elapsed
            )
            
            await recordSymbolStatistics(for: exercise, isCorrect: result.isCorrect, time: elapsed)
        } catch {
            print("[DEBUG] Failed to record statistics: \(error)")
        }
    }
    
    private func recordSymbolStatistics(for exercise: Exercise, isCorrect: Bool, time: TimeInterval) async {
        guard let repository = statisticsRepository else { return }
        
        let text: String
        if mode.isCodeInput {
            text = exercise.prompt
        } else {
            text = exercise.expectedAnswer
        }
        
        let symbols = text.uppercased().filter { $0.isLetter || $0.isNumber }
        let timePerSymbol = symbols.isEmpty ? 0 : time / Double(symbols.count)
        
        for symbol in symbols {
            do {
                try await repository.recordSymbolAttempt(
                    symbol: symbol,
                    isCorrect: isCorrect,
                    inputTime: timePerSymbol
                )
            } catch {
                print("[DEBUG] Failed to record symbol statistics: \(error)")
            }
        }
    }
}
