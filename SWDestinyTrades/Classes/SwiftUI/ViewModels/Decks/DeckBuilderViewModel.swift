//
//  DeckBuilderViewModel.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Combine
import SwiftUI

@MainActor
final class DeckBuilderViewModel: BaseViewModel {

    @Published var deck: DeckDTO
    @Published var deckSections: [DeckSection] = []
    @Published var isNewDeck: Bool
    @Published var showingShareSheet = false
    @Published var shareText = ""

    private var database: DatabaseProtocol? {
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
        setupNotificationObserver()
    }

    required init(dependencyContainer: DependencyContainer = .shared) {
        let newDeck = DeckDTO()
        newDeck.name = "New Deck"
        deck = newDeck
        isNewDeck = true
        super.init(dependencyContainer: dependencyContainer)
        loadDeckData()
        setupNotificationObserver()
    }

    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDeckReload(_:)),
            name: NotificationKey.reloadTableViewNotification,
            object: nil
        )
    }

    @objc
    private func handleDeckReload(_ notification: Notification) {
        if isNewDeck, !deck.list.isEmpty {
            Task {
                await saveDeck()
            }
        }
        loadDeckData()
    }

    func loadDeckData() {
        setLoading(true)
        organizeDeckIntoSections()
        setLoading(false)
    }

    private func organizeDeckIntoSections() {
        let cardList = Array(deck.list)

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
        guard let database else {
            handleError(ViewModelError.databaseNotAvailable)
            return
        }

        do {
            if isNewDeck {
                try await database.save(object: deck, update: .modified)
                isNewDeck = false
            } else {
                try await database.update {}
            }
        } catch {
            handleError(ConcurrencyError.realmAccessError(error))
        }
    }

    func updateCardQuantity(_ card: CardDTO, quantity: Int) {
        guard let database else {
            handleError(ViewModelError.databaseNotAvailable)
            return
        }

        Task { @MainActor in
            do {
                try Task.checkCancellation()

                try await database.update {
                    card.quantity = quantity
                }

                self.organizeDeckIntoSections()
            } catch is CancellationError {
                return
            } catch {
                self.handleError(ConcurrencyError.realmAccessError(error))
            }
        }
    }

    func updateCharacterElite(_ card: CardDTO, isElite: Bool) {
        guard let database else {
            handleError(ViewModelError.databaseNotAvailable)
            return
        }

        Task { @MainActor in
            do {
                try Task.checkCancellation()

                try await database.update {
                    card.isElite = isElite
                }

                self.organizeDeckIntoSections()
            } catch is CancellationError {
                return
            } catch {
                self.handleError(ConcurrencyError.realmAccessError(error))
            }
        }
    }

    func removeCard(_ card: CardDTO) {
        guard let database else {
            handleError(ViewModelError.databaseNotAvailable)
            return
        }

        Task { @MainActor in
            do {
                try Task.checkCancellation()

                if let index = self.deck.list.index(of: card) {
                    try await database.update {
                        self.deck.list.remove(at: index)
                    }

                    self.organizeDeckIntoSections()
                }
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
        showingShareSheet = true
    }

    var totalCardCount: Int {
        return deck.list.sum(ofProperty: "quantity") as Int
    }

    var uniqueCardCount: Int {
        return deck.list.count
    }

    var isDeckEmpty: Bool {
        return deck.list.isEmpty
    }
}

final class DeckSection: ObservableObject, Identifiable {
    let id = UUID()
    let name: String
    let cards: [CardDTO]
    @Published var isCollapsed: Bool

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
