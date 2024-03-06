//
//  PeopleListPresenterTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 02/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class PeopleListPresenterTests: XCTestCase {

    private var sut: PeopleListPresenter!
    private var navigationController: UINavigationControllerMock!
    private var controller: PeopleListViewControllerSpy!
    private var delegate: UpdateTableDataDelegateSpy!
    private var database: RealmDatabase?
    private var navigator: PeopleListNavigator!

    override func setUp() {
        super.setUp()
        controller = PeopleListViewControllerSpy()
        navigationController = UINavigationControllerMock(rootViewController: controller)
        database = RealmDatabaseHelper.createMemoryDatabase(identifier: #function)
        navigator = PeopleListNavigator(controller)
        sut = PeopleListPresenter(controller: controller,
                                  database: database,
                                  navigator: navigator)
        sut.insert(person: .stub())
    }

    override func tearDown() {
        controller = nil
        navigationController = nil
        sut = nil
        database = nil
        navigator = nil
        super.tearDown()
    }

    // MARK: - Test setupNavigationItems

    func test_setupNavigationItems() {
        var expectedItem: [UIBarButtonItem]? = []
        sut.setupNavigationItems { items in
            expectedItem = items
        }

        XCTAssertEqual(expectedItem?.count, 2)
    }

    // MARK: - Test loadDataFromRealm

    func test_loadDataFromRealm() {
        sut.loadDataFromRealm()

        XCTAssertEqual(controller.didCallUpdateTableViewDataValues.count, 8)
        XCTAssertNotNil(controller.didCallUpdateTableViewDataValues[0])
    }

    // MARK: - Test setNavigationTitle

    func test_setNavigationTitle() {
        sut.setNavigationTitle()

        XCTAssertEqual(controller.didCallSetNavigationTitle.count, 1)
        XCTAssertEqual(controller.didCallSetNavigationTitle[0], "People")
    }

    // MARK: - Test navigateToLoansDetail

    func test_navigateToLoansDetail() {
        sut.navigateToLoansDetail(person: .stub())

        XCTAssertTrue(navigationController.currentPushedViewController is LoansDetailViewController)
    }

    // MARK: - Test editButtonTouched

    func test_editButtonTouched_when_is_editing_true() {
        var barButtonItems: [UIBarButtonItem]? = []
        sut.setupNavigationItems { items in
            barButtonItems = items
        }
        let editutton = barButtonItems?[0]
        controller.isEditing = true
        _ = editutton?.target?.perform(editutton!.action, with: nil)

        XCTAssertTrue(controller.isEditing)
        XCTAssertEqual(controller.didCallToggleTableViewEditableValues.count, 1)
        XCTAssertTrue(controller.didCallToggleTableViewEditableValues[0].editable)
        XCTAssertEqual(controller.didCallToggleTableViewEditableValues[0].title, "Edit")
    }

    func test_editButtonTouched_when_is_editing_false() {
        var barButtonItems: [UIBarButtonItem]? = []
        sut.setupNavigationItems { items in
            barButtonItems = items
        }
        let editutton = barButtonItems?[0]
        controller.isEditing = false
        _ = editutton?.target?.perform(editutton!.action, with: nil)

        XCTAssertFalse(controller.isEditing)
        XCTAssertEqual(controller.didCallToggleTableViewEditableValues.count, 1)
        XCTAssertFalse(controller.didCallToggleTableViewEditableValues[0].editable)
        XCTAssertEqual(controller.didCallToggleTableViewEditableValues[0].title, "Done")
    }

    // MARK: - Test addButtonTouched

    func test_addButtonTouched_when_is_editing_true() {
        var barButtonItems: [UIBarButtonItem]? = []
        sut.setupNavigationItems { items in
            barButtonItems = items
        }
        let addButton = barButtonItems?[1]
        controller.isEditing = true
        _ = addButton?.target?.perform(addButton!.action, with: nil)

        XCTAssertTrue(controller.isEditing)
        XCTAssertEqual(controller.didCallToggleTableViewEditableValues.count, 1)
        XCTAssertTrue(controller.didCallToggleTableViewEditableValues[0].editable)
        XCTAssertEqual(controller.didCallToggleTableViewEditableValues[0].title, "Edit")
        XCTAssertTrue(navigationController.currentPushedViewController is NewPersonViewController)
    }

    func test_addButtonTouched_when_is_editing_false() {
        var barButtonItems: [UIBarButtonItem]? = []
        sut.setupNavigationItems { items in
            barButtonItems = items
        }
        let addButton = barButtonItems?[1]
        controller.isEditing = false
        _ = addButton?.target?.perform(addButton!.action, with: nil)

        XCTAssertTrue(navigationController.currentPushedViewController is NewPersonViewController)
    }

    // MARK: - Test ReloadTableView Notification

    func test_reloadTableView() {
        NotificationCenter.default.post(name: NotificationKey.reloadTableViewNotification, object: nil, userInfo: nil)

        XCTAssertEqual(controller.didCallUpdateTableViewDataValues.count, 10)
        XCTAssertNotNil(controller.didCallUpdateTableViewDataValues[0])
    }

    // MARK: - Test insert

    func test_insert() {
        let predicate = NSPredicate(format: "name == %@", "Insert Test")

        let person = PersonDTO()
        person.name = "Insert Test"

        XCTAssertNil(findObject(PersonDTO.self, predicate: predicate))

        sut.insert(person: person)

        XCTAssertNotNil(findObject(PersonDTO.self, predicate: predicate))
    }

    // MARK: - Test remove

    func test_remove() {
        let predicate = NSPredicate(format: "name == %@", "Remove Test")

        let person = PersonDTO()
        person.name = "Remove Test"

        sut.insert(person: person)

        XCTAssertNotNil(findObject(PersonDTO.self, predicate: predicate))

        sut.remove(person: person)

        XCTAssertNil(findObject(PersonDTO.self, predicate: predicate))
    }

    // MARK: - Test insert New Person

    func test_insertNewPerson() {
        sut.insertNew(person: .stub())

        XCTAssertEqual(controller.didCallInsertValues.count, 1)
        XCTAssertNotNil(controller.didCallInsertValues[0])
    }

    // MARK: - Utils

    private func findObject<T: Storable>(_ model: T.Type, predicate: NSPredicate?) -> T? {
        var foundObject: T?

        try? database?.fetch(model, predicate: predicate, sorted: nil) { results in
            foundObject = results.first
        }

        return foundObject
    }
}
