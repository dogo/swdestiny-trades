//
//  DeckGraphCollectionViewTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 13/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class DeckGraphCollectionViewTests: XCSnapshotableTestCase {

    private var sut: DeckGraphCollectionView!

    override func setUp() {
        super.setUp()
        sut = DeckGraphCollectionView(frame: CGRect(x: 0, y: 0, width: 375, height: 1350),
                                      collectionViewLayout: UICollectionViewFlowLayout())
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_validLayout() {
        let deck = DeckDTO.stub()
        let memoryDB = RealmDatabaseHelper.createMemoryDatabase(identifier: #function)
        try? memoryDB?.save(object: deck)

        sut.updateCollecionViewData(deck: deck)

        XCTAssertTrue(snapshot(sut, named: "DeckGraphViewController with a valid layout"))
    }

    func test_emptyStateLayout() {
        let deck = DeckDTO.stub(emptyList: true)

        sut.updateCollecionViewData(deck: deck)

        XCTAssertTrue(snapshot(sut, named: "DeckGraphViewController with an empty state layout"))
    }
}
