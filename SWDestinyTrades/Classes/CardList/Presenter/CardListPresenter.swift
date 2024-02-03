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
}

final class CardListPresenter: CardListPresenterProtocol {

    private let interactor: CardListInteractorProtocol
    private let database: DatabaseProtocol?
    private let navigator: CardListNavigator
    private let setDTO: SetDTO

    init(interactor: CardListInteractorProtocol,
         database: DatabaseProtocol?,
         navigator: CardListNavigator,
         setDTO: SetDTO) {
        self.interactor = interactor
        self.database = database
        self.navigator = navigator
        self.setDTO = setDTO
    }

    func retrieveCardsList() {
        // cardListView.activityIndicator.startAnimating()
        Task { [weak self] in
            guard let self else { return }

//            defer {
//                self.cardListView.activityIndicator.stopAnimating()
//            }

            do {
                let cardList = try await interactor.retrieveCards(setCode: setDTO.code.lowercased())
                // cardListView.cardListTableView.updateCardList(cardList)
            } catch {
                await MainActor.run {
                    ToastMessages.showNetworkErrorMessage()
                    LoggerManager.shared.log(event: .cardsList, parameters: ["error": error.localizedDescription])
                }
            }
        }
    }

    func didSelectCard(cardList: [CardDTO], card: CardDTO) {
        navigator.navigate(to: .cardDetail(database: database, with: cardList, card: card))
    }
}
