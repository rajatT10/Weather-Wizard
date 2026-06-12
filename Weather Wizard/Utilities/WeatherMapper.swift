import Foundation

struct WeatherMapper {
    static func condition(from code: Int, isDay: Bool) -> WeatherCondition {
        switch code {
        case 0, 1:       
            return isDay ? .sunny : .night
        case 2, 3:       
            return .cloudy
        case 45, 48:
            return .cloudy // Fog maps to cloudy
        case 51...67:    
            return .rain
        case 71...77, 85, 86:    
            return .snow
        case 80...82:    
            return .rain
        case 95, 96, 99: 
            return .thunderstorm
        default:         
            return isDay ? .sunny : .night
        }
    }
}
