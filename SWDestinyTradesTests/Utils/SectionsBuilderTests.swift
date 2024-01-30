//
//  SectionsBuilderTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 30/01/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import XCTest

@testable import SWDestinyTrades

final class SectionsBuilderTests: XCTestCase {

    // MARK: - alphabetically

    func test_alphabetically_withEmptyList_shouldReturnEmptyArray() {
        let cardList: [CardDTO] = []
        let result = SectionsBuilder.alphabetically(cardList: cardList)

        XCTAssertTrue(result.isEmpty)
    }

    func test_alphabetically_withSingleCard_shouldReturnArrayWithSingleElement() {
        let cardList: [CardDTO] = [.stub()]
        let result = SectionsBuilder.alphabetically(cardList: cardList)

        XCTAssertEqual(result, ["C"])
    }

    func test_alphabetically_withMultipleCards_shouldReturnSortedArray() {
        let cardList: [CardDTO] = [
            .stub(factionCode: "ColorC", name: "CardC"),
            .stub(factionCode: "ColorA", name: "ACard"),
            .stub(factionCode: "ColorB", name: "BCard")
        ]

        let result = SectionsBuilder.alphabetically(cardList: cardList)

        XCTAssertEqual(result, ["A", "B", "C"])
    }

    // MARK: - byColor

    func testByColor_withEmptyList_shouldReturnEmptyArray() {
        let cardList: [CardDTO] = []
        let result = SectionsBuilder.byColor(cardList: cardList)

        XCTAssertTrue(result.isEmpty)
    }

    func testByColor_withSingleCard_shouldReturnArrayWithSingleElement() {
        let cardList: [CardDTO] = [.stub()]
        let result = SectionsBuilder.byColor(cardList: cardList)

        XCTAssertEqual(result, ["red"])
    }

    func testByColor_withMultipleCards_shouldReturnArrayWithDistinctColors() {
        let cardList: [CardDTO] = [
            .stub(factionCode: "red", name: "CardC"),
            .stub(factionCode: "yellow", name: "CardA"),
            .stub(factionCode: "blue", name: "CardB"),
            .stub(factionCode: "yellow", name: "CardD")
        ]

        let result = SectionsBuilder.byColor(cardList: cardList)

        XCTAssertEqual(result, ["blue", "red", "yellow"])
    }
}
