//
//  DeckBuilderPresenterTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 11/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import XCTest

@testable import SWDestinyTrades

final class DeckBuilderPresenterTests: XCTestCase {

    private var sut: DeckBuilderPresenter!
    private var controller: DeckBuilderViewControllerSpy!
    private var database: RealmDatabase?
    private var navigator: DeckBuilderNavigator!
    private var navigationController: UINavigationControllerMock!
    private var deckDTO: DeckDTO!

    override func setUp() {
        super.setUp()
        deckDTO = .stub()
        controller = DeckBuilderViewControllerSpy()
        database = RealmDatabaseHelper.createMemoryDatabase(identifier: #function)
        navigationController = UINavigationControllerMock(rootViewController: controller)
        navigator = DeckBuilderNavigator(controller)
        sut = DeckBuilderPresenter(controller: controller,
                                   dispatchQueue: DispatchQueueSpy(),
                                   database: database,
                                   navigator: navigator,
                                   deckDTO: deckDTO)
    }

    override func tearDown() {
        controller = nil
        database = nil
        navigator = nil
        navigationController = nil
        sut = nil
        super.tearDown()
    }

    // MARK: - Test loadData

    func test_loadData() {
        sut.loadData(deck: .stub())

        XCTAssertEqual(controller.didCallUpdateTableViewData.count, 1)
        XCTAssertNotNil(controller.didCallUpdateTableViewData[0])
    }

    // MARK: - Test setNavigationTitle

    func test_setNavigationTitle() {
        sut.setNavigationTitle()

        XCTAssertEqual(controller.didCallSetNavigationTitle.count, 1)
        XCTAssertEqual(controller.didCallSetNavigationTitle[0], "Mock Deck")
    }

    // MARK: - Test setupNavigationItems

    func test_setupNavigationItems() {
        var expectedItem: [UIBarButtonItem]? = []
        sut.setupNavigationItems { items in
            expectedItem = items
        }

        XCTAssertEqual(expectedItem?.count, 3)
    }

    // MARK: - Test navigateToCardDetailViewController

    func test_navigateToCardDetailViewController() {
        let cardList: [CardDTO] = [.stub(), .stub()]
        let selectedCard = CardDTO.stub()

        sut.navigateToCardDetailViewController(cardList: cardList, card: selectedCard)

        XCTAssertTrue(navigationController.currentPushedViewController is CardDetailViewController)
    }

    // MARK: - Test navigateToAddToDeckViewController

    func test_navigateToAddToDeckViewController() {
        var barButtonItems: [UIBarButtonItem]? = []
        sut.setupNavigationItems { items in
            barButtonItems = items
        }
        let shareButton = barButtonItems?[0]
        _ = shareButton?.target?.perform(shareButton!.action, with: nil)

        XCTAssertTrue(navigationController.currentPushedViewController is AddToDeckViewController)
    }

    // MARK: - Test navigateToDeckGraphViewController

    func test_navigateToDeckGraphViewController() {
        var barButtonItems: [UIBarButtonItem]? = []
        sut.setupNavigationItems { items in
            barButtonItems = items
        }
        let shareButton = barButtonItems?[1]
        _ = shareButton?.target?.perform(shareButton!.action, with: nil)

        XCTAssertTrue(navigationController.currentPushedViewController is DeckGraphViewController)
    }

    // MARK: - Test reloadTableView

    func test_reloadTableView() {

        let notification = Notification(name: NotificationKey.reloadTableViewNotification, object: nil, userInfo: ["deckDTO": deckDTO!])

        NotificationCenter.default.post(notification)

        XCTAssertEqual(controller.didCallUpdateTableViewData.count, 1)
        XCTAssertNotNil(controller.didCallUpdateTableViewData[0])
    }

    // MARK: - Test share

    func test_share() {
        let cardList = Array(deckDTO.list)
        let sections = SectionsBuilder.byType(cardList: cardList)
        let local = Split.cardsByType(cardList: cardList, sections: sections)

        controller.deckList = local.map { DeckBuilderDatasource.Section(name: $0.key, items: $0.value) }

        var barButtonItems: [UIBarButtonItem]? = []
        sut.setupNavigationItems { items in
            barButtonItems = items
        }
        let shareButton = barButtonItems?[2]
        _ = shareButton?.target?.perform(shareButton!.action, with: nil)

        XCTAssertEqual(controller.didCallPresentViewController.count, 1)
    }

    // MARK: - Test updateCardQuantity

    func test_updateCardQuantity() {
        let card: CardDTO = .stub()
        sut.updateCardQuantity(newValue: 3, card: card)

        XCTAssertEqual(card.quantity, 3)
    }

    // MARK: - Test updateCharacterElite

    func test_updateCharacterElite() {
        let card: CardDTO = .stub()

        XCTAssertFalse(card.isElite)

        sut.updateCharacterElite(newValue: true, card: card)

        XCTAssertTrue(card.isElite)
    }

    // MARK: - Test remove

    func test_remove() {
        XCTAssertEqual(deckDTO.list.count, 20)

        sut.remove(at: 0)

        XCTAssertEqual(deckDTO.list.count, 19)
    }

    // MARK: - Test updateCardQuantity
}
