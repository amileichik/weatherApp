//
//  ProductTableAdapter.swift
//  Weather
//
//  Created by Александр Милейчик on 3/2/26.
//

import UIKit

final class WeatherTableAdapter: NSObject, UITableViewDataSource {
    
    private let dataSource: WeatherListDataSource
    private let eventHandler: WeatherViewModelEvents
    
    init(
        dataSource: WeatherListDataSource,
        eventHandler: WeatherViewModelEvents
    ) {
        self.dataSource = dataSource
        self.eventHandler = eventHandler
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as? WeatherCell else { return UITableViewCell() }
        
        guard let data = dataSource.item(at: indexPath.row) else {
            return UITableViewCell()
        }
        cell.configure(with: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            eventHandler.deleteRow(at: indexPath.row)
        }
    }
}
