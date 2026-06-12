import SwiftUI

struct ConditionCard: View {
    let condition: WeatherCondition
    
    @State private var isAnimating = false
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    var body: some View {
        GlassCard {
            VStack(spacing: 12) {
                Text("CONDITION")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundStyle(.white.opacity(0.5))
                    .tracking(1.0)
                    .lineLimit(1)
                
                ZStack {
                    Circle()
                        .stroke(.white.opacity(0.06), lineWidth: 4.5)
                    
                    VStack(spacing: 4) {
                        Image(systemName: condition.symbolName)
                            .font(.system(size: 26))
                            .symbolRenderingMode(.multicolor)
                            .symbolEffect(.bounce, value: isAnimating)
                            .symbolEffect(.variableColor.iterative, options: .repeating, isActive: !reduceMotion && isAnimating)
                            .foregroundStyle(.white)
                        
                        VStack(spacing: 0) {
                            Text(condition.label)
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                                .lineLimit(1)
                            
                            Text("Current")
                                .font(.system(size: 8, weight: .bold, design: .rounded))
                                .foregroundStyle(.white.opacity(0.5))
                        }
                    }
                    .padding(4)
                }
                .frame(width: 76, height: 76)
            }
        }
        .onAppear {
            isAnimating = true
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Condition: \(condition.label)")
    }
}
