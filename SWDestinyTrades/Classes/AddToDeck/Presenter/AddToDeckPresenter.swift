//
//  AddToDeckPresenter.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 02/01/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation

protocol AddToDeckPresenterProtocol {
    func retrieveAllCards()
    func insert(card: CardDTO)
    func doingSearch(_ query: String)
    func loadDataFromRealm()
    func navigateToCardDetail(with card: CardDTO)
}

final class AddToDeckPresenter: AddToDeckPresenterProtocol {

    private let interactor: AddToDeckInteractorProtocol
    private let database: DatabaseProtocol?
    private let navigator: AddCardNavigator
    private var cards = [CardDTO]()
    private var deck: DeckDTO?

    private weak var controller: AddToDeckViewProtocol?

    init(controller: AddToDeckViewProtocol,
         interactor: AddToDeckInteractorProtocol,
         database: DatabaseProtocol?,
         navigator: AddCardNavigator,
         deck: DeckDTO?) {
        self.controller = controller
        self.interactor = interactor
        self.database = database
        self.navigator = navigator
        self.deck = deck
    }

    // MARK: - Helpers

    private func insertToDeckBuilder(card: CardDTO) {
        if let deck, !deck.list.contains(where: { $0.code == card.code }) {
            try? database?.update { [weak self] in
                deck.list.append(card)
                self?.controller?.showSuccessMessage(card: card)
            }
            let deckDataDict: [String: DeckDTO] = ["deckDTO": deck]
            NotificationCenter.default.post(name: NotificationKey.reloadTableViewNotification, object: nil, userInfo: deckDataDict)
        } else {
            Task {
                await MainActor.run {
                    ToastMessages.showInfoMessage(title: "", message: L10n.alreadyAdded)
                }
            }
        }
    }
}

extension AddToDeckPresenter {

    @MainActor
    func retrieveAllCards() {
        controller?.startLoading()
        Task { [weak self] in
            guard let self else { return }

            defer {
                controller?.stopLoading()
            }

            do {
                let allCards = try await interactor.fetchAllCards()
                controller?.updateSearchList(allCards)
                cards = allCards
            } catch APIError.requestCancelled {
                // do nothing
            } catch {
                ToastMessages.showNetworkErrorMessage()
                LoggerManager.shared.log(event: .allCards, parameters: ["error": error.localizedDescription])
            }
        }
    }

    func insert(card: CardDTO) {
        let copy = CardDTO(value: card)
        copy.id = NSUUID().uuidString
        copy.quantity = 1

        insertToDeckBuilder(card: copy)
    }

    func doingSearch(_ query: String) {
        controller?.doingSearch(query)
    }

    func loadDataFromRealm() {
        interactor.cancelAllRequests()
        try? database?.fetch(UserCollectionDTO.self, predicate: nil, sorted: nil) { [weak self] collections in
            guard let self, let collection = collections.first else { return }
            cards = Array(collection.myCollection)
            controller?.updateSearchList(cards)
        }
    }

    func navigateToCardDetail(with card: CardDTO) {
        navigator.navigate(to: .cardDetail(database: database, with: cards, card: card))
    }
}
