//
//  DeckBuilderViewSpy.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 12/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

final class DeckBuilderViewSpy: UIView, DeckBuilderViewType {

    var didSelectCard: (([CardDTO], CardDTO) -> Void)?

    private(set) var didCallUpdateTableViewData = [DeckDTO]()
    func updateTableViewData(deck: DeckDTO) {
        didCallUpdateTableViewData.append(deck)
    }

    private(set) var didCallGetDeckListCount = 0
    var deckList: [DeckBuilderDatasource.Section]?
    func getDeckList() -> [DeckBuilderDatasource.Section]? {
        didCallGetDeckListCount += 1
        return deckList
    }
}
