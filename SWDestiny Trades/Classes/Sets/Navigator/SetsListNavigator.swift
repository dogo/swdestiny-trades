//
//  SetsListNavigator.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 20/04/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import UIKit

final class SetsListNavigator: Navigator {

    enum Destination {
        case about
        case cardList(database: DatabaseProtocol?, with: SetDTO)
        case search(database: DatabaseProtocol?)
    }

    private weak var navigationController: UINavigationController?

    // MARK: - Initializer

    init(_ navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    // MARK: - Navigator

    func navigate(to destination: Destination) {
        let viewController = makeViewController(for: destination)
        navigationController?.pushViewController(viewController, animated: true)
    }

    // MARK: - Private

    private func makeViewController(for destination: Destination) -> UIViewController {
        switch destination {
        case .about:
            return AboutViewController()
        case .cardList(let database, let set):
            return CardListViewController(database: database, with: set)
        case .search(let database):
            return SearchListViewController(database: database)
        }
    }
}
