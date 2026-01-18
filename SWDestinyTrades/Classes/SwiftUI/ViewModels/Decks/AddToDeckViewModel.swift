//
//  AddToDeckViewModel.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 12/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Combine
import SwiftUI

final class AddToDeckViewModel: ListViewModel<CardDTO> {

    @Published private(set) var deck: DeckDTO
    @Published private(set) var isLoadingFromRemote = false
    @Published private(set) var dataSource: DataSource = .remote

    @Published var showToast = false
    @Published var toastTitle = ""
    @Published var toastMessage = ""
    @Published var toastType: ToastType = .info

    enum DataSource {
        case remote
        case local
    }

    private var swDestinyService: SWDestinyServiceProtocol? {
        dependencyContainer.resolve(type: SWDestinyServiceProtocol.self)
    }

    private var database: DatabaseProtocol? {
        dependencyContainer.resolve(type: DatabaseProtocol.self)
    }

    init(deck: DeckDTO, dependencyContainer: DependencyContainer = .shared) {
        self.deck = deck
        super.init(dependencyContainer: dependencyContainer)
        loadRemoteCards()
    }

    required init(dependencyContainer: DependencyContainer = .shared) {
        deck = DeckDTO()
        super.init(dependencyContainer: dependencyContainer)
        loadRemoteCards()
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
        dataSource = .remote
        setLoading(true)

        Task { @MainActor in
            do {
                try Task.checkCancellation()

                guard let service = swDestinyService else {
                    handleError(ViewModelError.serviceNotAvailable)
                    return
                }

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
        dataSource = .local
        setLoading(true)

        Task { @MainActor in
            do {
                try Task.checkCancellation()

                guard let database else {
                    handleError(ViewModelError.databaseNotAvailable)
                    return
                }

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
            showToast = false
            toastTitle = ""
            toastMessage = L10n.alreadyAdded
            toastType = .info

            Task { @MainActor in
                do {
                    try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
                    self.showToast = true
                } catch {
                    // Ignore cancellation during toast delay
                }
            }
            return
        }

        let cardCopy = CardDTO(value: card)
        cardCopy.id = NSUUID().uuidString
        cardCopy.quantity = 1

        guard let database else {
            handleError(ViewModelError.databaseNotAvailable)
            return
        }

        Task { @MainActor in
            do {
                try await database.update { [weak self] in
                    self?.deck.list.append(cardCopy)
                }

                self.showToast = false
                self.toastTitle = L10n.added
                self.toastMessage = card.name
                self.toastType = .success

                try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
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

        showToast = false

        if ConcurrencyError.isCancellation(error) {
            return
        }

        toastTitle = "Error"
        toastMessage = L10n.errorMessage
        toastType = .error

        Task { @MainActor in
            do {
                try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
                self.showToast = true
            } catch {
                // Ignore cancellation during toast delay
            }
        }
    }
}
