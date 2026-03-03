//
//  File.swift
//  Weather
//
//  Created by Александр Милейчик on 3/2/26.
//

import UIKit

protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

protocol NetworkServiceProtocol: AnyObject {
    func fetchWeather(lat: Double, lon: Double) async throws -> WeatherResponse
    func fetchWeather(cityName: String) async throws -> WeatherResponse
}

extension URLSession: URLSessionProtocol {}

final class NetworkService: NetworkServiceProtocol {
    
    private let apiKey = "905b24b283a4f10b7dd62dd00e3c8692"
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    func fetchWeather(lat: Double, lon: Double) async throws -> WeatherResponse {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else { throw NetworkError.invalidURL }
        let (data, response) = try await session.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.badResponse((response as? HTTPURLResponse)?.statusCode ?? -1)
        }
        return try JSONDecoder().decode(WeatherResponse.self, from: data)
    }
    
    func fetchWeather(cityName: String) async throws -> WeatherResponse {
        let encodedName = cityName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? cityName
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(encodedName)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else { throw NetworkError.invalidURL }
        let (data, response) = try await session.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.badResponse((response as? HTTPURLResponse)?.statusCode ?? -1)
        }
        return try JSONDecoder().decode(WeatherResponse.self, from: data)
    }
}





