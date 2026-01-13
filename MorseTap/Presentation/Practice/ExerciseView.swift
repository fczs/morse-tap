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
            
            TextField(
                mode.isCodeInput ? "Enter Morse code..." : "Enter text...",
                text: Binding(
                    get: { viewModel.userAnswer },
                    set: { viewModel.userAnswer = $0 }
                )
            )
            .font(mode.isCodeInput ? .body.monospaced() : .body)
            .textFieldStyle(.roundedBorder)
            .textInputAutocapitalization(mode.isCodeInput ? .never : .characters)
            .autocorrectionDisabled()
            .disabled(viewModel.isShowingResult)
            .focused($isInputFocused)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isInputFocused = true
                }
            }
        }
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
                                .font(mode.isCodeInput ? .body : .body.monospaced())
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
                isInputFocused = true
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

#Preview("Session Complete") {
    NavigationStack {
        ExerciseView(mode: .codeToWord)
    }
}
