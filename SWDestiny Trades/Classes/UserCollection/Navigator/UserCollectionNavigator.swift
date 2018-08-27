//
//  UserCollectionNavigator.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 05/06/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import UIKit

final class UserCollectionNavigator: Navigator {

    enum Destination {
        case cardDetail(with: [CardDTO], card: CardDTO)
        case addCard(with: UserCollectionDTO)
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
        case .cardDetail(let cardList, let card):
            return CardDetailViewController(cardList: cardList, selected: card)
        case .addCard(let userCollection):
            return AddCardViewController(userCollection: userCollection, type: .collection)
        }
    }
}
