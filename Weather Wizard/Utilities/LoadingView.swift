import SwiftUI

struct ShimmerView: View {
    @State private var startPoint = UnitPoint(x: -1.8, y: -0.6)
    @State private var endPoint = UnitPoint(x: 0.0, y: -0.2)
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    var body: some View {
        if reduceMotion {
            Color.white.opacity(0.15)
        } else {
            LinearGradient(
                colors: [
                    .white.opacity(0.10),
                    .white.opacity(0.24),
                    .white.opacity(0.10)
                ],
                startPoint: startPoint,
                endPoint: endPoint
            )
            .onAppear {
                withAnimation(.linear(duration: 1.6).repeatForever(autoreverses: false)) {
                    startPoint = UnitPoint(x: 1.2, y: 1.2)
                    endPoint = UnitPoint(x: 3.0, y: 1.8)
                }
            }
        }
    }
}

struct LoadingView: View {
    var body: some View {
        ZStack {
            // Draw active particles in the background of the loading state
            AnimatedBackgroundView(condition: .sunny)
            
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    // Header section mimicking WeatherHeaderView
                    VStack(alignment: .leading, spacing: 10) {
                        // Location name placeholder
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.clear)
                            .frame(width: 180, height: 32)
                            .overlay(ShimmerView().clipShape(RoundedRectangle(cornerRadius: 8)))
                            .padding(.leading, 28)
                            .padding(.top, geometry.safeAreaInsets.top + 20)
                        
                        Spacer()
                        
                        // Temperature placeholder
                        HStack {
                            Spacer()
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.clear)
                                .frame(width: 140, height: 76)
                                .overlay(ShimmerView().clipShape(RoundedRectangle(cornerRadius: 16)))
                            Spacer()
                        }
                        
                        Spacer()
                    }
                    .frame(maxHeight: .infinity)
                    
                    // Card section mimicking WeatherCardsView
                    HStack(spacing: 12) {
                        ForEach(0..<3) { _ in
                            GlassCard {
                                VStack(spacing: 12) {
                                    // Title placeholder
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.clear)
                                        .frame(width: 50, height: 12)
                                        .overlay(ShimmerView().clipShape(RoundedRectangle(cornerRadius: 4)))
                                    
                                    // Gauge placeholder
                                    Circle()
                                        .stroke(.white.opacity(0.10), lineWidth: 4.5)
                                        .frame(width: 76, height: 76)
                                        .overlay(
                                            Circle()
                                                .trim(from: 0, to: 0.25)
                                                .stroke(.white.opacity(0.15), lineWidth: 4.5)
                                                .rotationEffect(.degrees(-90))
                                        )
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, geometry.safeAreaInsets.bottom + 12)
                    .frame(height: geometry.size.height * 0.25)
                }
            }
        }
        .ignoresSafeArea()
    }
}
