//
//  WeatherTests.swift
//  WeatherTests
//
//  Created by Александр Милейчик on 3/3/26.
//

import XCTest
@testable import Weather

final class LoadWeatherUseCaseTests: XCTestCase {
    
    final class MockRepository: WeatherRepositoryProtocol {
        var responseToReturn: WeatherResponse!
        
        func fetchWeather(lat: Double, lon: Double) async throws -> WeatherResponse {
            return responseToReturn
        }
        
        func fetchWeather(cityName: String) async throws -> WeatherResponse {
            return responseToReturn
        }
    }
    
    func testLoadWeatherMapsToViewData() async throws {
        
        let mockWeather = Weather(
            description: "Clear sky",
            icon: "01d"
        )
        let mockResponse = WeatherResponse(
            name: "Miami",
            main: Main(temp: 30, humidity: 50),
            weather: [mockWeather]
        )
        
        let mockRepo = MockRepository()
        mockRepo.responseToReturn = mockResponse
        
        let useCase = LoadWeatherUseCase(repository: mockRepo)
        
        let viewData = try await useCase.execute(cityName: "Miami")
        
        XCTAssertEqual(viewData.city, "Miami")
        XCTAssertEqual(viewData.temperature, "30°C")
        XCTAssertEqual(viewData.description, "Clear Sky")
        XCTAssertEqual(viewData.background, .sunny)
        XCTAssertEqual(viewData.iconURL.absoluteString, "https://openweathermap.org/img/wn/01d@2x.png")
    }
}
