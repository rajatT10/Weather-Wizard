import Foundation
import CoreLocation
import Combine

protocol LocationServiceProtocol: AnyObject {
    var currentLocation: CLLocation? { get }
    var authStatus: CLAuthorizationStatus { get }
    var locationName: String { get }
    func requestLocation()
}

@MainActor
final class LocationService: NSObject, ObservableObject, LocationServiceProtocol, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    @Published private(set) var currentLocation: CLLocation?
    @Published private(set) var authStatus: CLAuthorizationStatus = .notDetermined
    @Published private(set) var locationName: String = ""
    
    override init() {
        super.init()
        manager.delegate = self
        self.authStatus = manager.authorizationStatus
    }
    
    func requestLocation() {
        let status = manager.authorizationStatus
        self.authStatus = status
        if status == .notDetermined {
            manager.requestWhenInUseAuthorization()
        } else if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.requestLocation()
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        self.authStatus = status
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.currentLocation = location
        
        // Reverse geocoding to find city/locality
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self else { return }
            Task { @MainActor in
                if let placemark = placemarks?.first {
                    let city = placemark.locality ?? placemark.administrativeArea ?? placemark.country ?? "Unknown Location"
                    self.locationName = city
                } else {
                    self.locationName = "Current Location"
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Log error and handle silently
        print("Location manager failure: \(error.localizedDescription)")
    }
}
