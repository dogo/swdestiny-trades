//
//  SplitTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 29/01/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import XCTest

@testable import SWDestinyTrades

final class SplitTests: XCTestCase {

    func test_cardsAlphabetically() {
        let cardList: [CardDTO] = [
            .stub(name: "Cherry"),
            .stub(name: "Apple"),
            .stub(name: "Banana"),
            .stub(name: "Brocolis")
        ]

        let sections = ["B", "A", "C"]

        let result = Split.cardsAlphabetically(cardList: cardList, sections: sections)

        XCTAssertEqual(result["A"]?.count, 1)
        XCTAssertEqual(result["B"]?.count, 2)
        XCTAssertEqual(result["C"]?.count, 1)

        XCTAssertEqual(result["A"]?.first?.name, "Apple")
        XCTAssertEqual(result["B"]?.first?.name, "Banana")
        XCTAssertEqual(result["B"]?[1].name, "Brocolis")
        XCTAssertEqual(result["C"]?.first?.name, "Cherry")
    }

    func test_cardsByColor() {
        let cardList: [CardDTO] = [
            .stub(factionCode: "Red", name: "Card1"),
            .stub(factionCode: "Red", name: "Card3"),
            .stub(factionCode: "Green", name: "Card4"),
            .stub(factionCode: "Blue", name: "Card2")
        ]

        let sections = ["Red", "Blue", "Green"]

        let result = Split.cardsByColor(cardList: cardList, sections: sections)

        XCTAssertEqual(result["Red"]?.count, 2)
        XCTAssertEqual(result["Blue"]?.count, 1)
        XCTAssertEqual(result["Green"]?.count, 1)

        XCTAssertEqual(result["Red"]?.first?.name, "Card1")
        XCTAssertEqual(result["Red"]?[1].name, "Card3")
        XCTAssertEqual(result["Blue"]?.first?.name, "Card2")
        XCTAssertEqual(result["Green"]?.first?.name, "Card4")
    }

    func test_cardsByType() {
        let cardList: [CardDTO] = [
            .stub(typeName: "Creature", name: "Card1"),
            .stub(typeName: "Spell", name: "Card2"),
            .stub(typeName: "Creature", name: "Card3"),
            .stub(typeName: "Artifact", name: "Card4")
        ]

        let sections = ["Creature", "Spell", "Artifact"]

        let result = Split.cardsByType(cardList: cardList, sections: sections)

        XCTAssertEqual(result["Creature"]?.count, 2)
        XCTAssertEqual(result["Spell"]?.count, 1)
        XCTAssertEqual(result["Artifact"]?.count, 1)

        XCTAssertEqual(result["Creature"]?.first?.name, "Card1")
        XCTAssertEqual(result["Creature"]?[1].name, "Card3")
        XCTAssertEqual(result["Spell"]?.first?.name, "Card2")
        XCTAssertEqual(result["Artifact"]?.first?.name, "Card4")
    }

    func test_setsByAlphabetically() {
        let sections = ["S", "A", "E"]

        let sets: [SetDTO] = [
            .stub(),
            .stub(name: "Spirit of Rebellion", code: "SoR"),
            .stub(name: "Empire at War", code: "EaW"),
            .stub(name: "Spark of Hope", code: "SoH")
        ]

        let result = Split.setsByAlphabetically(setList: sets, sections: sections)

        XCTAssertEqual(result["A"]?.count, 1)
        XCTAssertEqual(result["E"]?.count, 1)
        XCTAssertEqual(result["S"]?.count, 2)

        XCTAssertEqual(result["A"]?.first?.name, "Awakenings")
        XCTAssertEqual(result["S"]?[0].name, "Spark of Hope")
        XCTAssertEqual(result["S"]?[1].name, "Spirit of Rebellion")
        XCTAssertEqual(result["E"]?.first?.name, "Empire at War")
    }
}
