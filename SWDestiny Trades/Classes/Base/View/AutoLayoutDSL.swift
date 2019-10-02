//
//  AutoLayoutDSL.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 02/10/19.
//  Copyright © 2019 Diogo Autilio. All rights reserved.
//

import UIKit

extension UIView {

    var layout: AutoConstraint {
        return AutoConstraint(view: self)
    }
}

public class AutoConstraint {

    let view: UIView

    init(view: UIView) {
        self.view = view
    }

    public func applyConstraint(_ block: ((UIView) -> Void)) {
        self.view.translatesAutoresizingMaskIntoConstraints = false
        block(self.view)
    }
}
