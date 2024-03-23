//
//  UserCollectionViewControllerFactory.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 22/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

final class UserCollectionViewControllerFactory: ViewControllerFactory {

    private let database: DatabaseProtocol?

    init(database: DatabaseProtocol?) {
        self.database = database
    }

    func createViewController() -> UIViewController {
        let view = UserCollectionTableView()
        let viewController = UserCollectionViewController(with: view, database: database)
        return viewController
    }
}
