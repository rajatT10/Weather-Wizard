import Foundation

enum AppState: Equatable {
    case loading
    case loaded(WeatherData)
    case error(AppError)
}
