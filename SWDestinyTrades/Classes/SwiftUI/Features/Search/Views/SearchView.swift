//
//  SearchView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct SearchView: View {
    @State private var viewModel: SearchViewModel
    @Environment(NavigationCoordinator.self) var navigationCoordinator: NavigationCoordinator

    @FocusState private var isSearchFocused: Bool

    init(viewModel: SearchViewModel? = nil) {
        if let viewModel {
            _viewModel = State(wrappedValue: viewModel)
        } else {
            _viewModel = State(wrappedValue: SearchViewModel())
        }
    }

    var body: some View {
        VStack {
            searchContent
        }
        .navigationTitle(L10n.search)
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $viewModel.searchText, prompt: L10n.searchCards)
        .onSubmit(of: .search) {
            if !viewModel.searchText.isEmpty {
                viewModel.performSearch(query: viewModel.searchText)
            }
        }
        .overlay(alignment: .top) {
            if viewModel.showToast {
                ToastView(
                    title: viewModel.toastTitle,
                    message: viewModel.toastMessage,
                    type: viewModel.toastType,
                    isPresented: $viewModel.showToast,
                    duration: 2.5
                )
                .padding(.top, 8)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .onChange(of: viewModel.searchText) { _, newValue in
            viewModel.onSearchTextChanged(newValue)
        }
    }

    @ViewBuilder private var searchContent: some View {
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

    private let popularSearches: [String] = [
        "Luke",
        "Vader",
        "Lightsaber",
        "Character",
        "Upgrade",
        "Event",
        "Blue",
        "Red",
        "Yellow"
    ]
}

#Preview {
    SearchView()
        .environment(NavigationCoordinator())
        .environment(\.dependencyContainer, DependencyContainer.shared)
}
