//
//  PersonCellTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 02/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class PersonCellTests: XCTestCase {

    private var sut: PersonCell!

    override func setUp() {
        super.setUp()
        sut = PersonCell(style: .default, reuseIdentifier: #function)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_configureCell_with_no_loans() {
        sut.configureCell(personDTO: .stub())

        XCTAssertEqual(sut.textLabel?.text, "User Mock")
        XCTAssertEqual(sut.detailTextLabel?.text, "No loans")
    }

    func test_configureCell_with_loans() {
        sut.configureCell(personDTO: .stub(lentMe: [.stub()], borrowed: [.stub()]))

        XCTAssertEqual(sut.textLabel?.text, "User Mock")
        XCTAssertEqual(sut.detailTextLabel?.text, "Lent me 1 card & borrowed 1 card")
    }

    func test_configureCell_with_only_lent_cards() {
        sut.configureCell(personDTO: .stub(lentMe: [.stub()]))

        XCTAssertEqual(sut.textLabel?.text, "User Mock")
        XCTAssertEqual(sut.detailTextLabel?.text, "Lent me 1 card")
    }

    func test_configureCell_with_only_borrow_cards() {
        sut.configureCell(personDTO: .stub(borrowed: [.stub()]))

        XCTAssertEqual(sut.textLabel?.text, "User Mock")
        XCTAssertEqual(sut.detailTextLabel?.text, "Borrowed 1 card")
    }

    func test_prepareForReuse() {
        sut.prepareForReuse()

        XCTAssertNil(sut.textLabel?.text)
        XCTAssertNil(sut.detailTextLabel?.text)
    }
}
