//
//  LoansDetailViewControllerFactory.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 25/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

final class LoansDetailViewControllerFactory: ViewControllerFactory {

    private let database: DatabaseProtocol?
    private let person: PersonDTO

    init(database: DatabaseProtocol?, person: PersonDTO) {
        self.database = database
        self.person = person
    }

    func createViewController() -> UIViewController {
        let view = LoanDetailTableView()
        let viewController = LoansDetailViewController(with: view)
        let router = LoanDetailNavigator(viewController)
        let presenter = LoansDetailPresenter(controller: viewController,
                                             database: database,
                                             person: person,
                                             navigator: router)
        viewController.presenter = presenter
        view.loansDetailDelegate = presenter
        return viewController
    }
}
