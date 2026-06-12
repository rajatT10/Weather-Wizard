import SwiftUI

struct AQICard: View {
    let aqi: Int
    let category: AQICategory
    
    @State private var fraction: Double = 0.0
    @Environment(\.colorSchemeContrast) var colorSchemeContrast
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    var body: some View {
        GlassCard {
            VStack(spacing: 12) {
                Text("AQI")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundStyle(.white.opacity(0.5))
                    .tracking(1.5)
                
                ZStack {
                    Circle()
                        .stroke(.white.opacity(0.12), lineWidth: 4.5)
                    
                    Circle()
                        .trim(from: 0.0, to: fraction)
                        .stroke(
                            category.color,
                            style: StrokeStyle(lineWidth: colorSchemeContrast == .increased ? 5.5 : 4.5, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                    
                    VStack(spacing: 0) {
                        Text("\(aqi)")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                        
                        Text(category.shortLabel)
                            .font(.system(size: 9, weight: .bold, design: .rounded))
                            .foregroundStyle(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .lineLimit(1)
                    }
                    .padding(6)
                }
                .frame(width: 76, height: 76)
            }
        }
        .onAppear {
            let targetFraction = min(Double(aqi) / 250.0, 1.0)
            if reduceMotion {
                fraction = targetFraction
            } else {
                withAnimation(.spring(response: 1.2, dampingFraction: 0.75)) {
                    fraction = targetFraction
                }
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Air quality index: \(aqi), \(category.label)")
    }
}
