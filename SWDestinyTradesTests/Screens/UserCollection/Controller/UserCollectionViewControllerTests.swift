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
    private var view: UserCollectionViewSpy!
    private var database: RealmDatabase?
    private var navigationController: UINavigationControllerMock!
    private var keyWindow: UIWindow!

    override func setUp() {
        super.setUp()
        keyWindow = UIWindow(frame: .testDevice)
        database = RealmDatabaseHelper.createMemoryDatabase(identifier: #function)
        view = UserCollectionViewSpy()
        sut = UserCollectionViewController(with: view, database: database)
        navigationController = UINavigationControllerMock(rootViewController: sut)
        keyWindow.showTestWindow(controller: navigationController)
    }

    override func tearDown() {
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

        XCTAssertEqual(sut.navigationItem.rightBarButtonItems?.count, 2)
        XCTAssertNotNil(sut.navigationItem.leftBarButtonItem)
    }

    func test_didSelectCard() {
        sut.viewDidLoad()
        view.didSelectCard?([.stub()], .stub())

        XCTAssertTrue(navigationController.currentPushedViewController is CardDetailViewController)
    }

    func test_viewWillAppear() {
        sut.viewWillAppear(false)

        XCTAssertEqual(sut.navigationItem.title, "My Collection")
    }

    func test_stepperValueChanged() {
        let card: CardDTO = .stub()
        sut.stepperValueChanged(newValue: 4, card: card)

        XCTAssertEqual(card.quantity, 4)
    }

    func test_remove() {
        // XCTAssertEqual(person.borrowed.count, 2)

        sut.remove(at: 0)

        // XCTAssertEqual(person.borrowed.count, 1)
    }
}
