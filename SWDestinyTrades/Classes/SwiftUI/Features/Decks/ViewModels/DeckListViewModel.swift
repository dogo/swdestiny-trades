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
final class DeckListViewModel: ListViewModel<DeckListItem> {
    private(set) var loadingDeckID: String?
    @ObservationIgnored private var decksByID: [String: DeckDTO] = [:]
    @ObservationIgnored private var remoteDecksByID: [String: DeckDTO] = [:]
    @ObservationIgnored private var remoteCardsByCode: [String: CardDTO] = [:]

    private var database: DatabaseProtocol {
        dependencyContainer.resolve(type: DatabaseProtocol.self)
    }

    private var authService: AuthServiceProtocol {
        dependencyContainer.resolve(type: AuthServiceProtocol.self)
    }

    private var cardService: CardServiceProtocol {
        dependencyContainer.resolve(type: CardServiceProtocol.self)
    }

    private var deckService: DeckServiceProtocol {
        dependencyContainer.resolve(type: DeckServiceProtocol.self)
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

        decksByID = fetchedDecks.reduce(into: [:]) { decks, deck in
            decks[deck.id] = deck
        }

        let remoteDecks = authService.isLoggedIn ? await (try? deckService.retrieveDecks()) ?? [] : []
        remoteDecksByID = remoteDecks.reduce(into: [:]) { decks, deck in
            decks[deck.id] = deck
        }

        updateItems((fetchedDecks + remoteDecks).map(DeckListItem.init))
        applySorting()
        setLoaded()
    }

    private func applySorting() {
        performFiltering(searchText: searchText)
    }

    private func filterDecks() -> [DeckListItem] {
        var filtered = items

        if !searchText.isEmpty {
            filtered = filtered.filter { deck in
                deck.name.localizedStandardContains(searchText)
            }
        }

        return filtered
    }

    override func filterItems(searchText: String) -> [DeckListItem] {
        return filterDecks()
    }

    func deck(for item: DeckListItem) -> DeckDTO? {
        decksByID[item.id]
    }

    func resolvedDeck(for item: DeckListItem) async -> DeckDTO? {
        if let deck = deck(for: item) {
            return deck
        }
        guard loadingDeckID == nil, let remoteDeck = remoteDecksByID[item.id] else { return nil }

        loadingDeckID = item.id
        defer { loadingDeckID = nil }

        do {
            let missingCodes = Set(remoteDeck.list.map(\.code)).subtracting(remoteCardsByCode.keys)
            let tasks = missingCodes.map { code in
                Task { [cardService] in
                    remoteCardsByCode[code] = try await cardService.retrieveCard(cardId: code)
                }
            }
            for task in tasks {
                try await task.value
            }

            let deck = DeckDTO()
            deck.id = remoteDeck.id
            deck.name = remoteDeck.name
            deck.list = remoteDeck.list.compactMap { slot in
                guard let card = remoteCardsByCode[slot.code] else { return nil }
                let copy = CardDTO(copying: card)
                copy.quantity = slot.quantity
                copy.isElite = slot.isElite
                return copy
            }
            return deck
        } catch {
            handleError(error)
            return nil
        }
    }

    func delete(_ item: DeckListItem) async {
        guard let deck = deck(for: item) else { return }

        do {
            try await database.delete(object: deck)
            await loadDecksFromDatabase()
        } catch {
            handleError(error)
        }
    }

    func renameDeck(_ item: DeckListItem, newName: String) async {
        let trimmedName = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty, let deck = deck(for: item) else { return }

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
