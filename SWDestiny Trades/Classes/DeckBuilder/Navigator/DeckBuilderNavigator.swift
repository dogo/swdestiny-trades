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
        case addToDeck(with: DeckDTO)
        case cardDetail(with: [CardDTO], card: CardDTO)
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
        case .addToDeck(let deck):
            return AddToDeckViewController(deck: deck)
        case .cardDetail(let cardList, let card):
            return CardDetailViewController(cardList: cardList, selected: card)
        case .deckGraph(let deck):
            return DeckGraphViewController(deck: deck)
        }
    }
}
