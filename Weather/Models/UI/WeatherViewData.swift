//
//  WeatherViewData.swift
//  Weather
//
//  Created by Александр Милейчик on 3/2/26.
//

import UIKit

struct WeatherViewData {
    let city: String
    let temperature: String
    let description: String
    let iconURL: URL
    let background: WeatherBackground
}

enum WeatherBackground {
    case sunny, cloudy, rainy
    var color: UIColor {
        switch self {
        case .sunny: return UIColor.systemYellow.withAlphaComponent(0.2)
        case .cloudy: return UIColor.lightGray.withAlphaComponent(0.2)
        case .rainy: return UIColor.systemBlue.withAlphaComponent(0.2)
        }
    }
}
