//
//  AddCardViewControllerTests.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 14/02/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import PKHUD
@testable import SWDestinyTrades
@testable import SwiftMessages

final class AddCardViewControllerTests: XCTestCase {

    private var sut: AddCardViewController!
    private var view: AddCardViewSpy!
    private var database: DatabaseProtocol!
    private var service: SWDestinyService!
    private var keyWindow: UIWindow!

    override func setUp() {
        super.setUp()
        keyWindow = UIWindow(frame: .testDevice)
        database = RealmDatabaseHelper.createMemoryDatabase(identifier: "UserCollection")
        service = SWDestinyService(client: HttpClientMock())
        view = AddCardViewSpy()
        sut = AddCardViewController(with: view,
                                    service: service,
                                    database: database,
                                    person: .stub(),
                                    userCollection: .stub(),
                                    type: .collection)
        let navigationController = UINavigationController(rootViewController: sut)
        keyWindow.showTestWindow(controller: navigationController)
    }

    override func tearDown() {
        keyWindow.cleanTestWindow()
        super.tearDown()
    }

    func testCreateController() {
        XCTAssertNotNil(sut)
    }

    func testViewIsKindOfAddCardViewType() {
        XCTAssertTrue(sut.view is AddCardViewType)
    }

    func testNavigationTitle() {
        sut.viewWillAppear(false)
        XCTAssertEqual(sut.navigationItem.title, L10n.addCard)
    }

    func testDidSelectCardInsertsIntoCollectionDatabaseSuccessfully() {
        let collection = UserCollectionDTO.stub()

        sut = AddCardViewController(with: view,
                                    service: service,
                                    database: database,
                                    person: .stub(),
                                    userCollection: collection,
                                    type: .collection)
        let navigationController = UINavigationController(rootViewController: sut)
        keyWindow.showTestWindow(controller: navigationController)

        sut.viewDidLoad()
        view.didSelectCard?(.stub())

        XCTAssertTrue(keyWindow.subviews.contains { $0 is ContainerView })
    }

    func testDidSelectCardDoesNotInsertIntoCollectionDatabase() {
        let collection = UserCollectionDTO.stub()
        collection.addCard(.stub())

        sut = AddCardViewController(with: view,
                                    service: service,
                                    database: database,
                                    person: .stub(),
                                    userCollection: collection,
                                    type: .collection)
        let navigationController = UINavigationController(rootViewController: sut)
        keyWindow.showTestWindow(controller: navigationController)

        sut.viewDidLoad()
        view.didSelectCard?(.stub())

        // XCTAssertTrue(keyWindow.subviews.contains { $0 is ContainerView })
    }

    func testDidSelectAccessory() {
        sut.viewDidLoad()
        view.didSelectAccessory?(.stub())

        let viewController = sut.navigationController?.viewControllers[0]
        // XCTAssertTrue(viewController is CardDetailViewController)
    }

    func testDoingSearch() {
        sut.viewDidLoad()
        view.doingSearch?("jabba")

        XCTAssertEqual(view.didCallDoingSearch.count, 1)
        XCTAssertEqual(view.didCallDoingSearch[0], "jabba")
    }
}
