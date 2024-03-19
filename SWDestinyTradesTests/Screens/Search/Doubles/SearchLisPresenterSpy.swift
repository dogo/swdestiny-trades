//
//  SearchLisPresenterSpy.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 19/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

final class SearchLisPresenterSpy: SearchLisPresenterProtocol {

    private(set) var didCallSetNavigationTitleCount = 0
    func setNavigationTitle() {
        didCallSetNavigationTitleCount += 1
    }

    private(set) var didCallSearchValues: [String] = []
    func search(query: String) {
        didCallSearchValues.append(query)
    }

    private(set) var didCallNavigateToCardDetailValues: [CardDTO] = []
    func navigateToCardDetail(with card: CardDTO) {
        didCallNavigateToCardDetailValues.append(card)
    }
}
