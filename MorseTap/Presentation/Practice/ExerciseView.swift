import SwiftUI

struct ExerciseView: View {
    let mode: ExerciseMode
    let statisticsRepository: StatisticsRepositoryProtocol?
    
    @State private var viewModel: ExerciseViewModel?
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isInputFocused: Bool
    
    init(mode: ExerciseMode, statisticsRepository: StatisticsRepositoryProtocol? = nil) {
        self.mode = mode
        self.statisticsRepository = statisticsRepository
    }
    
    var body: some View {
        Group {
            if let viewModel {
                if viewModel.isSessionComplete {
                    sessionCompleteView(viewModel: viewModel)
                } else {
                    exerciseContentView(viewModel: viewModel)
                }
            } else {
                ProgressView("Loading...")
            }
        }
        .navigationTitle(mode.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if viewModel == nil {
                let vm = ExerciseViewModel(
                    mode: mode,
                    statisticsRepository: statisticsRepository
                )
                vm.loadExercise()
                viewModel = vm
            }
        }
    }
    
    @ViewBuilder
    private func exerciseContentView(viewModel: ExerciseViewModel) -> some View {
        VStack(spacing: 0) {
            progressHeader(viewModel: viewModel)
            
            ScrollView {
                VStack(spacing: 32) {
                    promptSection(viewModel: viewModel)
                    inputSection(viewModel: viewModel)
                    
                    if viewModel.isShowingResult {
                        resultFeedbackSection(viewModel: viewModel)
                    } else {
                        submitButton(viewModel: viewModel)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 32)
            }
        }
    }
    
    @ViewBuilder
    private func progressHeader(viewModel: ExerciseViewModel) -> some View {
        HStack {
            Text(viewModel.progressText)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            ProgressView(value: Double(viewModel.currentIndex + 1), total: Double(viewModel.totalExercises))
                .frame(width: 100)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .background(.bar)
    }
    
    @ViewBuilder
    private func promptSection(viewModel: ExerciseViewModel) -> some View {
        VStack(spacing: 16) {
            Text(mode.isCodeInput ? "Tap the code for:" : "Decode this:")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            if let exercise = viewModel.currentExercise {
                Text(exercise.prompt)
                    .font(mode.isCodeInput ? .largeTitle : .title2.monospaced())
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.quaternary.opacity(0.5))
        )
    }
    
    @ViewBuilder
    private func inputSection(viewModel: ExerciseViewModel) -> some View {
        VStack(spacing: 12) {
            Text("Your answer:")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            if mode.isCodeInput {
                morseInputSection(viewModel: viewModel)
            } else {
                keyboardInputSection(viewModel: viewModel)
            }
        }
    }
    
    @ViewBuilder
    private func keyboardInputSection(viewModel: ExerciseViewModel) -> some View {
        VStack(spacing: 16) {
            TextField(
                "Type the decoded text...",
                text: Binding(
                    get: { viewModel.userAnswer },
                    set: { viewModel.userAnswer = $0 }
                )
            )
            .font(.body)
            .textFieldStyle(.roundedBorder)
            .textInputAutocapitalization(.characters)
            .autocorrectionDisabled()
            .disabled(viewModel.isShowingResult)
            .focused($isInputFocused)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isInputFocused = true
                }
            }
            
            if !viewModel.userAnswer.isEmpty && !viewModel.isShowingResult {
                Button {
                    viewModel.clearTypedAnswer()
                } label: {
                    Label("Clear", systemImage: "xmark.circle")
                        .font(.callout)
                }
                .buttonStyle(.bordered)
                .foregroundStyle(.secondary)
            }
        }
    }
    
    @ViewBuilder
    private func morseInputSection(viewModel: ExerciseViewModel) -> some View {
        VStack(spacing: 24) {
            answerPreview(viewModel: viewModel)
            
            if !viewModel.isShowingResult {
                MorseInputButton(
                    onPressDown: { viewModel.handlePressDown() },
                    onPressUp: { viewModel.handlePressUp() }
                )
                
                actionButtons(viewModel: viewModel)
            }
        }
    }
    
