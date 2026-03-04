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
    var isLoading: Bool { loadingState.isLoading }
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

@MainActor
@Observable
class ListViewModel<T: Identifiable & Equatable>: BaseViewModel {
    private(set) var items: [T] = []
    private(set) var filteredItems: [T] = []

    private(set) var hasMoreItems = true
    private(set) var currentPage = 0
    private let itemsPerPage = 50

    var searchText = ""

    required init(dependencyContainer: DependencyContainer = .shared) {
        super.init(dependencyContainer: dependencyContainer)
    }

    func performFiltering(searchText: String) {
        self.searchText = searchText
        filteredItems = filterItems(searchText: searchText)
    }

    func filterItems(searchText: String) -> [T] {
        if searchText.isEmpty {
            return items
        }
        assertionFailure("ListViewModel subclasses must override filterItems(searchText:) to implement filtering.")
        return items
    }

    func loadItems(page: Int = 0, reset: Bool = false) async {
        // Override in subclasses
    }

    func loadMoreItems() async {
        guard hasMoreItems, !isLoading else { return }
        await loadItems(page: currentPage + 1, reset: false)
    }

    func refresh() async {
        currentPage = 0
        hasMoreItems = true
        await loadItems(page: 0, reset: true)
    }

    func updateItems(_ newItems: [T], append: Bool = false) {
        let updatedItems = append ? items + newItems : newItems

        guard updatedItems != items else { return }

        items = updatedItems
        filteredItems = filterItems(searchText: searchText)
        if append {
            currentPage += 1
            hasMoreItems = newItems.count >= itemsPerPage
        }
    }
}
