//
//  SplitTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 29/01/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Testing

@testable import SWDestinyTrades

@MainActor
final class SplitTests {

    @Test
    func test_cardsAlphabetically() {
        let cardList: [CardDTO] = [
            .stub(name: "Cherry"),
            .stub(name: "Apple"),
            .stub(name: "Banana"),
            .stub(name: "Brocolis")
        ]

        let sections = ["B", "A", "C"]

        let result = Split.cardsAlphabetically(cardList: cardList, sections: sections)

        #expect(result["A"]?.count == 1)
        #expect(result["B"]?.count == 2)
        #expect(result["C"]?.count == 1)

        #expect(result["A"]?.first?.name == "Apple")
        #expect(result["B"]?.first?.name == "Banana")
        #expect(result["B"]?[1].name == "Brocolis")
        #expect(result["C"]?.first?.name == "Cherry")
    }

    @Test
    func test_cardsByColor() {
        let cardList: [CardDTO] = [
            .stub(factionCode: "Red", name: "Card1"),
            .stub(factionCode: "Red", name: "Card3"),
            .stub(factionCode: "Green", name: "Card4"),
            .stub(factionCode: "Blue", name: "Card2")
        ]

        let sections = ["Red", "Blue", "Green"]

        let result = Split.cardsByColor(cardList: cardList, sections: sections)

        #expect(result["Red"]?.count == 2)
        #expect(result["Blue"]?.count == 1)
        #expect(result["Green"]?.count == 1)

        #expect(result["Red"]?.first?.name == "Card1")
        #expect(result["Red"]?[1].name == "Card3")
        #expect(result["Blue"]?.first?.name == "Card2")
        #expect(result["Green"]?.first?.name == "Card4")
    }

    @Test
    func test_cardsByType() {
        let cardList: [CardDTO] = [
            .stub(typeName: "Creature", name: "Card1"),
            .stub(typeName: "Spell", name: "Card2"),
            .stub(typeName: "Creature", name: "Card3"),
            .stub(typeName: "Artifact", name: "Card4")
        ]

        let sections = ["Creature", "Spell", "Artifact"]

        let result = Split.cardsByType(cardList: cardList, sections: sections)

        #expect(result["Creature"]?.count == 2)
        #expect(result["Spell"]?.count == 1)
        #expect(result["Artifact"]?.count == 1)

        #expect(result["Creature"]?.first?.name == "Card1")
        #expect(result["Creature"]?[1].name == "Card3")
        #expect(result["Spell"]?.first?.name == "Card2")
        #expect(result["Artifact"]?.first?.name == "Card4")
    }

    @Test
    func test_setsByAlphabetically() {
        let sections = ["S", "A", "E"]

        let sets: [SetDTO] = [
            .stub(),
            .stub(name: "Spirit of Rebellion", code: "SoR"),
            .stub(name: "Empire at War", code: "EaW"),
            .stub(name: "Spark of Hope", code: "SoH")
        ]

        let result = Split.setsByAlphabetically(setList: sets, sections: sections)

        #expect(result["A"]?.count == 1)
        #expect(result["E"]?.count == 1)
        #expect(result["S"]?.count == 2)

        #expect(result["A"]?.first?.name == "Awakenings")
        #expect(result["S"]?[0].name == "Spark of Hope")
        #expect(result["S"]?[1].name == "Spirit of Rebellion")
        #expect(result["E"]?.first?.name == "Empire at War")
    }
}
