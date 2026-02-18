//
//  ViewModelError.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

enum ViewModelError: Error, LocalizedError {
    case objectNotFound
    case dataLoadingFailed(String)
    case networkError(Error)
    case invalidData
    case searchFailed
    case emptyQuery
    case custom(String)

    var errorDescription: String? {
        switch self {
        case .objectNotFound:
            return "Object not found in database"
        case let .dataLoadingFailed(message):
            return "Data loading failed: \(message)"
        case let .networkError(error):
            return "Network error: \(error.localizedDescription)"
        case .invalidData:
            return "Invalid data received"
        case .searchFailed:
            return "Search failed. Please try again."
        case .emptyQuery:
            return "Please enter a search term."
        case let .custom(message):
            return message
        }
    }
}
