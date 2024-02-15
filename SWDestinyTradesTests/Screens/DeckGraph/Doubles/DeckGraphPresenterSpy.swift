//
//  DeckGraphPresenterSpy.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 15/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

final class DeckGraphPresenterSpy: DeckGraphPresenterProtocol {

    private(set) var didCallUpdateCollecionViewDataCount = 0
    func updateCollecionViewData() {
        didCallUpdateCollecionViewDataCount += 1
    }

    private(set) var didCallSetNavigationTitleCount = 0
    func setNavigationTitle() {
        didCallSetNavigationTitleCount += 1
    }
}
