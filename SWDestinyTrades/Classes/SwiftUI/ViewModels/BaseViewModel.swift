//
//  BaseViewModel.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Combine
import SwiftUI

@MainActor
class BaseViewModel: ObservableObject {
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var loadingState: LoadingState<Void> = .idle

    let dependencyContainer: DependencyContainer

    var cancellables = Set<AnyCancellable>()

    required init(dependencyContainer: DependencyContainer = .shared) {
        self.dependencyContainer = dependencyContainer
    }

    func handleError(_ error: Error) {
        guard errorMessage != error.localizedDescription || isLoading || !loadingState.hasError else { return }

        objectWillChange.send()
        errorMessage = error.localizedDescription
        isLoading = false
        loadingState = .error(error)
    }

    func clearError() {
        guard errorMessage != nil || loadingState.hasError else { return }

        objectWillChange.send()
        errorMessage = nil
        if case .error = loadingState {
            loadingState = .idle
        }
    }

    func setLoading(_ loading: Bool) {
        guard isLoading != loading else {
            return
        }

        objectWillChange.send()
        isLoading = loading
        if loading {
            loadingState = .loading
        }
    }

    func setLoaded() {
        guard isLoading || !loadingState.isLoaded else { return }

        objectWillChange.send()
        isLoading = false
        loadingState = .loaded(())
    }
}

@MainActor
class ListViewModel<T: Identifiable & Equatable>: BaseViewModel {
    @Published private(set) var items: [T] = []
    @Published var searchText = ""
    @Published private(set) var filteredItems: [T] = []

    @Published private(set) var hasMoreItems = true
    @Published private(set) var currentPage = 0
    private let itemsPerPage = 50

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
        return items
    }

    func loadItems(page: Int = 0, reset: Bool = false) {
        // Override in subclasses
    }

    func loadMoreItems() {
        guard hasMoreItems, !isLoading else { return }
        loadItems(page: currentPage + 1, reset: false)
    }

    func refresh() {
        currentPage = 0
        hasMoreItems = true
        loadItems(page: 0, reset: true)
    }

    func updateItems(_ newItems: [T], append: Bool = false) {
        let updatedItems = append ? items + newItems : newItems

        guard updatedItems != items else { return }

        objectWillChange.send()
        items = updatedItems
        filteredItems = filterItems(searchText: searchText)
        if append {
            currentPage += 1
            hasMoreItems = newItems.count >= itemsPerPage
        }
    }
}
