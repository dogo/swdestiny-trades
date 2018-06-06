//
//  SnapKit+SafeArea.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 05/06/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import UIKit

extension UIView {

    public var safeArea: UILayoutGuide {
        guard #available(iOS 11.0, *) else {
            return self.layoutMarginsGuide
        }
        return self.safeAreaLayoutGuide
    }
}
