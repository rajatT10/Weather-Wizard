import Foundation

struct WeatherResponse: Codable {
    struct Current: Codable {
        let temperature2m: Double
        let weathercode: Int
        let precipitationProbability: Int
        let windspeed10m: Double
        let isDay: Int
        
        enum CodingKeys: String, CodingKey {
            case temperature2m = "temperature_2m"
            case weathercode = "weathercode"
            case precipitationProbability = "precipitation_probability"
            case windspeed10m = "windspeed_10m"
            case isDay = "is_day"
        }
    }
    
    let current: Current
}
