//
//  DeckListViewControllerFactory.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 21/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

final class DeckListViewControllerFactory: ViewControllerFactory {

    private let database: DatabaseProtocol?

    init(database: DatabaseProtocol?) {
        self.database = database
    }

    func createViewController() -> UIViewController {
        let view = DeckListTableView()
        let viewController = DeckListViewController(with: view)
        let router = DeckListNavigator(viewController)
        let presenter = DeckListPresenter(controller: viewController,
                                          database: database,
                                          navigator: router)
        viewController.presenter = presenter
        view.deckListDelegate = presenter
        return viewController
    }
}
