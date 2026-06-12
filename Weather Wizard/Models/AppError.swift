import Foundation

enum AppError: Error, LocalizedError, Equatable {
    case locationDenied
    case noNetwork
    case apiUnavailable
    
    var errorDescription: String? {
        switch self {
        case .locationDenied:
            return "Location access is required to display weather details for your current position. Please enable location permissions in Settings."
        case .noNetwork:
            return "Unable to connect to the internet. Please check your network connection and try again."
        case .apiUnavailable:
            return "Weather services are currently unreachable. Please try again later."
        }
    }
}
