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

    private weak var viewController: UIViewController?

    // MARK: - Initializer

    init(_ viewController: UIViewController?) {
        self.viewController = viewController
    }

    // MARK: - Navigator

    func navigate(to destination: Destination) {
        viewController?.navigationController?.pushViewController(makeViewController(for: destination), animated: true)
    }

    // MARK: - Private

    private func makeViewController(for destination: Destination) -> UIViewController {
        switch destination {
        case let .cardDetail(database, cardList, card):
            return CardDetailViewControllerFactory(database: database,
                                                   cardList: cardList,
                                                   card: card)
                .createViewController()
        case let .addCard(database, person, type):
            return AddCardViewControllerFactory(database: database,
                                                addCardType: type,
                                                personDTO: person)
                .createViewController()
        }
    }
}
