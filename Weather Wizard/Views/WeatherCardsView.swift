import SwiftUI

struct WeatherCardsView: View {
    let data: WeatherData
    
    @State private var appeared = false
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let useScale = width < 380
            
            HStack(spacing: useScale ? 8 : 12) {
                PrecipitationCard(probability: data.precipitationProbability)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 20)
                    .animation(reduceMotion ? nil : .spring(response: 0.6, dampingFraction: 0.8).delay(0.05), value: appeared)
                
                AQICard(aqi: data.aqi, category: data.aqiCategory)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 20)
                    .animation(reduceMotion ? nil : .spring(response: 0.6, dampingFraction: 0.8).delay(0.15), value: appeared)
                
                ConditionCard(condition: data.condition)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 20)
                    .animation(reduceMotion ? nil : .spring(response: 0.6, dampingFraction: 0.8).delay(0.25), value: appeared)
            }
            .scaleEffect(useScale ? 0.88 : 1.0)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
        .onAppear {
            appeared = true
        }
    }
}
