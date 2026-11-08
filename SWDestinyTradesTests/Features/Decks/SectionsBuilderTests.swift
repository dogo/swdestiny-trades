//
//  SectionsBuilderTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 30/01/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Testing

@testable import SWDestinyTrades

@MainActor
final class SectionsBuilderTests {

    // MARK: - alphabetically

    @Test
    func alphabetically_withEmptyCardList_shouldReturnEmptyArray() {
        let cardList: [CardDTO] = []
        let result = SectionsBuilder.alphabetically(cardList: cardList)

        #expect(result.isEmpty)
    }

    @Test
    func alphabetically_withSingleCard_shouldReturnArrayWithSingleElement() {
        let cardList: [CardDTO] = [.stub()]
        let result = SectionsBuilder.alphabetically(cardList: cardList)

        #expect(result == ["C"])
    }

    @Test
    func alphabetically_withMultipleCards_shouldReturnSortedArray() {
        let cardList: [CardDTO] = [
            .stub(factionCode: "ColorC", name: "CardC"),
            .stub(factionCode: "ColorA", name: "ACard"),
            .stub(factionCode: "ColorB", name: "BCard")
        ]

        let result = SectionsBuilder.alphabetically(cardList: cardList)

        #expect(result == ["A", "B", "C"])
    }

    @Test
    func alphabetically_withEmptySetList_shouldReturnEmptyArray() {
        let setList: [SetDTO] = []
        let result = SectionsBuilder.alphabetically(setList: setList)

        #expect(result.isEmpty)
    }

    @Test
    func alphabetically_withSingleSet_shouldReturnArrayWithSingleElement() {
        let setList: [SetDTO] = [.stub()]
        let result = SectionsBuilder.alphabetically(setList: setList)

        #expect(result == ["A"])
    }

    @Test
    func alphabetically_withMultipleSets_shouldReturnSortedArray() {
        let setList: [SetDTO] = [
            .stub(),
            .stub(name: "Spirit of Rebellion", code: "SoR"),
            .stub(name: "Empire at War", code: "EaW"),
            .stub(name: "Spark of Hope", code: "SoH")
        ]

        let result = SectionsBuilder.alphabetically(setList: setList)

        #expect(result == ["A", "E", "S"])
    }

    // MARK: - byColor

    @Test
    func byColor_withEmptyList_shouldReturnEmptyArray() {
        let cardList: [CardDTO] = []
        let result = SectionsBuilder.byColor(cardList: cardList)

        #expect(result.isEmpty)
    }

    @Test
    func byColor_withSingleCard_shouldReturnArrayWithSingleElement() {
        let cardList: [CardDTO] = [.stub()]
        let result = SectionsBuilder.byColor(cardList: cardList)

        #expect(result == ["red"])
    }

    @Test
    func byColor_withMultipleCards_shouldReturnArrayWithDistinctColors() {
        let cardList: [CardDTO] = [
            .stub(factionCode: "red", name: "CardC"),
            .stub(factionCode: "yellow", name: "CardA"),
            .stub(factionCode: "blue", name: "CardB"),
            .stub(factionCode: "yellow", name: "CardD")
        ]

        let result = SectionsBuilder.byColor(cardList: cardList)

        #expect(result == ["blue", "red", "yellow"])
    }

    // MARK: - byType

    @Test
    func byType_withEmptyList_shouldReturnEmptyArray() {
        let cardList: [CardDTO] = []
        let result = SectionsBuilder.byType(cardList: cardList)

        #expect(result.isEmpty)
    }

    @Test
    func byType_withSingleCard_shouldReturnArrayWithSingleElement() {
        let cardList: [CardDTO] = [.stub()]
        let result = SectionsBuilder.byType(cardList: cardList)

        #expect(result == ["Character"])
    }

    @Test
    func byType_withMultipleCards_shouldReturnArrayWithDistinctTypes() {
        let cardList: [CardDTO] = [
            .stub(typeName: "Character", name: "CardC"),
            .stub(typeName: "Upgrade", name: "CardA"),
            .stub(typeName: "Plot", name: "CardB"),
            .stub(typeName: "Event", name: "CardD")
        ]

        let result = SectionsBuilder.byType(cardList: cardList)

        #expect(result == ["Character", "Event", "Plot", "Upgrade"])
    }
}
