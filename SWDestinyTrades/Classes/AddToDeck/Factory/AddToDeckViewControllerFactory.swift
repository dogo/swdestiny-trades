//
//  AddToDeckViewControllerFactory.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 02/01/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

final class AddToDeckViewControllerFactory: ViewControllerFactory {

    private let database: DatabaseProtocol?
    private let deck: DeckDTO?

    init(database: DatabaseProtocol?,
         deck: DeckDTO?) {
        self.database = database
        self.deck = deck
    }

    func createViewController() -> UIViewController {
        let viewController = AddToDeckViewController()
        let router = AddCardNavigator(viewController)
        let interactor = AddToDeckInteractor()
        let presenter = AddToDeckPresenter(view: viewController,
                                           interactor: interactor,
                                           database: database,
                                           navigator: router,
                                           deck: deck)
        viewController.presenter = presenter
        return viewController
    }
}