    @ViewBuilder
    private func answerPreview(viewModel: ExerciseViewModel) -> some View {
        HStack(spacing: 0) {
            Text(viewModel.morseAnswerText)
                .font(.title2.monospaced())
                .fontWeight(.medium)
            
            if !viewModel.pendingPattern.isEmpty {
                Text(viewModel.pendingPattern)
                    .font(.title2.monospaced())
                    .fontWeight(.medium)
                    .foregroundStyle(.orange)
            }
            
            if viewModel.displayAnswer.isEmpty {
                Text("...")
                    .font(.title2.monospaced())
                    .fontWeight(.medium)
                    .foregroundStyle(.tertiary)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: 44)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.quaternary)
        )
        .animation(.easeOut(duration: 0.1), value: viewModel.displayAnswer)
    }
    
    @ViewBuilder
    private func actionButtons(viewModel: ExerciseViewModel) -> some View {
        HStack(spacing: 16) {
            Button {
                viewModel.deleteLastSignal()
            } label: {
                Label("Delete", systemImage: "delete.left")
                    .font(.callout)
            }
            .buttonStyle(.bordered)
            .disabled(viewModel.displayAnswer.isEmpty)
            
            Button {
                viewModel.insertSpace()
            } label: {
                Label("Space", systemImage: "space")
                    .font(.callout)
            }
            .buttonStyle(.bordered)
            
            Button {
                viewModel.clearMorseAnswer()
            } label: {
                Label("Clear", systemImage: "trash")
                    .font(.callout)
            }
            .buttonStyle(.bordered)
            .disabled(viewModel.displayAnswer.isEmpty)
        }
        .foregroundStyle(.secondary)
    }
    
    @ViewBuilder
    private func submitButton(viewModel: ExerciseViewModel) -> some View {
        Button {
            Task {
                await viewModel.submitAnswer()
            }
        } label: {
            Text("Check")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
        }
        .buttonStyle(.borderedProminent)
        .disabled(!viewModel.canSubmit)
    }
    
    @ViewBuilder
    private func resultFeedbackSection(viewModel: ExerciseViewModel) -> some View {
        VStack(spacing: 24) {
            if let result = viewModel.validationResult {
                VStack(spacing: 12) {
                    Image(systemName: result.isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .font(.system(size: 56))
                        .foregroundStyle(result.isCorrect ? .green : .red)
                    
                    Text(result.isCorrect ? "Correct!" : "Incorrect")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(result.isCorrect ? .green : .red)
                    
                    if !result.isCorrect {
                        VStack(spacing: 8) {
                            Text("Expected:")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            Text(result.expected)
                                .font(mode.isCodeInput ? .body.monospaced() : .body)
                                .fontWeight(.medium)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(.green.opacity(0.1))
                                )
                        }
                    }
                }
                .padding(.vertical, 16)
            }
            
            Button {
                viewModel.proceedToNext()
                if !mode.isCodeInput {
                    isInputFocused = true
                }
            } label: {
                Text("Next")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    @ViewBuilder
    private func sessionCompleteView(viewModel: ExerciseViewModel) -> some View {
        VStack(spacing: 32) {
            Spacer()
            
            VStack(spacing: 16) {
                Image(systemName: "trophy.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.yellow)
                
                Text("Session Complete!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("You've completed all \(viewModel.totalExercises) exercises")
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            VStack(spacing: 12) {
                Button {
                    viewModel.restartSession()
                } label: {
                    Text("Try Again")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
                .buttonStyle(.borderedProminent)
                
                Button {
                    dismiss()
                } label: {
                    Text("Back to Practice")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
                .buttonStyle(.bordered)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
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

#Preview("Sentence to Code") {
    NavigationStack {
        ExerciseView(mode: .sentenceToCode)
    }
}
