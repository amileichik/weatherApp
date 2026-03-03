//
//  NetworkError.swift
//  Weather
//
//  Created by Александр Милейчик on 3/2/26.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case badResponse(Int)
    case noData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .badResponse(let code): return "Bad HTTP response: \(code)"
        case .noData: return "No data received from server"
        }
    }
}
