//
//  UIView+Testable.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 14/10/21.
//  Copyright © 2021 Diogo Autilio. All rights reserved.
//

import UIKit

extension UIView {

    func viewWith(accessibilityIdentifier: String) -> UIView? {
        if self.accessibilityIdentifier == accessibilityIdentifier {
            return self
        } else {
            for view in subviews {
                if let childView = view.viewWith(accessibilityIdentifier: accessibilityIdentifier) {
                    return childView
                }
            }
        }
        return nil
    }
}
