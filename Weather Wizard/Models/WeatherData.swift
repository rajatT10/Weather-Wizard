import Foundation

struct WeatherData: Equatable {
    let temperature: Int
    let condition: WeatherCondition
    let precipitationProbability: Int
    let aqi: Int
    let aqiCategory: AQICategory
    let locationName: String
}
