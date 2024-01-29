//
//  SortTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 28/01/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import XCTest

@testable import SWDestinyTrades

final class SortTests: XCTestCase {

    func test_cardsByNumber() {
        let unsortedCards: [CardDTO] = [
            .stub(code: "002", name: "Card B"),
            .stub(code: "001", name: "Card A")
        ]

        let sortedCards = Sort.cardsByNumber(cardsArray: unsortedCards)

        XCTAssertEqual(sortedCards[0].code, "001")
        XCTAssertEqual(sortedCards[1].code, "002")
    }

    func test_cardsAlphabetically() {
        let unsortedCards: [CardDTO] = [
            .stub(name: "Card B"),
            .stub(name: "Card A")
        ]

        let sortedCards = Sort.cardsAlphabetically(cardsArray: unsortedCards)

        XCTAssertEqual(sortedCards[0].name, "Card A")
        XCTAssertEqual(sortedCards[1].name, "Card B")
    }

    func test_cardsByColor() {
        let unsortedCards: [CardDTO] = [
            .stub(factionCode: "red"),
            .stub(factionCode: "blue")
        ]

        let sortedCards = Sort.cardsByColor(cardsArray: unsortedCards)

        XCTAssertEqual(sortedCards[0].factionCode, "blue")
        XCTAssertEqual(sortedCards[1].factionCode, "red")
    }

    func test_cardsByType() {
        let unsortedCards: [CardDTO] = [
            .stub(typeName: "Upgrade", name: "Dagger of Mortis"),
            .stub(typeName: "Character", name: "Captain Phasma")
        ]

        let sortedCards = Sort.cardsByType(cardsArray: unsortedCards)

        XCTAssertEqual(sortedCards[0].typeName, "Character")
        XCTAssertEqual(sortedCards[1].typeName, "Upgrade")
    }

    func test_cardsByAffiliation() {
        let unsortedCards: [CardDTO] = [
            .stub(affiliationCode: "villain"),
            .stub(affiliationCode: "hero")
        ]

        let sortedCards = Sort.cardsByAffiliation(cardsArray: unsortedCards)

        XCTAssertEqual(sortedCards[0].affiliationCode, "hero")
        XCTAssertEqual(sortedCards[1].affiliationCode, "villain")
    }
}
