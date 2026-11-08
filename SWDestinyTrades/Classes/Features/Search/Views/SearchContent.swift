//
//  SearchContent.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct SearchContent: View {
    let viewModel: SearchViewModel

    @Environment(NavigationCoordinator.self) private var navigationCoordinator: NavigationCoordinator

    private let popularSearches: [String] = [
        "Luke", "Vader", "Lightsaber", "Character",
        "Upgrade", "Event", "Blue", "Red", "Yellow"
    ]

    var body: some View {
        if viewModel.shouldShowInitialState {
            SearchInitialStateView(popularSearches: popularSearches) { search in
                viewModel.searchText = search
                viewModel.performSearch(query: search)
            }
        } else if viewModel.shouldShowSuggestions {
            SearchSuggestionsView(suggestions: viewModel.getSearchSuggestions()) { suggestion in
                viewModel.searchText = suggestion
                viewModel.performSearch(query: suggestion)
            }
        } else if viewModel.isLoading {
            LoadingView()
        } else if viewModel.shouldShowEmptyState {
            SearchEmptyResultsView(query: viewModel.currentQuery) {
                viewModel.clearSearch()
            }
        } else {
            SearchResultsListView(
                results: viewModel.searchResults,
                query: viewModel.currentQuery,
                onClear: { viewModel.clearSearch() },
                onCardSelected: { card in
                    navigationCoordinator.navigate(to: .cardDetail(viewModel.searchResults, card))
                }
            )
        }
    }
}
