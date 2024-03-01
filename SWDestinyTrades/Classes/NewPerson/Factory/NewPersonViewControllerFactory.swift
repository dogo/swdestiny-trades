//
//  NewPersonViewControllerFactory.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 01/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

final class NewPersonViewControllerFactory: ViewControllerFactory {

    private weak var delegate: UpdateTableDataDelegate?

    init(delegate: UpdateTableDataDelegate?) {
        self.delegate = delegate
    }

    func createViewController() -> UIViewController {
        let view = NewPersonView()
        let viewController = NewPersonViewController(with: view)
        let presenter = NewPersonPresenter(controller: viewController,
                                           delegate: delegate)
        viewController.presenter = presenter
        return viewController
    }
}
