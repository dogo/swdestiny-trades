//
//  LoadingState.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

enum LoadingState<T> {
    case idle
    case loading
    case loaded(T)
    case error(Error)

    var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }

    var data: T? {
        if case let .loaded(data) = self {
            return data
        }
        return nil
    }

    var error: Error? {
        if case let .error(error) = self {
            return error
        }
        return nil
    }

    var hasError: Bool {
        if case .error = self {
            return true
        }
        return false
    }

    var isLoaded: Bool {
        if case .loaded = self {
            return true
        }
        return false
    }

    func map<U>(_ transform: (T) -> U) -> LoadingState<U> {
        switch self {
        case .idle:
            return .idle
        case .loading:
            return .loading
        case let .loaded(data):
            return .loaded(transform(data))
        case let .error(error):
            return .error(error)
        }
    }
}

extension LoadingState: Equatable where T: Equatable {
    static func == (lhs: LoadingState<T>, rhs: LoadingState<T>) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading):
            return true
        case let (.loaded(lhsData), .loaded(rhsData)):
            return lhsData == rhsData
        case let (.error(lhsError), .error(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}

extension LoadingState where T: Collection {
    var isEmpty: Bool {
        switch self {
        case let .loaded(data):
            return data.isEmpty
        default:
            return true
        }
    }

    var count: Int {
        switch self {
        case let .loaded(data):
            return data.count
        default:
            return 0
        }
    }
}
