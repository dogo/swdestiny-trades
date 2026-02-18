//
//  SearchViewModel.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Combine
import Observation
import SwiftUI

@MainActor
@Observable
final class SearchViewModel: ListViewModel<CardDTO> {

    var searchResults: [CardDTO] = []
    var hasSearched = false
    var currentQuery = ""

    var showToast = false
    var toastTitle = ""
    var toastMessage = ""
    var toastType: ToastType = .info

    private var service: SWDestinyServiceProtocol {
        dependencyContainer.resolve(type: SWDestinyServiceProtocol.self)
    }

    private var searchSubject = PassthroughSubject<String, Never>()
    private var searchCancellable = Set<AnyCancellable>()

    required init(dependencyContainer: DependencyContainer = .shared) {
        super.init(dependencyContainer: dependencyContainer)
        setupSearchDebouncing()
    }

    private func setupSearchDebouncing() {
        searchSubject
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                if !searchText.isEmpty {
                    self?.performSearch(query: searchText)
                } else {
                    self?.clearSearch()
                }
            }
            .store(in: &searchCancellable)
    }

    func onSearchTextChanged(_ searchText: String) {
        searchSubject.send(searchText)
    }

    override func handleError(_ error: Error) {
        super.handleError(error)

        showToast = false

        if ConcurrencyError.isCancellation(error) {
            return
        }

        toastTitle = L10n.error
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
                let results = try await service.search(query: query)

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
