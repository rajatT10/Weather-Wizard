import Foundation

enum WeatherCondition: String, Codable, CaseIterable {
    case sunny
    case cloudy
    case rain
    case thunderstorm
    case snow
    case night
    
    var symbolName: String {
        switch self {
        case .sunny: return "sun.max.fill"
        case .cloudy: return "cloud.fill"
        case .rain: return "cloud.rain.fill"
        case .thunderstorm: return "cloud.bolt.rain.fill"
        case .snow: return "cloud.snow.fill"
        case .night: return "moon.stars.fill"
        }
    }
    
    var label: String {
        switch self {
        case .sunny: return "Sunny"
        case .cloudy: return "Cloudy"
        case .rain: return "Rainy"
        case .thunderstorm: return "Thunderstorm"
        case .snow: return "Snowy"
        case .night: return "Clear Night"
        }
    }
}
