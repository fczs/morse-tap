import SwiftUI

struct MorseSignalsView: View {
    
    let signals: [MorseSignal]
    
    var dotSize: CGFloat = 12
    var dashWidth: CGFloat = 36
    var dashHeight: CGFloat = 12
    var spacing: CGFloat = 8
    
    var body: some View {
        HStack(spacing: spacing) {
            if signals.isEmpty {
                Text("—")
                    .font(.title2)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(Array(signals.enumerated()), id: \.offset) { index, signal in
                    signalView(for: signal)
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .frame(minHeight: dashHeight + 8)
        .animation(.spring(duration: 0.2), value: signals.count)
    }
    
    @ViewBuilder
    private func signalView(for signal: MorseSignal) -> some View {
        switch signal {
        case .dot:
            Circle()
                .fill(signalColor)
                .frame(width: dotSize, height: dotSize)
        case .dash:
            Capsule()
                .fill(signalColor)
                .frame(width: dashWidth, height: dashHeight)
        }
    }
    
    private var signalColor: Color {
        Color(red: 0.2, green: 0.4, blue: 0.9)
    }
}

#Preview("Empty") {
    MorseSignalsView(signals: [])
        .padding()
}

#Preview("SOS Pattern") {
    MorseSignalsView(signals: [.dot, .dot, .dot, .dash, .dash, .dash, .dot, .dot, .dot])
        .padding()
}

#Preview("Mixed Signals") {
    MorseSignalsView(signals: [.dot, .dash, .dot])
        .padding()
}
