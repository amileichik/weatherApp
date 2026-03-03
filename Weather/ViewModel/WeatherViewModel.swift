//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Александр Милейчик on 3/2/26.
//

import Foundation
import Combine

@MainActor
protocol WeatherListDataSource: AnyObject {
    func numberOfRows() -> Int
    func item(at index: Int) -> WeatherViewData?
}

@MainActor
protocol WeatherViewModelEvents: AnyObject {
    func deleteRow(at index: Int)
}

@MainActor
protocol WeatherViewModelInput {
    func loadWeather(lat: Double, lon: Double) async
    func loadWeather(cityName: String) async
}

@MainActor
protocol WeatherViewModelOutput {
    var statePublisher: AnyPublisher<ViewModelState, Never> { get }
    var eventPublisher: AnyPublisher<ViewModelEvent, Never> { get }
}

typealias WeatherViewModelProtocol = WeatherListDataSource & WeatherViewModelEvents & WeatherViewModelInput & WeatherViewModelOutput

@MainActor
final class WeatherViewModel: WeatherViewModelProtocol {
    
    private(set) var weather: [WeatherViewData] = []
    
    @Published private(set) var state: ViewModelState = .initial
    private let eventSubject = PassthroughSubject<ViewModelEvent, Never>()
    
    var statePublisher: AnyPublisher<ViewModelState, Never> {
        $state.eraseToAnyPublisher()
    }
    
    var eventPublisher: AnyPublisher<ViewModelEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
    
    private var loadProductsTask: Task<Void, Never>? = nil
    
    
    private let useCase: LoadWeatherUseCaseProtocol
    
    init(useCase: LoadWeatherUseCaseProtocol) {
        self.useCase = useCase
    }
    
    deinit {
        loadProductsTask?.cancel()
    }
    
    func loadWeather(lat: Double, lon: Double) async {
        
        loadProductsTask?.cancel()
        
        state = .loading
        do {
            let viewData = try await useCase.execute(lat: lat, lon: lon)
            self.weather.append(viewData)
            state = .loaded
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    func loadWeather(cityName: String) async {
        loadProductsTask?.cancel()
        
        state = .loading
        do {
            let viewData = try await useCase.execute(cityName: cityName)
            weather.append(viewData)
            state = .loaded
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}

extension WeatherViewModel {
    
    func deleteRow(at index: Int) {
        guard weather.indices.contains(index) else { return }
        weather.remove(at: index)
        eventSubject.send(.rowDeleted(IndexPath(row: index, section: 0)))
    }
}

extension WeatherViewModel {
    
    func numberOfRows() -> Int {
        weather.count
    }
    
    func item(at index: Int) -> WeatherViewData? {
        weather.indices.contains(index) ? weather[index] : nil
    }
}
