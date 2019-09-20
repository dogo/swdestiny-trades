//
//  UIWindow+Testable.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 27/08/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import UIKit

extension UIWindow {

    static func framed(frame: CGRect = CGRect(x: 0, y: 0, width: 375, height: 812)) -> UIWindow {
        return UIWindow(frame: frame)
    }

    func showTestWindow(controller: UIViewController) {
        self.rootViewController = controller
        self.makeKeyAndVisible()
    }

    func cleanTestWindow() {
        self.rootViewController = nil
        self.isHidden = true
    }
}
