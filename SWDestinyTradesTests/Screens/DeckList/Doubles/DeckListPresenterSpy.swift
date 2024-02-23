//
//  DeckListPresenterSpy.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 23/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

final class DeckListPresenterSpy: DeckListPresenterProtocol, DeckListProtocol {

    private(set) var didCallSetupNavigationItemsCount = 0
    func setupNavigationItems(completion: ([UIBarButtonItem]?) -> Void) {
        didCallSetupNavigationItemsCount += 1
        completion([])
    }

    private(set) var didCallSetNavigationTitleCount = 0
    func setNavigationTitle() {
        didCallSetNavigationTitleCount += 1
    }

    private(set) var didCallLoadDataFromRealmCount = 0
    func loadDataFromRealm() {
        didCallLoadDataFromRealmCount += 1
    }

    private(set) var didCallNavigateToDeckBuilder = [DeckDTO]()
    func navigateToDeckBuilder(with deck: DeckDTO) {
        didCallNavigateToDeckBuilder.append(deck)
    }

    private(set) var didCallRemove = [DeckDTO]()
    func remove(deck: DeckDTO) {
        didCallRemove.append(deck)
    }

    private(set) var didCallInsert = [DeckDTO]()
    func insert(deck: DeckDTO) {
        didCallInsert.append(deck)
    }

    private(set) var didCallRenameValues: [(name: String, deck: DeckDTO)] = []
    func rename(name: String, deck: DeckDTO) {
        didCallRenameValues.append((name, deck))
    }
}
