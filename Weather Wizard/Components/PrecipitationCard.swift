import SwiftUI

struct PrecipitationCard: View {
    let probability: Int
    
    @State private var fraction: Double = 0.0
    @Environment(\.colorSchemeContrast) var colorSchemeContrast
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    private var levelLabel: String {
        switch probability {
        case 0..<20: return "None"
        case 20..<50: return "Low"
        case 50..<80: return "Moderate"
        default: return "High"
        }
    }
    
    var body: some View {
        GlassCard {
            VStack(spacing: 12) {
                Text("PRECIPITATION")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundStyle(.white.opacity(0.5))
                    .tracking(1.0)
                    .lineLimit(1)
                
                ZStack {
                    Circle()
                        .stroke(.white.opacity(0.12), lineWidth: 4.5)
                    
                    Circle()
                        .trim(from: 0.0, to: fraction)
                        .stroke(
                            Color(red: 0.25, green: 0.60, blue: 1.0), // Clean Rain Blue
                            style: StrokeStyle(lineWidth: colorSchemeContrast == .increased ? 5.5 : 4.5, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                    
                    VStack(spacing: 0) {
                        Image(systemName: "drop.fill")
                            .font(.system(size: 13))
                            .foregroundStyle(Color(red: 0.35, green: 0.68, blue: 1.0))
                            .padding(.bottom, 2)
                        
                        Text("\(probability)%")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                        
                        Text(levelLabel)
                            .font(.system(size: 9, weight: .bold, design: .rounded))
                            .foregroundStyle(.white.opacity(0.7))
                    }
                    .padding(6)
                }
                .frame(width: 76, height: 76)
            }
        }
        .onAppear {
            let targetFraction = Double(probability) / 100.0
            if reduceMotion {
                fraction = targetFraction
            } else {
                withAnimation(.spring(response: 1.2, dampingFraction: 0.75)) {
                    fraction = targetFraction
                }
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Precipitation probability: \(probability) percent, \(levelLabel)")
    }
}
