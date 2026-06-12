import Foundation
import Combine
import CoreLocation

@MainActor
final class WeatherViewModel: ObservableObject {
    @Published var state: AppState = .loading
    
    private let weatherService = WeatherService()
    private let aqiService = AQIService()
    private let locationService = LocationService()
    
    private var cancellables = Set<AnyCancellable>()
    private var lastFetchedLocation: CLLocation?
    
    init() {
        setupSubscriptions()
        locationService.requestLocation()
    }
    
    private func setupSubscriptions() {
        // Monitor authorization status and update view state on denials
        locationService.$authStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                guard let self = self else { return }
                if status == .denied || status == .restricted {
                    self.state = .error(.locationDenied)
                }
            }
            .store(in: &cancellables)
            
        // Trigger weather loading on location change
        locationService.$currentLocation
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location in
                guard let self = self else { return }
                // Limit API reloading frequency if location change is less than 1km
                if self.lastFetchedLocation == nil || self.lastFetchedLocation!.distance(from: location) > 1000 {
                    self.lastFetchedLocation = location
                    Task {
                        await self.loadWeather(location: location)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func refresh() async {
        if let location = lastFetchedLocation {
            HapticsManager.shared.triggerRefresh()
            await loadWeather(location: location)
        } else {
            locationService.requestLocation()
        }
    }
    
    private func loadWeather(location: CLLocation) async {
        state = .loading
        
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        
        do {
            async let weatherFetch = weatherService.fetchWeather(lat: lat, lon: lon)
            async let aqiFetch = aqiService.fetchAQI(lat: lat, lon: lon)
            
            let (weather, aqi) = try await (weatherFetch, aqiFetch)
            
            // Await geocoded location name up to 1 second
            var name = locationService.locationName
            if name.isEmpty {
                for _ in 0..<10 {
                    try? await Task.sleep(nanoseconds: 100_000_000) // 100ms
                    name = locationService.locationName
                    if !name.isEmpty { break }
                }
            }
            if name.isEmpty {
                name = "Current Location"
            }
            
            let condition = WeatherMapper.condition(
                from: weather.current.weathercode,
                isDay: weather.current.isDay == 1
            )
            let roundedTemp = Int(round(weather.current.temperature2m))
            let aqiCategory = AQICategory.category(for: aqi.current.usAqi)
            
            let weatherData = WeatherData(
                temperature: roundedTemp,
                condition: condition,
                precipitationProbability: weather.current.precipitationProbability,
                aqi: aqi.current.usAqi,
                aqiCategory: aqiCategory,
                locationName: name
            )
            
            self.state = .loaded(weatherData)
            HapticsManager.shared.triggerSuccess()
            
        } catch let appError as AppError {
            self.state = .error(appError)
        } catch {
            self.state = .error(.apiUnavailable)
        }
    }
}
