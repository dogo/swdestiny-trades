//
//  DeckListViewSpy.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 23/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

final class DeckListViewSpy: UIView, DeckListViewType {

    var didSelectDeck: ((DeckDTO) -> Void)?

    private(set) var didCallUpdateTableViewData = [DeckDTO]()
    func updateTableViewData(decksList: [DeckDTO]) {
        didCallUpdateTableViewData.append(contentsOf: decksList)
    }

    private(set) var didCallRefreshDataCount = 0
    func refreshData() {
        didCallRefreshDataCount += 1
    }

    private(set) var didCallInsert = [DeckDTO]()
    func insert(deck: DeckDTO) {
        didCallInsert.append(deck)
    }
}
