//
//  DependencyContainer.swift
//  Weather
//
//  Created by Александр Милейчик on 3/2/26.
//

import Foundation

protocol HasNetworkService {
    var weatherUseCase: LoadWeatherUseCaseProtocol { get }
}

typealias DependencyContainerProtocol = HasNetworkService

final class DependencyContainer: DependencyContainerProtocol {
    
    let weatherUseCase: LoadWeatherUseCaseProtocol
    
    init(weatherUseCase: LoadWeatherUseCaseProtocol) {
        self.weatherUseCase = weatherUseCase
    }
}

