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

    func test_alphabetically_withEmptyCardList_shouldReturnEmptyArray() {
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

    func test_alphabetically_withEmptySetList_shouldReturnEmptyArray() {
        let setList: [SetDTO] = []
        let result = SectionsBuilder.alphabetically(setList: setList)

        XCTAssertTrue(result.isEmpty)
    }

    func test_alphabetically_withSingleSet_shouldReturnArrayWithSingleElement() {
        let setList: [SetDTO] = [.stub()]
        let result = SectionsBuilder.alphabetically(setList: setList)

        XCTAssertEqual(result, ["A"])
    }

    func test_alphabetically_withMultipleSets_shouldReturnSortedArray() {
        let setList: [SetDTO] = [
            .stub(),
            .stub(name: "Spirit of Rebellion", code: "SoR"),
            .stub(name: "Empire at War", code: "EaW"),
            .stub(name: "Spark of Hope", code: "SoH")
        ]

        let result = SectionsBuilder.alphabetically(setList: setList)

        XCTAssertEqual(result, ["A", "E", "S"])
    }

    // MARK: - byColor

    func test_byColor_withEmptyList_shouldReturnEmptyArray() {
        let cardList: [CardDTO] = []
        let result = SectionsBuilder.byColor(cardList: cardList)

        XCTAssertTrue(result.isEmpty)
    }

    func test_byColor_withSingleCard_shouldReturnArrayWithSingleElement() {
        let cardList: [CardDTO] = [.stub()]
        let result = SectionsBuilder.byColor(cardList: cardList)

        XCTAssertEqual(result, ["red"])
    }

    func test_byColor_withMultipleCards_shouldReturnArrayWithDistinctColors() {
        let cardList: [CardDTO] = [
            .stub(factionCode: "red", name: "CardC"),
            .stub(factionCode: "yellow", name: "CardA"),
            .stub(factionCode: "blue", name: "CardB"),
            .stub(factionCode: "yellow", name: "CardD")
        ]

        let result = SectionsBuilder.byColor(cardList: cardList)

        XCTAssertEqual(result, ["blue", "red", "yellow"])
    }

    // MARK: - byType

    func test_byType_withEmptyList_shouldReturnEmptyArray() {
        let cardList: [CardDTO] = []
        let result = SectionsBuilder.byType(cardList: cardList)

        XCTAssertTrue(result.isEmpty)
    }

    func test_byType_withSingleCard_shouldReturnArrayWithSingleElement() {
        let cardList: [CardDTO] = [.stub()]
        let result = SectionsBuilder.byType(cardList: cardList)

        XCTAssertEqual(result, ["Character"])
    }

    func test_byType_withMultipleCards_shouldReturnArrayWithDistinctTypes() {
        let cardList: [CardDTO] = [
            .stub(typeName: "Character", name: "CardC"),
            .stub(typeName: "Upgrade", name: "CardA"),
            .stub(typeName: "Plot", name: "CardB"),
            .stub(typeName: "Event", name: "CardD")
        ]

        let result = SectionsBuilder.byType(cardList: cardList)

        XCTAssertEqual(result, ["Character", "Event", "Plot", "Upgrade"])
    }
}
