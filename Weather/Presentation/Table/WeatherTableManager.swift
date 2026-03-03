//
//  ProductTableManager.swift
//  Weather
//
//  Created by Александр Милейчик on 3/2/26.
//

import UIKit

final class WeatherTableManager: NSObject, UITableViewDelegate {
    
    func registerCells(for tableView: UITableView) {
        tableView.register(WeatherCell.self, forCellReuseIdentifier: "WeatherCell")
    }
}
