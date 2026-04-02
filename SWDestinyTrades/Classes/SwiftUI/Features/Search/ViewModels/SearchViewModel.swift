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
            await executeSearch(for: normalizedQuery)
        }
    }

    private func executeSearch(for expectedQuery: String) async {
        do {
            let results = try await service.search(query: expectedQuery)
            guard currentQuery == expectedQuery else { return }
            searchResults = results
            updateItems(results)
            setLoaded()
        } catch is CancellationError {
            guard currentQuery == expectedQuery else { return }
            setLoaded()
        } catch {
            guard currentQuery == expectedQuery else { return }
            handleError(error)
            searchResults = []
            updateItems([])
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
