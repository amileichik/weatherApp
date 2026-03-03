//
//  ViewModelFactory.swift
//  Weather
//
//  Created by Александр Милейчик on 3/2/26.
//

import Foundation

protocol ViewModelFactoryProtocol: AnyObject {
    func makeWeatherViewModel() -> WeatherViewModelProtocol
}

final class ViewModelFactory: ViewModelFactoryProtocol {
    
    private let container: DependencyContainerProtocol
    
    init(container: DependencyContainerProtocol) {
        self.container = container
    }
    
    @MainActor
    func makeWeatherViewModel() -> WeatherViewModelProtocol {
        let useCase = container.weatherUseCase
        return WeatherViewModel(useCase: useCase)
    }
}
