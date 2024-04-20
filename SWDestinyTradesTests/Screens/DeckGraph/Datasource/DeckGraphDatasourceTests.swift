//
//  DeckGraphDatasourceTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 13/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import XCTest

@testable import SWDestinyTrades

final class DeckGraphDatasourceTests: XCTestCase {

    private var collectionView: UICollectionView!
    private var sut: DeckGraphDatasource!

    override func setUp() {
        super.setUp()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        sut = DeckGraphDatasource(collectionView: collectionView)

        let deck = DeckDTO.stub()
        let memoryDB = RealmDatabaseHelper.createMemoryDatabase(identifier: #function)
        try? memoryDB?.save(object: deck, completion: nil)

        sut.updateCollecionViewData(deck: deck)
    }

    override func tearDown() {
        collectionView = nil
        sut = nil
        super.tearDown()
    }

    func test_cellForRowAt_when_graphType_is_barGraph() {
        let cell = sut.collectionView(collectionView, cellForItemAt: IndexPath(row: 0, section: 0))

        XCTAssertTrue(cell is CardTypeBarChartCell)
    }

    func test_cellForRowAt_when_graphType_is_lineGraph() {
        let cell = sut.collectionView(collectionView, cellForItemAt: IndexPath(row: 1, section: 0))

        XCTAssertTrue(cell is CardCostLineChartCell)
    }

    func test_cellForRowAt_when_graphType_is_radarGraph() {
        let cell = sut.collectionView(collectionView, cellForItemAt: IndexPath(row: 2, section: 0))

        XCTAssertTrue(cell is DiceRadarChartCell)
    }

    func test_cellForRowAt_when_graphType_is_unknown() {
        let cell = sut.collectionView(collectionView, cellForItemAt: IndexPath(row: 3, section: 0))

        XCTAssertNotNil(cell)
    }

    func test_numberOfItemsInSection() {
        let rows = sut.collectionView(collectionView, numberOfItemsInSection: 0)

        XCTAssertEqual(rows, 3)
    }

    func test_updateCollecionViewData() {
        XCTAssertEqual(sut.cardCosts.count, 4)
        XCTAssertEqual(sut.cardTypes.count, 5)
        XCTAssertEqual(sut.dieFaces.count, 10)
    }

    func test_buildBarChart() {
        // upgrade
        XCTAssertEqual(sut.cardTypes[0], 5)

        // support
        XCTAssertEqual(sut.cardTypes[1], 2)

        // event
        XCTAssertEqual(sut.cardTypes[2], 7)

        // plot
        XCTAssertEqual(sut.cardTypes[3], 1)

        // downgrade
        XCTAssertEqual(sut.cardTypes[4], 1)
    }

    func test_buildLineChart() {
        // Cost 0
        XCTAssertEqual(sut.cardCosts[0], 4)

        // Cost 1
        XCTAssertEqual(sut.cardCosts[1], 5)

        // Cost 2
        XCTAssertEqual(sut.cardCosts[2], 3)

        // Cost 3
        XCTAssertEqual(sut.cardCosts[3], 3)
    }

    func test_buildRadarChart() {
        // specialFace
        XCTAssertEqual(sut.dieFaces[0], 3)

        // blankFace
        XCTAssertEqual(sut.dieFaces[1], 12)

        // meleeFace
        XCTAssertEqual(sut.dieFaces[2], 13)

        // rangedFace
        XCTAssertEqual(sut.dieFaces[3], 10)

        // focusFace
        XCTAssertEqual(sut.dieFaces[4], 2)

        // disruptFace
        XCTAssertEqual(sut.dieFaces[5], 3)

        // shieldFace
        XCTAssertEqual(sut.dieFaces[6], 3)

        // discardFace
        XCTAssertEqual(sut.dieFaces[7], 3)

        // resourceFace
        XCTAssertEqual(sut.dieFaces[8], 10)

        // indirectFace
        XCTAssertEqual(sut.dieFaces[9], 0)
    }
}
