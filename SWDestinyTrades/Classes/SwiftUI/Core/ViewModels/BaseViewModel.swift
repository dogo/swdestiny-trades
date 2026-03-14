//
//  BaseViewModel.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

@MainActor
@Observable
class BaseViewModel {
    var isLoading: Bool {
        loadingState.isLoading
    }

    private(set) var errorMessage: String?
    private(set) var loadingState: LoadingState<Void> = .idle

    let dependencyContainer: DependencyContainer

    required init(dependencyContainer: DependencyContainer = .shared) {
        self.dependencyContainer = dependencyContainer
    }

    func handleError(_ error: Error) {
        guard errorMessage != error.localizedDescription || !loadingState.hasError else { return }

        errorMessage = error.localizedDescription
        loadingState = .error(error)
    }

    func clearError() {
        guard errorMessage != nil || loadingState.hasError else { return }

        errorMessage = nil
        if case .error = loadingState {
            loadingState = .idle
        }
    }

    func setLoading(_ loading: Bool) {
        if loading {
            guard !loadingState.isLoading else { return }
            loadingState = .loading
        } else {
            guard case .loading = loadingState else { return }
            loadingState = .idle
        }
    }

    func setLoaded() {
        guard !loadingState.isLoaded else { return }
        loadingState = .loaded(())
    }
}
