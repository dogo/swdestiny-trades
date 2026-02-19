//
//  AddToDeckViewModel.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 12/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Combine
import SwiftUI

@MainActor
@Observable
final class AddToDeckViewModel: ListViewModel<CardDTO> {

    private(set) var deck: DeckDTO
    private(set) var isLoadingFromRemote = false
    private(set) var dataSource: DataSource = .remote

    var showToast = false
    var toastTitle = ""
    var toastMessage = ""
    var toastType: ToastType = .info

    private var loadTask: Task<Void, Never>?

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

                let cards = Array(collection.myCollection)
                self.updateItems(cards)
                self.setLoaded()
            } catch is CancellationError {
                self.setLoaded()
            } catch {
                self.handleError(ConcurrencyError.realmAccessError(error))
            }
        }
    }

    func addCardToDeck(_ card: CardDTO) {
        if deck.list.contains(where: { $0.code == card.code }) {
            toastTitle = ""
            toastMessage = L10n.alreadyAdded
            toastType = .info
            showToast = true
            return
        }

        let cardCopy = CardDTO(value: card)
        cardCopy.id = NSUUID().uuidString
        cardCopy.quantity = 1

        Task { @MainActor in
            do {
                try await database.update { [weak self] in
                    self?.deck.list.append(cardCopy)
                }

                self.toastTitle = L10n.added
                self.toastMessage = card.name
                self.toastType = .success
                self.showToast = true

                let deckDataDict: [String: DeckDTO] = ["deckDTO": self.deck]
                NotificationCenter.default.post(name: NotificationKey.reloadTableViewNotification, object: nil, userInfo: deckDataDict)
            } catch {
                self.handleError(ConcurrencyError.realmAccessError(error))
            }
        }
    }

    override func handleError(_ error: Error) {
        super.handleError(error)

        if ConcurrencyError.isCancellation(error) {
            return
        }

        toastTitle = L10n.error
        toastMessage = L10n.errorMessage
        toastType = .error
        showToast = true
    }
}
