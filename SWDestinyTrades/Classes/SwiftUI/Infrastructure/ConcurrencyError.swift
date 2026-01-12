//
//  ConcurrencyError.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 17/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

enum ConcurrencyError: Error, LocalizedError {
    case taskCancelled
    case mainActorTimeout
    case realmAccessError(Error)

    var errorDescription: String? {
        switch self {
        case .taskCancelled:
            return "Operation was cancelled"
        case .mainActorTimeout:
            return "Main actor operation timed out"
        case let .realmAccessError(error):
            return "Database error: \(error.localizedDescription)"
        }
    }

    /// Helper method to check if an error is a cancellation error
    static func isCancellation(_ error: Error) -> Bool {
        if error is CancellationError {
            return true
        }
        if case .taskCancelled = error as? ConcurrencyError {
            return true
        }
        return false
    }

    /// Helper method to convert generic errors to ConcurrencyError
    static func from(_ error: Error) -> ConcurrencyError {
        if error is CancellationError {
            return .taskCancelled
        }
        if let concurrencyError = error as? ConcurrencyError {
            return concurrencyError
        }
        return .realmAccessError(error)
    }
}
