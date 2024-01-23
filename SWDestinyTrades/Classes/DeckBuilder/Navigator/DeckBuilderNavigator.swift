//
//  DeckBuilderNavigator.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 05/06/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import UIKit

final class DeckBuilderNavigator: Navigator {
    enum Destination {
        case addToDeck(database: DatabaseProtocol?, with: DeckDTO)
        case cardDetail(database: DatabaseProtocol?, with: [CardDTO], card: CardDTO)
        case deckGraph(with: DeckDTO)
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
        case let .addToDeck(database, deck):
            return AddToDeckViewControllerFactory(database: database, deck: deck).createViewController()
        case let .cardDetail(database, cardList, card):
            return CardDetailsViewControllerFactory(database: database, cardList: cardList, card: card).createViewController()
        case let .deckGraph(deck):
            return DeckGraphViewController(deck: deck)
        }
    }
}
