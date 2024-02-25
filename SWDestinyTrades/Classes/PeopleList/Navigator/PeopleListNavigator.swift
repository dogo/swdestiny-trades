//
//  PeopleListNavigator.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 05/06/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import UIKit

final class PeopleListNavigator: Navigator {
    enum Destination {
        case loanDetail(database: DatabaseProtocol?, with: PersonDTO)
        case newPerson(with: UpdateTableDataDelegate)
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
        case let .loanDetail(database, person):
            return LoansDetailViewControllerFactory(database: database, person: person).createViewController()
        case let .newPerson(delegate):
            let viewController = NewPersonViewController()
            viewController.delegate = delegate
            return viewController
        }
    }
}
