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
    @Environment(\.dependencyContainer) private var container

    @FocusState private var isSearchFocused: Bool
    @State private var showToast = false

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
            if showToast {
                ToastView(
                    title: viewModel.toastTitle,
                    message: viewModel.toastMessage,
                    type: viewModel.toastType,
                    isPresented: $showToast,
                    duration: 2.5
                )
                .padding(.top, 8)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: showToast)
        .onChange(of: viewModel.showToast) { _, newValue in
            showToast = newValue
        }
        .onChange(of: viewModel.searchText) { _, newValue in
            viewModel.onSearchTextChanged(newValue)
        }
    }

    @ViewBuilder private var searchContent: some View {
        if viewModel.shouldShowInitialState {
            initialStateView
        } else if viewModel.shouldShowSuggestions {
            searchSuggestionsView
        } else if viewModel.isLoading {
            LoadingView()
        } else if viewModel.shouldShowEmptyState {
            emptySearchResultsView
        } else {
            searchResultsList
        }
    }

    @ViewBuilder private var initialStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: "magnifyingglass")
                .font(.largeTitle)
                .foregroundStyle(.secondary)

            VStack(spacing: 8) {
                Text(L10n.searchCards)
                    .font(.title2)
                    .fontWeight(.semibold)

                Text(L10n.enterACardNameTypeOrAnyKeywordToSearch)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            VStack(spacing: 12) {
                Text(L10n.popularSearches)
                    .font(.headline)
                    .foregroundStyle(.primary)

                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: 100), spacing: 8)
                ], spacing: 8) {
                    ForEach(popularSearches, id: \.self) { search in
                        Button {
                            viewModel.searchText = search
                            viewModel.performSearch(query: search)
                        } label: {
                            Text(search)
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color(.systemGray5))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }

    @ViewBuilder private var searchSuggestionsView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(L10n.suggestions)
                .font(.headline)
                .padding(.horizontal)
                .padding(.top)

            List(viewModel.getSearchSuggestions(), id: \.self) { suggestion in
                Button {
                    viewModel.searchText = suggestion
                    viewModel.performSearch(query: suggestion)
                } label: {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.secondary)

                        Text(suggestion)
                            .foregroundStyle(.primary)

                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
                .buttonStyle(.plain)
            }
            .listStyle(.plain)
        }
    }

    @ViewBuilder private var emptySearchResultsView: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.largeTitle)
                .foregroundStyle(.secondary)

            Text(L10n.noResultsFound)
                .font(.headline)
                .foregroundStyle(.primary)

            Text(L10n.noCardsMatchViewmodelcurrentqueryTryA(viewModel.currentQuery))
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button {
                viewModel.clearSearch()
            } label: {
                Text(L10n.clearSearch)
                    .font(.subheadline)
                    .foregroundStyle(.blue)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }

    @ViewBuilder private var searchResultsList: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(L10n.viewmodelsearchresultscountResultsFor(viewModel.searchResults.count, viewModel.currentQuery))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Spacer()

                Button {
                    viewModel.clearSearch()
                } label: {
                    Text(L10n.clear)
                        .font(.subheadline)
                        .foregroundStyle(.blue)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)

            List(viewModel.searchResults, id: \.code) { card in
                SearchResultRowView(card: card) {
                    navigationCoordinator.navigate(to: .cardDetail(viewModel.searchResults, card))
                }
                .listRowSeparator(.visible)
            }
            .listStyle(.plain)
        }
    }

    private var popularSearches: [String] {
        return [
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
}

#Preview {
    SearchView()
        .environment(NavigationCoordinator())
        .environment(\.dependencyContainer, DependencyContainer.shared)
}
