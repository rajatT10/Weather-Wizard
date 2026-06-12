import Foundation

struct WeatherService {
    func fetchWeather(lat: Double, lon: Double) async throws -> WeatherResponse {
        var components = URLComponents(string: "https://api.open-meteo.com/v1/forecast")!
        components.queryItems = [
            URLQueryItem(name: "latitude", value: String(lat)),
            URLQueryItem(name: "longitude", value: String(lon)),
            URLQueryItem(name: "current", value: "temperature_2m,weathercode,precipitation_probability,windspeed_10m,is_day"),
            URLQueryItem(name: "timezone", value: "auto")
        ]
        
        guard let url = components.url else {
            throw AppError.apiUnavailable
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw AppError.apiUnavailable
            }
            
            guard httpResponse.statusCode == 200 else {
                throw AppError.apiUnavailable
            }
            
            let decoder = JSONDecoder()
            return try decoder.decode(WeatherResponse.self, from: data)
            
        } catch let error as URLError {
            print("Weather Fetch URLError: \(error.localizedDescription)")
            throw AppError.noNetwork
        } catch {
            print("Weather Fetch Generic Error: \(error.localizedDescription)")
            if let appError = error as? AppError {
                throw appError
            }
            throw AppError.apiUnavailable
        }
    }
}
