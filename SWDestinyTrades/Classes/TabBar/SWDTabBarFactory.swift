//
//  SWDTabBarFactory.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 28/11/23.
//  Copyright © 2023 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

protocol ViewControllerFactory {
    func createViewController() -> UIViewController
}

final class SWDTabBarFactory {

    func makeSetsList(with database: DatabaseProtocol?) -> UIViewController {
        let viewController = SetsListViewController()
        let router = SetsListNavigator(viewController)
        let interactor = SetsListInteractor()
        let presenter = SetsListPresenter(controller: viewController,
                                          interactor: interactor,
                                          database: database,
                                          navigator: router)
        viewController.presenter = presenter
        return viewController
    }

    func makeDeckList(with database: DatabaseProtocol?) -> UIViewController {
        let factory = DeckListViewControllerFactory(database: database)
        return factory.createViewController()
    }
}
