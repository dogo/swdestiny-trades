//
//  NewPersonPresenterSpy.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 28/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

final class NewPersonPresenterSpy: NewPersonPresenterProtocol {

    private(set) var didCallSetNavigationTitleCount = 0
    func setNavigationTitle() {
        didCallSetNavigationTitleCount += 1
    }

    private(set) var didCallSetupNavigationItemsCount = 0
    func setupNavigationItems(completion: ([UIBarButtonItem]?) -> Void) {
        didCallSetupNavigationItemsCount += 1
        completion([])
    }
}
