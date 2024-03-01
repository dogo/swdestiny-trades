//
//  NewPersonViewSpy.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 29/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

final class NewPersonViewSpy: UIView, NewPersonViewType {

    private(set) var didCallRetriveUserInputCount = 0
    var userInput: (name: String, lastName: String) = ("", "")
    func retriveUserInput() -> (name: String, lastName: String) {
        didCallRetriveUserInputCount += 1
        return userInput
    }
}
