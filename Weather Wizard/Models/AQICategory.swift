import SwiftUI

enum AQICategory: String, Codable {
    case good
    case moderate
    case sensitiveGroups
    case unhealthy
    case veryUnhealthy
    
    var label: String {
        switch self {
        case .good: return "Good"
        case .moderate: return "Moderate"
        case .sensitiveGroups: return "Unhealthy for Sensitive Groups"
        case .unhealthy: return "Unhealthy"
        case .veryUnhealthy: return "Very Unhealthy"
        }
    }
    
    var shortLabel: String {
        switch self {
        case .good: return "Good"
        case .moderate: return "Moderate"
        case .sensitiveGroups: return "Sensitive"
        case .unhealthy: return "Unhealthy"
        case .veryUnhealthy: return "Very Unhealthy"
        }
    }
    
    var color: Color {
        switch self {
        case .good:
            return Color(red: 0.18, green: 0.80, blue: 0.44) // Emerald green
        case .moderate:
            return Color(red: 0.95, green: 0.77, blue: 0.06) // Warm yellow
        case .sensitiveGroups:
            return Color(red: 0.90, green: 0.49, blue: 0.13) // Orange
        case .unhealthy:
            return Color(red: 0.91, green: 0.30, blue: 0.24) // Soft red
        case .veryUnhealthy:
            return Color(red: 0.61, green: 0.35, blue: 0.71) // Purple
        }
    }
    
    static func category(for aqi: Int) -> AQICategory {
        switch aqi {
        case 0...50: return .good
        case 51...100: return .moderate
        case 101...150: return .sensitiveGroups
        case 151...200: return .unhealthy
        default: return .veryUnhealthy
        }
    }
}
