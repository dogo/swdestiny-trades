//
//  DeckBuilderViewModel.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

@MainActor
@Observable
final class DeckBuilderViewModel: BaseViewModel {

    var deck: DeckDTO
    var deckSections: [DeckSection] = []
    var isNewDeck: Bool
    var shareText: String?

    private var database: DatabaseProtocol {
        dependencyContainer.resolve(type: DatabaseProtocol.self)
    }

    init(deck: DeckDTO?, dependencyContainer: DependencyContainer = .shared) {
        if let existingDeck = deck {
            self.deck = existingDeck
            isNewDeck = false
        } else {
            let newDeck = DeckDTO()
            newDeck.name = "New Deck"
            self.deck = newDeck
            isNewDeck = true
        }

        super.init(dependencyContainer: dependencyContainer)
        loadDeckData()
    }

    required init(dependencyContainer: DependencyContainer = .shared) {
        let newDeck = DeckDTO()
        newDeck.name = "New Deck"
        deck = newDeck
        isNewDeck = true
        super.init(dependencyContainer: dependencyContainer)
        loadDeckData()
    }

    func handleViewAppear() async {
        if isNewDeck, !deck.list.isEmpty {
            await saveDeck()
        }
        loadDeckData()
    }

    func loadDeckData() {
        setLoading(true)
        organizeDeckIntoSections()
        setLoading(false)
    }

    private func organizeDeckIntoSections() {
        let cardList = deck.list

        if cardList.isEmpty {
            deckSections = []
            return
        }

        let sectionsByType = SectionsBuilder.byType(cardList: cardList)
        let cardsByType = Split.cardsByType(cardList: cardList, sections: sectionsByType)

        deckSections = cardsByType
            .map { key, value in
                DeckSection(name: key, cards: value, isCollapsed: false)
            }
            .sorted { $0.name < $1.name }
    }

    func saveDeck() async {
        do {
            try Task.checkCancellation()

            if isNewDeck {
                try await database.save(object: deck, update: .modified)
                isNewDeck = false
            } else {
                try await database.save(object: deck, update: .modified)
            }
        } catch is CancellationError {
            // Silently cancel
        } catch {
            handleError(ConcurrencyError.realmAccessError(error))
        }
    }

    func updateCardQuantity(_ card: CardDTO, quantity: Int) {
        Task { @MainActor in
            do {
                try Task.checkCancellation()

                card.quantity = quantity
                try await database.save(object: card, update: .modified)
                self.organizeDeckIntoSections()
            } catch is CancellationError {
                return
            } catch {
                self.handleError(ConcurrencyError.realmAccessError(error))
            }
        }
    }

    func updateCharacterElite(_ card: CardDTO, isElite: Bool) {
        Task { @MainActor in
            do {
                try Task.checkCancellation()

                card.isElite = isElite
                try await database.save(object: card, update: .modified)
                self.organizeDeckIntoSections()
            } catch is CancellationError {
                return
            } catch {
                self.handleError(ConcurrencyError.realmAccessError(error))
            }
        }
    }

    func removeCard(_ card: CardDTO) {
        Task { @MainActor in
            do {
                try Task.checkCancellation()

                let cardIDToRemove = card.id
                self.deck.list.removeAll { $0.id == cardIDToRemove }
                try await database.save(object: self.deck, update: .modified)
                self.organizeDeckIntoSections()
            } catch is CancellationError {
                return
            } catch {
                self.handleError(ConcurrencyError.realmAccessError(error))
            }
        }
    }

    func toggleSection(_ section: DeckSection) {
        if let index = deckSections.firstIndex(where: { $0.id == section.id }) {
            let updatedSection = deckSections[index]
            updatedSection.isCollapsed.toggle()

            var newSections = deckSections
            newSections[index] = updatedSection
            deckSections = newSections
        }
    }

    func prepareShareText() {
        var deckText = "\(deck.name)\n\n"

        for section in deckSections {
            deckText.append(String(format: "%@ (%d)\n", section.name, section.cards.count))
            for card in section.cards {
                deckText.append(String(format: "%d %@\n", card.quantity, card.name))
            }
            deckText.append("\n")
        }

        shareText = deckText
    }

    var totalCardCount: Int {
        return deck.list.reduce(0) { $0 + $1.quantity }
    }

    var uniqueCardCount: Int {
        return deck.list.count
    }

    var isDeckEmpty: Bool {
        return deck.list.isEmpty
    }
}

@Observable
final class DeckSection: Identifiable {
    let id = UUID()
    let name: String
    let cards: [CardDTO]
    var isCollapsed: Bool

    init(name: String, cards: [CardDTO], isCollapsed: Bool) {
        self.name = name
        self.cards = cards
        self.isCollapsed = isCollapsed
    }

    var cardCount: Int {
        return cards.count
    }

    var totalQuantity: Int {
        return cards.reduce(0) { $0 + $1.quantity }
    }
}
