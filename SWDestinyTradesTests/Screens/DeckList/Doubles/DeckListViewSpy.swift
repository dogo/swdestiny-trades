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

final class DeckListViewSpy: UITableView, DeckListViewType {

    var didSelectDeck: ((DeckDTO) -> Void)?

    private(set) var didCallUpdateTableViewData = [DeckDTO]()
    func updateTableViewData(decksList: [DeckDTO]) {
        didCallUpdateTableViewData.append(contentsOf: decksList)
    }

    private(set) var didCallInsert = [DeckDTO]()
    func insert(deck: DeckDTO) {
        didCallInsert.append(deck)
    }

    private(set) var didCallReloadDataCount = 0
    override func reloadData() {
        super.reloadData()
        didCallReloadDataCount += 1
    }
}
