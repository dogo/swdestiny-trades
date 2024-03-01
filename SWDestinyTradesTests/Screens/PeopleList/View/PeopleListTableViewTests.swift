//
//  PeopleListTableViewTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 01/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class PeopleListTableViewTests: XCTestCase {

    private var sut: PeopleListTableView!
    private var delegate: PeopleListPresenterSpy!

    override func setUp() {
        super.setUp()
        delegate = PeopleListPresenterSpy()
        sut = PeopleListTableView(frame: .testDevice)
        sut.peopleListDelegate = delegate
        sut.updateTableViewData([.stub()])
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_updateTableViewData() {
        sut.updateTableViewData([.stub(), .stub()])

        XCTAssertEqual(sut.tableViewDatasource.persons.count, 2)
    }

    func test_insert() {
        sut.insert(.stub(name: "Second", lastName: "Person"))

        XCTAssertEqual(sut.tableViewDatasource.persons.count, 2)
    }

    func test_toggleTableViewEditable_true() {
        sut.toggleTableViewEditable(editable: true)

        XCTAssertFalse(sut.isEditing)
    }

    func test_toggleTableViewEditable_false() {
        sut.toggleTableViewEditable(editable: false)

        XCTAssertTrue(sut.isEditing)
    }

    func test_didSelectRowAt() {
        var didCallDidSelectPerson = 0
        var didSelectPersonValues: [PersonDTO] = []
        sut.didSelectPerson = { person in
            didCallDidSelectPerson += 1
            didSelectPersonValues.append(person)
        }

        sut.didSelectRowAt(index: IndexPath(row: 0, section: 0))

        XCTAssertEqual(didCallDidSelectPerson, 1)
        XCTAssertNotNil(didSelectPersonValues[0])
    }

    func test_heightForRowAt() {
        let height = sut.tableView(sut, heightForRowAt: IndexPath(row: 0, section: 0))

        XCTAssertEqual(height, 53)
    }

    func test_delegate_didSelectRowAt() {
        var didCallDidSelectPerson = 0
        var didSelectPersonValues: [PersonDTO] = []
        sut.didSelectPerson = { person in
            didCallDidSelectPerson += 1
            didSelectPersonValues.append(person)
        }

        sut.tableView(sut, didSelectRowAt: IndexPath(row: 0, section: 0))

        XCTAssertEqual(didCallDidSelectPerson, 1)
        XCTAssertNotNil(didSelectPersonValues[0])
    }
}
