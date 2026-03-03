//
//  ViewModelState.swift
//  Weather
//
//  Created by Александр Милейчик on 3/2/26.
//

import Foundation

enum ViewModelState {
    case initial
    case loading
    case loaded
    case error(String)
}
