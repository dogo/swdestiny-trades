//
//  PeopleListDatasourceTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 02/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit
import XCTest

@testable import SWDestinyTrades

final class PeopleListDatasourceTests: XCTestCase {

    private var sut: PeopleListDatasource!
    private var delegate: PeopleListPresenterSpy!
    private var tableView: UITableView!

    override func setUp() {
        super.setUp()
        tableView = UITableView()
        delegate = PeopleListPresenterSpy()
        sut = PeopleListDatasource(tableView: tableView, delegate: delegate)

        sut.insert(personArray: [.stub(), .stub()])
    }

    override func tearDown() {
        tableView = nil
        sut = nil
        super.tearDown()
    }

    func test_cellForRowAt() {
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))

        XCTAssertTrue(cell is PersonCell)
    }

    func test_deleteRow() {
        XCTAssertEqual(sut.persons.count, 2)

        let indexPathToDelete = IndexPath(row: 0, section: 0)
        sut.tableView(tableView, commit: .delete, forRowAt: indexPathToDelete)

        XCTAssertEqual(sut.persons.count, 1)
        XCTAssertEqual(delegate.didCallRemoveValues.count, 1)
        XCTAssertNotNil(delegate.didCallRemoveValues[0])
    }

    func test_editingStyleForRowA_is_none() {
        let editStyle = sut.tableView(tableView, editingStyleForRowAt: IndexPath(row: 0, section: 0))

        XCTAssertEqual(editStyle, .none)
    }

    func test_editingStyleForRowA_is_delete() {
        tableView.isEditing = true
        let editStyle = sut.tableView(tableView, editingStyleForRowAt: IndexPath(row: 0, section: 0))

        XCTAssertEqual(editStyle, .delete)
    }

    func test_numberOfRowsInSection() {
        let rows = sut.tableView(tableView, numberOfRowsInSection: 0)

        XCTAssertEqual(rows, 2)
    }

    func test_getPerson() {
        XCTAssertNotNil(sut.getPerson(at: IndexPath(row: 0, section: 0)))
    }

    func test_insert() {
        sut.insert(person: .stub())

        XCTAssertEqual(sut.persons.count, 3)
    }

    func test_insert_person_array() {
        sut.insert(personArray: [.stub()])

        XCTAssertEqual(sut.persons.count, 1)
    }
}
