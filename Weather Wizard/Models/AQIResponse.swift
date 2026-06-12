import Foundation

struct AQIResponse: Codable {
    struct Current: Codable {
        let usAqi: Int
        let pm25: Double
        let pm10: Double
        
        enum CodingKeys: String, CodingKey {
            case usAqi = "us_aqi"
            case pm25 = "pm2_5"
            case pm10 = "pm10"
        }
    }
    
    let current: Current
}
