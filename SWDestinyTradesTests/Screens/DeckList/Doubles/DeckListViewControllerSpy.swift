//
//  DeckListViewControllerSpy.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 21/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

final class DeckListViewControllerSpy: UIViewController, DeckListViewControllerProtocol {

    private(set) var didCallUpdateTableViewData = [DeckDTO]()
    func updateTableViewData(deckList: [DeckDTO]) {
        didCallUpdateTableViewData.append(contentsOf: deckList)
    }

    private(set) var didCallInsert = [DeckDTO]()
    func insert(deck: DeckDTO) {
        didCallInsert.append(deck)
    }

    private(set) var didCallSetNavigationTitle = [String]()
    func setNavigationTitle(_ title: String) {
        didCallSetNavigationTitle.append(title)
    }
}
