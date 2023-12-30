//
//  DeckGraphViewControllerTests.swift
//  SWDestiny-TradesTests
//
//  Created by diogo.autilio on 20/09/19.
//  Copyright © 2019 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class DeckGraphViewControllerTests: XCSnapshotableTestCase {

    private var sut: DeckGraphViewController!
    private var navigationController: UINavigationController!
    private var window: UIWindow!

    override func setUp() {
        super.setUp()
        window = UIWindow(frame: CGRect(x: 0, y: 0, width: 375, height: 1350))
    }

    override func tearDown() {
        navigationController = nil
        sut = nil
        window.cleanTestWindow()
        super.tearDown()
    }

    func testValidLayout() {
        let deck = DeckDTO.stub()
        let memoryDB = RealmDatabaseHelper.createMemoryDatabase(identifier: "DeckGraph")
        try? memoryDB?.save(object: deck)

        sut = DeckGraphViewController(deck: deck)
        navigationController = UINavigationController(rootViewController: sut)
        window.showTestWindow(controller: navigationController)

        XCTAssertTrue(snapshot(navigationController, named: "DeckGraphViewController with a valid layout"))
    }

    func testEmptyStateLayout() {
        let deck = DeckDTO.stub(emptyList: true)
        sut = DeckGraphViewController(deck: deck)
        navigationController = UINavigationController(rootViewController: sut)
        window.showTestWindow(controller: navigationController)

        XCTAssertTrue(snapshot(navigationController, named: "DeckGraphViewController with an empty state layout"))
    }
}
