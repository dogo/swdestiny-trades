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

    private weak var viewController: UIViewController?

    // MARK: - Initializer

    init(_ viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - Navigator

    func navigate(to destination: Destination) {
        viewController?.navigationController?.pushViewController(makeViewController(for: destination), animated: true)
    }

    // MARK: - Private

    private func makeViewController(for destination: Destination) -> UIViewController {
        switch destination {
        case .about:
            return AboutViewControllerFactory().createViewController()
        case let .cardList(database, set):
            return CardListViewControllerFactory(database: database, setDTO: set).createViewController()
        case let .search(database):
            return SearchListViewController(database: database)
        }
    }
}
