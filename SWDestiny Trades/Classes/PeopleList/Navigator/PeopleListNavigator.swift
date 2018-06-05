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
        case loanDetail(with: PersonDTO)
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
        case .loanDetail(let person):
            return LoansDetailViewController(person: person)
        }
    }
}
