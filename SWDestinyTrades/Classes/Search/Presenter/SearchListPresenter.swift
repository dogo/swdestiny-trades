//
//  SearchListPresenter.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 18/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

protocol SearchLisPresenterProtocol: AnyObject {
    func setNavigationTitle()
    func search(query: String)
    func navigateToCardDetail(with card: CardDTO)
}

final class SearchListPresenter: SearchLisPresenterProtocol {

    private let interactor: SearchListInteractorProtocol
    private let database: DatabaseProtocol?
    private let navigator: SearchNavigator

    private var cards = [CardDTO]()

    private weak var controller: SearchListViewControllerProtocol?

    init(controller: SearchListViewControllerProtocol?,
         interactor: SearchListInteractorProtocol,
         database: DatabaseProtocol?,
         navigator: SearchNavigator) {
        self.controller = controller
        self.interactor = interactor
        self.database = database
        self.navigator = navigator
    }

    func setNavigationTitle() {
        controller?.setNavigationTitle(L10n.search)
    }

    func search(query: String) {
        controller?.startLoading()
        Task { [weak self] in
            guard let self else { return }

            do {
                let allCards = try await interactor.search(query: query)
                cards = allCards

                await MainActor.run { [weak self] in
                    self?.controller?.updateTableViewData(allCards)
                    self?.controller?.stopLoading()
                }
            } catch {
                await MainActor.run { [weak self] in
                    self?.controller?.showNetworkErrorMessage()
                    self?.controller?.stopLoading()
                    LoggerManager.shared.log(event: .allCards, parameters: ["error": error.localizedDescription])
                }
            }
        }
    }

    func navigateToCardDetail(with card: CardDTO) {
        navigator.navigate(to: .cardDetail(database: database, with: cards, card: card))
    }
}
