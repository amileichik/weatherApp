//
//  File.swift
//  Weather
//
//  Created by Александр Милейчик on 3/2/26.
//

import UIKit

final class WeatherCell: UITableViewCell {
    
    private let cityLabel = UILabel()
    private let tempLabel = UILabel()
    private let descLabel = UILabel()
    private let iconImageView = UIImageView()
    
    private let gradientLayer = CAGradientLayer()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        contentView.backgroundColor = .clear
        
        [cityLabel, tempLabel, descLabel, iconImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        contentView.layer.insertSublayer(gradientLayer, at: 0)
        contentView.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 50),
            iconImageView.heightAnchor.constraint(equalToConstant: 50),
            
            
            cityLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cityLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            
            tempLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 4),
            tempLabel.leadingAnchor.constraint(equalTo: cityLabel.leadingAnchor),
            
            descLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: 4),
            descLabel.leadingAnchor.constraint(equalTo: cityLabel.leadingAnchor),
            descLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = contentView.bounds
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0))
    }
    
    func configure(with data: WeatherViewData) {
        cityLabel.text = data.city
        tempLabel.text = data.temperature
        descLabel.text = data.description
        
        switch data.background {
        case .sunny:
            gradientLayer.colors = [UIColor.systemYellow.cgColor, UIColor.systemOrange.cgColor]
        case .cloudy:
            gradientLayer.colors = [UIColor.lightGray.cgColor, UIColor.darkGray.cgColor]
        case .rainy:
            gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemIndigo.cgColor]
        }
        
        iconImageView.tintColor = nil
        iconImageView.image = nil
        iconImageView.contentMode = .scaleAspectFit
        
        Task { @MainActor in
            do {
                let (iconData, _) = try await URLSession.shared.data(from: data.iconURL)
                if let image = UIImage(data: iconData) {
                    iconImageView.image = image.withRenderingMode(.alwaysOriginal)
                }
            } catch {
                print("Failed to load icon: \(error)")
            }
        }
    }
}
