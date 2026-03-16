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
                deckListView
            }
        }
        .navigationTitle(L10n.decks)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                addButton
            }
        }
        .searchable(text: $viewModel.searchText, prompt: L10n.searchDecks)
        .onChange(of: viewModel.searchText) { _, newValue in
            viewModel.performFiltering(searchText: newValue)
        }
        .refreshable {
            await refreshDecks()
        }
        .alert(L10n.deleteDeck, isPresented: $viewModel.showingDeleteConfirmation) {
            deleteConfirmationAlert
        }
        .onAppear {
            Task {
                await viewModel.loadDecks()
            }
        }
    }

    // MARK: - View Components

    private var deckListView: some View {
        List {
            ForEach(viewModel.filteredItems, id: \.id) { deck in
                DeckRowView(deck: deck, cardCount: viewModel.cardCounts[deck.id] ?? 0) {
                    editDeck(deck)
                } onGraph: {
                    showDeckGraph(deck)
                } onDelete: {
                    viewModel.prepareToDelete(deck)
                } onRename: { newName in
                    Task {
                        await viewModel.renameDeck(deck, newName: newName)
                    }
                }
            }
        }
        .listStyle(.plain)
    }

    private var addButton: some View {
        Button(L10n.createNewDeck, systemImage: "plus", action: createNewDeck)
    }

    private var deleteConfirmationAlert: some View {
        Group {
            Button(L10n.delete, role: .destructive) {
                Task {
                    await viewModel.confirmDelete()
                }
            }
            Button(L10n.cancel, role: .cancel) {
                viewModel.cancelDelete()
            }
        }
    }

    // MARK: - Actions

    private func createNewDeck() {
        navigationCoordinator.navigate(to: .deckBuilder(nil))
    }

    private func editDeck(_ deck: DeckDTO) {
        navigationCoordinator.navigate(to: .deckBuilder(deck))
    }

    private func showDeckGraph(_ deck: DeckDTO) {
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
