//
//  MainTableView.swift
//  Weather
//
//  Created by Александр Милейчик on 3/2/26.
//

import UIKit

protocol MainTableViewProtocol: AnyObject {
    func reload()
    func deleteRow(at indexPath: IndexPath)
}

final class MainTableView: UIView, MainTableViewProtocol {
    
    private(set) var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let adapter: WeatherTableAdapter
    private let manager: WeatherTableManager
    
    init(
        adapter: WeatherTableAdapter,
        manager: WeatherTableManager
    ) {
        self.adapter = adapter
        self.manager = manager
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
        configureTableView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func configureTableView() {
        tableView.dataSource = adapter
        tableView.delegate = manager
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        manager.registerCells(for: tableView)
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    func deleteRow(at indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
}
