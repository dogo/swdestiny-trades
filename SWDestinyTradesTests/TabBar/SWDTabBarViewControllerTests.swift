//
//  SWDTabBarViewControllerTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 20/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import XCTest

@testable import SWDestinyTrades

final class SWDTabBarViewControllerTests: XCTestCase {

    private var sut: SWDTabBarViewController!

    override func setUp() {
        super.setUp()
        sut = SWDTabBarViewController(database: nil)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_viewDidload() {
        sut.viewDidLoad()

        XCTAssertEqual(sut.viewControllers?.count, 4)

        XCTAssertTrue((sut.viewControllers?[0] as? UINavigationController)?.topViewController is SetsListViewController)
        XCTAssertEqual(sut.viewControllers?[0].tabBarItem.title, L10n.cards)
        XCTAssertEqual(sut.viewControllers?[0].tabBarItem.image, Asset.Tabbar.icCards.image)

        XCTAssertTrue((sut.viewControllers?[1] as? UINavigationController)?.topViewController is DeckListViewController)
        XCTAssertEqual(sut.viewControllers?[1].tabBarItem.title, L10n.decks)
        XCTAssertEqual(sut.viewControllers?[1].tabBarItem.image, Asset.Tabbar.icDecks.image)

        XCTAssertTrue((sut.viewControllers?[2] as? UINavigationController)?.topViewController is PeopleListViewController)
        XCTAssertEqual(sut.viewControllers?[2].tabBarItem.title, L10n.loans)
        XCTAssertEqual(sut.viewControllers?[2].tabBarItem.image, Asset.Tabbar.icLoans.image)

        XCTAssertTrue((sut.viewControllers?[3] as? UINavigationController)?.topViewController is UserCollectionViewController)
        XCTAssertEqual(sut.viewControllers?[3].tabBarItem.title, L10n.collection)
        XCTAssertEqual(sut.viewControllers?[3].tabBarItem.image, Asset.Tabbar.icCollection.image)
    }
}
