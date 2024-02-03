//
//  CardListPresenter.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 03/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation

protocol CardListPresenterProtocol {
    func retrieveCardsList()
    func didSelectCard(cardList: [CardDTO], card: CardDTO)
    func setNavigationTitle()
}

final class CardListPresenter: CardListPresenterProtocol {

    private weak var controller: CardListViewControllerProtocol?
    private let interactor: CardListInteractorProtocol
    private let database: DatabaseProtocol?
    private let navigator: CardListNavigator
    private let setDTO: SetDTO

    init(controller: CardListViewControllerProtocol,
         interactor: CardListInteractorProtocol,
         database: DatabaseProtocol?,
         navigator: CardListNavigator,
         setDTO: SetDTO) {
        self.controller = controller
        self.interactor = interactor
        self.database = database
        self.navigator = navigator
        self.setDTO = setDTO
    }

    func retrieveCardsList() {
        controller?.startLoading()
        Task { [weak self] in
            do {
                guard let self else { return }

                let cardList = try await interactor.retrieveCards(setCode: setDTO.code.lowercased())

                await MainActor.run { [weak self] in
                    self?.controller?.stopLoading()
                    self?.controller?.updateCardList(cardList)
                }
            } catch {
                await MainActor.run { [weak self] in
                    self?.controller?.showNetworkErrorMessage()
                    LoggerManager.shared.log(event: .cardsList, parameters: ["error": error.localizedDescription])
                }
            }
        }
    }

    func didSelectCard(cardList: [CardDTO], card: CardDTO) {
        navigator.navigate(to: .cardDetail(database: database, with: cardList, card: card))
    }

    func setNavigationTitle() {
        controller?.setNavigationTitle(setDTO.name)
    }
}
