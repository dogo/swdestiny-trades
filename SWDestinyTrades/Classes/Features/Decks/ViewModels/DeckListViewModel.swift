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

        var remoteDecks: [DeckDTO] = []
        if authService.isLoggedIn {
            do {
                remoteDecks = try await deckService.retrieveDecks()
            } catch {
                if !ConcurrencyError.isCancellation(error) {
                    toastQueue.enqueue(title: L10n.error, message: error.localizedDescription, type: .error, duration: 2.5)
                }
            }
        }
        remoteDecksByID = remoteDecks.reduce(into: [:]) { decks, deck in
            decks[deck.id] = deck
        }

        updateItems(fetchedDecks.map { DeckListItem(deck: $0) } + remoteDecks.map { DeckListItem(deck: $0, isRemote: true) })
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
                if copy.typeCode == "character", copy.isUnique, slot.quantity > 1 {
                    copy.quantity = 1
                    copy.isElite = true
                } else {
                    copy.quantity = slot.quantity
                    copy.isElite = slot.isElite
                }
                return copy
            }
            return deck
        } catch {
            handleError(error)
            return nil
        }
    }

    func delete(_ item: DeckListItem) async {
        do {
            if let deck = deck(for: item) {
                try await database.delete(object: deck)
            } else if let remoteID = remoteDecksByID[item.id]?.remoteID {
                try await deckService.deleteDeck(remoteID: remoteID)
            } else {
                return
            }
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
