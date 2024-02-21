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
        let deckListView = DeckListTableView()
        let viewController = DeckListViewController(with: deckListView, database: database)
        deckListView.deckListDelegate = viewController
        return viewController
    }
}
