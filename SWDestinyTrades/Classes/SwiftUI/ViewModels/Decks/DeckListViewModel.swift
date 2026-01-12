//
//  DeckListViewModel.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Combine
import SwiftUI

@MainActor
final class DeckListViewModel: ListViewModel<DeckDTO> {

    @Published var showingDeleteConfirmation = false
    @Published var deckToDelete: DeckDTO?

    private var database: DatabaseProtocol? {
        dependencyContainer.resolve(type: DatabaseProtocol.self)
    }

    required init(dependencyContainer: DependencyContainer = .shared) {
        super.init(dependencyContainer: dependencyContainer)
        loadDecks()
    }

    override func loadItems(page: Int = 0, reset: Bool = false) {
        loadDecks()
    }

    func loadDecks() {
        setLoading(true)
        Task { @MainActor in
            do {
                try Task.checkCancellation()
                try await self.loadDecksFromDatabase()
            } catch is CancellationError {
                self.setLoaded()
            } catch {
                self.handleError(ConcurrencyError.from(error))
            }
        }
    }

    private func loadDecksFromDatabase() async throws {
        guard let database else {
            handleError(ViewModelError.databaseNotAvailable)
            return
        }

        try Task.checkCancellation()
        _ = try database.fetch(DeckDTO.self, predicate: nil, sorted: nil) { fetchedDecks in
            self.updateItems(fetchedDecks)
            self.applySorting()
            self.setLoaded()
        }
    }

    private func applySorting() {
        performFiltering(searchText: searchText)
    }

    private func filterDecks() -> [DeckDTO] {
        let deckData = items.threadSafeMap { $0.toThreadSafe() }
        var filteredData = deckData

        if !searchText.isEmpty {
            filteredData = filteredData.filter { deck in
                deck.name.localizedCaseInsensitiveContains(searchText)
            }
        }

        let filteredDecks = filteredData.compactMap { deckData in
            items.first { $0.id == deckData.id }
        }

        return filteredDecks
    }

    override func filterItems(searchText: String) -> [DeckDTO] {
        return filterDecks()
    }

    func prepareToDelete(_ deck: DeckDTO) {
        deckToDelete = deck
        showingDeleteConfirmation = true
    }

    func confirmDelete() {
        guard let deck = deckToDelete,
              let database else {
            return
        }

        let deckData = deck.toThreadSafe()

        Task { @MainActor in
            do {
                try Task.checkCancellation()

                let itemsData = self.items.threadSafeMap { $0.toThreadSafe() }

                try database.delete(object: deck)

                let filteredData = itemsData.filter { $0.id != deckData.id }

                let newItems = filteredData.compactMap { deckData in
                    self.items.first { $0.id == deckData.id }
                }

                self.updateItems(newItems)
                self.deckToDelete = nil
                self.showingDeleteConfirmation = false
            } catch is CancellationError {
                return
            } catch {
                self.handleError(ConcurrencyError.realmAccessError(error))
            }
        }
    }

    func cancelDelete() {
        deckToDelete = nil
        showingDeleteConfirmation = false
    }

    func renameDeck(_ deck: DeckDTO, newName: String) {
        guard let database else {
            handleError(ViewModelError.databaseNotAvailable)
            return
        }

        let trimmedName = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }

        let deckId = deck.id

        Task { @MainActor in
            do {
                try Task.checkCancellation()

                try database.fetch(DeckDTO.self, predicate: NSPredicate(format: "id == %@", deckId), sorted: nil) { fetchedDecks in
                    guard let deckToUpdate = fetchedDecks.first else { return }

                    do {
                        try database.update {
                            deckToUpdate.name = trimmedName
                        }

                        Task { @MainActor in
                            do {
                                try Task.checkCancellation()
                                try await self.loadDecksFromDatabase()
                            } catch is CancellationError {
                                return
                            } catch {
                                self.handleError(ConcurrencyError.from(error))
                            }
                        }
                    } catch {
                        self.handleError(ConcurrencyError.realmAccessError(error))
                    }
                }
            } catch is CancellationError {
                return
            } catch {
                self.handleError(ConcurrencyError.realmAccessError(error))
            }
        }
    }
}
