import SwiftUI

struct WeatherHeaderView: View {
    let data: WeatherData
    
    @State private var appeared = false
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    // Derived mockup metrics to match visual design guidelines
    private var feelsLike: Int { data.temperature - 2 }
    private var highTemp: Int { data.temperature + 3 }
    private var lowTemp: Int { data.temperature - 4 }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Location Header: Left Aligned
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "mappin.and.ellipse")
                    .font(.system(size: 20))
                    .foregroundStyle(.white)
                    .padding(.top, 4)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(data.locationName)
                        .font(.system(size: 28, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                    
                    Text("Local weather")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.6))
                }
            }
            .padding(.leading, 28)
            .padding(.top, 30)
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 15)
            
            Spacer()
            
            // Temperature Details: Centered
            VStack(spacing: 8) {
                Text("\(data.temperature)°")
                    .font(.system(size: 96, weight: .ultraLight, design: .rounded))
                    .foregroundStyle(.white)
                    .accessibilityLabel("Temperature: \(data.temperature) degrees Celsius")
                
                VStack(spacing: 4) {
                    Text("Feels like \(feelsLike)°")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.85))
                    
                    Text("H: \(highTemp)°   L: \(lowTemp)°")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundStyle(.white.opacity(0.7))
                }
            }
            .frame(maxWidth: .infinity)
            .scaleEffect(appeared ? 1.0 : 0.9)
            .opacity(appeared ? 1 : 0)
            
            Spacer()
        }
        .onAppear {
            if reduceMotion {
                appeared = true
            } else {
                withAnimation(.easeOut(duration: 0.6)) {
                    appeared = true
                }
            }
        }
    }
}
