//
//  DeckBuilderViewControllerFactory.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 10/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

final class DeckBuilderViewControllerFactory: ViewControllerFactory {

    private let database: DatabaseProtocol?
    private let deckDTO: DeckDTO

    init(database: DatabaseProtocol?,
         deckDTO: DeckDTO) {
        self.database = database
        self.deckDTO = deckDTO
    }

    func createViewController() -> UIViewController {
        let view = DeckBuilderTableView()
        let viewController = DeckBuilderViewController(with: view)
        let router = DeckBuilderNavigator(viewController)
        let presenter = DeckBuilderPresenter(controller: viewController,
                                             database: database,
                                             navigator: router,
                                             deckDTO: deckDTO)
        viewController.presenter = presenter
        view.deckBuilderDelegate = presenter
        return viewController
    }
}
