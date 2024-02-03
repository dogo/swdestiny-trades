//
//  CardListViewControllerFactory.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 03/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

final class CardListViewControllerFactory: ViewControllerFactory {

    private let database: DatabaseProtocol?
    private let setDTO: SetDTO

    init(database: DatabaseProtocol?, setDTO: SetDTO) {
        self.database = database
        self.setDTO = setDTO
    }

    func createViewController() -> UIViewController {
        let viewController = CardListViewController()
        let router = CardListNavigator(viewController.navigationController)
        let interactor = CardListInteractor()
        let presenter = CardListPresenter(interactor: interactor,
                                          database: database,
                                          navigator: router,
                                          setDTO: setDTO)
        viewController.presenter = presenter
        return viewController
    }
}
