import SwiftUI

struct SymbolCardView: View {
    
    let symbol: MorseSymbol
    
    var body: some View {
        VStack(spacing: 32) {
            Text(String(symbol.character))
                .font(.system(size: 120, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)
            
            MorseSignalsView(
                signals: symbol.signals,
                dotSize: 16,
                dashWidth: 48,
                dashHeight: 16,
                spacing: 12
            )
            
            Text(symbol.pattern)
                .font(.title2.monospaced())
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Text("Symbol Card — Coming Soon")
                .font(.subheadline)
                .foregroundStyle(.tertiary)
                .padding(.bottom, 32)
        }
        .padding()
        .navigationTitle(String(symbol.character))
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SymbolCardView(symbol: MorseSymbol(character: "A", pattern: ".-"))
    }
}

#Preview("SOS") {
    NavigationStack {
        SymbolCardView(symbol: MorseSymbol(character: "S", pattern: "..."))
    }
}
