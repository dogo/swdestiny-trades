//
//  CardDetailPresenterTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 26/01/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class CardDetailPresenterTests: XCTestCase {

    private var sut: CardDetailPresenter!
    private var view: CardViewSpy!
    private var dispatchQueue: DispatchQueueSpy!
    private var database: RealmDatabase?

    override func setUp() {
        super.setUp()
        let cardList: [CardDTO] = [.stub(), .stub()]
        database = RealmDatabaseHelper.createMemoryDatabase(identifier: #function)
        view = CardViewSpy()
        dispatchQueue = DispatchQueueSpy()
        sut = CardDetailPresenter(view: view,
                                  dispatchQueue: dispatchQueue,
                                  database: database,
                                  cardList: cardList,
                                  selected: cardList[0])
    }

    override func tearDown() {
        database = nil
        dispatchQueue = nil
        view = nil
        sut = nil
        super.tearDown()
    }

    func test_viewDidLoad_with_valid_url_images() {
        sut.viewDidLoad()

        XCTAssertEqual(view.didCallSetSlideshowImageInputs.count, 2)
        XCTAssertEqual(view.didCallSetCurrentPage.count, 1)
    }

    func test_viewDidLoad_with_invalid_url_images() {
        let card = CardDTO.stub()
        card.imageUrl = ""
        let cardList: [CardDTO] = [card, card]

        sut = CardDetailPresenter(view: view,
                                  database: database,
                                  cardList: cardList,
                                  selected: cardList[0])

        sut.viewDidLoad()

        XCTAssertEqual(view.didCallSetSlideshowImageInputs.count, 2)
        XCTAssertEqual(view.didCallSetCurrentPage.count, 1)
    }

    func test_setNavigationTitle() {
        sut.setNavigationTitle()

        XCTAssertEqual(view.didCallSetNavigationTitle.count, 1)
        XCTAssertEqual(view.didCallSetNavigationTitle[0], "Captain Phasma")
    }

    func test_setupNavigationItems() {
        var expectedItem: [UIBarButtonItem]? = []
        sut.setupNavigationItems { items in
            expectedItem = items
        }

        XCTAssertEqual(expectedItem?.count, 2)
    }

    func test_share() {
        var barButtonItems: [UIBarButtonItem]? = []
        sut.setupNavigationItems { items in
            barButtonItems = items
        }
        let shareButton = barButtonItems?[0]
        _ = shareButton?.target?.perform(shareButton!.action, with: nil)

        XCTAssertEqual(view.didCallPresentViewController.count, 1)
    }

    func test_addToCollection_unique_card_with_success() {
        var barButtonItems: [UIBarButtonItem]? = []
        sut.setupNavigationItems { items in
            barButtonItems = items
        }
        let addToCollectionButton = barButtonItems?[1]
        _ = addToCollectionButton?.target?.perform(addToCollectionButton!.action, with: nil)

        XCTAssertEqual(view.didCallShowSuccessMessage.count, 1)
    }

    func test_addToCollection_increase_card_quantity_with_success() {
        var barButtonItems: [UIBarButtonItem]? = []
        sut.setupNavigationItems { items in
            barButtonItems = items
        }
        let addToCollectionButton = barButtonItems?[1]
        _ = addToCollectionButton?.target?.perform(addToCollectionButton!.action, with: nil)
        _ = addToCollectionButton?.target?.perform(addToCollectionButton!.action, with: nil)

        XCTAssertEqual(view.didCallShowSuccessMessage.count, 2)
    }
}
