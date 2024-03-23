//
//  UserCollectionViewControllerTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 22/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class UserCollectionViewControllerTests: XCTestCase {

    private var sut: UserCollectionViewController!
    private var presenter: UserCollectionPresenterSpy!
    private var view: UserCollectionViewSpy!
    private var navigationController: UINavigationControllerMock!
    private var keyWindow: UIWindow!

    override func setUp() {
        super.setUp()
        keyWindow = UIWindow(frame: .testDevice)
        view = UserCollectionViewSpy()
        presenter = UserCollectionPresenterSpy()
        sut = UserCollectionViewController(with: view)
        sut.presenter = presenter
        navigationController = UINavigationControllerMock(rootViewController: sut)
        keyWindow.showTestWindow(controller: navigationController)
    }

    override func tearDown() {
        view = nil
        presenter = nil
        navigationController = nil
        sut = nil
        keyWindow.cleanTestWindow()
        super.tearDown()
    }

    func test_loadView() {
        sut.loadView()

        XCTAssertTrue(sut.view is UserCollectionViewType)
    }

    func test_viewDidLoad() {
        sut.viewDidLoad()

        XCTAssertEqual(presenter.didCallSetupNavigationItemsCount, 1)
    }

    func test_didSelectCard() {
        sut.viewDidLoad()
        view.didSelectCard?([.stub()], .stub())

        XCTAssertEqual(presenter.didCallNavigateToCardDetail.count, 1)
    }

    func test_viewWillAppear() {
        sut.viewWillAppear(false)

        XCTAssertEqual(presenter.didCallSetNavigationTitleCount, 1)
        XCTAssertEqual(presenter.didCallLoadDataFromRealmCount, 1)
    }

    func test_setNavigationTitle() {
        sut.setNavigationTitle("Collection Title")

        XCTAssertEqual(sut.navigationItem.title, "Collection Title")
    }

    func test_updateTableViewData() {
        let collection = UserCollectionDTO.stub()
        sut.updateTableViewData(collection: collection)

        XCTAssertEqual(view.didCallUpdateTableViewData.count, 1)
        XCTAssertEqual(view.didCallUpdateTableViewData[0], collection)
    }

    func test_sort() {
        sut.sort(0)

        XCTAssertEqual(view.didCallSort.count, 1)
        XCTAssertEqual(view.didCallSort[0], 0)
    }

    func test_getCardList() {
        _ = sut.getCardList()

        XCTAssertEqual(view.didCallGetCardListCount, 1)
    }

    func test_presentViewController() {
        let controller = UIViewControllerMock()

        sut.presentViewController(controller, animated: false)

        XCTAssertTrue(controller.isBeingPresented)
    }
}
