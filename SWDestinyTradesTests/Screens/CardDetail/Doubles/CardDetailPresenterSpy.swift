//
//  CardDetailPresenterSpy.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 25/01/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

final class CardDetailPresenterSpy: CardDetailPresenterProtocol {

    private(set) var didCallViewDidLoadCount = 0
    func viewDidLoad() {
        didCallViewDidLoadCount += 1
    }

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
