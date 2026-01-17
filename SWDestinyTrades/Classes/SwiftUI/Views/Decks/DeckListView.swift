//
//  DeckListView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct DeckListView: View {
    @StateObject private var viewModel: DeckListViewModel
    @EnvironmentObject private var navigationCoordinator: NavigationCoordinator
    @Environment(\.dependencyContainer) private var dependencyContainer

    init(dependencyContainer: DependencyContainer = .shared) {
        _viewModel = StateObject(wrappedValue: DeckListViewModel(dependencyContainer: dependencyContainer))
    }

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.loadingState.isLoading {
                    loadingView
                } else if viewModel.filteredItems.isEmpty, !viewModel.searchText.isEmpty {
                    emptySearchView
                } else if viewModel.filteredItems.isEmpty {
                    emptyStateView
                } else {
                    deckListView
                }
            }
            .navigationTitle(L10n.decks)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    addButton
                }
            }
            .searchable(text: $viewModel.searchText, prompt: "Search decks...")
            .refreshable {
                await refreshDecks()
            }
            .alert(L10n.deleteDeck, isPresented: $viewModel.showingDeleteConfirmation) {
                deleteConfirmationAlert
            }
            .onAppear {
                viewModel.loadDecks()
            }
        }
    }

    // MARK: - View Components

    private var loadingView: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.2)
            Text(L10n.loadingDecks)
                .foregroundColor(.secondary)
                .padding(.top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "rectangle.stack")
                .font(.system(size: 60))
                .foregroundColor(.secondary)

            Text(L10n.noDecksYet)
                .font(.title2)
                .fontWeight(.semibold)

            Text(L10n.createYourFirstDeckToGetStarted)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Button(L10n.createNewDeck) {
                createNewDeck()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var emptySearchView: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.secondary)

            Text(L10n.noResults)
                .font(.title2)
                .fontWeight(.semibold)

            Text(L10n.noDecksMatchViewmodelsearchtext(viewModel.searchText))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var deckListView: some View {
        List {
            ForEach(viewModel.filteredItems, id: \.id) { deck in
                DeckRowView(deck: deck) {
                    editDeck(deck)
                } onGraph: {
                    showDeckGraph(deck)
                } onDelete: {
                    viewModel.prepareToDelete(deck)
                } onRename: { newName in
                    viewModel.renameDeck(deck, newName: newName)
                }
            }
        }
        .listStyle(PlainListStyle())
    }

    private var addButton: some View {
        Button {
            createNewDeck()
        } label: {
            Image(systemName: "plus")
        }
    }

    private var deleteConfirmationAlert: some View {
        Group {
            Button("Delete", role: .destructive) {
                viewModel.confirmDelete()
            }
            Button("Cancel", role: .cancel) {
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
        await MainActor.run {
            viewModel.loadDecks()
        }
    }
}

// MARK: - Deck Row View

struct DeckRowView: View {
    let deck: DeckDTO
    let onEdit: () -> Void
    let onGraph: () -> Void
    let onDelete: () -> Void
    let onRename: (String) -> Void

    @State private var isEditing = false
    @State private var editedName = ""

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                if isEditing {
                    TextField("Deck Name", text: $editedName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onSubmit {
                            saveName()
                        }
                } else {
                    Button(action: onEdit) {
                        Text(deck.name.isEmpty ? "Unnamed Deck" : deck.name)
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                    .buttonStyle(.plain)
                }

                Text(L10n.cardsCount(deck.list.sum(ofProperty: "quantity") as Int))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            if isEditing {
                Button(L10n.done) {
                    saveName()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
            } else {
                Button {
                    startEditing()
                } label: {
                    Image(systemName: "pencil")
                        .foregroundColor(.blue)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 4)
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button("Delete", role: .destructive) {
                onDelete()
            }

            .tint(.blue)

            Button(L10n.graph) {
                onGraph()
            }
            .tint(.green)
        }
        .contextMenu {
            Button("Edit", action: onEdit)
            Button("Show Graph", action: onGraph)
            Divider()
            Button("Delete", role: .destructive, action: onDelete)
        }
    }

    // MARK: - Private Methods

    private func startEditing() {
        editedName = deck.name
        isEditing = true
    }

    private func saveName() {
        let trimmedName = editedName.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedName.isEmpty, trimmedName != deck.name {
            onRename(trimmedName)
        }
        isEditing = false
    }
}

// MARK: - Preview

#Preview {
    NavigationView {
        DeckListView()
            .environmentObject(NavigationCoordinator())
            .environment(\.dependencyContainer, DependencyContainer.shared)
    }
}

#Preview("Empty State") {
    NavigationView {
        VStack {
            Text(L10n.noDecksYet)
                .font(.title2)
                .fontWeight(.semibold)

            Text(L10n.createYourFirstDeckToGetStarted)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Button(L10n.createNewDeck) {}
                .buttonStyle(.borderedProminent)
        }
        .padding()
        .navigationTitle(L10n.decks)
    }
}

#Preview("Loading State") {
    NavigationView {
        VStack {
            ProgressView()
                .scaleEffect(1.2)
            Text(L10n.loadingDecks)
                .foregroundColor(.secondary)
                .padding(.top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle(L10n.decks)
    }
}
