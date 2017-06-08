//
//  UIView+Utils.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 08/06/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    func rotate(toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")

        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards

        self.layer.add(animation, forKey: nil)
    }
}
