//
//  NewPersonViewControllerSpy.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 28/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

final class NewPersonViewControllerSpy: UIViewController, NewPersonViewControllerProtocol {

    private(set) var didCallSetNavigationTitle = [String]()
    func setNavigationTitle(_ title: String) {
        didCallSetNavigationTitle.append(title)
    }

    private(set) var didCallRetriveUserInputCount = 0
    func retriveUserInput() -> (name: String, lastName: String) {
        didCallRetriveUserInputCount += 1
        return ("name", "lastName")
    }

    private(set) var didCallCloseViewControllerCount = 0
    func closeViewController() {
        didCallCloseViewControllerCount += 1
    }
}
