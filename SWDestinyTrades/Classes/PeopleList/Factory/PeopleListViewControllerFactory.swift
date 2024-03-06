//
//  PeopleListViewControllerFactory.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 04/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

final class PeopleListViewControllerFactory: ViewControllerFactory {

    private let database: DatabaseProtocol?

    init(database: DatabaseProtocol?) {
        self.database = database
    }

    func createViewController() -> UIViewController {
        let view = PeopleListTableView()
        let viewController = PeopleListViewController(with: view)
        let router = PeopleListNavigator(viewController)
        let presenter = PeopleListPresenter(controller: viewController,
                                            database: database,
                                            navigator: router)
        viewController.presenter = presenter
        view.peopleListDelegate = presenter
        return viewController
    }
}
