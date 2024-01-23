//
//  CardListNavigator.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 20/04/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import UIKit

final class CardListNavigator: Navigator {

    enum Destination {
        case cardDetail(database: DatabaseProtocol?, with: [CardDTO], card: CardDTO)
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
        case let .cardDetail(database, cardList, card):
            return CardDetailsViewControllerFactory(database: database, cardList: cardList, card: card).createViewController()
        }
    }
}
