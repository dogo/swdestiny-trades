//
//  DeckBuilderViewControllerSpy.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 11/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

final class DeckBuilderViewControllerSpy: UIViewController, DeckBuilderViewControllerProtocol {

    private(set) var didCallUpdateTableViewData = [DeckDTO]()
    func updateTableViewData(deck: DeckDTO) {
        didCallUpdateTableViewData.append(deck)
    }

    private(set) var didCallgetDeckListCount = 0
    var deckList: [DeckBuilderDatasource.Section]?
    func getDeckList() -> [DeckBuilderDatasource.Section]? {
        didCallgetDeckListCount += 1
        return deckList
    }

    private(set) var didCallPresentViewController = [(controller: UIViewController, animated: Bool)]()
    func presentViewController(_ controller: UIViewController, animated: Bool) {
        didCallPresentViewController.append((controller, animated))
    }

    private(set) var didCallSetNavigationTitle = [String]()
    func setNavigationTitle(_ title: String) {
        didCallSetNavigationTitle.append(title)
    }
}
