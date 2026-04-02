//
//  SearchViewModel.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Observation
import SwiftUI

@MainActor
@Observable
final class SearchViewModel: ListViewModel<CardDTO> {

    var searchResults: [CardDTO] = []
    var hasSearched = false
    var currentQuery = ""

    private var service: SWDestinyServiceProtocol {
        dependencyContainer.resolve(type: SWDestinyServiceProtocol.self)
    }

    @ObservationIgnored private var searchTask: Task<Void, Never>?

    required init(dependencyContainer: DependencyContainer = .shared) {
        super.init(dependencyContainer: dependencyContainer)
    }

    func onSearchTextChanged(_ searchText: String) {
        searchTask?.cancel()
        searchTask = Task { @MainActor in
            do {
                try await Task.sleep(for: .milliseconds(500))
                if !searchText.isEmpty {
                    performSearch(query: searchText)
                } else {
                    clearSearch()
                }
            } catch {
                // Task cancelled by a new keystroke — ignore
            }
        }
    }

    override func handleError(_ error: Error) {
        guard !ConcurrencyError.isCancellation(error) else { return }
        super.handleError(error)
    }

    func performSearch(query: String) {
        let normalizedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !normalizedQuery.isEmpty else {
            clearSearch()
            return
        }

        currentQuery = normalizedQuery
        setLoading(true)
        hasSearched = true

        Task { @MainActor in
            let expectedQuery = normalizedQuery
            do {
                let results = try await service.search(query: expectedQuery)
                guard self.currentQuery == expectedQuery else { return }
                self.searchResults = results
                self.updateItems(results)
                self.setLoaded()
            } catch is CancellationError {
                guard self.currentQuery == expectedQuery else { return }
                self.setLoaded()
            } catch {
                guard self.currentQuery == expectedQuery else { return }
                self.handleError(error)
                self.searchResults = []
                self.updateItems([])
            }
        }
    }

    func clearSearch() {
        searchText = ""
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
            searchText.isEmpty || suggestion.localizedStandardContains(searchText)
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
