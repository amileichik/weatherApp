//
//  MainViewController.swift
//  Weather
//
//  Created by Александр Милейчик on 3/2/26.
//

import UIKit
import Combine

import CoreLocation

final class MainViewController: UIViewController {
    
    private let tableView: UIView & MainTableViewProtocol
    private let viewModel: WeatherViewModelProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        tableView: UIView & MainTableViewProtocol,
        viewModel: WeatherViewModelProtocol
    ) {
        self.tableView = tableView
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Weather"
        setupUI()
        setupNavigationBar()
        bindViewModel()
        
        Task {
            await viewModel.loadWeather(cityName: "Coral Springs")
            await viewModel.loadWeather(cityName: "Miami")
            await viewModel.loadWeather(cityName: "Tampa")
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self,
                                        action: #selector(addCityTapped))
        navigationItem.rightBarButtonItem = addButton
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    @objc private func addCityTapped() {
        let alert = UIAlertController(title: "Add City", message: "Enter city name", preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "City name" }
        alert.addAction(UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let self = self,
                  let name = alert.textFields?.first?.text,
                  !name.isEmpty else { return }
            Task {
                await self.viewModel.loadWeather(cityName: name)
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    func bindViewModel() {
        viewModel.statePublisher
            .sink { [weak self] state in
                self?.handleState(state)
            }
            .store(in: &cancellables)
        
        viewModel.eventPublisher
            .sink { [weak self] event in
                self?.handleEvent(event)
            }
            .store(in: &cancellables)
    }
    
    func handleState(_ state: ViewModelState) {
        switch state {
        case .initial, .loading:
            break
            
        case .loaded:
            tableView.reload()
            
        case .error(let message):
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    func handleEvent(_ event: ViewModelEvent) {
        switch event {
        case .rowDeleted(let indexPath):
            tableView.deleteRow(at: indexPath)
        }
    }
}
