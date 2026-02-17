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
        .searchable(text: $viewModel.searchText, prompt: "Search for cards...")
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
                .font(.system(size: 64))
                .foregroundColor(.secondary)

            VStack(spacing: 8) {
                Text(L10n.searchForCards)
                    .font(.title2)
                    .fontWeight(.semibold)

                Text(L10n.enterACardNameTypeOrAnyKeywordToSearch)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            VStack(spacing: 12) {
                Text(L10n.popularSearches)
                    .font(.headline)
                    .foregroundColor(.primary)

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
                            .foregroundColor(.secondary)

                        Text(suggestion)
                            .foregroundColor(.primary)

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
                .font(.system(size: 48))
                .foregroundColor(.secondary)

            Text(L10n.noResultsFound)
                .font(.headline)
                .foregroundColor(.primary)

            Text(L10n.noCardsMatchViewmodelcurrentqueryTryA(viewModel.currentQuery))
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button {
                viewModel.clearSearch()
            } label: {
                Text(L10n.clearSearch)
                    .font(.subheadline)
                    .foregroundColor(.blue)
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
                    .foregroundColor(.secondary)

                Spacer()

                Button {
                    viewModel.clearSearch()
                } label: {
                    Text(L10n.clear)
                        .font(.subheadline)
                        .foregroundColor(.blue)
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

// MARK: - Supporting Views

struct SearchResultRowView: View {
    let card: CardDTO
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                AsyncImage(url: URL(string: card.imageUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ZStack {
                        Image(asset: Asset.icCardback)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .opacity(0.3)

                        ProgressView()
                            .scaleEffect(0.8)
                    }
                }
                .frame(width: 40, height: 56)
                .clipShape(RoundedRectangle(cornerRadius: 4))

                VStack(alignment: .leading, spacing: 4) {
                    Text(card.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)

                    if !card.subtitle.isEmpty {
                        Text(card.subtitle)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }

                    HStack {
                        Text(card.setCode.uppercased())
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color(.systemGray5))
                            .clipShape(RoundedRectangle(cornerRadius: 4))

                        Text(card.typeCode.capitalized)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(.plain)
    }
}

struct SearchLoadingView: View {
    let query: String

    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)

            Text(L10n.searchingForQuery(query))
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    SearchView()
        .environment(NavigationCoordinator())
        .environment(\.dependencyContainer, DependencyContainer.shared)
}
