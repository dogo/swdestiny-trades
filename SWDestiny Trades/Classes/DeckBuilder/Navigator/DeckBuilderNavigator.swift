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
        case .addToDeck(let database, let deck):
            return AddToDeckViewController(database: database, deck: deck)
        case .cardDetail(let database, let cardList, let card):
            return CardDetailViewController(database: database, cardList: cardList, selected: card)
        case .deckGraph(let deck):
            return DeckGraphViewController(deck: deck)
        }
    }
}
