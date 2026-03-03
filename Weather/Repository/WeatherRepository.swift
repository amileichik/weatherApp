//
//  ProductRepository.swift
//  Weather
//
//  Created by Александр Милейчик on 3/2/26.
//

import Foundation

protocol WeatherRepositoryProtocol: AnyObject {
    func fetchWeather(lat: Double, lon: Double) async throws -> WeatherResponse
    func fetchWeather(cityName: String) async throws -> WeatherResponse
}

final class WeatherRepository: WeatherRepositoryProtocol {
    let service: NetworkServiceProtocol
    
    init(service: NetworkServiceProtocol) {
        self.service = service
    }
    
    func fetchWeather(lat: Double, lon: Double) async throws -> WeatherResponse {
        try await service.fetchWeather(lat: lat, lon: lon)
    }
    
    func fetchWeather(cityName: String) async throws -> WeatherResponse {
        try await service.fetchWeather(cityName: cityName)
    }
}
