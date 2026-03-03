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
    
    private let apiKey: String
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
        
        guard
            let path = Bundle.main.path(forResource: "config", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path),
            let key = dict["OPENWEATHER_API_KEY"] as? String,
            !key.isEmpty
        else {
            fatalError("API Key not found in config.plist or is empty")
        }
        
        self.apiKey = key
    }
    
    func fetchWeather(lat: Double, lon: Double) async throws -> WeatherResponse {
        var components = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather")!
        components.queryItems = [
            URLQueryItem(name: "lat", value: "\(lat)"),
            URLQueryItem(name: "lon", value: "\(lon)"),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric")
        ]
        guard let url = components.url else { throw NetworkError.invalidURL }
        print("Request URL: \(url)") // debug
        
        let (data, response) = try await session.data(from: url)
        try validate(response: response)
        return try JSONDecoder().decode(WeatherResponse.self, from: data)
    }
    
    func fetchWeather(cityName: String) async throws -> WeatherResponse {
        var components = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather")!
        components.queryItems = [
            URLQueryItem(name: "q", value: cityName),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric")
        ]
        guard let url = components.url else { throw NetworkError.invalidURL }
        
        let (data, response) = try await session.data(from: url)
        try validate(response: response)
        return try JSONDecoder().decode(WeatherResponse.self, from: data)
    }
    
    // MARK: - Private
    
    private func validate(response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.badResponse(-1)
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            print("HTTP Error: \(httpResponse.statusCode)")
            throw NetworkError.badResponse(httpResponse.statusCode)
        }
    }
}
