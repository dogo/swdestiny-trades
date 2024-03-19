//
//  SearchListViewControllerFactory.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 19/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

final class SearchListViewControllerFactory: ViewControllerFactory {

    private let database: DatabaseProtocol?

    init(database: DatabaseProtocol?) {
        self.database = database
    }

    func createViewController() -> UIViewController {
        let viewController = SearchListViewController()
        let router = SearchNavigator(viewController)
        let interactor = SearchListInteractor()
        let presenter = SearchListPresenter(controller: viewController,
                                            interactor: interactor,
                                            database: database,
                                            navigator: router)
        viewController.presenter = presenter
        return viewController
    }
}
