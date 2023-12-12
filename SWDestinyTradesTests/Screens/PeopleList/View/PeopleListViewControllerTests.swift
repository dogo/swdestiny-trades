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

final class PeopleListViewControllerTests: XCSnapshotableTestCase {

    private var sut: PeopleListViewController!
    private var database: DatabaseProtocol!
    private var navigation: UINavigationController!
    private var window: UIWindow!

    override func setUp() {
        super.setUp()
        AppearanceProxyHelper.customizeNavigationBar()
        window = UIWindow(frame: .testDevice)
        database = RealmDatabaseHelper.createMemoryDatabase(identifier: "PeopleList")
    }

    override func tearDown() {
        try! database.reset()
        window.cleanTestWindow()
        super.tearDown()
    }

    func testEmptyStateLayout() {
        sut = PeopleListViewController(database: database)
        navigation = UINavigationController(rootViewController: sut)
        window.showTestWindow(controller: navigation)

        XCTAssertTrue(snapshot(navigation, named: "PeopleListViewController with an empty state layout"))
    }

    func testPersonWithNoLoansLayout() {
        let person = PersonDTO.stub()
        try! database.save(object: person)

        sut = PeopleListViewController(database: database)
        navigation = UINavigationController(rootViewController: sut)
        window.showTestWindow(controller: navigation)

        XCTAssertTrue(snapshot(navigation, named: "PeopleListViewController with a person with no loans"))
    }

    func testPersonWithLentCardsLayout() {
        let person = PersonDTO.stub()
        person.lentMe.append(CardDTO.stub())
        try! database.save(object: person)

        sut = PeopleListViewController(database: database)
        navigation = UINavigationController(rootViewController: sut)
        window.showTestWindow(controller: navigation)

        XCTAssertTrue(snapshot(navigation, named: "PeopleListViewController with a person with lent cards"))
    }

    func testPersonWithBorrowedCardsLayout() {
        let person = PersonDTO.stub()
        person.borrowed.append(CardDTO.stub())
        try! database.save(object: person)

        sut = PeopleListViewController(database: database)
        navigation = UINavigationController(rootViewController: sut)
        window.showTestWindow(controller: navigation)

        XCTAssertTrue(snapshot(navigation, named: "PeopleListViewController with a person with borrowed cards"))
    }

    func testPersonWithLentAndBorrowedCardsLayout() {
        let person = PersonDTO.stub()
        person.lentMe.append(CardDTO.stub())
        person.borrowed.append(CardDTO.stub())
        try! database.save(object: person)

        sut = PeopleListViewController(database: database)
        navigation = UINavigationController(rootViewController: sut)
        window.showTestWindow(controller: navigation)

        XCTAssertTrue(snapshot(navigation, named: "PeopleListViewController with a person with lent and borrowed cards"))
    }
}
