//
//  DeckListViewModel.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

@MainActor
@Observable
final class DeckListViewModel: ListViewModel<DeckDTO> {

    private(set) var cardCounts: [String: Int] = [:]

    private var database: DatabaseProtocol {
        dependencyContainer.resolve(type: DatabaseProtocol.self)
    }

    required init(dependencyContainer: DependencyContainer = .shared) {
        super.init(dependencyContainer: dependencyContainer)
    }

    override func loadItems(page: Int = 0, reset: Bool = false) async {
        await loadDecks()
    }

    func loadDecks() async {
        setLoading(true)
        do {
            try Task.checkCancellation()
            await loadDecksFromDatabase()
        } catch is CancellationError {
            setLoaded()
        } catch {
            handleError(error)
        }
    }

    private func loadDecksFromDatabase() async {
        let fetchedDecks = await database.fetch(
            DeckDTO.self,
            predicate: nil,
            sorted: Sorted(key: "name", ascending: true)
        )

        var counts: [String: Int] = [:]
        for deck in fetchedDecks {
            counts[deck.id] = deck.list.reduce(0) { $0 + $1.quantity }
        }
        cardCounts = counts

        updateItems(fetchedDecks)
        applySorting()
        setLoaded()
    }

    private func applySorting() {
        performFiltering(searchText: searchText)
    }

    private func filterDecks() -> [DeckDTO] {
        var filtered = items

        if !searchText.isEmpty {
            filtered = filtered.filter { deck in
                deck.name.localizedStandardContains(searchText)
            }
        }

        return filtered
    }

    override func filterItems(searchText: String) -> [DeckDTO] {
        return filterDecks()
    }

    func delete(_ deck: DeckDTO) async {
        do {
            try await database.delete(object: deck)
            await loadDecksFromDatabase()
        } catch {
            handleError(error)
        }
    }

    func renameDeck(_ deck: DeckDTO, newName: String) async {
        let trimmedName = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }

        do {
            let updatedDeck = DeckDTO()
            updatedDeck.id = deck.id
            updatedDeck.name = trimmedName
            updatedDeck.list = deck.list
            try await database.save(object: updatedDeck, update: .modified)
            await loadDecksFromDatabase()
        } catch {
            handleError(error)
        }
    }
}
