//
//  UITextInput+Utils.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 24/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import UIKit

extension UITextField {

    var nonOptionalText: String {
        return text ?? ""
    }
}

extension UISearchBar {

    var nonOptionalText: String {
        return text ?? ""
    }
}
