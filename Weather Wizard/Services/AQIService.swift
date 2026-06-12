import Foundation

struct AQIService {
    func fetchAQI(lat: Double, lon: Double) async throws -> AQIResponse {
        var components = URLComponents(string: "https://air-quality-api.open-meteo.com/v1/air-quality")!
        components.queryItems = [
            URLQueryItem(name: "latitude", value: String(lat)),
            URLQueryItem(name: "longitude", value: String(lon)),
            URLQueryItem(name: "current", value: "us_aqi,pm2_5,pm10")
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
            
            // Decodes using custom CodingKeys mapped in AQIResponse
            let decoder = JSONDecoder()
            return try decoder.decode(AQIResponse.self, from: data)
            
        } catch let error as URLError {
            print("AQI Fetch URLError: \(error.localizedDescription)")
            throw AppError.noNetwork
        } catch {
            print("AQI Fetch Generic Error: \(error.localizedDescription)")
            if let appError = error as? AppError {
                throw appError
            }
            throw AppError.apiUnavailable
        }
    }
}
