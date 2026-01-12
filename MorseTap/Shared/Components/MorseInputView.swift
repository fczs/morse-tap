import SwiftUI

struct MorseInputView: View {
    
    var onSignalAdded: ((MorseSignal) -> Void)?
    var onSymbolCompleted: (([MorseSignal]) -> Void)?
    
    @State private var engine = MorseInputEngine()
    @State private var previousSignalsCount = 0
    
    var body: some View {
        VStack(spacing: 40) {
            MorseSignalsView(signals: engine.currentSignals)
                .frame(height: 44)
            
            MorseInputButton(
                onPressDown: handlePressDown,
                onPressUp: handlePressUp
            )
            
            if !engine.currentSignals.isEmpty {
                Button(action: deleteLastSignal) {
                    Label("Delete", systemImage: "delete.left")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .onChange(of: engine.currentSignals.count) { oldValue, newValue in
            if newValue > oldValue, let lastSignal = engine.currentSignals.last {
                HapticFeedbackManager.shared.signalFeedback()
                onSignalAdded?(lastSignal)
            }
            previousSignalsCount = newValue
        }
        .onAppear {
            engine.onSymbolCompleted = { signals in
                HapticFeedbackManager.shared.symbolCompletedFeedback()
                onSymbolCompleted?(signals)
            }
        }
    }
    
    private func handlePressDown() {
        engine.pressDown(at: Date())
    }
    
    private func handlePressUp() {
        engine.pressUp(at: Date())
    }
    
    private func deleteLastSignal() {
        engine.deleteLastSignal()
    }
}

#Preview {
    MorseInputView(
        onSignalAdded: { signal in
            print("Signal added: \(signal)")
        },
        onSymbolCompleted: { signals in
            print("Symbol completed: \(signals)")
        }
    )
    .padding()
}
