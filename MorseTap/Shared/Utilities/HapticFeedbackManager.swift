import UIKit

final class HapticFeedbackManager {
    
    static let shared = HapticFeedbackManager()
    
    var isEnabled: Bool = true
    
    private let impactGenerator = UIImpactFeedbackGenerator(style: .medium)
    private let heavyImpactGenerator = UIImpactFeedbackGenerator(style: .heavy)
    private let notificationGenerator = UINotificationFeedbackGenerator()
    
    private init() {
        impactGenerator.prepare()
        heavyImpactGenerator.prepare()
        notificationGenerator.prepare()
    }
    
    func signalFeedback() {
        guard isEnabled else { return }
        impactGenerator.impactOccurred()
    }
    
    func symbolCompletedFeedback() {
        guard isEnabled else { return }
        heavyImpactGenerator.impactOccurred()
    }
    
    func errorFeedback() {
        guard isEnabled else { return }
        notificationGenerator.notificationOccurred(.error)
    }
    
    func successFeedback() {
        guard isEnabled else { return }
        notificationGenerator.notificationOccurred(.success)
    }
}
