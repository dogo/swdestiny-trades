//
//  AddCardViewControllerFactory.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 30/12/23.
//  Copyright © 2023 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

final class AddCardViewControllerFactory: ViewControllerFactory {

    private let database: DatabaseProtocol?
    private let addCardType: AddCardType
    private let personDTO: PersonDTO?
    private let userCollectionDTO: UserCollectionDTO?

    init(database: DatabaseProtocol?,
         addCardType: AddCardType,
         personDTO: PersonDTO? = nil,
         userCollectionDTO: UserCollectionDTO? = nil) {
        self.database = database
        self.addCardType = addCardType
        self.personDTO = personDTO
        self.userCollectionDTO = userCollectionDTO
    }

    func createViewController() -> UIViewController {
        let viewController = AddCardViewController()
        let router = AddCardNavigator(viewController)
        let interactor = AddCardInteractor()
        let viewModel = AddCardViewModel(person: personDTO,
                                         userCollection: userCollectionDTO,
                                         type: addCardType)
        let presenter = AddCardPresenter(controller: viewController,
                                         interactor: interactor,
                                         database: database,
                                         navigator: router,
                                         viewModel: viewModel)
        viewController.presenter = presenter
        return viewController
    }
}
