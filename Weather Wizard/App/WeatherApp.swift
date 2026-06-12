import SwiftUI

@main
struct WeatherApp: App {
    init() {
        // Trigger soft haptic feedback on launch
        HapticsManager.shared.triggerLaunch()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
