//
//  AddToDeckViewModel.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 12/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

@MainActor
@Observable
final class AddToDeckViewModel: ListViewModel<CardDTO> {

    private(set) var deck: DeckDTO
    private(set) var isLoadingFromRemote = false
    private(set) var dataSource: DataSource = .remote

    private(set) var loadTask: Task<Void, Never>?

    enum DataSource {
        case remote
        case local
    }

    private var service: SWDestinyServiceProtocol {
        dependencyContainer.resolve(type: SWDestinyServiceProtocol.self)
    }

    private var database: DatabaseProtocol {
        dependencyContainer.resolve(type: DatabaseProtocol.self)
    }

    init(deck: DeckDTO, dependencyContainer: DependencyContainer = .shared) {
        self.deck = deck
        super.init(dependencyContainer: dependencyContainer)
    }

    required init(dependencyContainer: DependencyContainer = .shared) {
        deck = DeckDTO()
        super.init(dependencyContainer: dependencyContainer)
    }

    override func filterItems(searchText: String) -> [CardDTO] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { card in
                card.name.localizedCaseInsensitiveContains(searchText) ||
                    card.subtitle.localizedCaseInsensitiveContains(searchText) ||
                    card.typeCode.localizedCaseInsensitiveContains(searchText) ||
                    card.setCode.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    func loadRemoteCards() {
        loadTask?.cancel()
        dataSource = .remote
        setLoading(true)

        loadTask = Task { @MainActor in
            do {
                try Task.checkCancellation()

                let cards = try await service.retrieveAllCards()

                try Task.checkCancellation()

                self.updateItems(cards)
                self.setLoaded()
            } catch is CancellationError {
                self.setLoaded()
            } catch {
                self.handleError(error)
            }
        }
    }

    func loadLocalCards() {
        loadTask?.cancel()
        dataSource = .local
        setLoading(true)

        loadTask = Task { @MainActor in
            do {
                try Task.checkCancellation()
                let collections = await database.fetch(UserCollectionDTO.self, predicate: nil, sorted: nil)
                guard let collection = collections.first else {
                    self.setLoaded()
                    return
                }

                let cards = collection.myCollection
                self.updateItems(cards)
                self.setLoaded()
            } catch is CancellationError {
                self.setLoaded()
            } catch {
                self.handleError(ConcurrencyError.realmAccessError(error))
            }
        }
    }

    func awaitCurrentLoad() async {
        await loadTask?.value
    }

    func addCardToDeck(_ card: CardDTO) {
        if deck.list.contains(where: { $0.code == card.code }) {
            toastQueue.enqueue(title: "", message: L10n.alreadyAdded, type: .info, duration: 1.5)
            return
        }

        let cardCopy = CardDTO(copying: card)
        cardCopy.id = UUID().uuidString
        cardCopy.quantity = 1

        Task { @MainActor in
            do {
                self.deck.list.append(cardCopy)
                try await database.save(object: self.deck, update: .modified)

                toastQueue.enqueue(title: L10n.added, message: card.name, type: .success)
            } catch {
                self.handleError(ConcurrencyError.realmAccessError(error))
            }
        }
    }

    override func handleError(_ error: Error) {
        guard !ConcurrencyError.isCancellation(error) else { return }
        super.handleError(error)
    }
}
