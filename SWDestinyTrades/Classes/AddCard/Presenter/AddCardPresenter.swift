//
//  AddCardPresenter.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 30/12/23.
//  Copyright © 2023 Diogo Autilio. All rights reserved.
//

import Foundation

protocol AddCardPresenterProtocol {
    func fetchAllCards()
    func insert(card: CardDTO)
    func doingSearch(_ query: String)
    func cardDetailButtonTouched(with card: CardDTO)
}

final class AddCardPresenter: AddCardPresenterProtocol {

    private let interactor: AddCardInteractorProtocol
    private let database: DatabaseProtocol?
    private let navigator: AddCardNavigator
    private let viewModel: AddCardViewModel

    private weak var view: AddCardViewProtocol?
    private var cards = [CardDTO]()

    init(view: AddCardViewProtocol,
         interactor: AddCardInteractorProtocol,
         database: DatabaseProtocol?,
         navigator: AddCardNavigator,
         viewModel: AddCardViewModel) {
        self.view = view
        self.interactor = interactor
        self.database = database
        self.navigator = navigator
        self.viewModel = viewModel
    }

    @MainActor
    func fetchAllCards() {
        view?.startLoading()
        Task { [weak self] in
            guard let self else { return }
            do {
                let allCards = try await self.interactor.retrieveAllCards()
                self.view?.stopLoading()
                self.view?.updateSearchList(allCards)
                self.cards = allCards
            } catch {
                ToastMessages.showNetworkErrorMessage()
                LoggerManager.shared.log(event: .allCards, parameters: ["error": error.localizedDescription])
            }
        }
    }

    func insert(card: CardDTO) {
        switch viewModel.type {
        case .lent:
            insertToLentMe(card: card)
        case .borrow:
            insertToBorrowed(card: card)
        case .collection:
            insertToCollection(card: card)
        }
    }

    func doingSearch(_ query: String) {
        view?.doingSearch(query)
    }

    func cardDetailButtonTouched(with card: CardDTO) {
        navigator.navigate(to: .cardDetail(database: database, with: cards, card: card))
    }

    // MARK: - Helpers

    private func insertToBorrowed(card: CardDTO) {
        if let person = viewModel.person, !person.borrowed.contains(where: { $0.code == card.code }) {
            try? database?.update { [weak self] in
                person.borrowed.append(card)
                self?.view?.showSuccessMessage(card: card)
            }
            let personDataDict: [String: PersonDTO] = ["personDTO": person]
            NotificationCenter.default.post(name: NotificationKey.reloadTableViewNotification, object: nil, userInfo: personDataDict)
        } else {
            view?.showErrorMessage()
        }
    }

    private func insertToLentMe(card: CardDTO) {
        if let person = viewModel.person, !person.lentMe.contains(where: { $0.code == card.code }) {
            try? database?.update { [weak self] in
                person.lentMe.append(card)
                self?.view?.showSuccessMessage(card: card)
            }
            let personDataDict: [String: PersonDTO] = ["personDTO": person]
            NotificationCenter.default.post(name: NotificationKey.reloadTableViewNotification, object: nil, userInfo: personDataDict)
        } else {
            view?.showErrorMessage()
        }
    }

    private func insertToCollection(card: CardDTO) {
        if let userCollection = viewModel.userCollection, !userCollection.myCollection.contains(where: { $0.code == card.code }) {
            try? database?.update { [weak self] in
                userCollection.myCollection.append(card)
                self?.view?.showSuccessMessage(card: card)
            }
        } else {
            view?.showErrorMessage()
        }
    }
}
