import SwiftUI

struct SymbolRowView: View {
    
    let item: SymbolListItem
    
    var body: some View {
        HStack(spacing: 16) {
            Text(String(item.symbol.character))
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .frame(width: 50, alignment: .center)
                .foregroundStyle(.primary)
            
            MorseSignalsView(
                signals: item.symbol.signals,
                dotSize: 10,
                dashWidth: 28,
                dashHeight: 10,
                spacing: 6
            )
            .frame(maxWidth: .infinity, alignment: .leading)
            
            ProgressRingView(progress: item.accuracy)
                .frame(width: 44, height: 44)
        }
        .padding(.vertical, 8)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(item.symbol.character), \(item.symbol.pattern), \(Int(item.accuracy * 100))% mastered")
    }
}

struct ProgressRingView: View {
    
    let progress: Double
    
    private let lineWidth: CGFloat = 4
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: lineWidth)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(progressColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeOut(duration: 0.3), value: progress)
            
            Text("\(Int(progress * 100))")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.secondary)
        }
    }
    
    private var progressColor: Color {
        switch progress {
        case 0..<0.3:
            return .red
        case 0.3..<0.7:
            return .orange
        case 0.7...1.0:
            return .green
        default:
            return .gray
        }
    }
}

#Preview("No Progress") {
    SymbolRowView(item: SymbolListItem(
        symbol: MorseSymbol(character: "A", pattern: ".-"),
        accuracy: 0,
        totalAttempts: 0
    ))
    .padding()
}

#Preview("Partial Progress") {
    SymbolRowView(item: SymbolListItem(
        symbol: MorseSymbol(character: "S", pattern: "..."),
        accuracy: 0.65,
        totalAttempts: 20
    ))
    .padding()
}

#Preview("High Progress") {
    SymbolRowView(item: SymbolListItem(
        symbol: MorseSymbol(character: "O", pattern: "---"),
        accuracy: 0.92,
        totalAttempts: 50
    ))
    .padding()
}
