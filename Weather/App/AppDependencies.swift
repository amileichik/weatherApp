//
//  AppDependencies.swift
//  Weather
//
//  Created by Александр Милейчик on 3/2/26.
//

import UIKit

protocol AppDependenciesProtocol: AnyObject {
    var container: DependencyContainerProtocol { get }
    var viewModelFactory: ViewModelFactoryProtocol { get }
    var screenFactory: ScreenFactoryProtocol { get }
    
    func makeRootViewController() -> UIViewController
}

final class AppDependencies: AppDependenciesProtocol {
    
    let container: DependencyContainerProtocol
    let viewModelFactory: ViewModelFactoryProtocol
    let screenFactory: ScreenFactoryProtocol
    
    init() {
        let weatherService = NetworkService(session: URLSession.shared)
        let repository = WeatherRepository(service: weatherService)
        let loadWeatherUseCase = LoadWeatherUseCase(repository: repository)
        
        container = DependencyContainer(weatherUseCase: loadWeatherUseCase)
        viewModelFactory = ViewModelFactory(container: container)
        screenFactory = ScreenFactory(container: container)
    }
    
    func makeRootViewController() -> UIViewController {
        let viewModel = viewModelFactory.makeWeatherViewModel()
        return screenFactory.createHomeScreen(viewModel: viewModel)
    }
}
