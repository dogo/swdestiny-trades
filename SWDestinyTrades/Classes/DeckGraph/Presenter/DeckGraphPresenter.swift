//
//  DeckGraphPresenter.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 15/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation

protocol DeckGraphPresenterProtocol: AnyObject {
    func updateCollecionViewData()
    func setNavigationTitle()
}

final class DeckGraphPresenter: DeckGraphPresenterProtocol {

    private weak var controller: DeckGraphViewControllerProtocol?
    private let deckDTO: DeckDTO

    init(controller: DeckGraphViewControllerProtocol,
         deckDTO: DeckDTO) {
        self.controller = controller
        self.deckDTO = deckDTO
    }

    func updateCollecionViewData() {
        controller?.updateCollecionViewData(deck: deckDTO)
    }

    func setNavigationTitle() {
        controller?.setNavigationTitle(L10n.deckStatistics)
    }
}
