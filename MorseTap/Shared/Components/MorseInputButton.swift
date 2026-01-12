import SwiftUI

struct MorseInputButton: View {
    
    let onPressDown: () -> Void
    let onPressUp: () -> Void
    
    @State private var isPressed = false
    
    private let buttonSize: CGFloat = 200
    
    var body: some View {
        Circle()
            .fill(buttonGradient)
            .frame(width: buttonSize, height: buttonSize)
            .overlay(
                Circle()
                    .stroke(strokeColor, lineWidth: 4)
            )
            .scaleEffect(isPressed ? 0.92 : 1.0)
            .shadow(
                color: shadowColor,
                radius: isPressed ? 4 : 12,
                y: isPressed ? 2 : 6
            )
            .animation(.easeOut(duration: 0.1), value: isPressed)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        if !isPressed {
                            isPressed = true
                            onPressDown()
                        }
                    }
                    .onEnded { _ in
                        isPressed = false
                        onPressUp()
                    }
            )
    }
    
    private var buttonGradient: LinearGradient {
        LinearGradient(
            colors: isPressed ? pressedColors : defaultColors,
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    private var defaultColors: [Color] {
        [Color(red: 0.4, green: 0.6, blue: 1.0), Color(red: 0.2, green: 0.4, blue: 0.9)]
    }
    
    private var pressedColors: [Color] {
        [Color(red: 0.3, green: 0.5, blue: 0.9), Color(red: 0.15, green: 0.3, blue: 0.8)]
    }
    
    private var strokeColor: Color {
        isPressed ? Color.white.opacity(0.3) : Color.white.opacity(0.5)
    }
    
    private var shadowColor: Color {
        Color(red: 0.1, green: 0.2, blue: 0.5).opacity(0.4)
    }
}

#Preview {
    MorseInputButton(
        onPressDown: { print("Press down") },
        onPressUp: { print("Press up") }
    )
    .padding()
}
