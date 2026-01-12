//
//  SearchViewModel.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Combine
import SwiftUI

@MainActor
final class SearchViewModel: ListViewModel<CardDTO> {

    @Published var searchResults: [CardDTO] = []
    @Published var hasSearched = false
    @Published var currentQuery = ""

    // Toast properties
    @Published var showToast = false
    @Published var toastTitle = ""
    @Published var toastMessage = ""
    @Published var toastType: ToastType = .info

    private var service: SWDestinyServiceProtocol? {
        dependencyContainer.resolve(type: SWDestinyServiceProtocol.self)
    }

    private var searchCancellable: AnyCancellable?

    required init(dependencyContainer: DependencyContainer = .shared) {
        super.init(dependencyContainer: dependencyContainer)
        setupSearchDebouncing()
    }

    override func handleError(_ error: Error) {
        super.handleError(error)

        showToast = false

        if ConcurrencyError.isCancellation(error) {
            return
        }

        toastTitle = "Error"
        toastMessage = error.localizedDescription
        toastType = .error

        Task { @MainActor in
            do {
                try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
                self.showToast = true
            } catch {
                // Ignore cancellation during toast delay
            }
        }
    }

    private func setupSearchDebouncing() {
        searchCancellable = $searchText
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                guard let self else { return }
                if !searchText.isEmpty {
                    performSearch(query: searchText)
                } else {
                    clearSearch()
                }
            }
    }

    func performSearch(query: String) {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            clearSearch()
            return
        }

        currentQuery = query
        setLoading(true)
        hasSearched = true

        Task { @MainActor in
            do {
                try Task.checkCancellation()

                guard let service else {
                    throw ViewModelError.serviceNotAvailable
                }

                let results = try await service.search(query: query)

                try Task.checkCancellation()

                if self.currentQuery == query {
                    self.searchResults = results
                    self.updateItems(results)
                    self.setLoaded()
                }
            } catch is CancellationError {
                if self.currentQuery == query {
                    self.setLoaded()
                }
            } catch {
                if self.currentQuery == query {
                    self.handleError(error)
                    self.searchResults = []
                    self.updateItems([])
                }
            }
        }
    }

    func clearSearch() {
        currentQuery = ""
        searchResults = []
        updateItems([])
        hasSearched = false
        setLoading(false)
        clearError()
    }

    override func filterItems(searchText: String) -> [CardDTO] {
        return searchResults
    }

    func getSearchSuggestions() -> [String] {
        return [
            "Luke Skywalker",
            "Darth Vader",
            "Lightsaber",
            "Force",
            "Jedi",
            "Sith",
            "Rebel",
            "Empire",
            "Character",
            "Upgrade",
            "Event",
            "Support"
        ].filter { suggestion in
            searchText.isEmpty || suggestion.localizedCaseInsensitiveContains(searchText)
        }
    }

    var shouldShowSuggestions: Bool {
        return !hasSearched && !searchText.isEmpty && searchText.count < 3
    }

    var shouldShowEmptyState: Bool {
        return hasSearched && searchResults.isEmpty && !isLoading
    }

    var shouldShowInitialState: Bool {
        return !hasSearched && searchText.isEmpty
    }
}
