//
//  AddCardViewModelTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 27/06/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Testing

@testable import SWDestinyTrades

@MainActor
final class AddCardViewModelTests: BaseTestCase {

    /// Builds a SUT in the collection context and waits for its initial load
    /// (which pulls all cards from the service) to settle.
    private func makeCollectionSUT(
        collection: UserCollectionDTO,
        serviceCards: [CardDTO]
    ) async -> AddCardViewModel {
        mockSWDestinyService.retrieveAllCardsResult = serviceCards
        try? await populateTestData(objects: [collection])
        let sut = AddCardViewModel(context: .collection(collection), dependencyContainer: testContainer.container)
        await waitUntil { sut.items.count == serviceCards.count }
        return sut
    }

    // MARK: - Loading

    @Test
    func test_loadAllCards_populatesItemsFromService() async {
        let sut = await makeCollectionSUT(
            collection: UserCollectionDTO(),
            serviceCards: [CardDTO.stub(code: "01001"), CardDTO.stub(code: "01002")]
        )

        #expect(sut.items.count == 2)
        #expect(sut.isLoading == false)
    }

    @Test
    func test_loadAllCards_onError_enqueuesErrorToast() async {
        mockSWDestinyService.retrieveAllCardsError = APIError.invalidData
        let sut = AddCardViewModel(context: .collection(UserCollectionDTO()), dependencyContainer: testContainer.container)

        await waitUntil { sut.toastQueue.current != nil }

        #expect(sut.toastQueue.current?.type == .error)
    }

    // MARK: - Filtering

    @Test
    func test_filterItems_bySearch() async {
        let sut = await makeCollectionSUT(
            collection: UserCollectionDTO(),
            serviceCards: [
                CardDTO.stub(code: "01001", name: "Captain Phasma"),
                CardDTO.stub(code: "01002", name: "Kylo Ren")
            ]
        )

        sut.searchText = "Phasma"
        sut.applyFilters()

        #expect(sut.filteredItems.map(\.code) == ["01001"])
    }

    @Test
    func test_filterItems_excludesCardsAlreadyInCollection() async {
        let owned = CardDTO.stub(code: "01001", name: "Captain Phasma")
        let collection = UserCollectionDTO.stub(collection: [owned])
        let sut = await makeCollectionSUT(
            collection: collection,
            serviceCards: [
                CardDTO.stub(code: "01001", name: "Captain Phasma"),
                CardDTO.stub(code: "01002", name: "Kylo Ren")
            ]
        )

        sut.applyFilters()

        // The already-owned code 01001 is filtered out.
        #expect(sut.filteredItems.map(\.code) == ["01002"])
    }

    // MARK: - Add card (async Task)

    @Test
    func test_addCard_collection_appendsCopyAndShowsSuccess() async {
        let collection = UserCollectionDTO()
        let sut = await makeCollectionSUT(
            collection: collection,
            serviceCards: [CardDTO.stub(code: "01001", name: "Captain Phasma")]
        )
        let card = sut.items[0]

        sut.addCard(card)
        await waitUntil { sut.toastQueue.current?.type == .success }

        #expect(collection.myCollection.map(\.code) == ["01001"])
        #expect(collection.myCollection.first?.id != card.id) // fresh copy
        #expect(sut.toastQueue.current?.type == .success)
    }

    @Test
    func test_addCard_duplicate_showsErrorToast() async {
        let owned = CardDTO.stub(code: "01001")
        let collection = UserCollectionDTO.stub(collection: [owned])
        let sut = await makeCollectionSUT(
            collection: collection,
            serviceCards: [CardDTO.stub(code: "01001")]
        )

        sut.addCard(CardDTO.stub(code: "01001"))
        await waitUntil { sut.toastQueue.current != nil }

        #expect(sut.toastQueue.current?.type == .error)
        #expect(collection.myCollection.count == 1)
    }

    // MARK: - Context title

    @Test
    func test_addCardContext_titlesAreLocalized() {
        #expect(AddCardContext.collection(UserCollectionDTO()).title == L10n.addCard)
        #expect(AddCardContext.lentToPerson(PersonDTO()).title == L10n.addLentCard)
        #expect(AddCardContext.borrowedFromPerson(PersonDTO()).title == L10n.addBorrowedCard)
        #expect(AddCardContext.person(id: "1", type: .lent).title == L10n.addLentCard)
        #expect(AddCardContext.person(id: "1", type: .collection).title == L10n.addCard)
    }
}
