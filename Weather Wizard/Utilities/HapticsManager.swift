import UIKit

final class HapticsManager {
    static let shared = HapticsManager()
    
    private let lightGenerator = UIImpactFeedbackGenerator(style: .light)
    private let mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
    private let successGenerator = UINotificationFeedbackGenerator()
    
    private init() {}
    
    func triggerLaunch() {
        lightGenerator.prepare()
        lightGenerator.impactOccurred()
    }
    
    func triggerLocation() {
        lightGenerator.prepare()
        lightGenerator.impactOccurred()
    }
    
    func triggerRefresh() {
        mediumGenerator.prepare()
        mediumGenerator.impactOccurred()
    }
    
    func triggerSuccess() {
        successGenerator.prepare()
        successGenerator.notificationOccurred(.success)
    }
}
