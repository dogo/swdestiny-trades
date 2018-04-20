//
//  SetsListNavigator.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 20/04/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import UIKit

class SetsListNavigator: Navigator {

    enum Destination {
        case about
        case cardList(with: SetDTO)
        case search
    }

    private weak var navigationController: UINavigationController?

    // MARK: - Initializer

    init(navigationController: UINavigationController?) {
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
        case .cardList(let set):
            return CardListViewController(with: set)
        case .search:
            return SearchListViewController()
        }
    }
}
