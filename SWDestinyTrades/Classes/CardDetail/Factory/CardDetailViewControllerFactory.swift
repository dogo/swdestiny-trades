//
//  CardDetailViewControllerFactory.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 23/01/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

final class CardDetailViewControllerFactory: ViewControllerFactory {

    private let database: DatabaseProtocol?
    private let cardList: [CardDTO]
    private let card: CardDTO

    init(database: DatabaseProtocol?,
         cardList: [CardDTO],
         card: CardDTO) {
        self.database = database
        self.cardList = cardList
        self.card = card
    }

    func createViewController() -> UIViewController {
        let viewController = CardDetailViewController()
        let presenter = CardDetailPresenter(controller: viewController,
                                            database: database,
                                            cardList: cardList,
                                            selected: card)
        viewController.presenter = presenter
        return viewController
    }
}
