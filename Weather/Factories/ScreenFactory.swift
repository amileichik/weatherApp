//
//  ScreenFactory.swift
//  Weather
//
//  Created by Александр Милейчик on 3/2/26.
//

import UIKit

protocol ScreenFactoryProtocol: AnyObject {
    func createHomeScreen(viewModel: WeatherViewModelProtocol) -> UIViewController
}

final class ScreenFactory: ScreenFactoryProtocol {
    
    private let container: DependencyContainerProtocol
    
    init(container: DependencyContainerProtocol) {
        self.container = container
    }
    
    func createHomeScreen(viewModel: WeatherViewModelProtocol) -> UIViewController {
        let adapter = WeatherTableAdapter(dataSource: viewModel, eventHandler: viewModel)
        let manager = WeatherTableManager()
        let mainTableView = MainTableView(adapter: adapter, manager: manager)
        return MainViewController(tableView: mainTableView, viewModel: viewModel)
    }
}
