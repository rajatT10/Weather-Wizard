import SwiftUI

struct ErrorOverlay: View {
    let error: AppError
    let onRetry: () -> Void
    
    @State private var pulse = false
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    private var iconName: String {
        switch error {
        case .locationDenied: return "location.slash.fill"
        case .noNetwork: return "wifi.slash"
        case .apiUnavailable: return "exclamationmark.icloud.fill"
        }
    }
    
    private var title: String {
        switch error {
        case .locationDenied: return "Location Access Needed"
        case .noNetwork: return "No Internet Connection"
        case .apiUnavailable: return "Weather API Unreachable"
        }
    }
    
    var body: some View {
        ZStack {
            // Draw a cloudy backdrop behind the error card
            AnimatedBackgroundView(condition: .cloudy)
            
            VStack {
                Spacer()
                
                GlassCard {
                    VStack(spacing: 20) {
                        Image(systemName: iconName)
                            .font(.system(size: 44))
                            .foregroundStyle(.white)
                            .scaleEffect(pulse ? 1.06 : 0.94)
                            .onAppear {
                                if !reduceMotion {
                                    withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                                        pulse = true
                                    }
                                }
                            }
                        
                        VStack(spacing: 8) {
                            Text(title)
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                            
                            Text(error.localizedDescription)
                                .font(.system(size: 14, design: .rounded))
                                .foregroundStyle(.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                                .lineSpacing(2)
                        }
                        .padding(.horizontal, 8)
                        
                        Button(action: {
                            HapticsManager.shared.triggerLaunch()
                            if error == .locationDenied {
                                if let url = URL(string: UIApplication.openSettingsURLString) {
                                    UIApplication.shared.open(url)
                                }
                            } else {
                                onRetry()
                            }
                        }) {
                            Text(error == .locationDenied ? "Open Settings" : "Try Again")
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                .foregroundStyle(.black)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 28)
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                                .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
                        }
                        .buttonStyle(ScaleButtonStyle())
                    }
                    .padding(.vertical, 8)
                }
                .frame(maxWidth: 320)
                .padding(.horizontal, 24)
                
                Spacer()
            }
        }
        .ignoresSafeArea()
    }
}

// Custom button style for high-end micro-interaction
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}
