//
//  LoadProductsUseCase.swift
//  Weather
//
//  Created by Александр Милейчик on 3/2/26.
//

import Foundation

protocol LoadWeatherUseCaseProtocol: AnyObject {
    func execute(lat: Double, lon: Double) async throws -> WeatherViewData
    func execute(cityName: String) async throws -> WeatherViewData
}

final class LoadWeatherUseCase: LoadWeatherUseCaseProtocol {
    
    private let repository: WeatherRepositoryProtocol
    
    init(repository: WeatherRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(lat: Double, lon: Double) async throws -> WeatherViewData {
        let response = try await repository.fetchWeather(lat: lat, lon: lon)
        return mapToViewData(response)
    }
    
    func execute(cityName: String) async throws -> WeatherViewData {
        let response = try await repository.fetchWeather(cityName: cityName)
        return mapToViewData(response)
    }
    
    private func mapToViewData(_ response: WeatherResponse) -> WeatherViewData {
        let weather = response.weather.first?.description.lowercased() ?? ""
        let background: WeatherBackground
        if weather.contains("clear") { background = .sunny }
        else if weather.contains("cloud") { background = .cloudy }
        else { background = .rainy }
        
        return WeatherViewData(
            city: response.name,
            temperature: "\(Int(response.main.temp))°C",
            description: response.weather.first?.description.capitalized ?? "",
            iconURL: URL(string: "https://openweathermap.org/img/wn/\(response.weather.first?.icon ?? "01d")@2x.png")!,
            background: background
        )
    }
}
