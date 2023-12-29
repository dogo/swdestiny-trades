//
//  AboutViewControllerFactory.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 29/12/23.
//  Copyright © 2023 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

final class AboutViewControllerFactory: ViewControllerFactory {

    func createViewController() -> UIViewController {
        let viewController = AboutViewController()
        let router = AboutNavigator(viewController)
        let presenter = AboutPresenter(navigator: router)
        viewController.presenter = presenter
        return viewController
    }
}
