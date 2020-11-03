//
//  LoanDetailNavigator.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 05/06/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import UIKit

final class LoanDetailNavigator: Navigator {
    enum Destination {
        case cardDetail(database: DatabaseProtocol?, with: [CardDTO], card: CardDTO)
        case addCard(database: DatabaseProtocol?, with: PersonDTO, type: AddCardType)
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
            return CardDetailViewController(database: database, cardList: cardList, selected: card)
        case let .addCard(database, person, type):
            return AddCardViewController(database: database, person: person, type: type)
        }
    }
}
