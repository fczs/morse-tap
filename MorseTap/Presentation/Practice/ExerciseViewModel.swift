import Foundation

@Observable
@MainActor
final class ExerciseViewModel {
    
    let mode: ExerciseMode
    private(set) var currentExercise: Exercise?
    private(set) var currentIndex: Int = 0
    let totalExercises: Int
    var userAnswer: String = ""
    private(set) var morseAnswerSymbols: [Character] = []
    private(set) var pendingSignals: [MorseSignal] = []
    private(set) var validationResult: ValidationResult?
    private(set) var isShowingResult: Bool = false
    private(set) var isSessionComplete: Bool = false
    private var startTime: Date?
    private var pressDownTimestamp: Date?
    private var completionTask: Task<Void, Never>?
    
    private let generator: ExerciseGenerating
    private let validator: ExerciseValidating
    private let statisticsRepository: StatisticsRepositoryProtocol?
    private let difficulty: Difficulty
    private let alphabet: MorseAlphabetProviding
    private let timingConfig: MorseTimingConfig
    
    var progressText: String {
        "\(currentIndex + 1) / \(totalExercises)"
    }
    
    var morseAnswerText: String {
        String(morseAnswerSymbols)
    }
    
    var pendingPattern: String {
        pendingSignals.asPattern
    }
    
    /// Display text showing completed symbols + pending signals pattern
    var displayAnswer: String {
        let completed = morseAnswerText
        let pending = pendingPattern
        
        if completed.isEmpty && pending.isEmpty {
            return ""
        } else if pending.isEmpty {
            return completed
        } else {
            return completed + pending
        }
    }
    
    var hasPendingInput: Bool {
        !pendingSignals.isEmpty
    }
    
    var currentAnswer: String {
        mode.isCodeInput ? encodeMorseAnswer() : userAnswer
    }
    
    var canSubmit: Bool {
        !currentAnswer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty 
            && !isShowingResult 
            && pendingSignals.isEmpty
    }
    
    init(
        mode: ExerciseMode,
        difficulty: Difficulty = .beginner,
        totalExercises: Int = 10,
        generator: ExerciseGenerating = ExerciseGenerator(),
        validator: ExerciseValidating = ExerciseValidator(),
        statisticsRepository: StatisticsRepositoryProtocol? = nil,
        alphabet: MorseAlphabetProviding = MorseAlphabet(),
        timingConfig: MorseTimingConfig = .standard
    ) {
        self.mode = mode
        self.difficulty = difficulty
        self.totalExercises = totalExercises
        self.generator = generator
        self.validator = validator
        self.statisticsRepository = statisticsRepository
        self.alphabet = alphabet
        self.timingConfig = timingConfig
    }
    
    func loadExercise() {
        currentExercise = generator.generateExercise(mode: mode, difficulty: difficulty)
        userAnswer = ""
        morseAnswerSymbols = []
        pendingSignals = []
        cancelPendingCompletion()
        validationResult = nil
        isShowingResult = false
        startTime = Date()
    }
    
    func submitAnswer() async {
        guard let exercise = currentExercise, canSubmit else { return }
        
        let result = validator.validate(exercise: exercise, userAnswer: currentAnswer)
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
        morseAnswerSymbols = []
        pendingSignals = []
        cancelPendingCompletion()
        loadExercise()
    }
    
    private func encodeMorseAnswer() -> String {
        let words = morseAnswerText.split(separator: " ")
        let encodedWords = words.map { word -> String in
            word.compactMap { char -> String? in
                alphabet.symbol(for: char)?.pattern
            }.joined(separator: " ")
        }
        return encodedWords.joined(separator: " / ")
    }
    
    // MARK: - Morse Input Handling (Direct Button Control)
    
    func handlePressDown() {
        pressDownTimestamp = Date()
        cancelPendingCompletion()
    }
    
    func handlePressUp() {
        guard let downTimestamp = pressDownTimestamp else { return }
        
        let duration = Date().timeIntervalSince(downTimestamp)
        let signal: MorseSignal = duration >= timingConfig.dashMinDuration ? .dash : .dot
        
        pendingSignals.append(signal)
        HapticFeedbackManager.shared.signalFeedback()
        pressDownTimestamp = nil
        
        startCompletionTimer()
    }
    
    func deleteLastSignal() {
        if !pendingSignals.isEmpty {
            pendingSignals.removeLast()
            if pendingSignals.isEmpty {
                cancelPendingCompletion()
            } else {
                startCompletionTimer()
            }
        } else if !morseAnswerSymbols.isEmpty {
            morseAnswerSymbols.removeLast()
        }
    }
    
    func insertSpace() {
        if !pendingSignals.isEmpty {
            completeCurrentSymbol()
        }
        morseAnswerSymbols.append(" ")
    }
    
    func clearMorseAnswer() {
        morseAnswerSymbols.removeAll()
        pendingSignals.removeAll()
        cancelPendingCompletion()
    }
    
    func clearTypedAnswer() {
        userAnswer = ""
    }
    
    private func startCompletionTimer() {
        cancelPendingCompletion()
        
        let pauseDuration = timingConfig.symbolPauseDuration
        
        completionTask = Task { [weak self] in
            try? await Task.sleep(for: .seconds(pauseDuration))
            
            guard !Task.isCancelled else { return }
            
            await self?.completeCurrentSymbol()
        }
    }
    
    private func cancelPendingCompletion() {
        completionTask?.cancel()
        completionTask = nil
    }
    
    private func completeCurrentSymbol() {
        guard !pendingSignals.isEmpty else { return }
        
        let pattern = pendingSignals.asPattern
        pendingSignals.removeAll()
        
        if let character = alphabet.decode(pattern) {
            morseAnswerSymbols.append(character)
            HapticFeedbackManager.shared.symbolCompletedFeedback()
        } else {
            HapticFeedbackManager.shared.errorFeedback()
        }
    }
    
    // MARK: - Statistics Recording
    
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
