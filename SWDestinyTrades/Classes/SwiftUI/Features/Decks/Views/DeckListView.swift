//
//  DeckListView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct DeckListView: View {
    @State private var viewModel: DeckListViewModel
    @Environment(NavigationCoordinator.self) private var navigationCoordinator: NavigationCoordinator

    init(dependencyContainer: DependencyContainer = .shared) {
        _viewModel = State(wrappedValue: DeckListViewModel(dependencyContainer: dependencyContainer))
    }

    var body: some View {
        VStack {
            if viewModel.loadingState.isLoading {
                DeckListLoadingView()
            } else if viewModel.filteredItems.isEmpty, !viewModel.searchText.isEmpty {
                DeckEmptySearchView()
            } else if viewModel.filteredItems.isEmpty {
                DeckEmptyStateView(onCreateDeck: createNewDeck)
            } else {
                DeckListContent(
                    items: viewModel.filteredItems,
                    onEdit: editDeck,
                    onGraph: showDeckGraph,
                    onDelete: { item in
                        Task { await viewModel.delete(item) }
                    },
                    onRename: { item, newName in
                        Task { await viewModel.renameDeck(item, newName: newName) }
                    }
                )
            }
        }
        .navigationTitle(L10n.decks)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(L10n.createNewDeck, systemImage: "plus", action: createNewDeck)
            }
        }
        .searchable(text: $viewModel.searchText, prompt: L10n.searchDecks)
        .onChange(of: viewModel.searchText) { _, newValue in
            viewModel.performFiltering(searchText: newValue)
        }
        .refreshable {
            await refreshDecks()
        }
        .onAppear {
            Task {
                await viewModel.loadDecks()
            }
        }
    }

    // MARK: - Actions

    private func createNewDeck() {
        navigationCoordinator.navigate(to: .deckBuilder(nil))
    }

    private func editDeck(_ item: DeckListItem) {
        guard let deck = viewModel.deck(for: item) else { return }
        navigationCoordinator.navigate(to: .deckBuilder(deck))
    }

    private func showDeckGraph(_ item: DeckListItem) {
        guard let deck = viewModel.deck(for: item) else { return }
        navigationCoordinator.navigate(to: .deckGraph(deck))
    }

    private func refreshDecks() async {
        await viewModel.loadDecks()
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        DeckListView()
            .environment(NavigationCoordinator())
            .environment(\.dependencyContainer, DependencyContainer.shared)
    }
}

#Preview("Empty State") {
    NavigationStack {
        VStack {
            Text(L10n.noDecksYet)
                .font(.title2)
                .bold()

            Text(L10n.createYourFirstDeckToGetStarted)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button(L10n.createNewDeck) {}
                .buttonStyle(.borderedProminent)
                .tint(ColorPalette.appTheme)
                .foregroundStyle(ColorPalette.appThemeForeground)
        }
        .padding()
        .navigationTitle(L10n.decks)
    }
}

#Preview("Loading State") {
    NavigationStack {
        VStack {
            ProgressView()
                .scaleEffect(1.2)
            Text(L10n.loadingDecks)
                .foregroundStyle(.secondary)
                .padding(.top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle(L10n.decks)
    }
}
