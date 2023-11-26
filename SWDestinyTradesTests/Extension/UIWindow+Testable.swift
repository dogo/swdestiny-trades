//
//  UIWindow+Testable.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 27/08/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import UIKit

extension UIWindow {

    func showTestWindow(controller: UIViewController) {
        rootViewController = controller
        makeKeyAndVisible()
    }

    func cleanTestWindow() {
        rootViewController = nil
        isHidden = true
    }
}
