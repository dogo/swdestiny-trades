//
//  UserCollectionPresenterTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 22/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class UserCollectionPresenterTests: XCTestCase {

    private var sut: UserCollectionPresenter!
    private var navigationController: UINavigationControllerMock!
    private var controller: UserCollectionViewControllerSpy!
    private var navigator: UserCollectionNavigator!
    private var database: RealmDatabase?

    override func setUp() {
        super.setUp()
        controller = UserCollectionViewControllerSpy()
        navigationController = UINavigationControllerMock(rootViewController: controller)
        database = RealmDatabaseHelper.createMemoryDatabase(identifier: #function)
        navigator = UserCollectionNavigator(controller)
        sut = UserCollectionPresenter(controller: controller,
                                      dispatchQueue: DispatchQueueSpy(),
                                      database: database,
                                      navigator: navigator)
    }

    override func tearDown() {
        navigator = nil
        navigationController = nil
        controller = nil
        database = nil
        sut = nil
        super.tearDown()
    }

    // MARK: - Test setNavigationTitle

    func test_setNavigationTitle() {
        sut.setNavigationTitle()

        XCTAssertEqual(controller.didCallSetNavigationTitle.count, 1)
        XCTAssertEqual(controller.didCallSetNavigationTitle[0], "My Collection")
    }

    // MARK: - Test setupNavigationItems

    func test_setupNavigationItems() {
        var expectedItems: ([UIBarButtonItem]?, [UIBarButtonItem]?)?
        sut.setupNavigationItems { leftItems, rightItems in
            expectedItems = (leftItems, rightItems)
        }

        XCTAssertEqual(expectedItems?.0?.count, 1)
        XCTAssertEqual(expectedItems?.1?.count, 2)
    }

    // MARK: - Test sort

    func test_sort() {
        var barButtonItems: ([UIBarButtonItem]?, [UIBarButtonItem]?)?
        sut.setupNavigationItems { leftItems, rightItems in
            barButtonItems = (leftItems, rightItems)
        }
        let sortButton = barButtonItems?.0?[0]
        _ = sortButton?.target?.perform(sortButton!.action, with: nil)

        // XCTAssertTrue(navigationController.currentPushedViewController is AddCardViewController)
    }

    // MARK: - Test addCard

    func test_addCard() {
        var barButtonItems: ([UIBarButtonItem]?, [UIBarButtonItem]?)?
        sut.setupNavigationItems { leftItems, rightItems in
            barButtonItems = (leftItems, rightItems)
        }
        let addCardButton = barButtonItems?.1?[0]
        _ = addCardButton?.target?.perform(addCardButton!.action, with: nil)

        XCTAssertTrue(navigationController.currentPushedViewController is AddCardViewController)
    }

    // MARK: - Test share

    func test_share() {
        var barButtonItems: ([UIBarButtonItem]?, [UIBarButtonItem]?)?
        sut.setupNavigationItems { leftItems, rightItems in
            barButtonItems = (leftItems, rightItems)
        }
        let shareButton = barButtonItems?.1?[1]
        _ = shareButton?.target?.perform(shareButton!.action, with: nil)

        XCTAssertEqual(controller.didCallPresentViewController.count, 1)
    }

    // MARK: - Test loadDataFromRealm

    func test_loadDataFromRealm() {
        sut.loadDataFromRealm()

        XCTAssertEqual(controller.didCallUpdateTableViewData.count, 1)
        XCTAssertNotNil(controller.didCallUpdateTableViewData[0])

        XCTAssertEqual(controller.didCallSort.count, 1)
        XCTAssertEqual(controller.didCallSort[0], 0)
    }

    // MARK: - Test navigateToCardDetail

    func test_navigateToCardDetail() {
        sut.navigateToCardDetail(cardList: [.stub()], card: .stub())

        XCTAssertTrue(navigationController.currentPushedViewController is CardDetailViewController)
    }

    // MARK: - Test navigateToAddCard

    func test_navigateToAddCard() {
        sut.navigateToAddCard()

        XCTAssertTrue(navigationController.currentPushedViewController is AddCardViewController)
    }

    // MARK: - Test stepperValueChanged

    func test_stepperValueChanged() {
        let card: CardDTO = .stub()
        sut.stepperValueChanged(newValue: 4, card: card)

        XCTAssertEqual(card.quantity, 4)
    }

    // MARK: - Test remove

    func test_remove() {
        // XCTAssertEqual(deckDTO.list.count, 22)

        // sut.remove(at: 0)

        // XCTAssertEqual(deckDTO.list.count, 21)
    }
}