//
//  PeopleListViewControllerTests.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 19/09/19.
//  Copyright © 2019 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class PeopleListViewControllerTests: XCTestCase {

    private var sut: PeopleListViewController!
    private var presenter: PeopleListPresenterSpy!
    private var view: PeopleListViewSpy!
    private var database: DatabaseProtocol!
    private var navigationController: UINavigationControllerMock!
    private var keyWindow: UIWindow!

    override func setUp() {
        super.setUp()
        keyWindow = UIWindow(frame: .testDevice)
        view = PeopleListViewSpy()
        presenter = PeopleListPresenterSpy()
        sut = PeopleListViewController(with: view)
        sut.presenter = presenter
        database = RealmDatabaseHelper.createMemoryDatabase(identifier: #function)
        navigationController = UINavigationControllerMock(rootViewController: sut)
        keyWindow.showTestWindow(controller: navigationController)
    }

    override func tearDown() {
        sut = nil
        database = nil
        view = nil
        navigationController = nil
        keyWindow = nil
        super.tearDown()
    }

    func test_loadView() {
        sut.loadView()

        XCTAssertTrue(sut.view is PeopleListViewType)
    }

    func test_viewDidLoad() {
        sut.viewDidLoad()

        XCTAssertEqual(presenter.didCallSetupNavigationItemsCount, 1)
        XCTAssertEqual(presenter.didCallLoadDataFromRealmCount, 1)
    }

    func test_didSelectPerson() {
        sut.viewDidLoad()
        view.didSelectPerson?(.stub())

        XCTAssertEqual(presenter.didCallNavigateToLoansDetailValues.count, 1)
        XCTAssertNotNil(presenter.didCallNavigateToLoansDetailValues[0])
    }

    func test_viewWillAppear() {
        sut.viewWillAppear(false)

        XCTAssertEqual(presenter.didCallSetNavigationTitleCount, 1)
    }

    func test_updateTableViewData() {
        sut.updateTableViewData([.stub()])

        XCTAssertEqual(view.didCallUpdateTableViewDataValues.count, 1)
        XCTAssertNotNil(view.didCallUpdateTableViewDataValues[0])
    }

    func test_setNavigationTitle() {
        sut.setNavigationTitle("Darth Vader")

        XCTAssertEqual(sut.navigationItem.title, "Darth Vader")
    }

    func test_toggleTableViewEditable_true() {
        sut.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Test",
                                                               style: .plain,
                                                               target: nil,
                                                               action: nil)
        sut.toggleTableViewEditable(editable: true, title: "Edit")

        XCTAssertFalse(sut.isEditing)
        XCTAssertEqual(view.didICallToggleTableViewEditableValues.count, 1)
        XCTAssertTrue(view.didICallToggleTableViewEditableValues[0])
        XCTAssertEqual(sut.navigationItem.leftBarButtonItem?.title, "Edit")
    }

    func test_toggleTableViewEditable_false() {
        sut.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Test",
                                                               style: .plain,
                                                               target: nil,
                                                               action: nil)
        sut.toggleTableViewEditable(editable: false, title: "Done")

        XCTAssertTrue(sut.isEditing)
        XCTAssertEqual(view.didICallToggleTableViewEditableValues.count, 1)
        XCTAssertFalse(view.didICallToggleTableViewEditableValues[0])
        XCTAssertEqual(sut.navigationItem.leftBarButtonItem?.title, "Done")
    }

    func test_insert() {
        sut.insert(.stub())

        XCTAssertEqual(view.didICallnsertValues.count, 1)
        XCTAssertNotNil(view.didICallnsertValues[0])
    }
}
