//
//  NewPersonView+Mirror.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 29/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

extension NewPersonView {

    var firstNameTextField: FloatingTextfield {
        Mirror.extract(variable: "firstNameTextField", from: self)!
    }

    var lastNameTextField: FloatingTextfield {
        Mirror.extract(variable: "lastNameTextField", from: self)!
    }
}
