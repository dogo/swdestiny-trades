//
//  CardListViewModelTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 08/08/25.
//  Copyright © 2025 Diogo Autilio. All rights reserved.
//

import Testing

@testable import SWDestinyTrades

@MainActor
final class CardListViewModelTests: BaseTestCase {

    // MARK: - Properties

    var sut: CardListViewModel!
    var testSet: SetDTO!

    override init() async throws {
        try await super.init()
        testSet = SetDTO.stub(name: "Awakenings", code: "AW")
        sut = CardListViewModel(set: testSet, dependencyContainer: testContainer.container)
    }

    isolated deinit {
        sut = nil
        testSet = nil
    }

    @Test
    func loadCardsFromDatabase() async {
        let card1 = CardDTO.stub(
            setCode: "AW",
            code: "01001",
            name: "Captain Phasma",
            subtitle: "Elite Trooper"
        )
        let card2 = CardDTO.stub(
            setCode: "AW",
            code: "01002",
            name: "Kylo Ren",
            subtitle: "Vader's Disciple"
        )

        mockSWDestinyService.retrieveSetCardListResult = [card1, card2]

        await sut.loadCards()

        #expect(sut.items.count == 2)
        #expect(sut.items[0].code == "01001")
        #expect(sut.items[1].code == "01002")
        #expect(sut.isLoading == false)
    }

    @Test
    func loadCardsWithEmptyDatabase() async {
        await sut.loadCards()

        #expect(sut.items.isEmpty)
        #expect(sut.isLoading == false)
    }

    @Test
    func loadCardsFiltersCorrectSet() async {
        let awCard = CardDTO.stub(
            setCode: "AW",
            code: "01001",
            name: "Captain Phasma"
        )

        mockSWDestinyService.retrieveSetCardListResult = [awCard]

        await sut.loadCards()

        #expect(sut.items.count == 1)
        #expect(sut.items[0].code == "01001")
        #expect(sut.items[0].setCode == "AW")
    }

    @Test
    func loadCardsWithMockHttpClient() async {
        mockHttpClient.fileName = "card-list"
        mockHttpClient.error = false

        await sut.loadCards()

        #expect(sut.isLoading == false)
        #expect(!sut.items.isEmpty, "Should have loaded cards from mock data")
    }

    @Test
    func loadCardsHandlesHttpError() async {
        mockSWDestinyService.retrieveSetCardListError = APIError.invalidData

        await sut.loadCards()

        #expect(sut.isLoading == false)
        #expect(sut.toastQueue.current != nil)
        #expect(sut.toastQueue.current?.type == .error)
    }

    @Test
    func asyncOperationCompletesLoading() async {
        let card = CardDTO.stub(setCode: "AW", code: "01001")

        mockSWDestinyService.retrieveSetCardListResult = [card]

        await sut.loadCards()

        #expect(sut.isLoading == false)
    }

    @Test
    func searchFilteringByName() async {
        let card1 = CardDTO.stub(
            setCode: "AW",
            code: "01001",
            name: "Captain Phasma",
            subtitle: "Elite Trooper"
        )
        let card2 = CardDTO.stub(
            setCode: "AW",
            code: "01002",
            name: "Kylo Ren",
            subtitle: "Vader's Disciple"
        )

        mockSWDestinyService.retrieveSetCardListResult = [card1, card2]

        await sut.loadCards()

        sut.performFiltering(searchText: "Phasma")

        #expect(sut.filteredItems.count == 1)
        #expect(sut.filteredItems[0].name == "Captain Phasma")
    }

    @Test
    func searchFilteringBySubtitle() async {
        let card1 = CardDTO.stub(
            setCode: "AW",
            code: "01001",
            name: "Captain Phasma",
            subtitle: "Elite Trooper"
        )
        let card2 = CardDTO.stub(
            setCode: "AW",
            code: "01002",
            name: "Kylo Ren",
            subtitle: "Vader's Disciple"
        )

        mockSWDestinyService.retrieveSetCardListResult = [card1, card2]

        await sut.loadCards()

        sut.performFiltering(searchText: "Vader")

        #expect(sut.filteredItems.count == 1)
        #expect(sut.filteredItems[0].name == "Kylo Ren")
    }

    @Test
    func colorFiltering() async {
        let redCard = CardDTO.stub(
            setCode: "AW",
            factionCode: "red",
            code: "01001",
            name: "Captain Phasma"
        )
        let blueCard = CardDTO.stub(
            setCode: "AW",
            factionCode: "blue",
            code: "01002",
            name: "Rey"
        )

        mockSWDestinyService.retrieveSetCardListResult = [redCard, blueCard]

        await sut.loadCards()

        sut.filter.selectedColors.insert("red")
        sut.performFiltering(searchText: "")

        #expect(sut.filteredItems.count == 1)
        #expect(sut.filteredItems[0].factionCode == "red")
    }

    @Test
    func typeFiltering() async {
        let character = CardDTO.stub(
            setCode: "AW",
            typeCode: "character",
            code: "01001",
            name: "Captain Phasma"
        )
        let upgrade = CardDTO.stub(
            setCode: "AW",
            typeCode: "upgrade",
            code: "01002",
            name: "Lightsaber"
        )

        mockSWDestinyService.retrieveSetCardListResult = [character, upgrade]

        await sut.loadCards()

        sut.filter.selectedTypes.insert("character")
        sut.performFiltering(searchText: "")

        #expect(sut.filteredItems.count == 1)
        #expect(sut.filteredItems[0].typeCode == "character")
    }

    @Test
    func costFiltering() async {
        let lowCostCard = CardDTO.stub(
            setCode: "AW",
            factionCode: "red",
            code: "01001",
            name: "Card 1",
            cost: 1
        )
        let midCostCard = CardDTO.stub(
            setCode: "AW",
            factionCode: "blue",
            code: "01002",
            name: "Card 2",
            cost: 3
        )
        let highCostCard = CardDTO.stub(
            setCode: "AW",
            factionCode: "red",
            code: "01003",
            name: "Card 3",
            cost: 5
        )

        mockSWDestinyService.retrieveSetCardListResult = [lowCostCard, midCostCard, highCostCard]

        await sut.loadCards()

        sut.filter.selectedColors.insert("blue")
        sut.performFiltering(searchText: "")

        #expect(sut.filteredItems.count == 1)
        #expect(sut.filteredItems[0].cost == 3)
    }

    @Test
    func propertyLoadingAlwaysCompletes() async {
        for iteration in 0 ..< 100 {
            let randomCardCount = Int.random(in: 0 ... 10)
            var randomCards: [CardDTO] = []

            for index in 0 ..< randomCardCount {
                let card = CardDTO.stub(
                    setCode: "AW",
                    code: "test-\(iteration)-\(index)",
                    name: "Test Card \(iteration)-\(index)"
                )
                randomCards.append(card)
            }

            mockSWDestinyService.retrieveSetCardListResult = randomCards

            let testViewModel = CardListViewModel(set: testSet, dependencyContainer: testContainer.container)
            await testViewModel.loadCards()

            #expect(testViewModel.isLoading == false, "Loading should complete on iteration \(iteration)")
            #expect(testViewModel.items.count == randomCardCount, "Should load correct number of cards on iteration \(iteration)")
        }
    }
}
